//
//  CalculatorGlobal.h
//  CalculatorFix
//
//  Created by hebei on 14-10-30.
//  Copyright (c) 2014年 PNC. All rights reserved.
//

#ifndef CalculatorFix_CalculatorGlobal_h
#define CalculatorFix_CalculatorGlobal_h
#endif

#define ratePointLimitCount     4 //小数点后面位数

#define COMMON_KEYBOARD_HEIGHT      200
#define COMMON_INPUT_HEIGHT         176
#define COMMON_ADVIEW_HEIGHT        44
#define COMMON_TOOLBAR_HEIGHT       44

#define COMMON_DATEPICKER_Y 201

#define rateJSUrl @"http://hq.sinajs.cn/rn=i64tf&list=HKYN,AUCA,AUER,AUHK,AUSF,AUYN,CAHK,CAYN,ERAU,ERCA,ERHK,ERSF,ERUK,ERYN,SFHK,SFYN,UKAU,UKCA,UKER,UKHK,UKSF,UKYN,HKD,AUD,CAD,CHF,EUR,GBP,JPY"


typedef enum {
    CALC_SHOW_DETAIL_NONE   = 0,
    CALC_SHOW_DETAIL_YES    = 1
}CALC_SHOW_DETAIL;

//计算器种类
typedef enum {
    CalculateCategoryInstallments,         //零存整取
    CalculateCategoryLumpsumDeposit,       //整存整取
    CalculateCategoryNotificationDeposit,  //通知存款
    CalculateCategoryCurrentDeposit,       //活期储蓄
    CalculateCategoryPersonalLoan,         //个人贷款
    CalculateCategoryPrepayment,           //一次性提前还款
    CalculateCategoryPartPrepayment,       //部分提前还款
    CalculateCategoryEndowmentInsurance,   //养老保险
    CalculateCategoryHousingReserve,       //住房公积金
    CalculateCategoryPersonalIncomeTax,     //个人所得锐
}CalculateCategory;

// 输入
#define kLoanAmount									@"贷款金额"
#define kLoanTimelimit								@"贷款年限"
#define	kLoanInterestRate							@"贷款利率"
//#define	kReimbursementMeans						@"还款方式"
#define kEqualInstallmentsOfPrincipalAndInterest	@"等额本息"
#define kEqualPrincipal								@"等额本金"

// 输出
#define kAccumulativeTotalPayInterest			@"累计支付利息"
#define kAccumulativeTotalReimbursementAmount	@"累计还款总额"



#define kStringNil									@""
#define kStringNibNameDetailResult					@"DetailResult"
#define kStringNibNameDetailResultCell				@"DetailResultCell"


#define kStringTerm									@"期次"
#define kStringInterestPayments						@"偿还利息"
#define kStringRepaymentOfPrincipalAndInterest		@"偿还本息"
#define kStringPrincipalRepayment					@"偿还本金"
#define kStringRemainingPrincipal					@"剩余本金"


//详细
#define kTagTerm								1
#define kTagRepaymentOfPrincipalAndInterest		2
#define kTagInterestPayments					3
#define kTagPrincipalRepayment					4
#define kTagRemainingPrincipal					5

typedef struct tagForm
{
    int nTerm;//期次（nTerm）
    double fRepaymentOfPrincipalAndInterest;//偿还本息(元)
    double fInterestPayments;//偿还利息(元)
    double fPrincipalRepayment;//偿还本金(元)
    double fRemainingPrincipal;//剩余本金(元)
    double fBusinessRemainingPrincipal;//商贷剩余本金（元）
    double fAccumulationFundRemainingPrincipal;//公积金贷款剩余本金（元）
    double fBusinessInterestPayments;//商贷偿还利息（元）
    double fAccumulationFundInterestPayments;//公积金偿还利息（元）
}Form;//表单

static Form ssForm[1024*12];





