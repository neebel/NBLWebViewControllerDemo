//
//  NBLWebViewController.m
//  NBLWebViewControllerDemo
//
//  Created by neebel on 2017/10/21.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "NBLWebViewController.h"

//handler name
static NSString *baseMessagehandler = @"baseMessagehandler";

//implemented method list
static NSString *closeWebView = @"closeWebView";
static NSString *goBack = @"goBack";


@interface NBLWebViewController ()<WKNavigationDelegate, WKUIDelegate>

//UI
@property (nonatomic, strong) UIProgressView  *progressView;
@property (nonatomic, strong) UIBarButtonItem *backItem;
@property (nonatomic, strong) UIBarButtonItem *closeItem;
@property (nonatomic, assign) UIBarStyle      barStyle;
@property (nonatomic, strong) UIView          *errorView;
@property (nonatomic, assign) BOOL            translucent;

//data
@property (nonatomic, copy)   NSString *urlString;
@property (nonatomic, strong) NSURL    *url;
@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, copy)   NSString *htmlString;
@property (nonatomic, strong) NSURL    *baseURL;

//message
@property (nonatomic, strong) NBLMessage *message;

@end

@implementation NBLWebViewController

#pragma mark - LifeCycle

- (void)dealloc
{
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [_webView removeObserver:self forKeyPath:@"canGoBack"];
    [_webView removeObserver:self forKeyPath:@"title"];
}


- (instancetype)initWithURLString:(NSString *)urlString
{
    self = [super init];
    if (self) {
        _urlString = urlString;
    }
    
    return self;
}


- (instancetype)initWithURL:(NSURL *)url
{
    self = [super init];
    if (self) {
        _url = url;
    }
    
    return self;
}


- (instancetype)initWithRequest:(NSURLRequest *)request
{
    self = [super init];
    if (self) {
        _request = request;
    }
    
    return self;
}


- (instancetype)initWithHTMLString:(NSString *)string baseURL:(NSURL *)baseURL
{
    self = [super init];
    if (self) {
        _htmlString = string;
        _baseURL = baseURL;
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
    [self registerMessageHandler];
    [self addObserver];
    [self loadPage];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.barStyle = self.navigationController.navigationBar.barStyle;
    self.translucent = self.navigationController.navigationBar.translucent;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.translucent = NO;
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barStyle = self.barStyle;
    self.navigationController.navigationBar.translucent = self.translucent;
}

#pragma mark - Getter

- (WKWebView *)webView
{
    if (!_webView) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
        _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
    }
    
    return _webView;
}


- (UIProgressView *)progressView
{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
        _progressView.tintColor = [UIColor greenColor];
        _progressView.trackTintColor = [UIColor clearColor];
        _progressView.hidden = YES;
    }
    
    return _progressView;
}


- (UIBarButtonItem *)backItem
{
    if (!_backItem) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setImage:[UIImage imageNamed:@"icon.bundle/nav_back"] forState:UIControlStateNormal];
        [button setTitle:@"返回" forState:UIControlStateNormal];
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
        [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        _backItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    
    return _backItem;
}


- (UIBarButtonItem *)closeItem
{
    if (!_closeItem) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
        [button setTitle:@"关闭" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(closeSelf) forControlEvents:UIControlEventTouchUpInside];
        _closeItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    
    return _closeItem;
}


- (UIView *)errorView
{
    if (!_errorView) {
        _errorView = [[UIView alloc] initWithFrame:self.view.bounds];
        _errorView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _errorView.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(refreshPage)];
        _errorView.userInteractionEnabled = YES;
        [_errorView addGestureRecognizer:gesture];
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 140, 60)];
        [button setTitle:@"轻触重新加载" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(refreshPage) forControlEvents:UIControlEventTouchUpInside];
        button.center = _errorView.center;
        [_errorView addSubview:button];
    }
    
    return _errorView;
}

#pragma mark - Action

- (void)backAction
{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    } else {
        [self closeSelf];
    }
}


