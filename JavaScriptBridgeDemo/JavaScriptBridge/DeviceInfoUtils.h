//
//  DeviceInfoUtils.h
//  Example-JSB
//
//  Created by sue on 2020/5/11.
//  Copyright © 2020 sharlockk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeviceInfoUtils : NSObject

/// 获取设备Id 优先级为 IDFA >> IDFA
+ (NSString *)getDeviceId;

/// 获取IP 地址
+ (NSString *)getNetWorkInfo;

/// 获取设备Model
+ (NSString *)getDeviceModel;

/// 关闭输入法
+ (void)closeInputKeyboard;

/// 震动
+ (void)vibrate;

/// 打电话
+ (void)callPhone:(NSString *)phoneString;

/// 发短信
+ (void)sendMsg:(NSString *)phoneString;
@end

NS_ASSUME_NONNULL_END
