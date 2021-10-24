//
//  HHJHomeGridTemplateView.m
//  iOS_Template
//
//  Created by 贺文杰 on 2021/10/24.
//

#import "HHJHomeGridTemplateView.h"

@interface HHJHomeGridTemplateView ()

@property(nonatomic,strong)UILabel *label;

@end

@implementation HHJHomeGridTemplateView

/// 设置所有需要的UI
- (void)setupAllSubviews{
    self.backgroundColor = [UIColor redColor];
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 200, 50)];
    self.label.font = [UIFont systemFontOfSize:20];
    [self addSubview:self.label];
}

/// 设置数据
/// @param model 模型
- (void)setupSubviewsWithModel:(HHJBaseModel *)model{
    self.label.text = model.dataDic[@"title"];
}

/// 返回高度
/// @param model 模型
- (NSNumber *)getTemplateHeightWithModel:(HHJBaseModel *)model{
    return [NSNumber numberWithFloat:100];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
