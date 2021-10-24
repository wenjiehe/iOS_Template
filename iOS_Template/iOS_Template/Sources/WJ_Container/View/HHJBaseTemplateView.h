//
//  HHJBaseTemplateView.h
//  iOS_Template
//
//  Created by 贺文杰 on 2021/10/24.
//

#import <UIKit/UIKit.h>
#import "HHJBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HHJBaseTemplateView : UIView

- (void)setupSubviewsWithModel:(HHJBaseModel *)model;

@end

NS_ASSUME_NONNULL_END
