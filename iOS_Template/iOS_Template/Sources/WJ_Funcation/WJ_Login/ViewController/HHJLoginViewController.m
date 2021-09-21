//
//  HHJLoginViewController.m
//  iOS_Template
//
//  Created by 贺文杰 on 2021/9/21.
//

#import "HHJLoginViewController.h"
#import "Masonry.h"
#import "HHJContext.h"
#import "HHJGlobalConstant.h"

@interface HHJLoginViewController ()

@property(nonatomic,strong)UIButton *loginButton;

@end

@implementation HHJLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor yellowColor];
    
    [self initUI];
}

- (void)dealloc{
    HHJLog(@"");
}

- (void)initUI{
    [self.view addSubview:self.loginButton];
    
    [self initConstraints];
}

- (void)initConstraints{
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(45);
        make.top.mas_equalTo(200);
    }];
}


#pragma mark -- action
- (void)clickLoginButton:(UIButton *)sender{
    if (self.successBlock) {
        self.successBlock(@{}, self.extendInfo);
    }
    
    if (self.processBlock) {
        BOOL isPop = self.processBlock();
        if (isPop) {
            [self performSelector:@selector(loginVCHandle) withObject:nil afterDelay:0.5];
        }
    }
}

- (void)loginVCHandle{
    if (HHJContext.getCurrentVC.navigationController) {
        NSMutableArray *mtbAry = [[NSMutableArray alloc] initWithArray:HHJContext.getCurrentVC.navigationController.viewControllers];
        for (NSInteger i = 0; i < mtbAry.count; i++) {
            UIViewController *vc = mtbAry[i];
            if (vc && [vc isKindOfClass:[self class]]) {
                [mtbAry removeObject:vc];
            }
        }
        [HHJContext.getCurrentVC.navigationController setViewControllers:mtbAry animated:NO];
    }else{
        [HHJContext.getCurrentVC dismissViewControllerAnimated:NO completion:^{
                    
        }];
    }
}

#pragma mark -- setter
- (UIButton *)loginButton{
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginButton.backgroundColor = [UIColor blueColor];
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(clickLoginButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
