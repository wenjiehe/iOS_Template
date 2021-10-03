//
//  HHJPersonalLoansView.m
//  iOS_Template
//
//  Created by  贺文杰 on 2021/9/28.
//

#import "HHJPersonalLoansView.h"
#import "CalculatorUtil.h"

@interface HHJPersonalLoansView ()

@end

@implementation HHJPersonalLoansView

- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}

/// 计算个人贷款
/// @param principalAndInterest 0 等额本息 1 等额本金
- (void)calculatorPersonalLoans:(int)principalAndInterest{
    double loanAmount = 0.f; //贷款金额
    NSString *loanInterestRate = @"0"; //贷款利率
    double loanTimeLimit = 5.f; //贷款年限
    NSString *totalPayInterest = @"0"; //累计支付利息
    NSString *totalReimbursementAmount = @"0"; //累计还款总额
    double fTotalReimbursement = 0.0;
    double fTotalPayInterest = 0.0;
    
    if (loanTimeLimit > 100) { //年限不得大于100年
        return;
    }
    if (loanInterestRate.floatValue > 100) { //年利率不得大于100%
        totalPayInterest = @"0";
        totalReimbursementAmount = @"0";
        return;
    }
    
    if ((loanInterestRate.doubleValue < 10 && loanInterestRate.length > ratePointLimitCount + 2) || (loanInterestRate.doubleValue > 10 && loanInterestRate.length > ratePointLimitCount + 2)) {
        for(int i=0;i <loanInterestRate.length;i++){
            if([loanInterestRate  characterAtIndex:i] == 46 ){
                NSRange range = [loanInterestRate rangeOfString:@"."];
                NSString *string1 = [loanInterestRate substringToIndex:(range.location )];
                NSString *string2 = [loanInterestRate substringWithRange:NSMakeRange(range.location + 1, ratePointLimitCount)];
                NSString *result =  [NSString stringWithFormat:@"%@%@%@",string1,@".",string2];
                loanInterestRate = [CalculatorUtil addPoint:[result stringByReplacingOccurrencesOfString:@"," withString:@""]];
            }
        }
    }
    
    [CalculatorUtil TotalPayment:loanAmount
           LoanInterestRate:loanInterestRate.doubleValue
              LoanTimeLimit:loanTimeLimit
         ReimbursementMeans:principalAndInterest
                       Form:ssForm
   TotalReimbursementAmount:&fTotalReimbursement
           TotalPayInterest:&fTotalPayInterest];

    NSString *strTotalReimbursement = [[NSString alloc] initWithFormat:@"%0.2f", fTotalReimbursement];
    NSString *strTotalPayInterest = [[NSString alloc] initWithFormat:@"%0.2f", fTotalPayInterest];
    NSMutableString *tempStr1 = [[NSMutableString alloc] initWithString:strTotalPayInterest];
    totalPayInterest = [CalculatorUtil addPoint:tempStr1];
    NSMutableString *tempStr2 = [[NSMutableString alloc] initWithString:strTotalReimbursement];
    totalReimbursementAmount = [CalculatorUtil addPoint:tempStr2];
    if(loanInterestRate.floatValue == 0){
        totalPayInterest = @"0.00";    
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
