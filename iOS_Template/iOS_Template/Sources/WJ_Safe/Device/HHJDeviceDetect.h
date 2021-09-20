//
//  HHJDeviceDetect.h
//  iOS_Template
//
//  Created by 贺文杰 on 2021/9/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHJDeviceDetect : NSObject

/// 检测设备越狱状态
+ (BOOL)checkDeviceJailBreakState;

/// 判断当前设备是否是模拟器
+ (BOOL)isSimulator;

/// 判断是否被动态库注入
+ (BOOL)isDynamicLBInjected;

/// 防止动态调试，如果动态调试则退出调试
void disable_gdb_debug();

@end

NS_ASSUME_NONNULL_END
