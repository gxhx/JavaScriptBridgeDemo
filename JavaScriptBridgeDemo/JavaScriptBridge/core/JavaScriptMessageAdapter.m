//
//  JavaScriptMessage.m
//  JavaScriptBridgeDemo
//
//  Created by sue on 2020/6/18.
//  Copyright © 2020 sharlockk. All rights reserved.
//

#import "JavaScriptMessageAdapter.h"
#import <objc/runtime.h>
//Scheme  like alipay://  weixin://
static NSString * _Nonnull kBridgeScheme = @"jsdemo";
static NSString *hostToHandlesMapDictionaryKey;

@implementation JavaScriptMessageAdapter

- (instancetype)initWithMessage:(NSString *)message {
    self = [super init];
    if (self) {
        NSURL *url = [NSURL URLWithString:[message stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        
        if (![url.scheme isEqualToString:kBridgeScheme]) {
            NSLog(@"jsbridge error scheme is invalid");
            return nil;
        }
        
        NSString *className = [JavaScriptMessageAdapter hostToHandlesMapDictionary][url.host];
        Class class = NSClassFromString(className);
        if (!class) {
            NSLog(@"jsbridge error host is invalid");
            return nil;
        }else {
            _className = className;
            _handleClass = class;
        }
        
        NSString *path = url.path;
        path = [[path stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/"]] stringByAppendingString:@":"];
        if (!path || path.length == 0) {
            NSLog(@"jsbridge error path is invalid");
            return nil;
        }
        
        SEL methodSEL = NSSelectorFromString(path);
        
        if ([_handleClass instancesRespondToSelector:methodSEL]) {
             _methodName = path;
            _handleSelector = methodSEL;
        }else {
            NSLog(@"jsbridge error func name is invalid");
            return nil;
        }
        
        NSURLComponents *components = [[NSURLComponents alloc] initWithString:url.absoluteString];
       
        for (NSURLQueryItem *item in components.queryItems) {
            if ([item.name isEqualToString:@"data"]) {
                _parametersDictionary = [self _deserializeMessageJSON:item.value];
            }else if([item.name isEqualToString:@"id"]) {
                _callId = item.value;
            }
        }
        
        if (!_callId) {
            NSLog(@"jsbridge error callId is invalid");
            return nil;
        }
        
    }
    return self;
}


- (NSDictionary*_Nonnull)_deserializeMessageJSON:(NSString *_Nonnull)messageJSON {
    return [NSJSONSerialization JSONObjectWithData:[messageJSON dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
}

+(void)registerHandle:(NSString *_Nonnull)handleClassName forKey:(NSString *_Nonnull)key{

    NSMutableDictionary *hostToHandlesMapDictionary = [JavaScriptMessageAdapter hostToHandlesMapDictionary];
    [hostToHandlesMapDictionary setObject:handleClassName forKey:key];
     objc_setAssociatedObject(self, &hostToHandlesMapDictionaryKey, hostToHandlesMapDictionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+(NSMutableDictionary *_Nonnull)hostToHandlesMapDictionary{

    NSMutableDictionary *hostToHandlesMapDictionary = objc_getAssociatedObject(self, &hostToHandlesMapDictionaryKey);
    if(!hostToHandlesMapDictionary){
      hostToHandlesMapDictionary =  [
         @{@"device": @"JavaScriptDeviceMoudle",
           
         } mutableCopy];
        
        objc_setAssociatedObject(self, &hostToHandlesMapDictionaryKey, hostToHandlesMapDictionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return hostToHandlesMapDictionary;
}

@end
