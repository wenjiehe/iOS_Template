//
//  HHJBaseTemplateView.m
//  iOS_Template
//
//  Created by 贺文杰 on 2021/10/24.
//

#import "HHJBaseTemplateView.h"
#import "HHJGlobalConstant.h"
#import "HHJTemplateManager.h"
#import "HHJ_TemplateProtocol.h"
#import "HHJTemplateCompontView.h"

@interface HHJBaseTemplateView ()

@property (nonatomic, strong) UIView *containerView;
@property(nonatomic,strong)NSMutableArray *compontViewMtbAry;

@end

@implementation HHJBaseTemplateView

- (instancetype)init{
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.compontViewMtbAry = [NSMutableArray new];
    _containerView = [[UIView alloc] init];
    [self addSubview:_containerView];
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

- (void)setupSubviewsWithModel:(HHJBaseModel *)model{
    if (self.containerView.subviews && [self.containerView.subviews isKindOfClass:[NSArray class]] && self.containerView.subviews.count > 0) {
        [self.containerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    BOOL isHave = NO;
    UIView *tempView;
    NSNumber *currentHeight = @(0);
    if (model) {
        HHJTemplateManager *manager = [HHJTemplateManager shareInstance];
        NSString *className = [manager getTemplateWithStyleType:model.styleType];
        if (!className) {
            //没找到对应的模板类型
        }else{
            Class templateClass = NSClassFromString(className);
            if (!templateClass) {
                //没找到对应的模板实现文件
            }else{
                HHJTemplateCompontView<HHJ_TemplateProtocol> *templateView;
                if (self.compontViewMtbAry.count == 0) {
                    templateView = [[templateClass alloc] init];
                    [self.compontViewMtbAry addObject:templateView];
                }else{
                    templateView = self.compontViewMtbAry[0];
                    isHave = YES;
                }
                if (![templateView isKindOfClass:[HHJTemplateCompontView class]]) {
                    //必须继承HHJTemplateCompontView类
                }else{
                    BOOL isConform = [templateView conformsToProtocol:@protocol(HHJ_TemplateProtocol)];
                    if (!isConform) {
                        //模板实现文件没有遵循HHJ_TemplateProtocol协议
                        
                    }else{
                        [self.containerView addSubview:templateView];
                        if (!isHave) {
                            [templateView setupAllSubviews];
                        }
                        [templateView setupSubviewsWithModel:model];
                        currentHeight = [self getTemplateHeightWithModel:model templateView:templateView];
                        templateView.clipsToBounds = YES;
                        tempView = templateView;
                    }
                }
            }
        }
    }else{
        //没找到对应的模板类型
    }
    
    if (tempView) {
        [tempView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.containerView);
            make.left.right.mas_equalTo(self.containerView);
            make.height.mas_equalTo(currentHeight.floatValue);
        }];
    }
    
    if (isHave) {
        
    }
    model.height = currentHeight;
}

- (NSNumber *)getTemplateHeightWithModel:(HHJBaseModel *)model templateView:(HHJTemplateCompontView<HHJ_TemplateProtocol> *)templateView{
    if (model.height) {
        if ([templateView respondsToSelector:@selector(alwaysCalculateHeight)] && [templateView alwaysCalculateHeight]) {
            model.height = [templateView getTemplateHeightWithModel:model];
        }
    }else{
        model.height = [templateView getTemplateHeightWithModel:model];
    }
    return model.height;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
