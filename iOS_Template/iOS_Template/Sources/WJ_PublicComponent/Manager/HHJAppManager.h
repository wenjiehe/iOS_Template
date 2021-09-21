//
//  HHJAppManager.h
//  iOS_Template
//
//  Created by 贺文杰 on 2021/9/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHJAppManager : NSObject

@property(nonatomic,strong)NSMutableArray<NSString *> *vcMtbAry; //存储没有释放dealloc的vc

+ (instancetype)sharedInstance;

@end

NS_ASSUME_NONNULL_END
