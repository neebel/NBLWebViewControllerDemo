//
//  NBLWebViewController.h
//  NBLWebViewControllerDemo
//
//  Created by neebel on 2017/10/21.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "NBLWebViewHeader.h"
#import "NBLMessage.h"

@interface NBLWebViewController : UIViewController<WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong, readonly) NBLMessage *message;

- (instancetype)initWithURLString:(NSString *)urlString;

- (instancetype)initWithURL:(NSURL *)url;

- (instancetype)initWithRequest:(NSURLRequest *)request;

- (instancetype)initWithHTMLString:(NSString *)string baseURL:(NSURL *)baseURL;

//for subclass

- (void)registerMessageHandler;

- (BOOL)dealWithMessage:(WKScriptMessage *)message;

@end
