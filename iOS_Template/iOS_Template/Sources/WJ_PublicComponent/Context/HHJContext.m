//
//  HHJContext.m
//  iOS_Template
//
//  Created by 贺文杰 on 2021/9/21.
//

#import "HHJContext.h"

NSString *const ServiceString = @"Service";
NSString *const ProtocolString = @"Protocol";

@implementation HHJContext

+ (UIViewController *)getCurrentVC{
    UIViewController *result = nil;
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (UIWindow *tempWindow in windows) {
            if (tempWindow.windowLevel == UIWindowLevelNormal) {
                window = tempWindow;
                break;
            }
        }
    }
    
    UIViewController *rootVC = window.rootViewController;
    id nextResponder = [rootVC.view nextResponder];
    if ([nextResponder isKindOfClass:[UINavigationController class]]) {
        result = ((UINavigationController *)nextResponder).topViewController;
        if ([result isKindOfClass:[UITabBarController class]]) {
            result = ((UITabBarController *)result).selectedViewController;
        }
    }else if ([nextResponder isKindOfClass:[UITabBarController class]]){
        result = ((UITabBarController *)nextResponder).selectedViewController;
        if ([result isKindOfClass:[UINavigationController class]]) {
            result = ((UINavigationController *)result).topViewController;
        }
    }else if ([nextResponder isKindOfClass:[UIViewController class]]){
        result = nextResponder;
    }else{
        result = window.rootViewController;
        if ([result isKindOfClass:[UINavigationController class]]) {
            result = ((UINavigationController *)result).topViewController;
            if ([result isKindOfClass:[UITabBarController class]]) {
                result = ((UITabBarController *)result).selectedViewController;
            }
        }else if([result isKindOfClass:[UIViewController class]]){
            result = nextResponder;
        }
    }
    
    return result;
}

+ (id)findServerName:(NSString *)name{
    NSString *clsString = [name stringByReplacingOccurrencesOfString:ProtocolString withString:ServiceString];
    Class cls = NSClassFromString(clsString);
    return [[cls alloc] init];
}


@end
