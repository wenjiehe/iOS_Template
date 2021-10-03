//
//  CalculatorUtil.m
//  CalculatorFix
//
//  Created by hebei on 14-10-30.
//  Copyright (c) 2014年 PNC. All rights reserved.
//

#import "CalculatorUtil.h"
//#import "NoticeLoans.h"
//#import "MODropAlertView.h"

static NSInteger g_nTerm;

@implementation CalculatorUtil
#pragma mark -
#pragma mark 常用方法：打印日志、判空、警告框、字符串格式化、通过名称获取图片、压缩频幕大小
+ (BOOL)strNilOrEmpty:(NSString *)string{
    if ([string isKindOfClass:[NSString class]]) {
        if (string.length > 0) {
            return NO;
        }
        else {
            return YES;
        }
    }
    else {
        return YES;
    }
}

//去掉两端的空格
+ (NSString *)strTrim:(NSString *)string{
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
#pragma mark -
#pragma mark NSDate

+ (NSDate*)getNSDateByString:(NSString*)string formate:(NSString*)formate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formate];
    NSDate *date = [formatter dateFromString:string];
    return date;
}

+ (NSString*)getDateStringByFormateString:(NSString*)formateString date:(NSDate*)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formateString];
    NSString *strDate = [formatter stringFromDate:date];
    return strDate;
}


// 组合最终要发送到服务端的三个加密后的字符串
+ (NSString *)getFinalStringWithString:(NSString *)aString
{
    // 随机得到一个16位的密钥
    
    return  @"" ;
}

+ (NSString *)getSeveralDaysLater:(int)days fromDate:(NSDate *)startDate {
    
    NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *components = [gregorian components:(NSCalendarUnitDay |
                                                          NSCalendarUnitWeekday |
                                                          NSCalendarUnitMonth |
                                                          NSCalendarUnitYear) fromDate:startDate];
    NSDateComponents *addComponents = [[NSDateComponents alloc] init];
    [addComponents setDay:days];
    NSDate *previousSeveralDaysDate = [gregorian dateByAddingComponents:addComponents toDate:[gregorian dateFromComponents:components] options:0];
    NSString *strResultDate = [CalculatorUtil getDateStringByFormateString:@"yyyyMMdd" date: previousSeveralDaysDate];
    return strResultDate;
    
}

+(double)roundTheNumber:(double)number
{
    NSString* aNumber = [NSString stringWithFormat:@"%0.6f", number];
    NSRange pointOffset = [aNumber rangeOfString:@"."];
    NSUInteger pos = pointOffset.location + 4;
    
    
    if ( pointOffset.location  > aNumber.length
        || pos > aNumber.length)
    {
        return number;
    }
    NSString * tempStr = [aNumber substringWithRange:NSMakeRange(0,pos)];
    NSString *lastBit = [tempStr substringFromIndex:tempStr.length-1];
    if ([lastBit isEqualToString:@"0"])
    {
        return number;
    }
    NSString *roundBit = [tempStr substringWithRange:NSMakeRange((tempStr.length -2),1)];
    NSString *cutStr = [tempStr substringToIndex:(tempStr.length -2)];
    int value = [lastBit intValue];
    int roundValue = [roundBit intValue];
    if (value >= 5)
    {
        roundValue+= 1;
        if (10 == roundValue)
        {
            return number;
        }
    }
    NSString* appendStr = [NSString stringWithFormat:@"%d", roundValue];
    NSString *resultStr =  [NSString stringWithFormat:@"%@%@",cutStr, appendStr];
    
    return [resultStr doubleValue];
    
}

+(NSString*)dateFormateTransfer:(NSString*)date8{
    if ([date8 length] != 8) {
        return date8;
    }
    NSRange range1 = {0,4};
    NSRange range2 = {4,2};
    NSRange range3 = {6,2};
    
    NSString *strTemp = [NSString stringWithFormat:@"%@-%@-%@",
                         [date8 substringWithRange :range1],
                         [date8 substringWithRange :range2],
                         [date8 substringWithRange :range3]];
    return strTemp;
}

