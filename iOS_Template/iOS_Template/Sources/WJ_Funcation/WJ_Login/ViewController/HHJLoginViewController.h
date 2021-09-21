//
//  HHJLoginViewController.h
//  iOS_Template
//
//  Created by 贺文杰 on 2021/9/21.
//

#import "HHJBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^HHJLoginSuccessBlock)(NSDictionary *userInfo, NSDictionary *extendInfo);
typedef BOOL(^HHJProcessBlock)(void);

@interface HHJLoginViewController : HHJBaseViewController

@property(nonatomic,strong)NSDictionary *extendInfo;
@property(nonatomic,copy)HHJLoginSuccessBlock successBlock;
@property(nonatomic,copy)HHJProcessBlock processBlock;

@end

NS_ASSUME_NONNULL_END
