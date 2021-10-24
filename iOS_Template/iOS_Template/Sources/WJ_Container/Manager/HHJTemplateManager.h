//
//  HHJTemplateManager.h
//  iOS_Template
//
//  Created by 贺文杰 on 2021/10/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHJTemplateManager : NSObject

+ (instancetype)shareInstance;

/// 获取styleType对应的类名
/// @param styleType 风格ID
- (NSString *)getTemplateWithStyleType:(NSString *)styleType;

@end

NS_ASSUME_NONNULL_END
