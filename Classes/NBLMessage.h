//
//  NBLMessage.h
//  NBLWebViewControllerDemo
//
//  Created by neebel on 2017/10/27.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NBLMessage : NSObject

@property (nonatomic, copy) NSString *methodName;
@property (nonatomic, copy) NSDictionary *params;
@property (nonatomic, copy) NSString *callbackMethod;

@end
