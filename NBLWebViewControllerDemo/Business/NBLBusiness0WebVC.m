//
//  NBLBusiness0WebVC.m
//  NBLWebViewControllerDemo
//
//  Created by neebel on 2017/10/26.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "NBLBusiness0WebVC.h"

//handler name
static NSString *business0Messagehandler = @"business0Messagehandler";

//implemented method list
static NSString *business0 = @"business0";

@implementation NBLBusiness0WebVC

- (void)registerMessageHandler
{
    [super registerMessageHandler];
    [self.webView.configuration.userContentController addScriptMessageHandler:self name:business0Messagehandler];
}


- (BOOL)dealWithMessage:(WKScriptMessage *)message
{
    BOOL deal = [super dealWithMessage:message];
    if (deal) {
        return deal;
    }
    
    if ([message.name isEqualToString:business0Messagehandler] && [self.message.methodName isEqualToString:business0]) {
        [self business0];
        deal = YES;
        if (self.message.callbackMethod.length > 0) {
           //callback js
        }
    }
    
    return deal;
}


- (void)business0
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"js调用OC business0方法" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertVC addAction:confirmAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

@end
