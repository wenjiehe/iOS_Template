//
//  HHJCustomTabBarView.h
//  iOS_Template
//
//  Created by 贺文杰 on 2021/10/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HHJCustomTabBarViewDelegate <NSObject>

- (void)didSelectIcon:(NSInteger)index;

@end

@interface HHJCustomTabBarView : UIView

@property(nonatomic,weak)id<HHJCustomTabBarViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