- (void)closeSelf
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Private

- (void)initUI
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = self.backItem;
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];
}


- (void)updateButtonItems
{
    if (self.webView.canGoBack && self.navigationItem.leftBarButtonItems.count != 2) {
        self.navigationItem.leftBarButtonItems = @[self.backItem, self.closeItem];
    }
}


- (void)setErrorViewHidden:(BOOL)hidden
{
    if (hidden) {
        [self.errorView removeFromSuperview];
    } else {
        [self.view addSubview:self.errorView];
    }
}


- (void)addObserver
{
    [self.webView addObserver:self
                   forKeyPath:@"estimatedProgress"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    
    [self.webView addObserver:self
                   forKeyPath:@"canGoBack"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
    
    [self.webView addObserver:self
                   forKeyPath:@"title"
                      options:NSKeyValueObservingOptionNew
                      context:NULL];
}


- (void)loadPage
{
    if (self.urlString.length > 0) {
        [self loadURLString:self.urlString];
    } else if (self.url) {
        [self loadURL:self.url];
    } else if (self.request) {
        [self loadRequest:self.request];
    } else if (self.htmlString.length > 0 || self.baseURL) {
        [self loadHTMLString:self.htmlString baseURL:self.baseURL];
    }
}


- (void)refreshPage
{
    if (self.webView.URL) {
        [self.webView reload];
    } else {
        [self loadPage];
    }
}


- (void)hideProgress
{
    self.progressView.hidden = YES;
    [self.progressView setProgress:0 animated:NO];
}


- (void)updateProgress:(float)progress
{
    self.progressView.hidden = NO;
    [self.progressView setProgress:progress animated:YES];
}


- (void)loadURLString:(NSString *)urlString
{
    [self loadURL:[NSURL URLWithString:urlString]];
}


- (void)loadURL:(NSURL *)url
{
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [self loadRequest:request];
}


- (void)loadRequest:(NSURLRequest *)request
{
    [self.webView loadRequest:request];
}


- (void)loadHTMLString:(NSString *)string baseURL:(nullable NSURL *)baseURL
{
    [self.webView loadHTMLString:string baseURL:baseURL];
}

#pragma mark - Public

- (void)registerMessageHandler
{
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:baseMessagehandler];
}


- (BOOL)dealWithMessage:(WKScriptMessage *)message
{
    BOOL canDeal = NO;
    if ([message.body isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = (NSDictionary *)message.body;
        self.message = [[NBLMessage alloc] init];
        self.message.methodName = dic[methodNameKey];
        self.message.params = dic[paramsKey];
        self.message.callbackMethod = dic[callbackMethodKey];
    }
    
    if ([message.name isEqualToString:baseMessagehandler]) {
        if ([self.message.methodName isEqualToString:closeWebView]) {
            //close webview
            [self closeSelf];
            canDeal = YES;
        } else if ([self.message.methodName isEqualToString:goBack]) {
            //go back
            [self backAction];
            canDeal = YES;
        }
    }
    
    if (canDeal && self.message.callbackMethod.length > 0) {
        //callback js
    }
    
    return canDeal;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self.webView) {
        if ([keyPath isEqualToString:@"estimatedProgress"]) {
            CGFloat progress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
            if (progress == 1) {
                [self hideProgress];
            } else {
                [self updateProgress:progress];
            }
        } else if ([keyPath isEqualToString:@"canGoBack"]) {
            [self updateButtonItems];
        } else if ([keyPath isEqualToString:@"title"]) {
            self.title = self.webView.title;
        }
    }
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    [self hideProgress];
    [self setErrorViewHidden:NO];
    self.title = @"加载失败";
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    [self hideProgress];
    [self setErrorViewHidden:YES];
}

#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    [self dealWithMessage:message];
}

#pragma mark - WKUIDelegate

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertVC addAction:confirmAction];
    [self presentViewController:alertVC animated:YES completion:nil];
    completionHandler();
}

@end