+ (NSInteger)totalDay:(NSDate *)depositeDate			//初始存入日期
           pickUpDate:(NSDate *)pickUpDate			//提取日期
{
    NSInteger nDay = 0;
    NSTimeInterval ss = [pickUpDate timeIntervalSinceDate:depositeDate];
    nDay = ss/(24*60*60);
    
    return nDay;
}

+ (int)isStartDateGreaterThanEndDate:(NSString *)stringStartDate
                             endDate:(NSString *)stringEndDate
{
    NSDateFormatter *dateFormatter  = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [dateFormatter dateFromString:stringStartDate];
    NSDate *endDate = [dateFormatter dateFromString:stringEndDate];
    
    NSComparisonResult b = [endDate compare:startDate];
    
    return (int)b;
}


+ (void)calculateResult:(NSInteger)depositType			//储蓄类型:一天通知存款.七天通知存款
           depositeDate:(NSDate *)depositeDate			//初始存入日期
             pickUpDate:(NSDate *)pickUpDate			//提取日期
          depositeMoney:(double)depositeMoney		//存入金额
            ratePerYear:(double)ratePerYear			//年利率
            interestTax:(double *)interestTax	//扣除利息税金额(暂不征收)
   principalAndInterest:(double *)principalAndInterest	//实得本息总额
{
//    NoticeLoans *nl = [[NoticeLoans alloc] init];
//    NSString *startDate = nl.textFieldDepositDate.text;
//    NSString *endDate = nl.textFieldPickUpDate.text;
    
    NSString *startDate = @"";
    NSString *endDate = @"";
    
    NSInteger dayDiff = [self totalDay:depositeDate pickUpDate:pickUpDate];
    
    double compare = [self isStartDateGreaterThanEndDate:startDate
                                                 endDate:endDate];
    
    if (compare < 0) {
//        UIAlertView *alert = [[UIAlertView alloc]
//                              initWithTitle:@"提示"
//                              message:@"您所选择存储日期在提取日期之后"
//                              delegate:self
//                              cancelButtonTitle:@"确定"
//                              otherButtonTitles:nil];
//        [alert show];
        
//        MODropAlertView* alert = [[MODropAlertView alloc] initDropAlertWithTitle:@"温馨提示" message:@"您所选择存储日期在提取日期之后" delegate:self cancelButtonTitle:nil okButtonTitle:@"确定"];
//        [alert show];
        //add by dxm
        return;
    }
    
    ratePerYear = ratePerYear/(100*360);
    NSInteger n = dayDiff ;//+ depositType; 2013.1.31 修改通知存款计算公式
    double ir = 0;
    
    double b = depositeMoney + depositeMoney * ratePerYear * n  * (1 - ir);
    double y = depositeMoney * ratePerYear * n * ir;
    
    *interestTax = y;
    *principalAndInterest = b;
}

+(int)GetTerm:(double)fLoanTimeLimit
{
    return 12*fLoanTimeLimit;
}

+ (void)TotalPayment:(double)fLoanAmount					//贷款金额
    LoanInterestRate:(double)fLoanInterestRate			//贷款利率
       LoanTimeLimit:(int)fLoanTimeLimit				//贷款年限
  ReimbursementMeans:(int)nReimbursementMeans			//还款方式:等额本息,等额本金
                Form:(Form *)sForm						//表单
