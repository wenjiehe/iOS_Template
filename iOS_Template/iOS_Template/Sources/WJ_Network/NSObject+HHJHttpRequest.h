//
//  NSObject+HHJHttpRequest.h
//  iOS_Template
//
//  Created by 贺文杰 on 2021/10/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (HHJHttpRequest)

/// 上传文件接口方法
/// @param urlString 接口地址
/// @param head header
/// @param parameters body
/// @param fileList 文件数组
/// @param extendInfo 扩展信息
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
+ (void)upload:(NSString *)urlString head:(NSDictionary *)head body:(NSDictionary *)parameters fileList:(NSArray<NSDictionary *> *)fileList extendInfo:(NSDictionary *)extendInfo success:(void(^)(NSURLSessionDataTask *task, id responseObject))successBlock failure:(void(^)(NSURLSessionDataTask *task, id responseObject))failureBlock;

/// 下载文件接口方法
/// @param urlString 接口地址
/// @param head head
/// @param parameters body
/// @param extendInfo 扩展信息
/// @param progressBlock 下载进度
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
+ (void)download:(NSString *)urlString head:(NSDictionary *)head body:(NSDictionary *)parameters extendInfo:(NSDictionary *)extendInfo progress:(void(^)(NSUInteger totalBytes, NSUInteger completedBytes, double fractionCompleted))progressBlock success:(void(^)(NSURLResponse *resp, NSURL *ur))successBlock failure:(void(^)(NSURLResponse *resp, NSError *err))failureBlock;


/// POST请求
/// @param urlString 接口地址
/// @param head head
/// @param parameters body
/// @param extendInfo 扩展信息
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
+ (void)HHJ_POST:(NSString *)urlString head:(NSDictionary *)head body:(NSDictionary *)parameters extendInfo:(NSDictionary *)extendInfo success:(void(^)(NSURLSessionDataTask *task, id responseObject))successBlock failure:(void(^)(NSURLSessionDataTask *task, NSError *err))failureBlock;

+ (void)HHJ_GET:(NSString *)urlString head:(NSDictionary *)head body:(NSDictionary *)parameters extendInfo:(NSDictionary *)extendInfo success:(void(^)(NSURLSessionDataTask *task, id responseObject))successBlock failure:(void(^)(NSURLSessionDataTask *task, NSError *err))failureBlock;


@end

NS_ASSUME_NONNULL_END
