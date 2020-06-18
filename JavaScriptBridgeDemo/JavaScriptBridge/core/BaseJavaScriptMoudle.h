//
//  BaseJavaScriptMoudle.h
//  JavaScriptBridgeDemo
//
//  Created by sue on 2020/6/18.
//  Copyright © 2020 sharlockk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JavaScriptBridge.h"
#import "JavaScriptMessageAdapter.h"
NS_ASSUME_NONNULL_BEGIN
API_AVAILABLE(ios(8.0))
@interface BaseJavaScriptMoudle : NSObject
@property (readonly, nonatomic, weak) __kindof JavaScriptBridge *bridge;
- (instancetype)initWithBridge:(JavaScriptBridge *)bridge NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;
- (void)dispatchMessageId:(NSString *)msgId result:(NSDictionary *)result;
- (void)dispatchMessageId:(NSString *)msgId errorMsg:(NSString *)errorMsg;
- (void)dispatchMessageId:(NSString *)msgId errorMsg:(NSString *)errorMsg errorCode:(NSInteger)errorCode;
@end

NS_ASSUME_NONNULL_END
