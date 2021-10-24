//
//  HHJTemplateManager.h
//  iOS_Template
//
//  Created by 贺文杰 on 2021/10/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class HHJBaseModel;

typedef void(^HHJTemplateJumpEvent)(HHJBaseModel *model, NSInteger index, NSDictionary *extendInfo);

@interface HHJTemplateManager : NSObject

+ (instancetype)shareInstance;

///响应点击事件
@property(nonatomic,copy)HHJTemplateJumpEvent templeteJumpEvent;

/// 获取styleType对应的类名
/// @param styleType 风格ID
- (NSString *)getTemplateWithStyleType:(NSString *)styleType;


@end

NS_ASSUME_NONNULL_END
