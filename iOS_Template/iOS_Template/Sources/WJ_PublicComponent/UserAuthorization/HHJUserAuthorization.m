//
//  HHJUserAuthorization.m
//  iOS_Template
//
//  Created by 贺文杰 on 2021/9/22.
//

#import "HHJUserAuthorization.h"
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import "HHJContext.h"
#import <Contacts/Contacts.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

@interface HHJUserAuthorization ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, copy) void(^locationHandler)(BOOL agree);
@property (nonatomic, strong) CNContactStore *contactStore;

@end

@implementation HHJUserAuthorization

+ (HHJUserAuthorization *)sharedInstance
{
    static HHJUserAuthorization *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

/// 定位权限
+ (HHJSystemServiceStatus)getLocationServiceEnabled{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (![CLLocationManager locationServicesEnabled] || status == kCLAuthorizationStatusRestricted) {
        return HHJSystemServiceStatusClose;
    } else if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        return HHJSystemServiceStatusAllowed;
    } else if (status == kCLAuthorizationStatusNotDetermined) {
        return HHJSystemServiceStatusNotDetermined;
    } else {
        return HHJSystemServiceStatusDenied;
    }

}

/// 请求定位权限
/// @param pushWhenDenied 是否在被拒绝后，提示前往系统设置页
/// @param completionHandle 权限变更后的回调
+ (void)requestLocationService:(BOOL)pushWhenDenied completionHandle:(void(^)(BOOL agree))completionHandle{
    HHJSystemServiceStatus status = [HHJUserAuthorization getLocationServiceEnabled];
    if (status == HHJSystemServiceStatusNotDetermined) {
        [HHJUserAuthorization sharedInstance].locationHandler = completionHandle;
        [[HHJUserAuthorization sharedInstance].locationManager requestWhenInUseAuthorization];
    }else if (status == HHJSystemServiceStatusDenied &&pushWhenDenied){
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"你没有开启定位权限，请开启定位权限" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }];
            
            [alertVC addAction:cancelAction];
            [alertVC addAction:defaultAction];
            [HHJContext.getCurrentVC presentViewController:alertVC animated:YES completion:^{
                
            }];
        });
    }else{
        if (completionHandle) {
            completionHandle(YES);
        }
    }
}

- (CLLocationManager *)locationManager{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    return _locationManager;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    if (status == kCLAuthorizationStatusNotDetermined) {
        return;
    }
    BOOL agree = YES;
    if (status != kCLAuthorizationStatusAuthorizedAlways && status != kCLAuthorizationStatusAuthorizedWhenInUse) {
        agree = NO;
    }
    if (self.locationHandler) {
        self.locationHandler(agree);
    }
}

/// 通讯录权限
+ (HHJSystemServiceStatus)getContactServiceEnabled{
    CNAuthorizationStatus authStatus = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    switch (authStatus) {
        case CNAuthorizationStatusRestricted:
            return HHJSystemServiceStatusClose;
        case CNAuthorizationStatusNotDetermined:
            return HHJSystemServiceStatusNotDetermined;
        case CNAuthorizationStatusAuthorized:
            return HHJSystemServiceStatusAllowed;
        default:
            return HHJSystemServiceStatusDenied;
    }
}

/// 请求通讯录权限
/// @param pushWhenDenied 是否在被拒绝后，提示前往系统设置页
/// @param completionHandle 权限变更后的回调
+ (void)requestContactService:(BOOL)pushWhenDenied completionHandle:(void(^)(BOOL agree))completionHandle{
    HHJSystemServiceStatus status = [HHJUserAuthorization getContactServiceEnabled];
    if (status == HHJSystemServiceStatusNotDetermined) {
        [[HHJUserAuthorization sharedInstance].contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completionHandle) {
                    completionHandle(granted);
                }
            });
        }];
    }else if (status == HHJSystemServiceStatusDenied && pushWhenDenied){
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"你没有开启通讯录权限，请开启通讯录权限" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }];
            
            [alertVC addAction:cancelAction];
            [alertVC addAction:defaultAction];
            [HHJContext.getCurrentVC presentViewController:alertVC animated:YES completion:^{
                
            }];
        });
    }else{
        if (completionHandle) {
            completionHandle(YES);
        }
    }
}

/// 相机权限
+ (HHJSystemServiceStatus)getCameraServiceEnabled{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusRestricted:
            return HHJSystemServiceStatusClose;
        case AVAuthorizationStatusNotDetermined:
            return HHJSystemServiceStatusNotDetermined;
        case AVAuthorizationStatusAuthorized:
            return HHJSystemServiceStatusAllowed;
        default:
            return HHJSystemServiceStatusDenied;
    }
}

