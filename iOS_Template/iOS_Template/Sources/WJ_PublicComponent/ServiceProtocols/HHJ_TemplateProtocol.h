//
//  HHJ_TemplateProtocol.h
//  iOS_Template
//
//  Created by 贺文杰 on 2021/10/24.
//

#import <Foundation/Foundation.h>
#import "HHJBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HHJ_TemplateProtocol <NSObject>

@required

/// 设置所有需要的UI
- (void)setupAllSubviews;

/// 设置数据
/// @param model 模型
- (void)setupSubviewsWithModel:(HHJBaseModel *)model;

/// 返回高度
/// @param model 模型
- (NSNumber *)getTemplateHeightWithModel:(HHJBaseModel *)model;

@optional

/// 总是重新计算高度，默认NO，只计算一次
- (BOOL)alwaysCalculateHeight;



@end

NS_ASSUME_NONNULL_END
