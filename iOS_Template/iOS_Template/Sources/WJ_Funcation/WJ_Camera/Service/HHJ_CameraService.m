//
//  HHJ_CameraService.m
//  iOS_Template
//
//  Created by 贺文杰 on 2021/9/21.
//

#import "HHJ_CameraService.h"
#import "HHJQRCodeViewController.h"
#import "HHJContext.h"

@implementation HHJ_CameraService

- (void)startQRCodeWithExtendInfo:(NSDictionary *)extendInfo animated:(BOOL)animated completionHandle:(void (^)(NSString * _Nonnull, NSString * _Nonnull, NSDictionary * _Nonnull))completionHandle{
    HHJQRCodeViewController *qrCodeVC = [[HHJQRCodeViewController alloc] init];
    qrCodeVC.extendInfo = extendInfo;
    qrCodeVC.block = completionHandle;
    [HHJContext.getCurrentVC.navigationController pushViewController:qrCodeVC animated:YES];
}

@end
