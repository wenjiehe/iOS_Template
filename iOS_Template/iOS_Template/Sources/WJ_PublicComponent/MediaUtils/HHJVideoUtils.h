//
//  HHJVideoUtils.h
//  iOS_Template
//
//  Created by 贺文杰 on 2021/9/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHJVideoUtils : NSObject

/// 获取网络视频信息，建议：放在异步线程中获取，避免阻塞主线程
/// @param url 网络视频url
+ (NSDictionary *)getNetworkVideoInfo:(NSString *)url;

@end

NS_ASSUME_NONNULL_END
