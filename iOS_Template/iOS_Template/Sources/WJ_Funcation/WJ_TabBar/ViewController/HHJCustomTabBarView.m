//
//  HHJCustomTabBarView.m
//  iOS_Template
//
//  Created by 贺文杰 on 2021/10/22.
//

#import "HHJCustomTabBarView.h"
#import "HHJGlobalConstant.h"
#import "NSString+HHJBase.h"

@interface HHJCustomTabBarView ()

@property(nonatomic,strong)NSMutableArray *imgMtbAry;
@property(nonatomic,strong)NSMutableArray *labMtbAry;

@end

@implementation HHJCustomTabBarView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    self.backgroundColor = [UIColor whiteColor];
    self.imgMtbAry = [NSMutableArray new];
    self.labMtbAry = [NSMutableArray new];
    
    NSArray *titleAry = @[@"首页", @"社区", @"消息", @"生活", @"我的"];
    for (NSInteger i = 0; i < titleAry.count; i++) {
        UIView *view = [[UIView alloc] init];
        view.tag = 300 + i;
        view.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickIcon:)];
        [view addGestureRecognizer:tap];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.backgroundColor = [UIColor redColor];
        [view addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = HHJ_RegularFont_(13);
        label.text = titleAry[i];
        [view addSubview:label];
        
        CGFloat width = screenWidth / 5;
        CGFloat x = width * i;
        view.frame = CGRectMake(x, 0, width, 49);
        imageView.frame = CGRectMake(width / 2 - 28 / 2, 2, 28, 28);
        label.frame = CGRectMake(0, 32, width, 18);
        
        [self addSubview:view];
        [self.imgMtbAry addObject:imageView];
        [self.labMtbAry addObject:label];
        
    }
}

#pragma mark -- action
- (void)clickIcon:(UITapGestureRecognizer *)ges{
    if (ges.view) {
        NSInteger index = ges.view.tag - 300;
        for (NSInteger i = 0; i < self.imgMtbAry.count; i++) {
            UIImageView *imgV = self.imgMtbAry[i];
            UILabel *label = self.labMtbAry[i];
            if (index == i) {
                imgV.backgroundColor = [UIColor greenColor];
                label.textColor = [UIColor redColor];
            }else{
                imgV.backgroundColor = [UIColor redColor];
                label.textColor = [UIColor blackColor];
            }
        }
        if ([self.delegate respondsToSelector:@selector(didSelectIcon:)]) {
            [self.delegate didSelectIcon:ges.view.tag - 300];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