/// 请求相机权限
/// @param pushWhenDenied 是否在被拒绝后，提示前往系统设置页
/// @param completionHandle 权限变更后的回调
+ (void)getCameraService:(BOOL)pushWhenDenied completionHandle:(void(^)(BOOL agree))completionHandle{
    HHJSystemServiceStatus status = [HHJUserAuthorization getCameraServiceEnabled];
    if (status == HHJSystemServiceStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completionHandle) {
                    completionHandle(granted);
                }
            });
        }];
    } else if (status == HHJSystemServiceStatusDenied && pushWhenDenied) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"你没有开启相机权限，请开启相机权限" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }];
            
            [alertVC addAction:cancelAction];
            [alertVC addAction:defaultAction];
            [HHJContext.getCurrentVC presentViewController:alertVC animated:YES completion:^{
                
            }];
        });
    }else{
        if (completionHandle) {
            completionHandle(YES);
        }
    }
}

/// 相册权限
+ (HHJSystemServiceStatus)getPhotoServiceEnabled{
    PHAuthorizationStatus photoStatus =  [PHPhotoLibrary authorizationStatus];
    switch (photoStatus) {
        case PHAuthorizationStatusRestricted:
            return HHJSystemServiceStatusClose;
        case PHAuthorizationStatusNotDetermined:
            return HHJSystemServiceStatusNotDetermined;
        case PHAuthorizationStatusAuthorized:
            return HHJSystemServiceStatusAllowed;
        default:
            return HHJSystemServiceStatusDenied;
    }
}

/// 请求相册权限
/// @param pushWhenDenied 是否在被拒绝后，提示前往系统设置页
/// @param completionHandle 权限变更后的回调
+ (void)requestPhotoService:(BOOL)pushWhenDenied completionHandle:(void(^)(BOOL agree))completionHandle{
    HHJSystemServiceStatus status = [HHJUserAuthorization getPhotoServiceEnabled];
    if (status == HHJSystemServiceStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                BOOL granted = YES;
                if (status != PHAuthorizationStatusAuthorized) {
                    granted = NO;
                }
                if (completionHandle) {
                    completionHandle(granted);
                }
            });
        }];
    } else if (status == HHJSystemServiceStatusDenied && pushWhenDenied) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"你没有开启相册权限，请开启相册权限" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }];
            
            [alertVC addAction:cancelAction];
            [alertVC addAction:defaultAction];
            [HHJContext.getCurrentVC presentViewController:alertVC animated:YES completion:^{
                
            }];
        });
    }else{
        if (completionHandle) {
            completionHandle(YES);
        }
    }
}

/// 麦克风权限
+ (HHJSystemServiceStatus)getMicrophoneServiceEnabled{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (status) {
        case AVAuthorizationStatusRestricted:
            return HHJSystemServiceStatusClose;
        case AVAuthorizationStatusNotDetermined:
            return HHJSystemServiceStatusNotDetermined;
        case AVAuthorizationStatusAuthorized:
            return HHJSystemServiceStatusAllowed;
        default:
            return HHJSystemServiceStatusDenied;
    }
}

/// 请求麦克风权限
/// @param pushWhenDenied 是否在被拒绝后，提示前往系统设置页
/// @param completionHandle 权限变更后的回调
+ (void)requestMicrophoneService:(BOOL)pushWhenDenied completionHandle:(void(^)(BOOL agree))completionHandle{
    HHJSystemServiceStatus status = [HHJUserAuthorization getMicrophoneServiceEnabled];
    if (status == HHJSystemServiceStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completionHandle) {
                    completionHandle(granted);
                }
            });
        }];
    } else if (status == HHJSystemServiceStatusDenied && pushWhenDenied) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"你没有开启麦克风权限，请开启麦克风权限" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }];
            
            [alertVC addAction:cancelAction];
            [alertVC addAction:defaultAction];
            [HHJContext.getCurrentVC presentViewController:alertVC animated:YES completion:^{
                
            }];
        });
    }else{
        if (completionHandle) {
            completionHandle(YES);
        }
    }
}

/// 是否允许通知
+ (BOOL)isUserNotificationEnable{
    BOOL isEnable = NO;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0f) {
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        isEnable = (UIUserNotificationTypeNone == setting.types) ? NO : YES;
    }
    return isEnable;
}


@end
