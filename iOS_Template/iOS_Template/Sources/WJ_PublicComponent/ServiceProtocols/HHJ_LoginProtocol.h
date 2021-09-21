//
//  HHJ_LoginProtocol.h
//  iOS_Template
//
//  Created by 贺文杰 on 2021/9/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HHJ_LoginProtocol <NSObject>

/// 进入登录界面
/// @param extendInfo 扩展信息
/// @param animated 动画效果
/// @param loginSuccess 成功或失败回调, userInfo-返回登录成功后的用户信息，extendInfo-返回传递进去的扩展信息
/// @param pageProcessSuccess YES-把登录界面从栈中移除，NO-保留登录界面
- (void)startLogin:(NSDictionary *)extendInfo animated:(BOOL)animated loginSuccess:(void(^)(NSDictionary *userInfo, NSDictionary *extendInfo))loginSuccess pageProcessSuccess:(BOOL(^)(void))pageProcessSuccess;

- (void)cleanLoginInfo;

@end

NS_ASSUME_NONNULL_END
