//
//  HHJHomeGridTemplateView.m
//  iOS_Template
//
//  Created by 贺文杰 on 2021/10/24.
//

#import "HHJHomeGridTemplateView.h"
#import "HHJTemplateManager.h"

@interface HHJHomeGridTemplateView ()

@property(nonatomic,strong)UILabel *label;
@property(nonatomic)CGFloat defaultHeight;
@property(nonatomic,strong)HHJBaseModel *model;

@end

@implementation HHJHomeGridTemplateView

/// 设置所有需要的UI
- (void)setupAllSubviews{
    _defaultHeight = 100;
    self.backgroundColor = [UIColor redColor];
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 200, 50)];
    self.label.font = [UIFont systemFontOfSize:20];
    self.label.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTap)];
    [self.label addGestureRecognizer:tap];
    
    [self addSubview:self.label];
}

/// 设置数据
/// @param model 模型
- (void)setupSubviewsWithModel:(HHJBaseModel *)model{
    _model = model;
    self.label.text = model.dataDic[@"title"];
}

/// 返回高度
/// @param model 模型
- (NSNumber *)getTemplateHeightWithModel:(HHJBaseModel *)model{
    CGFloat height = 100;
    if (self.label.text.length > 0) {
        height = 200;
    }
    NSLog(@"_defaultHeight = %.f", height);
    return [NSNumber numberWithFloat:height];
}

- (void)clickTap{
    [HHJTemplateManager shareInstance].templeteJumpEvent(self.model, 0, @{});
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
