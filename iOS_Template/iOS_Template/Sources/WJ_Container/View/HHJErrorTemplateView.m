//
//  HHJErrorTemplateView.m
//  iOS_Template
//
//  Created by 贺文杰 on 2021/10/24.
//

#import "HHJErrorTemplateView.h"
#import "HHJGlobalConstant.h"

@interface HHJErrorTemplateView ()

@property(nonatomic,strong)UILabel *label;

@end

@implementation HHJErrorTemplateView

/// 设置所有需要的UI
- (void)setupAllSubviews{
    self.backgroundColor = [UIColor redColor];
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, screenWidth - 30, 80)];
    self.label.numberOfLines = 0;
    self.label.font = [UIFont systemFontOfSize:16];
    [self addSubview:self.label];
}

/// 设置数据
/// @param model 模型
- (void)setupSubviewsWithModel:(HHJBaseModel *)model{
}

/// 返回高度
/// @param model 模型
- (NSNumber *)getTemplateHeightWithModel:(HHJBaseModel *)model{
    return [NSNumber numberWithFloat:100];
}

- (void)setupMessage:(NSString *)message{
    self.label.text = message;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
