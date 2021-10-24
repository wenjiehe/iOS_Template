//
//  HHJGlobalConstant.h
//  iOS_Template
//
//  Created by 贺文杰 on 2021/9/20.
//

#ifndef HHJGlobalConstant_h
#define HHJGlobalConstant_h

#import "Masonry.h"

//其他宏定义

#define HHJ_MediumFont_(i) (([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) ? [UIFont fontWithName:@"PingFangSC-Medium" size:i] : [UIFont fontWithName:@"STHeitiSC-Medium" size:i])

#define HHJ_RegularFont_(i) (([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) ? [UIFont fontWithName:@"PingFangSC-Regular" size:i] : [UIFont fontWithName:@"STHeitiSC-Light" size:i])

#define HHJ_BoldFont_(i) (([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) ? [UIFont fontWithName:@"PingFangSC-Bold" size:i] : [UIFont fontWithName:@"STHeitiSC-Light" size:i])

#define HHJ_SemiBoldFont_(i) (([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) ? [UIFont fontWithName:@"PingFangSC-Semibold" size:i] : [UIFont fontWithName:@"STHeitiSC-Light" size:i])

#define HHJ_HeavyFont_(i) (([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) ? [UIFont fontWithName:@"PingFangSC-Heavy" size:i] : [UIFont fontWithName:@"STHeitiSC-Light" size:i])

#pragma mark - ================  Frame ================
//状态栏高度
#define kStatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height
//导航栏高度
#define kNavBarHeight 44.0f
#define kTitleHeight kNavBarHeight + kStatusBarHeight
//tabbar高度
#define kTabBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20.0f?83.0f:49.0f)

//屏幕比例
#define wflag ([UIScreen mainScreen].bounds.size.width / 375.0f)
#define hflag ([UIScreen mainScreen].bounds.size.height / 667.0f)
#define kStretch(x) (wflag * x)

//是否是iPhoneX
//844是iPhone12和iPhone12Pro机型
//926是iPhone12 Pro Max机型
#define iPhoneX ([UIScreen mainScreen].bounds.size.height == 812.0f || [UIScreen mainScreen].bounds.size.height == 896.0f || [UIScreen mainScreen].bounds.size.height == 844.0f || [UIScreen mainScreen].bounds.size.height == 926.0f)
//X与其他屏幕的导航栏高度差
#define isIphoneXNavBarMargin (iPhoneX?24.0f:0.0f)
//X与其他屏幕的底部tabbar高度差
#define isIphoneXTabBarMargin (iPhoneX?34.0f:0.0f)

#define screenWidth ([UIScreen mainScreen].bounds.size.width)
#define screenHeight ([UIScreen mainScreen].bounds.size.height)
#define screenScale ([UIScreen mainScreen].scale)

#pragma mark - ================  Color ================
#define COLOR_RGB(R,G,B)     [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:1]
#define COLOR_RGBA(R,G,B,A)  [UIColor colorWithRed:(R)/255.0f green:(G)/255.0f blue:(B)/255.0f alpha:(A)]

#pragma mark - ================  Debug ================
// 打印调试信息
#ifdef DEBUG
#define HHJLog(format, ...) printf("class: <%p %s:(%d) > method: %s \n%s\n", self, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String] )
#else
#define HHJLog(format, ...)
#endif


#pragma mark - ================  Nil ================
//字符串是否为空
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )
//数组是否为空
#define kArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)
//字典是否为空
#define kDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)

//如果为空对象，返回@""
#define kCheckNil(value)\
({id tmp;\
if ([(value) isKindOfClass:[NSNull class]] || \
[[NSString stringWithFormat:@"%@",value] isEqualToString:@"(null)"] || \
[[NSString stringWithFormat:@"%@",value] isEqualToString:@"(NULL)"] || \
[[NSString stringWithFormat:@"%@",value] isEqualToString:@"null"] || \
[[NSString stringWithFormat:@"%@",value] isEqualToString:@"<null>"] || \
[[NSString stringWithFormat:@"%@",value] isEqualToString:@"NULL"]) \
{tmp = @"";}\
else\
{tmp = (value?value:@"");}\
tmp;\
})\

#endif /* HHJGlobalConstant_h */
