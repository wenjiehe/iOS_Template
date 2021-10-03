//
//  NSString+HHJBase.m
//  iOS_Template
//
//  Created by 贺文杰 on 2021/9/29.
//

#import "NSString+HHJBase.h"
#import "HHJGlobalConstant.h"

@implementation NSString (HHJBase)

/// 字符串转字典
/// @param string 字符串
+ (NSDictionary *)dictionaryWithString:(NSString *)string{
    string = kCheckNil(string);
    if (string && string.length == 0) {
        return @{};
    }
    NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if (!error) {
        return dic;
    }
    return @{};
}

/// 字典转字符串
/// @param dic 字典
+ (NSString *)stringWithDictionary:(NSDictionary *)dic{
    if (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0) {
        return @"";
    }
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    if (!error) {
        NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (str && str.length > 0) {
            return str;
        }
    }
    return @"";
}


@end
