//
//  JavaScriptBridgeDelegate.m
//  JavaScriptBridgeDemo
//
//  Created by sue on 2020/6/18.
//  Copyright © 2020 sharlockk. All rights reserved.
//

#import "JavaScriptBridgeDelegate.h"

@implementation JavaScriptBridgeDelegate

- (instancetype)initWithDelegate:(id <WKScriptMessageHandler> )delegate {
    if (self = [super init]) {
        self.delegate = delegate;
    }
    return self;
}

- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    [self.delegate userContentController:userContentController didReceiveScriptMessage:message];
}
@end
