//
//  HHJHousingFundView.m
//  iOS_Template
//
//  Created by  贺文杰 on 2021/9/28.
//

#import "HHJHousingFundView.h"
#import "CalculatorUtil.h"

@implementation HHJHousingFundView

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

/// 计算住房公积金
- (void)calculatorHousingFund{
    double total = 0;
    NSString *lastYearAmount = @"0"; //上一年月均工资
    NSString *personPayRate = @"12"; //个人缴存比例
    NSString *enterprisePayRate = @"12"; //单位缴存比例
    NSString *personFund = @""; //个人缴存金额
    NSString *enterpriseFund = @""; //单位缴存额
    NSString *totalFund = @""; //公积金月缴存额
    double personFundAmount = (lastYearAmount.doubleValue * personPayRate.doubleValue);
    NSString *strpersonfund = [[NSString alloc] initWithFormat:@"%0.2f", personFundAmount * 0.01];
    personFund = [CalculatorUtil addPoint:strpersonfund];
    double  enterpriseFundAmount = (lastYearAmount.doubleValue * enterprisePayRate.doubleValue);
    NSString *strenterprisefund = [[NSString alloc] initWithFormat:@"%0.2f", enterpriseFundAmount * 0.01];
    enterpriseFund = [CalculatorUtil addPoint:strenterprisefund]  ;
    total = personFundAmount * 0.01 + enterpriseFundAmount * 0.01;
    NSString *strtotalfund= [[NSString alloc] initWithFormat:@"%0.2f", total];
    totalFund = [CalculatorUtil addPoint:strtotalfund];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
