//
//  JavaScriptBridge.h
//  JavaScriptBridgeDemo
//
//  Created by sue on 2020/6/18.
//  Copyright © 2020 sharlockk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
NS_ASSUME_NONNULL_BEGIN
API_AVAILABLE(ios(8.0))
@interface JavaScriptBridge : NSObject <WKScriptMessageHandler>
@property (readonly, nonatomic, weak) __kindof UIViewController *h5ViewController;
+ (instancetype)bridgeForViewController:(UIViewController *)viewController webView:(WKWebView *)webView;
- (void)dispatchMessage:(NSDictionary *)message;
@end

NS_ASSUME_NONNULL_END
