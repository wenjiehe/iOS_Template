//
//  HHJBaseViewController.h
//  iOS_Template
//
//  Created by 贺文杰 on 2021/9/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HHJBaseViewController : UIViewController

@property(nonatomic,strong)NSString *homeType; //首页类型
@property(nonatomic,strong)NSArray *dataAry;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic)BOOL isHiddenTableView; //是否隐藏tableview

- (void)reloadTableData;

@end

NS_ASSUME_NONNULL_END
