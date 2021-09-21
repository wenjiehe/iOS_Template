//
//  HHJContext.m
//  iOS_Template
//
//  Created by 贺文杰 on 2021/9/21.
//

#import "HHJContext.h"
#import <objc/runtime.h>

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
    Protocol *protocol = NSProtocolFromString(name);
    BOOL isProtocol = class_conformsToProtocol(cls, protocol);
    //判断服务类是否实现了对应协议
    if (!isProtocol) { //没有实现
        NSLog(@"没有实现%@协议", name);
    }
    unsigned int count = 0;
    //第一个YES：是否是RequiredMethod, 第二个YES：是否是实例方法
    struct objc_method_description *methodList = protocol_copyMethodDescriptionList(protocol, YES, YES, &count);
    NSMutableArray *selectorMtbAry = [NSMutableArray new];
    for (unsigned int i = 0; i < count; i++) {
        struct objc_method_description method = methodList[i];
        [selectorMtbAry addObject:NSStringFromSelector(method.name)];
    }
    free(methodList);
    
    id class = [[cls alloc] init];
    for (NSString *selectorName in selectorMtbAry) {
        if (![class respondsToSelector:NSSelectorFromString(selectorName)]) {
            NSLog(@"没有实现%@协议的必须方法%@", name, selectorName);
        }
    }


    return class;
}


@end
