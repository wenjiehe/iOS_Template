//
//  HHJNetworkDetect.m
//  iOS_Template
//
//  Created by 贺文杰 on 2021/9/20.
//

#import "HHJNetworkDetect.h"

@implementation HHJNetworkDetect

/// 判断是否开启了代理
+ (BOOL)checkProxySetting{
    CFDictionaryRef dicRef = CFNetworkCopySystemProxySettings();
    const CFStringRef proxyCFstr = (const CFStringRef)CFDictionaryGetValue(dicRef,
                                                                           (const void*)kCFNetworkProxiesHTTPProxy);
    NSString *proxy = (__bridge NSString *)proxyCFstr;
    
    if (proxy && proxy.length > 0) {
        return YES;
    }else {
        return NO;
    }
}

@end
