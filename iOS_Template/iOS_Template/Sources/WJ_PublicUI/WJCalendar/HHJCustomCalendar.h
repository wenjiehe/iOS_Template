//
//  HHJCustomCalendar.h
//  iOS_Template
//
//  Created by  贺文杰 on 2021/9/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHJCustomCalendar : UIView

- (void)show;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END

@interface HHJCustomCalendarCollectionCell : UICollectionViewCell

- (void)configData:(NSDictionary *)dic;

@end
