//
//  HHJWebView.m
//
//  Created by 贺文杰 on 2021/09/29.
//

#import "HHJWebView.h"
#import "HHJGlobalConstant.h"
#import "NSString+HHJBase.h"

static const NSString* nativeFunctionName = @"nativePlugin";

@interface HHJWebView ()<WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView* webView;

@property (nonatomic) BOOL hasLoaded;

@end

@implementation HHJWebView

- (void)evalJs:(NSString *)jsString {
    [self evalJs:jsString completionHandler:nil];
}

- (void)evalJs:(NSString *)jsString completionHandler:(void (^_Nullable)(NSString* _Nullable result, NSError* _Nullable error))completionHandler {
    [self.webView evaluateJavaScript:jsString completionHandler:^(id result, NSError * _Nullable error) {
        if (completionHandler) {
            completionHandler(result, error);
        }
    }];
}

- (void)loadRequest:(NSURLRequest*)request {
    [self.webView loadRequest:request];
}

- (void)loadFileURL:(NSURL*)URL allowingReadAccessToURL:(NSURL*)readAccessURL {
    [self.webView loadFileURL:URL allowingReadAccessToURL:readAccessURL];
}

- (void)stopLoading {
    [self.webView stopLoading];
}

- (void)cancelLoading {
    [UIApplication sharedApplication].networkActivityIndicatorVisible =NO;
    //终止正在加载的页面
    if (self.webView && [self isLoading]) {
        [self stopLoading];
        [NSURLRequest cancelPreviousPerformRequestsWithTarget:self];
    }
}

- (BOOL)isLoading {
    WKWebView* webView = (WKWebView*)self.webView;
    return [webView isLoading];
}

- (void)handJSMessage:(NSString*)message {
    NSDictionary* params = [NSString dictionaryWithString:message];
    if (params != nil && [params isKindOfClass:[NSDictionary class]]) {
        NSString* eventCode = params[@"code"];
        NSString* message = params[@"name"];
        eventCode = kCheckNil(eventCode);
        if (eventCode && eventCode.length > 0) {
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(webView:handCode:message:)]) {
                [self.delegate webView:self handCode:eventCode message:message];
            }
        }
    }
}

- (BOOL)canGoBack {
    return [self.webView canGoBack];
}

- (void)goBack {
    [self.webView goBack];
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    if (self.hasLoaded) {
        if (self.clickBlock) {
            BOOL isSameDomainURL = [webView.URL.host isEqualToString:navigationResponse.response.URL.host];
            self.clickBlock(navigationResponse.response.URL.absoluteString, isSameDomainURL);
            decisionHandler(WKNavigationResponsePolicyCancel);
            return;
        }
    }
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(webView:shouldStartLoadRequest:)]) {
        NSURL* url = navigationResponse.response.URL;
        NSURLRequest* request = [NSURLRequest requestWithURL:url];
        [self.delegate webView:self shouldStartLoadRequest:request];
    }
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [self.delegate webViewDidStartLoad:self];
    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [self.delegate webView:self didFailLoadWithError:error];
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    self.hasLoaded = YES;
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [self.delegate webViewDidFinishLoad:self];
    }
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        NSURLCredential* credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
    }
}

#pragma mark - WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }];
    [alert addAction:okAction];
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    [vc presentViewController:alert animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    [vc presentViewController:alert animated:YES completion:nil];
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:(NSString*)nativeFunctionName]) {
        NSString* body = message.body;
        [self handJSMessage:body];
    }
}

#pragma mark - Getter
- (WKWebView*)webView {
    if (!_webView) {
        WKUserContentController* userContentController = [[WKUserContentController alloc] init];
        [userContentController addScriptMessageHandler:(id<WKScriptMessageHandler>)self name: (NSString*)nativeFunctionName];
        WKWebViewConfiguration* configuration = [[WKWebViewConfiguration alloc] init];
        configuration.userContentController = userContentController;
        WKWebView* webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:configuration];
        webView.UIDelegate = (id<WKUIDelegate>)self;
        webView.navigationDelegate = (id<WKNavigationDelegate>)self;
        webView.opaque = YES;
        webView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
        _webView = webView;
    }
    return _webView;
}

- (UIScrollView*)scrollView {
    return self.webView.scrollView;
}

#pragma mark - dealloc
- (void)dealloc {
    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
}

@end
