//
//  JavaScriptBridge.m
//  JavaScriptBridgeDemo
//
//  Created by sue on 2020/6/18.
//  Copyright © 2020 sharlockk. All rights reserved.
//

#import "JavaScriptBridge.h"
#import "JavaScriptBridgeDelegate.h"
#import "JavaScriptMessageAdapter.h"
#import "BaseJavaScriptMoudle.h"

static NSString * _Nonnull kBridgePrefix = @"jsbridge";
@implementation JavaScriptBridge{
    WKWebView * _webView;
    NSMutableDictionary <NSString *, BaseJavaScriptMoudle *> * _handleDictionary;
}
- (void)dealloc {
    [self removeScriptMessageHandler];
}

+ (instancetype)bridgeForViewController:(UIViewController *)viewController webView:(WKWebView *)webView {
    
    JavaScriptBridge *bridge = [[JavaScriptBridge alloc] init];
    [bridge _setupInstance:viewController webView:webView];
    return bridge;
}


- (void)_setupInstance:(UIViewController *)viewController webView:(WKWebView *)webView {
    _webView = webView;
    _handleDictionary = [NSMutableDictionary dictionary];
    _h5ViewController = viewController;
    [self addScriptMessageHandler];
    [self _injectJavascriptFile];
}


- (void)addScriptMessageHandler {
    [_webView.configuration.userContentController addScriptMessageHandler:[[JavaScriptBridgeDelegate alloc] initWithDelegate:self] name:kBridgePrefix];
}

- (void)removeScriptMessageHandler {
    [_webView.configuration.userContentController removeScriptMessageHandlerForName:kBridgePrefix];
}


- (void)userContentController:(nonnull WKUserContentController *)userContentController didReceiveScriptMessage:(nonnull WKScriptMessage *)message {
    
    if (![message.name isEqualToString:kBridgePrefix]) {
        return;
    }
    
    NSString * body = (NSString * )message.body;
    
    JavaScriptMessageAdapter *msg = [[JavaScriptMessageAdapter alloc] initWithMessage:body];
    if (msg) {
        BaseJavaScriptMoudle *moudle = _handleDictionary[msg.className];
        if (!moudle) {
            moudle = [(BaseJavaScriptMoudle *)[msg.handleClass alloc] initWithBridge:self];
            _handleDictionary[msg.className] = moudle;
        }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [moudle performSelector:msg.handleSelector withObject:msg afterDelay:0.0f];
#pragma clang diagnostic pop
        
    }
    
}


- (NSString *)_serializeMessage:(id)message pretty:(BOOL)pretty{
    return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:message options:(NSJSONWritingOptions)(pretty ? NSJSONWritingPrettyPrinted : 0) error:nil] encoding:NSUTF8StringEncoding];
}

- (void)dispatchMessage:(NSDictionary *)message {
    NSString *messageJSON = [self _serializeMessage:message pretty:NO];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\'" withString:@"\\\'"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\f" withString:@"\\f"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\u2028" withString:@"\\u2028"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\u2029" withString:@"\\u2029"];
    NSString* javascriptCommand = [NSString stringWithFormat:@"jsbridge._handleMessageFromObjC('%@');", messageJSON];
    if ([[NSThread currentThread] isMainThread]) {
        [_webView evaluateJavaScript:javascriptCommand completionHandler:nil];
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [_webView evaluateJavaScript:javascriptCommand completionHandler:nil];
        });
    }
}

- (void)_injectJavascriptFile {
    NSString *bridge_js = WebViewJavascriptBridge_js();
    //injected the method when H5 starts to create the DOM tree
    WKUserScript * bridge_userScript = [[WKUserScript alloc]initWithSource:bridge_js injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
    [_webView.configuration.userContentController addUserScript:bridge_userScript];
}


NSString * WebViewJavascriptBridge_js() {
#define __WVJB_js_func__(x) #x
    
    // BEGIN preprocessorJSCode
    static NSString * preprocessorJSCode = @__WVJB_js_func__(
                                                             ;(function(window) {
               
        window.jsbridge = {
             device: {
                getDeviceId:_getDeviceId,
                getNetWorkInfo:_getNetWorkInfo,
                getDeviceModel:_getDeviceModel,
                closeInputKeyboard:_closeInputKeyboard,
                vibrate:_vibrate,
                callPhone:_callPhone,
                sendMsg:_sendMsg
             },
            _handleMessageFromObjC: _handleMessageFromObjC,
          
        };

        var responseCallbacks = {};
        var uniqueId = 1;
        
        function _getDeviceId(success, fail) {
            _doSend('device/getDeviceId', {}, success, fail);
        }
        
        function _getNetWorkInfo(success, fail) {
            _doSend('device/getNetWorkInfo', {}, success, fail);
        }
        
        function _getDeviceModel(success, fail) {
            _doSend('device/getDeviceModel', {}, success, fail);
        }
        
        function _closeInputKeyboard(success, fail) {
            _doSend('device/closeInputKeyboard', {}, success, fail);
        }
        
        function _vibrate(success, fail) {
            _doSend('device/vibrate', {}, success, fail);
        }
        
        function _callPhone(phone,success, fail) {
            _doSend('device/callPhone', {'phone':phone}, success, fail);
        }
        
        function _sendMsg(phone,success, fail) {
            _doSend('device/sendMsg', {'phone':phone}, success, fail);
        }
        
        
        function _doSend(handlerName,data, success, fail) {
            var callbackId = 'cb_'+(uniqueId++)+'_'+new Date().getTime();
            if (success && fail) {
                responseCallbacks[callbackId] = [success, fail];
            }
            var body = 'jsdemo://'+handlerName+'?id='+callbackId+'&data='+JSON.stringify(data);
            window.webkit.messageHandlers.jsbridge.postMessage(body);
        }
        
        function _dispatchMessageFromObjC(messageJSON) {
            _doDispatchMessageFromObjC();
            function _doDispatchMessageFromObjC() {
                var message = JSON.parse(messageJSON);
                var messageHandler;
                var responseCallback;
                
                if (message.responseId) {
                    if (message.code == 0) {
                        responseCallback = responseCallbacks[message.responseId][0];
                    }else {
                        responseCallback = responseCallbacks[message.responseId][1];
                    }
                    if (!responseCallback) {
                        return;
                    }
                    responseCallback(message.data);
                    delete responseCallbacks[message.responseId];
                }
            }
        }
        function _handleMessageFromObjC(messageJSON) {
            _dispatchMessageFromObjC(messageJSON);
        }
    })(window);); // END preprocessorJSCode
    
#undef __WVJB_js_func__
    return preprocessorJSCode;
};


@end
