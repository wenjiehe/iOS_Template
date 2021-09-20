//
//  NSObject+HHJScreenDetect.m
//  iOS_Template
//
//  Created by 贺文杰 on 2021/9/20.
//

#import "NSObject+HHJScreenDetect.h"
#import <UIKit/UIKit.h>

@implementation NSObject (HHJScreenDetect)

/// 添加截屏监听
/// @param aSelector 发生截屏触发
- (void)addScreenCaptureObserver:(SEL)aSelector{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:aSelector name:UIApplicationUserDidTakeScreenshotNotification object:nil];
}

/// 移除截屏监听
- (void)removeScreenCaptureObserver{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationUserDidTakeScreenshotNotification object:nil];
}

/// 添加录屏监听，iOS 11之后有效，通过
/// @param aSelector 发生录屏触发，事件出发后 通过  [UIScreen mainScreen].isCaptured 来判断是否录屏(YES录屏 NO没录屏)
- (void)addScreenRecordObserver:(SEL)aSelector{
    if (@available(iOS 11.0,*)) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:aSelector name:UIScreenCapturedDidChangeNotification  object:nil];
    }
}

/// 移除录屏监听，iOS 11之后有效
- (void)removeScreenRecordObserver{
    if (@available(iOS 11.0,*)) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIScreenCapturedDidChangeNotification object:nil];
    }
}

@end
