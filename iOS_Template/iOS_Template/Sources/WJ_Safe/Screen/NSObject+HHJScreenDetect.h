//
//  NSObject+HHJScreenDetect.h
//  iOS_Template
//
//  Created by 贺文杰 on 2021/9/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (HHJScreenDetect)

/// 添加截屏监听
/// @param aSelector 发生截屏触发
- (void)addScreenCaptureObserver:(SEL)aSelector;

/// 移除截屏监听
- (void)removeScreenCaptureObserver;

/// 添加录屏监听，iOS 11之后有效，通过
/// @param aSelector 发生录屏触发，事件出发后 通过  [UIScreen mainScreen].isCaptured 来判断是否录屏(YES录屏 NO没录屏)
- (void)addScreenRecordObserver:(SEL)aSelector;

/// 移除录屏监听，iOS 11之后有效
- (void)removeScreenRecordObserver;

@end

NS_ASSUME_NONNULL_END
