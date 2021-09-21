//
//  HHJContext.h
//  iOS_Template
//
//  Created by 贺文杰 on 2021/9/21.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHJContext : NSObject

//当前显示的控制器
+ (UIViewController *)getCurrentVC;

+ (id)findServerName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
