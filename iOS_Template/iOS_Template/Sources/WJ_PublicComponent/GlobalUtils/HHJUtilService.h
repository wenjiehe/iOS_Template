//
//  HHJUtilService.h
//  iOS_Template
//
//  Created by 贺文杰 on 2021/9/20.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHJUtilService : NSObject

/// 返回网络状态
/// @param block 回调block，status为 unknow-未知网络 NotReachable-网络不可达, 无网络 WiFi-WiFi 2G-2G网络 3G-3G网络 4G-4G网络 5G-5G网络
+ (void)getNetworkStatus:(void(^)(NSString *status))block;

/// 获取ip
/// @param preferIPv4 是否ipv4
+ (NSString *)getIPAddressIPv4:(BOOL)preferIPv4;

/**
 *  获取Mac地址
 *
 *  @return NSString *
 */
+ (NSString *)macaddress;
// 获取运营商
+ (NSString *)carrierName;
// 获取系统版本
+ (NSString *)OSVersion;
// 获取设备型号
+ (NSString *)deviceName;
// 获取平台 iPhone iPad
+ (NSString *)devicePlatForm;
/// 获取设备分辨率
+ (NSString *)resolution;

/**
*  获取用户手机的语言
*  例如 zh-Hans
*
*  @return  例如zh-Hans
*/
+ (NSString *)getUserLanguageCode;

/**
*  获取应用名称
*  @return  应用名称
*/
+ (NSString *)getAppName;

/**
 *  把设计搞上的标注转换成小屏设备需要的标注尺寸
 *
 *  @param original     设计稿上的标注
 *  @param width    设计稿设计的标准宽度(目前按750设计)
 *
 *  @return 小屏设备需要的标注尺寸
 */
+ (CGFloat)adaptedUI:(CGFloat)original UIWidth:(CGFloat)width;



@end

NS_ASSUME_NONNULL_END
