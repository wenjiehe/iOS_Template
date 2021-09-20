//
//  HHJNetworkDetect.h
//  iOS_Template
//
//  Created by 贺文杰 on 2021/9/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHJNetworkDetect : NSObject

/// 判断是否开启了代理
+ (BOOL)checkProxySetting;

@end

NS_ASSUME_NONNULL_END
