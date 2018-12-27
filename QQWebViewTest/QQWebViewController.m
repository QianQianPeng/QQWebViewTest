//
//  QQWebViewController.m
//  QQWebViewTest
//
//  Created by 彭倩倩 on 2018/12/27.
//  Copyright © 2018 彭倩倩. All rights reserved.
//

#import "QQWebViewController.h"
#import <WebKit/WebKit.h>

#define NAVBAR_HEIGHT (([[UIApplication sharedApplication] statusBarFrame].size.height) + ([UINavigationController new].navigationBar.frame.size.height))

@interface QQWebViewController ()<WKNavigationDelegate>

/** 网页视图 */
@property (nonatomic, strong) WKWebView *webView;
/** 进度条 */
@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation QQWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"loading...";
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://github.com/QianQianPeng"]]];
    [self setupToolView];
}

- (void)setupToolView {
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, self.view.frame.size.width, 40)];
    [self.view addSubview:toolBar];
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(goBackAction)];
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshAction)];
    UIBarButtonItem *forwardButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(goForwardAction)];
    [toolBar setItems:@[backButton,fixedSpace,refreshButton,fixedSpace,forwardButton] animated:YES];
}

#pragma mark - 代理区域
/** 开始加载 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    self.progressView.hidden = NO;
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self.view bringSubviewToFront:self.progressView];
}

/** 加载完成 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    self.progressView.hidden = YES;
}

/** 加载失败 */
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    self.progressView.hidden = YES;
}

/** 监听 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.webView.estimatedProgress;
        if (self.progressView.progress == 1) {
            __weak typeof(self) weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;
            }];
        }
    } else if ([keyPath isEqualToString:@"title"]) {
        self.navigationItem.title = self.webView.title;
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)goBackAction {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
}

- (void)goForwardAction {
    if ([self.webView canGoForward]) {
        [self.webView goForward];
    }
}

- (void)refreshAction {
    [self.webView reload];
}

#pragma mark - 懒加载区域
- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, [UIScreen mainScreen].bounds.size.width, 2)];
        _progressView.tintColor = [UIColor blueColor];
        _progressView.trackTintColor = [UIColor whiteColor];
    }
    return _progressView;
}

- (WKWebView *)webView {
    if(!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT+40, [UIScreen mainScreen].bounds.size.width, self.view.frame.size.height-40-NAVBAR_HEIGHT)];
        _webView.navigationDelegate = self;
        _webView.opaque = NO;
        _webView.multipleTouchEnabled = YES;
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    }
    
    return _webView;
}

- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"title"];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

@end

