//
//  NBLBusiness1WebVC.m
//  NBLWebViewControllerDemo
//
//  Created by neebel on 2017/10/26.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "NBLBusiness1WebVC.h"

//handler name
static NSString *business1Messagehandler = @"business1Messagehandler";

//implemented method list
static NSString *business1 = @"business1";

@implementation NBLBusiness1WebVC

- (void)registerMessageHandler
{
    [super registerMessageHandler];
    [self.webView.configuration.userContentController addScriptMessageHandler:self
                                                                         name:business1Messagehandler];
}


- (BOOL)dealWithMessage:(WKScriptMessage *)message
{
    BOOL deal = [super dealWithMessage:message];
    if (deal) {
        return deal;
    }
    
    if ([message.name isEqualToString:business1Messagehandler] && [self.message.methodName isEqualToString:business1]) {
        [self business1];
        deal = YES;
        if (self.message.callbackMethod.length > 0) {
            [self.webView evaluateJavaScript:[NSString stringWithFormat:@"%@('test')",self.message.callbackMethod] completionHandler:^(id _Nullable response, NSError * _Nullable error) {
                
            }];
        }
    }
    
    return deal;
}


- (void)business1
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.message.params
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (!error) {
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"js传给oc的参数是：%@", jsonString);
    }
}

@end
