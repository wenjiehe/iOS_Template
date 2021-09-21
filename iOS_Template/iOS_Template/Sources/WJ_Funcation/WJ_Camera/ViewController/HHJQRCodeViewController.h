//
//  HHJQRCodeViewController.h
//  iOS_Template
//
//  Created by 贺文杰 on 2021/9/21.
//

#import "HHJBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^HHJQRCodeBlock)(NSString *qrcodeString, NSString *source, NSDictionary *extendInfo);

@interface HHJQRCodeViewController : HHJBaseViewController

@property(nonatomic,strong)NSDictionary *extendInfo;
@property(nonatomic,copy)HHJQRCodeBlock block;

@end

NS_ASSUME_NONNULL_END
