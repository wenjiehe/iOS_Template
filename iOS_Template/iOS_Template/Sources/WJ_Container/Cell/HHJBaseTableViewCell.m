//
//  HHJBaseTableViewCell.m
//  iOS_Template
//
//  Created by 贺文杰 on 2021/10/24.
//

#import "HHJBaseTableViewCell.h"
#import "HHJBaseTemplateView.h"
#import "HHJGlobalConstant.h"

@interface HHJBaseTableViewCell ()

@property(nonatomic,strong)HHJBaseTemplateView *templateView;

@end

@implementation HHJBaseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    _templateView = [[HHJBaseTemplateView alloc] init];
    [self.contentView addSubview:_templateView];
    [_templateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
}

- (void)setHhj_customModel:(HHJBaseModel *)hhj_customModel{
    _hhj_customModel = hhj_customModel;
    [self.templateView setupSubviewsWithModel:_hhj_customModel];
}


@end
