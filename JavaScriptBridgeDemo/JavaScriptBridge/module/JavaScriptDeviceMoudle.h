//
//  JavaScriptDeviceMoudle.h
//  JavaScriptBridgeDemo
//
//  Created by sue on 2020/6/18.
//  Copyright © 2020 sharlockk. All rights reserved.
//

#import "BaseJavaScriptMoudle.h"

NS_ASSUME_NONNULL_BEGIN
API_AVAILABLE(ios(8.0))
@interface JavaScriptDeviceMoudle : BaseJavaScriptMoudle
- (void)getDeviceId:(JavaScriptMessageAdapter *)message;
- (void)getNetWorkInfo:(JavaScriptMessageAdapter *)message;
- (void)getDeviceModel:(JavaScriptMessageAdapter *)message;
- (void)closeInputKeyboard:(JavaScriptMessageAdapter *)message;
- (void)vibrate:(JavaScriptMessageAdapter *)message;
- (void)callPhone:(JavaScriptMessageAdapter *)message;
- (void)sendMsg:(JavaScriptMessageAdapter *)message;
@end

NS_ASSUME_NONNULL_END