TotalReimbursementAmount:(double *)fTotalReimbursementAmount//累计还款总额
    TotalPayInterest:(double *)fTotalPayInterest			//累计支付利息
{
    double fRemainingPrincipal = 0.0;
    double fTotalAmount = 0.0;
    double fTotalPInterest = 0.0;
    double fTotalPerMonth = 0.0;
    double fInterestsPerMonth = 0.0;
    
    fLoanInterestRate = (double)(fLoanInterestRate/100/12);
    //nTerm总月数 期次
    int nTerm = [CalculatorUtil GetTerm:fLoanTimeLimit];
    g_nTerm = nTerm;
    
    if (fLoanInterestRate > -0.000001 && fLoanInterestRate < 0.000001)
    {
        nReimbursementMeans = 0;
    }
    
    if (nReimbursementMeans == 0)
    {
        //等额本息法
        //fTotalPerMonth 偿还本息(元)，月还款额
        if (nTerm == 0) {
            fTotalPerMonth = 0.0;
        }
        else
        {
            fTotalPerMonth = (fLoanAmount * fLoanInterestRate * pow(1 + fLoanInterestRate, nTerm))/(pow(1 + fLoanInterestRate, nTerm) - 1);
            if(fLoanInterestRate == 0){
                fTotalPerMonth = fLoanAmount / nTerm;
                
            }
        }
        
        fTotalAmount = fTotalPerMonth * nTerm;
        *fTotalReimbursementAmount = fTotalAmount;
        
        for (int i=0; i<nTerm; i++) {
            //本期剩余本金
            fRemainingPrincipal = i==0 ? fLoanAmount : sForm[i-1].fRemainingPrincipal;
            // 每月利息 = 剩余本金 × 月利率
            fInterestsPerMonth = fRemainingPrincipal * fLoanInterestRate;
            fTotalPInterest += fInterestsPerMonth;
            *fTotalPayInterest = fTotalPInterest;
            
            
            sForm[i].nTerm = i+1;
            sForm[i].fRepaymentOfPrincipalAndInterest = fTotalPerMonth;
            sForm[i].fInterestPayments = fInterestsPerMonth;
            sForm[i].fPrincipalRepayment = fTotalPerMonth - fInterestsPerMonth;
            sForm[i].fRemainingPrincipal = fRemainingPrincipal - (fTotalPerMonth - fInterestsPerMonth);
            
            if( fLoanInterestRate == 0){
                
                sForm[i].nTerm = i+1;
                //sForm[i].fRepaymentOfPrincipalAndInterest = 0;
                sForm[i].fInterestPayments = 0;
                //sForm[i].fPrincipalRepayment = 0;
                // sForm[i].fRemainingPrincipal = 0;
                
            }
        }
        
    }
    else if(nReimbursementMeans == 1)
    {
        //偿还本金
        
        double fPrincipalRepayment = fLoanAmount / nTerm;
        
        for (int i=0; i<nTerm; i++) {
            //剩余本金
            fRemainingPrincipal = i==0 ? fLoanAmount : sForm[i-1].fRemainingPrincipal;
            //月利息
            fInterestsPerMonth = fRemainingPrincipal * fLoanInterestRate;
            fTotalPInterest += fInterestsPerMonth;
            *fTotalPayInterest = fTotalPInterest;
            fTotalAmount += fPrincipalRepayment + fInterestsPerMonth;
            *fTotalReimbursementAmount = fTotalAmount;
            
            sForm[i].nTerm = i+1;
            sForm[i].fRepaymentOfPrincipalAndInterest = fInterestsPerMonth + fPrincipalRepayment;
            sForm[i].fInterestPayments = fInterestsPerMonth;
            sForm[i].fPrincipalRepayment = fPrincipalRepayment;
            sForm[i].fRemainingPrincipal = fRemainingPrincipal - fPrincipalRepayment;
            
            if( fLoanInterestRate == 0){
                
                sForm[i].nTerm = i+1;
                // sForm[i].fRepaymentOfPrincipalAndInterest = 0;
                sForm[i].fInterestPayments = 0;
                // sForm[i].fPrincipalRepayment = 0;
                // sForm[i].fRemainingPrincipal = 0;
                
            }
        }
    }
    
}

