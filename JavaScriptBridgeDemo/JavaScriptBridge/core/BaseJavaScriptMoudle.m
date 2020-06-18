//
//  BaseJavaScriptMoudle.m
//  JavaScriptBridgeDemo
//
//  Created by sue on 2020/6/18.
//  Copyright © 2020 sharlockk. All rights reserved.
//

#import "BaseJavaScriptMoudle.h"

@implementation BaseJavaScriptMoudle

- (instancetype)initWithBridge:(JavaScriptBridge *)bridge {

    self = [super init];
    if (self) {
        _bridge = bridge;
    }
    return self;
}

- (void)dispatchMessageId:(NSString *)msgId result:(NSDictionary *)result {
    
    if (!msgId) {
        return;
    }
    [self.bridge dispatchMessage:@{@"responseId":msgId,@"code":@(0),@"data":result?:@{}}];
}

- (void)dispatchMessageId:(NSString *)msgId errorMsg:(NSString *)errorMsg {
    
    [self dispatchMessageId:msgId errorMsg:errorMsg errorCode:-1];
}

- (void)dispatchMessageId:(NSString *)msgId errorMsg:(NSString *)errorMsg errorCode:(NSInteger)errorCode {
    
    if (!msgId) {
        return;
    }
    [self.bridge dispatchMessage:@{@"responseId":msgId,@"code":@(errorCode),@"data":@{@"msg":errorMsg?:@"未知错误"}}];
}
@end
