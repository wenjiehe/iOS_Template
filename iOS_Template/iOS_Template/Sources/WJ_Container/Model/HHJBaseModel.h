//
//  HHJBaseModel.h
//  iOS_Template
//
//  Created by 贺文杰 on 2021/10/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHJBaseModel : NSObject

@property(nonatomic,copy)NSString *styleType;
@property(nonatomic,strong)NSDictionary *dataDic;
@property (nonatomic, strong)NSNumber *height;

@end

NS_ASSUME_NONNULL_END
