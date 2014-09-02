//
//  UIWebViewBridge.h
//  Version 1.0
//
//  Created by Kaoru Kawashima on 3/18/14.
//  Copyright (c) 2014 Kaoru Kawashima. All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this file,
//  You can obtain one at http://mozilla.org/MPL/2.0/.
//

#import <UIKit/UIKit.h>

@interface UIWebViewBridge : UIWebView <UIWebViewDelegate>

/*
 Specifies object with callback methods that receives calls from
 HTML/JavaScript displayed in WebView.
 */
@property (nonatomic, assign) id callbackDelegate;

- (void)loadWebViewBridgeHTML;

/*
 This method will serve as a bridge to HTML page and also back to
 app via callback, so if there is a return value(s)
 in specified jsMethodName they are passed to it.
 
 callback - Method in callbackDelegate that will be called with
 return values from JavaScript method being called.
 Return values of the JavaScript method should be array with
 element(s) matching argument(s) of callback function.
 */
- (void)execJavaScript:(NSString *)jsMethodName;
- (void)execJavaScript:(NSString *)jsMethodName arguments:(NSArray *)argsArray;
- (void)execJavaScript:(NSString *)jsMethodName arguments:(NSArray *)argsArray callback:(SEL)callback;

@end
