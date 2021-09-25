//
//  HHJUserAuthorization.h
//  iOS_Template
//
//  Created by 贺文杰 on 2021/9/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, HHJSystemServiceStatus) {
    HHJSystemServiceStatusNotDetermined, //尚未授权
    HHJSystemServiceStatusAllowed, //已授权
    HHJSystemServiceStatusDenied, //已拒绝授权
    HHJSystemServiceStatusClose, //系统关闭或者不支持该功能
};

@interface HHJUserAuthorization : NSObject

+ (HHJUserAuthorization *)sharedInstance;

/// 定位权限
+ (HHJSystemServiceStatus)getLocationServiceEnabled;

/// 请求定位权限
/// @param pushWhenDenied 是否在被拒绝后，提示前往系统设置页
/// @param completionHandle 权限变更后的回调
+ (void)requestLocationService:(BOOL)pushWhenDenied completionHandle:(void(^)(BOOL agree))completionHandle;

/// 通讯录权限
+ (HHJSystemServiceStatus)getContactServiceEnabled;

/// 请求通讯录权限
/// @param pushWhenDenied 是否在被拒绝后，提示前往系统设置页
/// @param completionHandle 权限变更后的回调
+ (void)requestContactService:(BOOL)pushWhenDenied completionHandle:(void(^)(BOOL agree))completionHandle;

/// 相机权限
+ (HHJSystemServiceStatus)getCameraServiceEnabled;

/// 请求相机权限
/// @param pushWhenDenied 是否在被拒绝后，提示前往系统设置页
/// @param completionHandle 权限变更后的回调
+ (void)getCameraService:(BOOL)pushWhenDenied completionHandle:(void(^)(BOOL agree))completionHandle;

/// 相册权限
+ (HHJSystemServiceStatus)getPhotoServiceEnabled;

/// 请求相册权限
/// @param pushWhenDenied 是否在被拒绝后，提示前往系统设置页
/// @param completionHandle 权限变更后的回调
+ (void)requestPhotoService:(BOOL)pushWhenDenied completionHandle:(void(^)(BOOL agree))completionHandle;

/// 麦克风权限
+ (HHJSystemServiceStatus)getMicrophoneServiceEnabled;

/// 请求麦克风权限
/// @param pushWhenDenied 是否在被拒绝后，提示前往系统设置页
/// @param completionHandle 权限变更后的回调
+ (void)requestMicrophoneService:(BOOL)pushWhenDenied completionHandle:(void(^)(BOOL agree))completionHandle;

/// 是否允许通知
+ (BOOL)isUserNotificationEnable;

@end

NS_ASSUME_NONNULL_END
