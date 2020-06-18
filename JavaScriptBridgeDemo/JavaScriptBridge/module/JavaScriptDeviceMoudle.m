//
//  JavaScriptDeviceMoudle.m
//  JavaScriptBridgeDemo
//
//  Created by sue on 2020/6/18.
//  Copyright © 2020 sharlockk. All rights reserved.
//

#import "JavaScriptDeviceMoudle.h"
#import "DeviceInfoUtils.h"
@implementation JavaScriptDeviceMoudle
- (void)getDeviceId:(JavaScriptMessageAdapter *)message {
    
    NSString *deviceId = [DeviceInfoUtils getDeviceId];
    
    if (deviceId) {
        [self dispatchMessageId:message.callId result:@{@"deviceId":deviceId}];
    }else {
        [self dispatchMessageId:message.callId errorMsg:@"获取设备Id失败"];
    }
}

- (void)getNetWorkInfo:(JavaScriptMessageAdapter *)message {
    
    NSString *ip = [DeviceInfoUtils getNetWorkInfo];
    
    if (ip) {
        [self dispatchMessageId:message.callId result:@{@"ip":ip}];
    }else {
        [self dispatchMessageId:message.callId errorMsg:@"获取设备ip失败"];
    }
    
}

- (void)getDeviceModel:(JavaScriptMessageAdapter *)message {
    
    NSString *model = [DeviceInfoUtils getDeviceModel];
    
    if (model) {
        [self dispatchMessageId:message.callId result:@{@"model":model}];
    }else {
        [self dispatchMessageId:message.callId errorMsg:@"获取设备model失败"];
    }
}

- (void)closeInputKeyboard:(JavaScriptMessageAdapter *)message {
    
    [DeviceInfoUtils closeInputKeyboard];
    [self dispatchMessageId:message.callId result:@{}];
}

- (void)vibrate:(JavaScriptMessageAdapter *)message {
    
    [DeviceInfoUtils vibrate];
    [self dispatchMessageId:message.callId result:@{}];
}
- (void)callPhone:(JavaScriptMessageAdapter *)message {
    
    NSString *phone = [message.parametersDictionary valueForKey:@"phone"];
    [DeviceInfoUtils callPhone:phone];
    [self dispatchMessageId:message.callId result:@{}];
}
- (void)sendMsg:(JavaScriptMessageAdapter *)message {
    
    NSString *phone = [message.parametersDictionary valueForKey:@"phone"];
    [DeviceInfoUtils sendMsg:phone];
    [self dispatchMessageId:message.callId result:@{}];
    
}

@end
