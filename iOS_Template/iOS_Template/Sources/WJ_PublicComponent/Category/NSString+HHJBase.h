//
//  NSString+HHJBase.h
//  iOS_Template
//
//  Created by 贺文杰 on 2021/9/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (HHJBase)

/// 字符串转字典
/// @param string 字符串
+ (NSDictionary *)dictionaryWithString:(NSString *)string;

/// 字典转字符串
/// @param dic 字典
+ (NSString *)stringWithDictionary:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
