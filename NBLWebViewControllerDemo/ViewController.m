//
//  ViewController.m
//  NBLWebViewControllerDemo
//
//  Created by neebel on 2017/10/21.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "ViewController.h"
#import "NBLBusiness0WebVC.h"
#import "NBLBusiness1WebVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UIButton *button0 = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 100, 40, 200, 80)];
    [button0 setTitle:@"OC、JS无交互WebView" forState:UIControlStateNormal];
    [button0 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button0 addTarget:self action:@selector(openWebView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button0];
    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 140, button0.frame.origin.y + button0.frame.size.height + 40, 280, 80)];
    [button1 setTitle:@"OC、JS互相调用WebView 业务0" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(openWebView0) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 140, button1.frame.origin.y + button1.frame.size.height + 40, 280, 80)];
    [button2 setTitle:@"OC、JS互相调用WebView 业务1" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(openWebView1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
}


- (void)openWebView
{
    NBLWebViewController *webVC = [[NBLWebViewController alloc] initWithURLString:@"https://www.baidu.com"];
    [self.navigationController pushViewController:webVC animated:YES];
}


- (void)openWebView0
{
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"business0"
                                                         ofType:@"html"];
    NSString *htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                   encoding:NSUTF8StringEncoding
                                                      error:nil];
    NBLBusiness0WebVC *webVC = [[NBLBusiness0WebVC alloc] initWithHTMLString:htmlCont baseURL:baseURL];
    [self.navigationController pushViewController:webVC animated:YES];
}


- (void)openWebView1
{
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"business1"
                                                          ofType:@"html"];
    NSString *htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];
    NBLBusiness1WebVC *webVC = [[NBLBusiness1WebVC alloc] initWithHTMLString:htmlCont baseURL:baseURL];
    [self.navigationController pushViewController:webVC animated:YES];
}

@end
