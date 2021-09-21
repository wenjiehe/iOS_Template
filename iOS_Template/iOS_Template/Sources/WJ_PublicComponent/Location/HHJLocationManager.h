//
//  HHJLocationManager.h
//  iOS_Template
//
//  Created by 贺文杰 on 2021/9/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHJLocationManager : NSObject

+ (instancetype)sharedInstance;

/// 是否支持定位服务
+ (BOOL)isLocationServicesEnabled;

/// 获取定位信息
/// @param completion 回调
- (void)startUpdatingLocationWithCompletion:(void(^)(NSDictionary *locationInfo))completion;

@end

NS_ASSUME_NONNULL_END
