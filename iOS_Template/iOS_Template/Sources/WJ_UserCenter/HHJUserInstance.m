//
//  HHJUserInstance.m
//  iOS_Template
//
//  Created by 贺文杰 on 2021/9/20.
//

#import "HHJUserInstance.h"

@implementation HHJUserInstance

+ (HHJUserInstance *)shareInstance{
    static HHJUserInstance *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        instance.sessionID = @"";
        instance.userInfoDict = [NSMutableDictionary new];
    });
    return instance;
}

- (void)setIsLogin:(BOOL)isLogin{
    _isLogin = isLogin;
}

@end
