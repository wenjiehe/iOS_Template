//
//  HHJAppManager.m
//  iOS_Template
//
//  Created by 贺文杰 on 2021/9/21.
//

#import "HHJAppManager.h"

@implementation HHJAppManager

+ (instancetype)sharedInstance
{
    static HHJAppManager *sharedInstance = nil;
    
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[HHJAppManager alloc] init];
    });
    return sharedInstance;
}

- (NSMutableArray *)vcMtbAry
{
    if (!_vcMtbAry) {
        _vcMtbAry = [NSMutableArray new];
    }
    return _vcMtbAry;
}

@end
