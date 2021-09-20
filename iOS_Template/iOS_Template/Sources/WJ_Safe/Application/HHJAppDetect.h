//
//  HHJAppDetect.h
//  iOS_Template
//
//  Created by 贺文杰 on 2021/9/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHJAppDetect : NSObject

/// 通过bundleId判断应用是否被重签
/// @param bundleId bundleId
+ (BOOL)checkIsResignByBundleId:(NSString *)bundleId;

/// 通过证书中的组织单位信息字段判断是否被重签
/// @param organizationalUnitId 组织单位id
+ (BOOL)checkIsResignByOrganizationalUnitId:(NSString *)organizationalUnitId;

/// 检测应用是否被篡改
+ (BOOL)checkIsTamper;

@end

NS_ASSUME_NONNULL_END
