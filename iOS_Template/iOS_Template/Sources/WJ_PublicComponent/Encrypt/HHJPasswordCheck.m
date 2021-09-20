//
//  HHJPasswordCheck.m
//  iOS_Template
//
//  Created by 贺文杰 on 2021/9/20.
//

#import "HHJPasswordCheck.h"

static NSString *const numbers = @"1234567890";
static NSString *const charactersCapital = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
static NSString *const punctuations = @"~`!@#$%^&*()_-+={[}]|\\:;\"\'<,>.?/";

@implementation HHJPasswordCheck

/// 检查密码是否符合标准
/// @param password 密码
/// @param account 需要比对密码一致的另一个密码
/// 返回值：@"0"-正常 @"4"-密码长度不符合8-12位之间 @"1"-密码不符合2种类型以上并包含字母 @"3"-弱密码校验不通过 @"2"-密码前后不一致
+ (NSString *)checkComplexPassword:(NSString *)password account:(NSString *)account{
    NSString *complexFlag = @"0";
    
    if (password.length < 8 || password.length > 12)
    {
        complexFlag = @"4";
    }
    else if (![self checkKindsOfPassword:password])
    {
        complexFlag = @"1";
    }
    else if ([self checkNormalWeakPassword:password] || [self checkWeakPassword:password])
    {
        complexFlag = @"3";
    }
    else if (account)
    {
        if ([self checkSamePassword:password withAccount:account])
        {
            complexFlag = @"2";
        }
    }
    return complexFlag;
}

/// 检查密码组合 2种组合以上并必须包含字母
/// @param password 密码
+ (BOOL)checkKindsOfPassword:(NSString *)password{
    // 检查密码组合
    // 密码要两种类型组合以上的才行,但必需包括字母
    // 字母+数字、字母+符号、字母+数字+符号
    // 符合密码组合要求返回YES，否则返回NO
    
    BOOL isContainNumber = NO;
    BOOL isContainCharacter = NO;
    BOOL isContainPunctuation = NO;
    
    for (NSUInteger index = 0; index < [password length]; index++)
    {
        NSString *tempString = [password substringWithRange:NSMakeRange(index, 1)];
        
        // 检查是否包含数字
        if ([numbers rangeOfString:tempString].length > 0)
        {
            if (!isContainNumber)
            {
                isContainNumber = YES;;
            }
        }
        // 检查是否包含字母
        else if ([charactersCapital rangeOfString:[tempString uppercaseString]].length > 0)
        {
            if (!isContainCharacter)
            {
                isContainCharacter = YES;
            }
        }
        // 检查是否包含符号
        else if ([punctuations rangeOfString:tempString].length > 0)
        {
            if (!isContainPunctuation)
            {
                isContainPunctuation = YES;
            }
        }
        
        // 每次检测一次当前情况，符号要求就返回
        if ((isContainCharacter && isContainNumber) || (isContainCharacter && isContainPunctuation))
        {
            return YES;
        }
    }
    
    return NO;
}

/// 检查密码是否一致
/// @param password 密码
/// @param account 另一个密码
+ (BOOL)checkSamePassword:(NSString *)password withAccount:(NSString *)account{
    NSUInteger checkCount = password.length -3; // 验证连续相同个数
    for (NSUInteger index = 0; index < [password length]; index++)
    {
        // 位置和检测密码段长度比密码长时，跳出循环
        if (index + checkCount > [password length])
        {
            break;
        }
        
        // 截取对应位置和长度的密码段
        NSString *checkPassword = [password substringWithRange:NSMakeRange(index, checkCount)];
        if ([account rangeOfString:checkPassword].length > 0)
        {
            return YES;
        }
    }
    
    return NO;
}

/// 弱密码检查 不能为连续8位相同的数字或字母
///               连续8位顺序递增或者递减的数字或字母
/// @param password 密码
+ (BOOL)checkWeakPassword:(NSString *)password{
    // 密码不能够为连续8位相同的数字或字母
    // 密码不能够为连续8位顺序递增或者递减的数字或字母
    // 符合弱密码情况返回YES，否则返回NO
    
    const char *passwordChars = [password UTF8String];
    NSUInteger num = 0; //重复情况计数
    NSUInteger decNum = 0; //递减情况计数
    NSUInteger incNum = 0; //递增情况计数
    NSUInteger len = [password length] - 1;
    float M = 6 + (len - 5) * 1.5;
    
    for (NSUInteger index = 0; index < len; index++)
    {
        if (passwordChars[index] == passwordChars[index + 1])
        {
            num++;
        }
        if (passwordChars[index] == passwordChars[index + 1] - 1)
        {
            decNum++;
        }
        if (passwordChars[index] == passwordChars[index + 1] + 1)
        {
            incNum++;
        }
        if (num * 2 + (decNum + incNum) * 1.5 >= M)
        {
            return YES;
        }
    }
    
    return NO;
}

+ (BOOL)checkNormalWeakPassword:(NSString *)s
{
    //密码不能够为连续8位相同的数字或字母，密码不能够为连续的8位顺序递增或者递减的数字或字母。
    if ([s length] >= 8) {//大于等于8位才检查
        const char* chs = [s UTF8String];
        int num = 0; //重复。
        int decNum = 0;//递减。
        int incNum = 0;//递增。
        unsigned long len = [s length] - 1;
        for (int i = 0; i < len; i++) {
            if (chs[i] == chs[i + 1]) {
                num++;
            } else {
                num = 0;
            }
            if (chs[i] == chs[i + 1] - 1) {
                decNum++;
            } else {
                decNum = 0;
            }
            if (chs[i] == chs[i + 1] + 1) {
                incNum++;
            } else {
                incNum = 0;
            }
            if (num >= 7 || decNum >= 7 || incNum >= 7)
            {
                
                return YES;
            }
        }
        
    }
    
    return NO;
}

/// 支付密码检查
/// @param pas 密码
/// 返回值@"0"-符合 @"3"-弱密码检验不通过
+ (NSString *)checkPayPasssword:(NSString *)pas{
    if ([self checkWeakPassword:pas]) {
        return @"3";
    }else{
        return @"0";
    }
}


@end
