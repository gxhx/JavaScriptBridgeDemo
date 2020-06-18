//
//  JavaScriptMessage.h
//  JavaScriptBridgeDemo
//
//  Created by sue on 2020/6/18.
//  Copyright © 2020 sharlockk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JavaScriptMessageAdapter : NSObject
/** 命令 ID */
@property (readonly, nonatomic, copy) NSString *callId;

/** 该命令的相关处理类名字 */
@property (readonly, nonatomic, copy) NSString *className;

/** 该命令的相关处理类 */
@property (readonly, nonatomic, copy) Class handleClass;

/** 该命令的相关处理方法名字 */
@property (readonly, nonatomic, copy) NSString *methodName;

/** 该命令的相关处理方法 */
@property (readonly, nonatomic, assign) SEL handleSelector;

/** 调用方提供的参数 */
@property (readonly, nonatomic, copy, nullable) NSDictionary *parametersDictionary;


- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithMessage:(NSString *)message;

+(void)registerHandle:(NSString *)handleClassName forKey:(NSString *)key;


@end

NS_ASSUME_NONNULL_END