+(NSString *)addPoint:(NSString *)str{
    NSArray *tempArr = [str componentsSeparatedByString:@"."];
    NSString *left = [[tempArr objectAtIndex:0] stringByReplacingOccurrencesOfString:@"," withString:@""];
    NSString *right;
    if ([tempArr count] > 1){
        right = [tempArr objectAtIndex:1];
    }
    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:1];
    for (int i = 0; i < left.length; i++){
        [arr addObject:[left substringWithRange:NSMakeRange(i, 1)]];
    }
    NSUInteger count = [arr count];
    NSMutableArray *arr2 = [[NSMutableArray alloc] initWithCapacity:1];
    int j = 1;
    NSMutableString *tempLeft = [[NSMutableString alloc] initWithCapacity:1];
    if ([arr count] > 3)
    {
        for (NSUInteger i = count; i > 0 ; i --)
        {
            [arr2 addObject:[arr objectAtIndex:i - 1]];
            if (j > 2 && j % 3 == 0 && j != count)
            {
                [arr2 addObject:@","];
            }
            
            j++;
        }
    }
    
    for (NSUInteger i = [arr2 count]; i > 0; i--){
        [tempLeft appendFormat:@"%@",[arr2 objectAtIndex:i - 1]];
    }
    if ([tempLeft isEqualToString:@""]){
        [tempLeft appendFormat:@"%@",left];
    }
    if ([tempArr count] > 1){
        [tempLeft appendFormat:@"."];
        [tempLeft appendFormat:@"%@",right];
    }
    return tempLeft;
}

+(NSString *)result:(double)dou{
    NSString *result;
    double twoint2 = 0;
    long long aa = 0;//int aa;
    int aabb = 0;
    double bb = 0;
    double cc = 0;
    aa = dou;
    bb = dou - aa ;
    cc = bb * (double)1000;
    aabb = cc;
    bb = aabb/(double)1000;
    NSString *straa = [NSString  stringWithFormat:@"%lld", aa];//@"%d"
    NSString *strbb = [NSString  stringWithFormat:@"%f", bb];
    NSRange range = [strbb rangeOfString:@"."];
    if(range.length){
        if( [strbb  characterAtIndex:range.location + 3] <= 52 && [strbb  characterAtIndex:range.location + 3] >= 48){
            
            strbb = [strbb substringWithRange:NSMakeRange(range.location + 1, 2)];
        }else if([strbb  characterAtIndex:range.location + 3] <= 57 && [strbb  characterAtIndex:range.location + 3] >= 53)
        {
            NSString *str1 = [NSString stringWithFormat:@"0"];
            twoint2 = [str1 stringByAppendingFormat:@"%@",[strbb substringWithRange:NSMakeRange(range.location, 4)]].doubleValue + 0.005;
            NSString *str2 = [NSString  stringWithFormat:@"%f", twoint2];
            NSRange range1 = [str2 rangeOfString:@"."];
            strbb = [str2 substringWithRange:NSMakeRange(range1.location + 1, 2)];
            if([str2  characterAtIndex:(range1.location - 1)] == 49){
                int b = straa.intValue + 1;
                straa = [NSString  stringWithFormat:@"%d", b];
            }
            
        }
        result =  [NSString stringWithFormat:@"%@%@%@",straa,@".",strbb];
        
    }
    
    return result;
    
}

+(NSString *)limitInput:(NSString *)astring{
    NSString *strResult = astring;
    NSString *string1 = nil;
    NSString *string2 = nil;
    NSString *result = nil;
    NSString *pointBehind = nil;
    
    if(astring.length > [astring rangeOfString:@"."].location+ratePointLimitCount){
        for(int i=0;i <astring.length;i++){
            if([astring  characterAtIndex:i] == 46 ){
                NSRange range = [astring rangeOfString:@"."];
                pointBehind = [astring substringFromIndex:(range.location + 1)];
                string1 = [astring substringToIndex:(range.location )];
                string2 = [astring substringWithRange:NSMakeRange(range.location + 1, ratePointLimitCount)];
                result =  [NSString stringWithFormat:@"%@%@%@",string1,@".",string2];
                
            }
        }
    }
    
    if(pointBehind.length >= ratePointLimitCount +1){//利率限制3
        strResult = [CalculatorUtil addPoint:[result stringByReplacingOccurrencesOfString:@"," withString:@""]];
    }
    
    return strResult;
    
}

+(float)getDeviceHight{
    UIScreen *ms = [UIScreen mainScreen];
    CGSize tempSize = CGSizeMake(320, 480);
    if ([ms respondsToSelector:@selector(currentMode)]) {
        tempSize = ms.currentMode.size;
    }
    CGFloat width = MIN(tempSize.width, tempSize.height);
    CGFloat height = MAX(tempSize.width, tempSize.height);
    CGSize cmSize = CGSizeMake(width, height);
    return cmSize.height;
}

@end
