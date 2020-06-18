//
//  JavaScriptBridgeDelegate.h
//  JavaScriptBridgeDemo
//
//  Created by sue on 2020/6/18.
//  Copyright © 2020 sharlockk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
NS_ASSUME_NONNULL_BEGIN
API_AVAILABLE(ios(8.0))
@interface JavaScriptBridgeDelegate: NSObject <WKScriptMessageHandler>
@property(nonatomic, weak)id <WKScriptMessageHandler> delegate;
- (instancetype)initWithDelegate:(id <WKScriptMessageHandler> )delegate;
@end

NS_ASSUME_NONNULL_END
