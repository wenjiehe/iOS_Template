//
//  HHJ_CameraProtocol.h
//  iOS_Template
//
//  Created by 贺文杰 on 2021/9/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HHJ_CameraProtocol <NSObject>

/// 启动扫码组件
/// @param extendInfo 传递扩展信息
/// @param animated 动画效果
/// @param completionHandle 回调，qrcodeString-扫描出的二维码字符串，source-来源：1-扫描 0-相册，extendInfo-传递进来的扩展信息
- (void)startQRCodeWithExtendInfo:(NSDictionary *)extendInfo animated:(BOOL)animated completionHandle:(void(^)(NSString *qrcodeString, NSString *source, NSDictionary *extendInfo))completionHandle;

@end

NS_ASSUME_NONNULL_END
