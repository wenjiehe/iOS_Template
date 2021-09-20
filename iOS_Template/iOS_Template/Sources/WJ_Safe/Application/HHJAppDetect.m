//
//  HHJAppDetect.m
//  iOS_Template
//
//  Created by 贺文杰 on 2021/9/20.
//

#import "HHJAppDetect.h"

@implementation HHJAppDetect

/// 通过bundleId判断应用是否被重签
/// @param bundleId bundleId
+ (BOOL)checkIsResignByBundleId:(NSString *)bundleId
{
    BOOL isResign = YES;
    NSString *appBundleId = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
    if (bundleId && bundleId.length > 0 && appBundleId && appBundleId.length > 0 && [appBundleId isEqualToString:bundleId]) {
        isResign = NO;
    }
    return isResign;
}

/// 通过证书中的组织单位信息字段判断是否被重签
/// @param organizationalUnitId 组织单位id
+ (BOOL)checkIsResignByOrganizationalUnitId:(NSString *)organizationalUnitId
{
    BOOL isResign = NO;
    // 描述文件路径
    NSString *embeddedPath = [[NSBundle mainBundle] pathForResource:@"embedded" ofType:@"mobileprovision"];
    // 读取application-identifier  注意描述文件的编码要使用:NSASCIIStringEncoding
    NSString *embeddedProvisioning = [NSString stringWithContentsOfFile:embeddedPath encoding:NSASCIIStringEncoding error:nil];
    NSArray *embeddedProvisioningLines = [embeddedProvisioning componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    for (int i = 0; i < embeddedProvisioningLines.count; i++) {
        if ([embeddedProvisioningLines[i] rangeOfString:@"application-identifier"].location != NSNotFound) {
            NSInteger fromPosition = [embeddedProvisioningLines[i+1] rangeOfString:@"<string>"].location+8;
            NSInteger toPosition = [embeddedProvisioningLines[i+1] rangeOfString:@"</string>"].location;
            NSRange range;
            range.location = fromPosition;
            range.length = toPosition - fromPosition;
            NSString *fullIdentifier = [embeddedProvisioningLines[i+1] substringWithRange:range];
            NSArray *identifierComponents = [fullIdentifier componentsSeparatedByString:@"."];
            NSString *appIdentifier = [identifierComponents firstObject];
            // 对比签名ID
            if (![appIdentifier isEqual:organizationalUnitId]) {
                isResign = YES;
            }
            break;
        }
    }
    
    return isResign;
}

/// 检测应用是否被篡改
+ (BOOL)checkIsTamper{
    NSBundle *bundle = [NSBundle mainBundle];
    NSDictionary *info = [bundle infoDictionary];
    if ([info objectForKey:@"SignerIdentity"] != nil)
    {
        return YES;
    }
    return NO;
}


@end
