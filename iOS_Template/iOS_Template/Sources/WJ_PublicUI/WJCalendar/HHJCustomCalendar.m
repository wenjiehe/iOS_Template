//
//  HHJCustomCalendar.m
//  iOS_Template
//
//  Created by  贺文杰 on 2021/9/26.
//

#import "HHJCustomCalendar.h"
//#import "YNETAUpgradeService.h"
#import "Masonry.h"
#import "HHJGlobalConstant.h"

@interface HHJCustomCalendar ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UIView *blindView;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)UIView *whiteView;
@property(nonatomic,strong)NSMutableArray *dayAllMtbAry;
@property(nonatomic)NSInteger line;
@property(nonatomic,strong)UIButton *lastButton;
@property(nonatomic,strong)UIButton *nextButton;
@property(nonatomic,strong)UILabel *dateLabel;
@property(nonatomic,strong)NSDateFormatter *dateFormatt;

@end

@implementation HHJCustomCalendar

- (instancetype)init{
    self = [super init];
    if (self) {
//        [self initView];
    }
    return self;
}

/*
- (void)initView{
    [self addSubview:self.blindView];
    [self addSubview:self.whiteView];
    [self.whiteView addSubview:self.collectionView];
    [self.whiteView addSubview:self.lastButton];
    [self.whiteView addSubview:self.nextButton];
    [self.whiteView addSubview:self.dateLabel];
    
    self.dateFormatt = [[NSDateFormatter alloc] init];
    _line = 0;
    self.dayAllMtbAry.count > 0 ? [self.dayAllMtbAry removeAllObjects] : @"";
    [self.dayAllMtbAry addObjectsFromArray:[self getCurrentDateWithDays:[NSDate date]]];
    
    [self initConstraints];
    
    [self configUI];
}

- (void)initConstraints{
    [self.blindView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(screenHeight);
    }];
    
    CGFloat collectionHeight = _line * 35.f;
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(collectionHeight + 45 + isIphoneXTabBarMargin);
        make.bottom.mas_equalTo(collectionHeight + 45 + isIphoneXTabBarMargin);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(45);
        make.height.mas_equalTo(collectionHeight);
    }]; 
    
    [self.lastButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(45);
        make.height.mas_equalTo(45);
        make.top.mas_equalTo(0);
    }];
    
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.width.height.mas_equalTo(45);
        make.top.mas_equalTo(0);
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(45);
        make.centerX.mas_equalTo(self.whiteView);
        make.width.mas_equalTo(100);
    }];
}

- (NSMutableArray *)getCurrentDateWithDays:(NSDate *)date{
    NSUInteger dayCount = [YNETAUpgradeService getNumberOfDaysInMonth:date];
    
    CGFloat result = (CGFloat)dayCount / (CGFloat)7;
    NSInteger fResult = floor(result); //去掉小数点，向下取整
    NSInteger allDays = 0;
    if (dayCount % 7 == 0) {
        allDays = dayCount;
    }else{
        if (fResult * 7 < dayCount) {
            fResult = fResult + 1;
            allDays = fResult * 7;
        }
    }
    
    [self.dateFormatt setDateFormat:@"yyyy-MM"];
    NSString *str = [self.dateFormatt stringFromDate:date];
    [self.dateFormatt setDateFormat:@"yyyy-MM-dd"];
    
    NSString *string = [NSString stringWithFormat:@"%@-%@", str, @"01"];
    NSDate *subDate = [self.dateFormatt dateFromString:string];
    NSNumber *weekDay = [YNETAUpgradeService getWeekDayWithDate:subDate];
    NSInteger k = 0;
    if (weekDay.integerValue == 1) { //周日
        k = 6;
    }else if (weekDay.integerValue == 2){ //周一
        k = 0;
    }else if (weekDay.integerValue == 3){ //周二
        k = 1;
    }else if (weekDay.integerValue == 4){ //周三
        k = 2;
    }else if (weekDay.integerValue == 5){ //周四
        k = 3;
    }else if (weekDay.integerValue == 6){ //周五
        k = 4;
    }else if (weekDay.integerValue == 7){ //周六
        k = 5;
    }
    
    NSMutableArray *mtbAry = [NSMutableArray new];
    NSArray *ay = @[@"一", @"二", @"三", @"四", @"五", @"六", @"日"];
    for (NSInteger i = 0; i < ay.count; i++) {
        [mtbAry addObject:ay[i]];
    }
    
    for (NSInteger i = 0; i < k; i++) {
        [mtbAry addObject:[NSNumber numberWithInteger:0]];
    }
    
    NSInteger h = allDays - k - dayCount; //剩余需要补的位置
    
    for (NSInteger i = 1; i <= dayCount; i++) {
        [mtbAry addObject:[NSNumber numberWithInteger:i]];
    }
    
    for (NSInteger i = 0; i < h; i++) {
        [mtbAry addObject:[NSNumber numberWithInteger:0]];
    }
    
    //获取日历行数
    CGFloat result1 = (CGFloat)mtbAry.count / (CGFloat)7;
    NSInteger fResult1 = floor(result1); //去掉小数点，向下取整
    if (mtbAry.count % 7 == 0) {
        _line = mtbAry.count / 7;
    }else{
        if (fResult * 7 < mtbAry.count) {
            _line = fResult1 + 1;
        }
    }
    
    return mtbAry;
}

- (void)configUI
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIBezierPath *crPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(8, 8)];
        CAShapeLayer *crLayer = [[CAShapeLayer alloc] init];
        crLayer.frame = self.whiteView.bounds;
        crLayer.path = crPath.CGPath;
        self.whiteView.layer.mask = crLayer;
        
        self.dateLabel.text = [self stringChangeDate:[NSDate date]];
    });
}

#pragma mark -- UICollectionDelegate 
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dayAllMtbAry.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HHJCustomCalendarCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HHJCustomCalendarCollectionCell" forIndexPath:indexPath];
    id num = self.dayAllMtbAry[indexPath.row];
    NSDictionary *dic = nil;
    if ([num isKindOfClass:[NSNumber class]]) {
        NSNumber *number = (NSNumber *)num;
        dic = @{@"date" : [NSString stringWithFormat:@"%ld", number.integerValue]};
    }else if ([num isKindOfClass:[NSString class]]){
        NSString *str = (NSString *)num;
        dic = @{@"date" : [NSString stringWithFormat:@"%@", str]};
    }
    if (dic && [dic allKeys].count > 0) {
        [cell configData:dic];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row > 6) {
        NSNumber *num = self.dayAllMtbAry[indexPath.row];
        NSInteger day = num.integerValue;
        if (day != 0) {
            if (day < 10) {
                HHJLog(@"indexPath = %@-0%ld", self.dateLabel.text, (long)day);
            }else{
                HHJLog(@"indexPath = %@-%ld", self.dateLabel.text, (long)day);
            }
        }
    }
}

#pragma mark -- action
- (void)show{
    //动画效果
    [UIView animateWithDuration:0.2 animations:^{
        self.blindView.alpha = 0.4;
        [self.whiteView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
        }];
    }];
}

- (void)dismiss{
    [UIView animateWithDuration:0.2 animations:^{
        self.blindView.alpha = 0;
        [self.whiteView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self->_line * 35.f + 45.f + isIphoneXTabBarMargin);
        }];
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)clickBlindAction{
    [self dismiss];
}

- (void)updateUI{
    CGFloat collectionHeight = _line * 35.f;
    [self.whiteView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(collectionHeight + 45 + isIphoneXTabBarMargin);
    }];
    
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(collectionHeight);
    }]; 
    
    [self.whiteView setNeedsDisplay];
    [self.whiteView setNeedsLayout];
}

- (void)clickActionButton:(UIButton *)sender{
    NSString *dateStr = self.dateLabel.text;
    dateStr = kCheckNil(dateStr);
    if (dateStr.length > 0 && dateStr.length == 7) {
        NSString *month = [dateStr substringFromIndex:5];
        NSString *year = [dateStr substringToIndex:4];
        NSInteger mon = month.integerValue;
        NSInteger ye = year.integerValue;
        NSString *ds = @"";
        if (sender == self.lastButton) { //上一个月
            if (mon == 1) {
                ds = [NSString stringWithFormat:@"%ld-%d", (ye - 1), 12];
            }else {
                if ((mon - 1) < 10) {
                    ds = [NSString stringWithFormat:@"%ld-0%ld", ye, (mon - 1)]; 
                }else{
                    ds = [NSString stringWithFormat:@"%ld-%ld", ye, (mon - 1)]; 
                }
            }
        }else{
            if (mon == 12) {
                ds = [NSString stringWithFormat:@"%ld-0%d", (ye + 1), 1];
            }else {
                if ((mon + 1) < 10) {
                    ds = [NSString stringWithFormat:@"%ld-0%ld", ye, (mon + 1)]; 
                }else{
                    ds = [NSString stringWithFormat:@"%ld-%ld", ye, (mon + 1)]; 
                }
            }
        }
        
        if (ds.length > 0) {
            self.dateLabel.text = ds;
            NSDate *date = [self dateChangeString:ds];
            [self.dayAllMtbAry removeAllObjects];
            [self.dayAllMtbAry addObjectsFromArray:[self getCurrentDateWithDays:date]];
            if (self.dayAllMtbAry.count > 0) {
                [self updateUI];
                [self.collectionView reloadData];
            }
        }
    }
}

#pragma mark -- tools
/// 日期转字符串
/// @param date 日期
- (NSString *)stringChangeDate:(NSDate *)date{
    self.dateFormatt.dateFormat = @"yyyy-MM";
    NSString *dateString = [self.dateFormatt stringFromDate:date];
    return dateString;
}

/// 字符串转日期
/// @param string 字符串
- (NSDate *)dateChangeString:(NSString *)string{
    self.dateFormatt.dateFormat = @"yyyy-MM";
    NSDate *date = [self.dateFormatt dateFromString:string];
    return date;
}

#pragma mark -- setter
- (UIView *)blindView{
    if (!_blindView) {
        _blindView = [[UIView alloc] init];
        _blindView.backgroundColor = [UIColor blackColor];
        _blindView.alpha = 0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBlindAction)];
        [_blindView addGestureRecognizer:tap];
    }
    return _blindView;
}

- (UIView *)whiteView{
    if (!_whiteView) {
        _whiteView = [[UIView alloc] init];
        _whiteView.backgroundColor = [UIColor whiteColor];
    }
    return _whiteView;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        // 每一行cell之间的间距
        layout.minimumLineSpacing = 0;
        // 每一列cell之间的间距
        layout.minimumInteritemSpacing = 0;
        // 设置第一个cell和最后一个cell,与父控件之间的间距
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.itemSize = CGSizeMake(screenWidth / 7, 35);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, _line * 35) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.dataSource = self;
        [_collectionView registerClass:[HHJCustomCalendarCollectionCell class] forCellWithReuseIdentifier:@"HHJCustomCalendarCollectionCell"];
    }
    return _collectionView;
}

- (UIButton *)lastButton{
    if (!_lastButton) {
        _lastButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_lastButton setTitle:@"<" forState:UIControlStateNormal];
        [_lastButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _lastButton.titleLabel.font = [UIFont systemFontOfSize:17.f];
        [_lastButton addTarget:self action:@selector(clickActionButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lastButton;
}

- (UIButton *)nextButton{
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextButton setTitle:@">" forState:UIControlStateNormal];
        [_nextButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _nextButton.titleLabel.font = [UIFont systemFontOfSize:17.f];
        [_nextButton addTarget:self action:@selector(clickActionButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextButton;
}

- (UILabel *)dateLabel{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15.f];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _dateLabel;
}

- (NSMutableArray *)dayAllMtbAry{
    if (!_dayAllMtbAry) {
        _dayAllMtbAry = [NSMutableArray new];
    }
    return _dayAllMtbAry;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

@interface HHJCustomCalendarCollectionCell ()

@property(nonatomic,strong)UILabel *dateLabel;

@end

@implementation HHJCustomCalendarCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    [self.contentView addSubview:self.dateLabel];
        
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(35);
    }];
}

- (void)configData:(NSDictionary *)dic
{
    NSString *date = kCheckNil(dic[@"date"]);
    if ([date isEqualToString:@"0"]) {
        self.dateLabel.text = @"";
    }else{
        self.dateLabel.text = date;
    }
}

#pragma mark -- setter & getter
- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14.f];
        _dateLabel.textColor = [UIColor blackColor];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _dateLabel;
}


@end
