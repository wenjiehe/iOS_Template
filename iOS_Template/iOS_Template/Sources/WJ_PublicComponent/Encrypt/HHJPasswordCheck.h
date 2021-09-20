//
//  HHJPasswordCheck.h
//  iOS_Template
//
//  Created by 贺文杰 on 2021/9/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHJPasswordCheck : NSObject

/// 检查密码是否符合标准
/// @param password 密码
/// @param account 需要比对密码一致的另一个密码
/// 返回值：@"0"-正常 @"4"-密码长度不符合8-12位之间 @"1"-密码不符合2种类型以上并包含字母 @"3"-弱密码校验不通过 @"2"-密码前后不一致
+ (NSString *)checkComplexPassword:(NSString *)password account:(NSString *)account;

/// 检查密码组合 2种组合以上并必须包含字母
/// @param password 密码
+ (BOOL)checkKindsOfPassword:(NSString *)password;

/// 检查密码是否一致
/// @param password 密码
/// @param account 另一个密码
+ (BOOL)checkSamePassword:(NSString *)password withAccount:(NSString *)account;


/// 弱密码检查 不能为连续8位相同的数字或字母
///               连续8位顺序递增或者递减的数字或字母
/// @param password 密码
+ (BOOL)checkWeakPassword:(NSString *)password;

/// 支付密码检查
/// @param pas 密码
/// 返回值@"0"-符合 @"3"-弱密码检验不通过
+ (NSString *)checkPayPasssword:(NSString *)pas;

@end

NS_ASSUME_NONNULL_END
