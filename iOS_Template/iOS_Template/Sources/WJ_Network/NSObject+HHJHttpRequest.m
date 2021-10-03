//
//  NSObject+HHJHttpRequest.m
//  iOS_Template
//
//  Created by 贺文杰 on 2021/10/3.
//

#import "NSObject+HHJHttpRequest.h"
#import "AFHTTPSessionManager.h"
#import "AFURLSessionManager.h"
#import "HHJGlobalConstant.h"
#import "NSString+HHJBase.h"
#import "HHJUtilService.h"

@implementation NSObject (HHJHttpRequest)

/// 上传文件接口方法
/// @param urlString 接口地址
/// @param head header
/// @param parameters body
/// @param fileList 文件数组
/// @param extendInfo 扩展信息
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
+ (void)upload:(NSString *)urlString head:(NSDictionary *)head body:(NSDictionary *)parameters fileList:(NSArray<NSDictionary *> *)fileList extendInfo:(NSDictionary *)extendInfo success:(void(^)(NSURLSessionDataTask *task, id responseObject))successBlock failure:(void(^)(NSURLSessionDataTask *task, id responseObject))failureBlock{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [self HHJ_SecurityPolicy]; //安全策略
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 60; //超时时间
    [manager.requestSerializer setValue:@"application/octet-stream; charset=utf-8" forKey:@"Content-Type"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain",@"text/html", nil];
    [NSObject publicHTTPHeaderFieldForManager:manager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (parameters) {
        [dict addEntriesFromDictionary:parameters];
    }

    [manager POST:urlString parameters:dict headers:head constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            for (NSDictionary *fileDic in fileList) {
                NSData *streamData = [[NSData alloc] initWithBase64EncodedString:fileDic[@"imageBase64"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
                [formData appendPartWithFileData:streamData name:fileDic[@"name"] fileName:fileDic[@"fileName"] mimeType:fileDic[@"fileType"]];
            }
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSError *error = nil;
            id data = [NSJSONSerialization JSONObjectWithData:responseObject
                                                      options:0
                                                        error:&error];
            if (!error) { //上传成功
                if (successBlock) {
                    successBlock(task, data);
                }
            }else{ //上传失败
                if (failureBlock) {
                    failureBlock(task, [self handle:task error:nil]);
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failureBlock) {
                failureBlock(task, [self handle:task error:error]);
            }
        }];
}


//安全策略
- (AFSecurityPolicy *)HHJ_SecurityPolicy
{
#ifdef DEBUG
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesDomainName = NO;
#else
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    securityPolicy.allowInvalidCertificates = NO;
    securityPolicy.validatesDomainName = YES;
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"证书名字" ofType:@"cer"];
    NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
    NSSet *set = [[NSSet alloc] initWithObjects:cerData, nil];
    securityPolicy.pinnedCertificates = set;
#endif
    return securityPolicy;
}

/// 下载文件接口方法
/// @param urlString 接口地址
/// @param head head
/// @param parameters body
/// @param extendInfo 扩展信息
/// @param progressBlock 下载进度
/// @param successBlock 成功回调
/// @param failureBlock 失败回调
+ (void)download:(NSString *)urlString head:(NSDictionary *)head body:(NSDictionary *)parameters extendInfo:(NSDictionary *)extendInfo progress:(void(^)(NSUInteger totalBytes, NSUInteger completedBytes, double fractionCompleted))progressBlock success:(void(^)(NSURLResponse *resp, NSURL *ur))successBlock failure:(void(^)(NSURLResponse *resp, NSError *err))failureBlock{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.securityPolicy = [self HHJ_SecurityPolicy];
    [NSObject publicHTTPHeaderFieldForManager:manager];
    
    NSMutableURLRequest *mtbRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [mtbRequest setHTTPMethod:@"POST"];
    NSString *jsonStr = [NSString stringWithDictionary:parameters];
    NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    [mtbRequest setHTTPBody:data];
    NSURLSessionDownloadTask *dTask = [manager downloadTaskWithRequest:mtbRequest progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progressBlock) {
            progressBlock(downloadProgress.totalUnitCount, downloadProgress.completedUnitCount, downloadProgress.fractionCompleted);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString *cacheDir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        NSString *path = [cacheDir stringByAppendingPathComponent:response.suggestedFilename];
        NSURL *fileURL = [NSURL fileURLWithPath:path];
        return fileURL;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (error) {
            if (failureBlock) {
                failureBlock(response, error);
            }
        }else{
            if (successBlock) {
                successBlock(response, filePath);
            }
        }
    }];
    [dTask resume];
}

+ (void)HHJ_POST:(NSString *)urlString head:(NSDictionary *)head body:(NSDictionary *)parameters extendInfo:(NSDictionary *)extendInfo success:(void(^)(NSURLSessionDataTask *task, id responseObject))successBlock failure:(void(^)(NSURLSessionDataTask *task, NSError *err))failureBlock{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [self HHJ_SecurityPolicy]; //安全策略
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 60; //超时时间
    [manager.requestSerializer setValue:@"application/octet-stream; charset=utf-8" forKey:@"Content-Type"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain",@"text/html", nil];
    [NSObject publicHTTPHeaderFieldForManager:manager];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (parameters) {
        [dict addEntriesFromDictionary:parameters];
    }
    
    [manager POST:urlString parameters:dict headers:head progress:^(NSProgress * _Nonnull uploadProgress) {
            
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            successBlock(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failureBlock) {
            failureBlock(task, error);
        }
    }];
}

+ (void)HHJ_GET:(NSString *)urlString head:(NSDictionary *)head body:(NSDictionary *)parameters extendInfo:(NSDictionary *)extendInfo success:(void(^)(NSURLSessionDataTask *task, id responseObject))successBlock failure:(void(^)(NSURLSessionDataTask *task, NSError *err))failureBlock{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = [self HHJ_SecurityPolicy]; //安全策略
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 60; //超时时间
    [manager.requestSerializer setValue:@"application/octet-stream; charset=utf-8" forKey:@"Content-Type"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain",@"text/html", nil];
    [NSObject publicHTTPHeaderFieldForManager:manager];

    [manager GET:urlString parameters:parameters headers:head progress:^(NSProgress * _Nonnull downloadProgress) {
            
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            successBlock(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failureBlock) {
            failureBlock(task, error);
        }
    }];
}

+ (void)publicHTTPHeaderFieldForManager:(AFHTTPSessionManager *)manager{
    [HHJUtilService getNetworkStatus:^(NSString * _Nonnull status) {
        [manager.requestSerializer setValue:status forHTTPHeaderField:@"network"];
    }];
    [manager.requestSerializer setValue:[HHJUtilService getIPAddressIPv4:YES] forHTTPHeaderField:@"ip"];
    [manager.requestSerializer setValue:[HHJUtilService macaddress] forHTTPHeaderField:@"mac"];
    [manager.requestSerializer setValue:[HHJUtilService carrierName] forHTTPHeaderField:@"carrier"];
    [manager.requestSerializer setValue:[HHJUtilService OSVersion] forHTTPHeaderField:@"OSVersion"];
    [manager.requestSerializer setValue:[HHJUtilService deviceName] forHTTPHeaderField:@"deviceName"];
    [manager.requestSerializer setValue:[HHJUtilService devicePlatForm] forHTTPHeaderField:@"devicePlatForm"];
    [manager.requestSerializer setValue:[HHJUtilService resolution] forHTTPHeaderField:@"resolution"];
    [manager.requestSerializer setValue:[HHJUtilService getUserLanguageCode] forHTTPHeaderField:@"UserLanguageCode"];
    [manager.requestSerializer setValue:[HHJUtilService getAppName] forHTTPHeaderField:@"AppName"];
    [manager.requestSerializer setValue:[HHJUtilService getAppBuildVersion] forHTTPHeaderField:@"AppBuildVersion"];
    [manager.requestSerializer setValue:[HHJUtilService getAppVersion] forHTTPHeaderField:@"AppVersion"];
}

//NSURLErrorDomain 的错误编码
//https://www.it610.com/article/1305285465959600128.htm

//处理http报错回传的报错信息
- (NSDictionary *)handle:(NSURLSessionDataTask *)task error:(NSError *)error
{
    NSMutableDictionary *errDic = [[NSMutableDictionary alloc]initWithCapacity:4];
    [errDic setValue:@"温馨提示" forKey:@"title"];
    NSString *errMsg;
    
    switch ([error code])
    {
        case NSURLErrorUnknown: //-1,未知
            break;
        case NSURLErrorCancelled: //999,取消
            break;
        case NSURLErrorBadURL: //-1000,错误URL
            break;
        case NSURLErrorTimedOut: //-1001,超时
            errMsg = @"请求超时,请稍后再试!";
            break;
        case NSURLErrorUnsupportedURL: //-1002,不支持URL
            break;
        case NSURLErrorCannotFindHost: //-1003,找不到主机
            break;
        case NSURLErrorCannotConnectToHost: //-1004,无法连接到主机
            errMsg = @"暂时无法链接到服务器,请稍后再试!";
            break;
        case NSURLErrorNetworkConnectionLost: //-1005,网络连接丢失
            errMsg = @"网络连接丢失";
            break;
        case NSURLErrorDNSLookupFailed: //-1006,DNS查询失败
            break;
        case NSURLErrorHTTPTooManyRedirects: //-1007,HTTP重定向太多
            break;
        case NSURLErrorResourceUnavailable: //-1008,资源不可用
            break;
        case NSURLErrorNotConnectedToInternet: //-1009,未连接到互联网的NSURL错误
            errMsg = @"网络链接不可用,请检查网络!";
            break;
        case NSURLErrorRedirectToNonExistentLocation: //-1010,重定向到不存在的位置
            break;
        case NSURLErrorBadServerResponse: //-1011,服务器响应错误
            errMsg = [NSString stringWithFormat:@"服务器返回异常(%zd),请稍后再试!", ((NSHTTPURLResponse *)task.response).statusCode];
            break;
        case NSURLErrorUserCancelledAuthentication: //-1012,用户取消身份验证
            break;
        case NSURLErrorUserAuthenticationRequired: //-1013
            break;
        case NSURLErrorZeroByteResource: //-1014,0字节资源
            break;
        case NSURLErrorCannotDecodeRawData: //-1015,无法解码原始数据
            break;
        case NSURLErrorCannotDecodeContentData: //-1016,无法解码内容数据
            break;
        case NSURLErrorCannotParseResponse: //-1017,无法解析响应
            break;
        case NSURLErrorSecureConnectionFailed: //-1200,安全连接失败
            break;
        case NSURLErrorServerCertificateHasBadDate: //-1201,服务器证书错误日期
            break;
        case NSURLErrorServerCertificateUntrusted: //-1202,服务器证书不可信
            break;
        case NSURLErrorServerCertificateHasUnknownRoot: //-1203,服务器证书有未知的根
            break;
        case NSURLErrorServerCertificateNotYetValid: //-1204,服务器证书无效
            break;
        case NSURLErrorClientCertificateRejected: //-1205,客户端证书拒绝
            break;
        case NSURLErrorClientCertificateRequired: //-1206,客户端证书要求
            break;
        case NSURLErrorCannotLoadFromNetwork: //-2000,无法从网络加载
            break;
        default:
            errMsg = @"请求失败,请稍后再试!";
            break;
    }
    NSDictionary *bodyDic = @{@"resultCode" : @([error code]).stringValue, @"resultMessage" : errMsg};
    [errDic setValue:bodyDic forKey:@"head"];
    return errDic;
}


@end
