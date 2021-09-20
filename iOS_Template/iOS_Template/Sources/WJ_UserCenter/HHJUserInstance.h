//
//  HHJUserInstance.h
//  iOS_Template
//
//  Created by 贺文杰 on 2021/9/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHJUserInstance : NSObject

@property(nonatomic)BOOL isLogin; /**< 当前用户是否登录 */
@property(nonatomic,strong)NSMutableDictionary *userInfoDict; /**< 登录后的用户信息 */
@property(nonatomic,copy)NSString *sessionID; 

+ (HHJUserInstance *)shareInstance;

@end

NS_ASSUME_NONNULL_END
