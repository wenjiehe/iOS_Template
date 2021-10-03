//
//  HHJWebView.h
//
//  Created by 贺文杰 on 2021/09/29.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HHJWebViewDelegate;
@interface HHJWebView : NSObject

@property (nonatomic, weak) id<HHJWebViewDelegate> delegate;
@property (nonatomic, strong, readonly) WKWebView *webView;
@property (nonatomic, strong, readonly) UIScrollView *scrollView;

/// Web页面点击回调
@property (nonatomic, copy) void (^clickBlock)(NSString* url, BOOL isSameDomainURL);

- (void)evalJs:(NSString*)jsString;
- (void)evalJs:(NSString *)jsString completionHandler:(void (^_Nullable)(NSString* _Nullable result, NSError* _Nullable error))completionHandler;
- (void)loadRequest:(NSURLRequest*)request;
- (void)loadFileURL:(NSURL*)URL allowingReadAccessToURL:(NSURL*)readAccessURLs;

- (void)stopLoading;
- (BOOL)isLoading;

- (void)cancelLoading;

- (BOOL)canGoBack;

- (void)goBack;

@end

@protocol HHJWebViewDelegate <NSObject>
@optional
- (void)webView:(HHJWebView *)webView handCode:(NSString*)handCode message:(NSString*)message;
- (BOOL)webView:(HHJWebView *)webView shouldStartLoadRequest:(NSURLRequest*)request;
- (void)webViewDidStartLoad:(HHJWebView *)webView;
- (void)webView:(HHJWebView *)webView didFailLoadWithError:(NSError*)error;
- (void)webViewDidFinishLoad:(HHJWebView *)webView;

@end

NS_ASSUME_NONNULL_END
