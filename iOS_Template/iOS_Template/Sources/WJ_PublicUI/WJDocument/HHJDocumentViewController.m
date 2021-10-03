//
//  HHJDocumentViewController.m
//  iOS_Template
//
//  Created by  贺文杰 on 2021/9/28.
//

#import "HHJDocumentViewController.h"
#import <UIKit/UIKit.h>
#import "HHJWebView.h"
#import "MBProgressHUD.h"
//#import "UIViewController+AlertControllerExtension.h"
#import "HHJGlobalConstant.h"
#import "HHJContext.h"
#import "Masonry.h"

@interface HHJDocumentViewController ()<HHJWebViewDelegate>

@property(nonatomic,strong)HHJWebView *baseWebView;
@property(nonatomic,strong)MBProgressHUD *hud;

@end

@implementation HHJDocumentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.baseWebView = [[HHJWebView alloc] init];
    self.baseWebView.delegate = self;
    [self.baseWebView.webView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:self.baseWebView.webView];
    
    [self.baseWebView.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(kTitleHeight);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if ([self.baseWebView isLoading]) {
        [self.baseWebView stopLoading];
        [NSURLRequest cancelPreviousPerformRequestsWithTarget:self];
    }
    
    [self loadWebRequest];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.baseWebView cancelLoading];
}

- (void)dealloc{
    HHJLog(@"");
}

- (void)loadWebRequest{
    self.url = kCheckNil(self.url);
    if (self.url.length > 0) {
        NSURL *finalURL =[NSURL URLWithString:self.url];
        NSURLRequestCachePolicy cachePolicy = NSURLRequestUseProtocolCachePolicy;
        //不使用缓存模式，关闭浏览器缓存
        cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:finalURL cachePolicy:cachePolicy timeoutInterval:60.0f];
        [self.baseWebView loadRequest:request];
    }else{
//        [self showAlertWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"无效url"] cancelButtonTitle:@"确定" cancelButtonHandler:^{
//            if (YNETContextGet().currentVisibleViewController.navigationController) {
//                [YNETContextGet().currentVisibleViewController.navigationController popViewControllerAnimated:YES];
//            }else{
//                [YNETContextGet().currentVisibleViewController dismissViewControllerAnimated:YES completion:^{
//
//                }];
//            }
//        }];
    }
}

#pragma mark -- HHJWebViewDelegate
- (void)webView:(HHJWebView *)webView handCode:(NSString*)handCode message:(NSString*)message{
    
}

- (BOOL)webView:(HHJWebView *)webView shouldStartLoadRequest:(NSURLRequest*)request{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //清空所有页面缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];

    return YES;
}

- (void)webViewDidStartLoad:(HHJWebView *)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webView:(HHJWebView *)webView didFailLoadWithError:(NSError*)error{
    [self.hud hideAnimated:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    // 当页面发生取消操作的时候，不弹出提示框
    if (error.code != NSURLErrorCancelled) {
//        [self showAlertWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"页面加载失败,请稍后再试"] cancelButtonTitle:@"确定" cancelButtonHandler:^{
//        }];
    }
}

- (void)webViewDidFinishLoad:(HHJWebView *)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.hud hideAnimated:YES];
    NSLog(@"加载成功");
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
