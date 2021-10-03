//
//  CalculatorUtil.h
//  CalculatorFix
//
//  Created by hebei on 14-10-30.
//  Copyright (c) 2014年 PNC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CalculatorGlobal.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface CalculatorUtil : NSObject

/**
 *	@brief	string是否为nil或空.
 *
 *	@param 	string 	源字符串.
 *
 *	@return	是否为nil或空.
 */
+ (BOOL)strNilOrEmpty:(NSString *)string;
/**
 *	@brief	弹出系统警告框.
 *
 *	@param
 *
 *	@return	UIAlertView
 */


+ (NSString *)strTrim:(NSString *)string;
/**
 *	@brief	去掉string内的“,“
 *
 *	@param 	string 	源字符串.
 *
 *	@return	处理后的string.
 */

+ (NSDate*)getNSDateByString:(NSString*)string formate:(NSString*)formate;
/**
 *  将指定日期转换成格式化日期字符串
 *
 *  @param formateString 格式
 *  @param date          日期
 *
 *  @return 格式化日期字符串
 */
+ (NSString*)getDateStringByFormateString:(NSString*)formateString date:(NSDate*)date;

/**
 *  组合最终要发送到服务端的三个加密后的字符串
 *
 *  @param String
 *
 *  @return 加密后的字符串
 */
+ (NSString *)getFinalStringWithString:(NSString *)aString;

+ (NSString *)getSeveralDaysLater:(int)days fromDate:(NSDate *)startDate;

//嵌入计算器重新引入
+(double)roundTheNumber:(double)number;

+(NSString*)dateFormateTransfer:(NSString*)date8;

+ (NSInteger)totalDay:(NSDate *)depositeDate			//初始存入日期
           pickUpDate:(NSDate *)pickUpDate;			//提取日期

+ (void)calculateResult:(NSInteger)depositType			//储蓄类型:一天通知存款.七天通知存款
           depositeDate:(NSDate *)depositeDate			//初始存入日期
             pickUpDate:(NSDate *)pickUpDate			//提取日期
          depositeMoney:(double)depositeMoney		//存入金额
            ratePerYear:(double)ratePerYear			//年利率
            interestTax:(double *)interestTax	//扣除利息税金额(暂不征收)
   principalAndInterest:(double *)principalAndInterest;	//实得本息总额

+(int)GetTerm:(double)fLoanTimeLimit;

+ (void)TotalPayment:(double)fLoanAmount					//贷款金额
    LoanInterestRate:(double)fLoanInterestRate			//贷款利率
       LoanTimeLimit:(int)fLoanTimeLimit				//贷款年限
  ReimbursementMeans:(int)nReimbursementMeans			//还款方式:等额本息,等额本金
                Form:(Form *)sForm						//表单
TotalReimbursementAmount:(double *)fTotalReimbursementAmount//累计还款总额
    TotalPayInterest:(double *)fTotalPayInterest;
+(NSString *)addPoint:(NSString *)str;
+(NSString *)result:(double)dou;
+(NSString *)limitInput:(NSString *)astring;
+(float )getDeviceHight;

@end
