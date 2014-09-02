//
//  UIWebViewBridge.m
//  Version 1.0
//
//  Created by Kaoru Kawashima on 3/18/14.
//  Copyright (c) 2014 Kaoru Kawashima. All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this file,
//  You can obtain one at http://mozilla.org/MPL/2.0/.
//

#import <objc/runtime.h>
#import "UIWebViewBridge.h"

@interface UIWebViewBridge ()

@property NSMutableArray* queuedJavaScriptCommands;

/*
 WebViewBridge will detect location change with this
 protocol to determine it is a response being sent back to app from HTML/JavaScript.
 */
@property NSString* responseProtocol;

/*
 JavaScript method in HTML page that will take actual JS method to be called
 and name of callback function to be receive response, in form:
 function(targetJSMethod, args, returnAS3Handler)
 */
@property NSString* bridgeJSFunction;

- (void)callJS:(NSString *)methodName arguments:(id)args, ...;
- (void)processResponseFromWebView:(NSString *)stringToBeDecoded;

@end

@implementation UIWebViewBridge {
    
    BOOL contentLoaded;
    NSInteger hashcounter;
    
}

@synthesize callbackDelegate = _callbackDelegate;

@synthesize queuedJavaScriptCommands = _queuedJavaScriptCommands;
@synthesize responseProtocol = _responseProtocol;
@synthesize bridgeJSFunction = _bridgeJSFunction;

//--------------------------------------------------------------------------
//
//  Initialization methods
//
//--------------------------------------------------------------------------

- (void)initializeProperties
{
    
    _queuedJavaScriptCommands = NULL;
    _responseProtocol = @"kaorulikescurryrice";
    _bridgeJSFunction = @"functionCall";
    
    contentLoaded = NO;
    hashcounter = 0;
    
    [super setDelegate:self];
    
}

- (id)init
{
    
    self = [super init];
    
    if (self) {
        
        [self initializeProperties];
        [self initializeUIWebView];
        
    }
    
    return self;
    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        [self initializeProperties];
        [self initializeUIWebView];
        
    }
    
    return self;
    
}

- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self initializeProperties];
        [self initializeUIWebView];
        
    }
    
    return self;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)didAddSubview:(UIView *)subview
{
    
    [super didAddSubview:subview];
    
}

- (void)initializeUIWebView
{
    
    [self loadWebViewBridgeHTML];
    
}

/*
 Load necessary HTML file
 */
- (void)loadWebViewBridgeHTML
{
    
    // load in necessary html
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *source = [mainBundle pathForResource: @"index" ofType:@"html" inDirectory:@"html"];
    //NSString *source = [NSBundle pathForResource:@"index" ofType:@"html" inDirectory:@"html"];
    NSURL *url = [NSURL fileURLWithPath:source];
    [self loadRequest:[NSURLRequest requestWithURL:url]];
    
}

//--------------------------------------------------------------------------
//
//  Overridden Getters Setters
//
//--------------------------------------------------------------------------

//--------------------------------------
//  delegate
//--------------------------------------

- (void)setDelegate:(id<UIWebViewDelegate>)delegate
{
    
    @throw [NSException exceptionWithName:@"SetDelegateNotAllowed" reason:@"Setting delegate for UIWebViewBridge is currently not allowed." userInfo:nil];
    
}

//--------------------------------------------------------------------------
//
//  Getters Setters
//
//--------------------------------------------------------------------------

//--------------------------------------
//  callbackDelegate
//--------------------------------------

- (id)callbackDelegate
{
    
    return _callbackDelegate;
    
}

- (void)setCallbackDelegate:(id)callbackDelegate
{
    
    _callbackDelegate = callbackDelegate;
    
}

//--------------------------------------------------------------------------
//
//  Private methods
//
//--------------------------------------------------------------------------

- (NSString *)encodeURIComponent:(NSString *)string
{
    
    CFStringRef rv = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)string, NULL, CFSTR(";:@&=+$,/?%#[]"), kCFStringEncodingUTF8);
    
    return (NSString *)CFBridgingRelease(rv);
    
}

- (NSString *)decodeURIComponent:(NSString *)string
{
    
    return [string stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
}

- (NSString *)dropProtocol:(NSString *)url protocol:(NSString *)protocol
{
    
    return [url substringFromIndex:[url rangeOfString:protocol].length + 3];
    
}

- (NSDictionary *)createCommandObj:(NSString *)methodName
{
    
    return [self createCommandObj:methodName arguments:NULL];
    
}

- (NSDictionary *)createCommandObj:(NSString *)methodName arguments:(NSArray *)args
{
    
    //NSMutableDictionary *command = [NSMutableDictionary dictionaryWithObject:methodName forKey:@"method"];
    NSMutableDictionary *command = @{@"method":methodName}.mutableCopy;
    
    int numArgs = (args != NULL ? (int)args.count : 0);
    if (numArgs > 0)
        [command setObject:args forKey:@"arguments"];
    
    return command;
    
}

- (void)webViewExecuteNextJavaScriptCommand
{
    
    if ((self.queuedJavaScriptCommands != NULL) && (self.queuedJavaScriptCommands.count > 0))
    {
        
        NSLog(@"<======== Javascript queued call");
        hashcounter++;
        
        // Put all queued JavaScript commands into single string
        NSError *error;
        NSData *commandData = [NSJSONSerialization dataWithJSONObject:self.queuedJavaScriptCommands options:0 error:&error];
        NSString *commandString = [[NSString alloc] initWithData:commandData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", commandString);
        
        for (id command in self.queuedJavaScriptCommands)
        {
            
            NSLog(@"<-- %@", [NSString stringWithFormat:@"%@%@", [command objectForKey:@"method"], ([command objectForKey:@"arguments"] ? [NSString stringWithFormat:@"%@%@", @", ", [command objectForKey:@"arguments"]] : @"")]);
            
        }
        
        // and send as one hash change
        NSLog(@"<---- %ld&%@", (long)hashcounter, commandString);
        
        NSString *encoded = [self encodeURIComponent:[NSString stringWithFormat:@"%ld&%@", (long)hashcounter, commandString]];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@", @"javascript:window.location.hash='", encoded, @"'"]];
        [self loadRequest:[NSURLRequest requestWithURL:url]];
        
        self.queuedJavaScriptCommands = NULL;
        
    }
    
}

- (void)callJS:(NSString *)methodName arguments:(id)args, ...
{
    
    if (contentLoaded) {
        
        id arguments;
        
        if (args) {
            
            arguments = args; // assuming only one argument...
            
            id eachObject;
            va_list argumentList;
            
            va_start(argumentList, args);
            while ((eachObject = va_arg(argumentList, id)))
            {
                
                if (arguments == args)
                {
                    
                    // If there are more arguments,
                    // recreate Array to hold all
                    arguments = @[].mutableCopy;
                    [arguments addObject:args];
                    
                }
                
                // Add each object to arguments array
                [arguments addObject:eachObject];
                
            }
            va_end(argumentList);
            
        }
        
        // This is my dirty trick #1 to send data to contents in StageWebView
        // HTML page should be watching for hash changing and when it does capture it
        // it should parse data being passed.
        if (self.queuedJavaScriptCommands == NULL)
           self.queuedJavaScriptCommands = [NSMutableArray array];
        
        // Put all JavaScript commands into Array so they will be called all at once later
        // need to do this because hashchange event in HTML page may not capture all changes
        // so I'm sending it as one
        [self.queuedJavaScriptCommands addObject:[self createCommandObj:methodName arguments:arguments]];
        
        if (self.queuedJavaScriptCommands.count == 1)
            [self performSelector:@selector(webViewExecuteNextJavaScriptCommand) withObject:nil afterDelay:0];
        
    }
    
}

- (void)processResponseFromWebView:(NSString *)stringToBeDecoded
{
    
    if (contentLoaded && ([stringToBeDecoded rangeOfString:self.responseProtocol].location != NSNotFound))
    {
        
        stringToBeDecoded = [self dropProtocol:stringToBeDecoded protocol:self.responseProtocol];
        
        if (self.callbackDelegate == NULL)
        {
            
            @throw [NSException exceptionWithName:@"CallbackDelegateNotSet" reason:@"Callback delegate not set." userInfo:nil];
            
            return;
            
        }
        
        NSArray *responses = [stringToBeDecoded componentsSeparatedByString:@"/"];
        id command;
        NSString *methodName;
        SEL methodSelector;
        NSUInteger methodSelectorParameterCount;
        NSArray *methodArgs;
        NSObject *argument;
        NSInvocation *invocation;
        NSMethodSignature *methodSignature;
        for (NSString *response in responses)
        {
            
            command = [NSJSONSerialization JSONObjectWithData:[[self decodeURIComponent:response] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
            methodName = [command objectForKey:@"method"];
            methodSelector = NSSelectorFromString(methodName);
            methodArgs = [command objectForKey:@"arguments"];
            
            // Now do something with this data
            NSLog(@"%@", [self decodeURIComponent:response]);
            NSLog(@"====> Process %@ %@", methodName, [methodArgs componentsJoinedByString:@","]);
            
            // See if specified method exists
            // iOS allows having multiple methods with same name
            // so first check to see if method specified as is exists
            // and then if method with matching arguments exists
            methodSelectorParameterCount = method_getNumberOfArguments(class_getInstanceMethod([self.callbackDelegate class], methodSelector));
            
            if (([self.callbackDelegate respondsToSelector:methodSelector] && (methodSelectorParameterCount - 2 == [methodArgs count])) ||
                [self getArgsMatchingSelector:methodName arguments:methodArgs targetDelegate:self.callbackDelegate selector:&methodSelector])
            {
                
                // Found corresponding function, execute with arguments
                NSLog(@"--> Execute: %@", NSStringFromSelector(methodSelector));
                //[self.callbackDelegate performSelector:methodSelector withObject:methodArgs];
                
                methodSignature = [self.callbackDelegate methodSignatureForSelector:methodSelector];
                invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
                [invocation setSelector:methodSelector];
                [invocation setTarget:self.callbackDelegate];
                
                // arguments
                for (NSInteger i = 0; i < [methodArgs count]; i++) {
                    
                    //NSLog(@"%@", [methodArgs objectAtIndex:i]);
                    argument = [methodArgs objectAtIndex:i];
                    [invocation setArgument:&argument atIndex:(i + 2)];
                    //[invocation setArgument:&[methodArgs objectAtIndex:i] atIndex:i + 2];
                    
                }
                
                // execute
                [invocation invoke];
                //id result;
                //[invocation getReturnValue:&result];
                
            }
            else
            {
                
                NSLog(@"--> No corresponding method: %@", methodName);
                
            }
            
        }
        
    }
    
}

/*
 Checks to see if specified method with matching parameters exists in targetDelegate.
 If it is, then methodSelector will get reference to it.
 */
- (BOOL)getArgsMatchingSelector:(NSString *)methodName arguments:(NSArray *)methodArgs targetDelegate:(id)delegate selector:(SEL *)methodSelector
{
    
    NSLog(@"Checking if there is \"%@\" with matching number of arguments", methodName);
    
    unsigned int callbackMethodCount = 0;
    Method *callbackMethods = class_copyMethodList(object_getClass(delegate), &callbackMethodCount);
    
    NSString *targetMethodName;
    NSRange methodNameRange;
    const char *targetMethodEncoding;
    NSMethodSignature *targetMethodSignature;
    NSUInteger targetMethodParameterCount;
    SEL targetMethodSelector;
    //IMP targetMethodImp;
    //const char *datatype;
    
    for (int i = 0; i < callbackMethodCount; i++)
    {
        
        targetMethodName = [NSString stringWithFormat:@"%s", sel_getName(method_getName(callbackMethods[i]))];
        targetMethodEncoding = method_getTypeEncoding(callbackMethods[i]);
        targetMethodSignature = [NSMethodSignature signatureWithObjCTypes:targetMethodEncoding];
        targetMethodParameterCount = targetMethodSignature.numberOfArguments - 2;
        //targetMethodParameterCount = method_getNumberOfArguments(callbackMethods[i]) - 2;
        
        //NSLog(@"num args - %lu", (unsigned long)targetMethodParameterCount);
        
        methodNameRange = [targetMethodName rangeOfString:methodName];
        
        if ((methodNameRange.location != NSNotFound) && (methodNameRange.location == 0) && (targetMethodParameterCount == [methodArgs count]))
        {
            
            // targetMethodName has specified methodName
            // and number of arguments match
            
            NSLog(@"method - %@, num args: %lu", targetMethodName, (unsigned long)targetMethodParameterCount);
            
            targetMethodSelector = NSSelectorFromString(targetMethodName);
            
            *methodSelector = targetMethodSelector;
            return YES;
            
            // TODO: see if data types match
            
            /*
            targetMethodImp = [delegate methodForSelector:targetMethodSelector];
            
            for (int j = 2; j < targetMethodParameterCount + 2; j++)
            {
                
                datatype = [targetMethodSignature getArgumentTypeAtIndex:j];
                if (strcmp(datatype, @encode(id)) == 0)
                {
                    
                    NSLog(@"%s", datatype);
                    NSLog(@"%@ - %@: %s", [methodArgs objectAtIndex:j - 2], [[methodArgs objectAtIndex:j - 2] class], datatype);
                    
                }
                
            }
             */
            
        }
        
    }
    
    return NO;
    
}

//--------------------------------------------------------------------------
//
//  Public methods
//
//--------------------------------------------------------------------------

- (void)execJavaScript:(NSString *)jsMethodName
{
    
    [self execJavaScript:jsMethodName arguments:NULL];
    
}

- (void)execJavaScript:(NSString *)jsMethodName arguments:(NSArray *)args
{
    
    [self callJS:jsMethodName arguments:args, nil];
    
}

- (void)execJavaScript:(NSString *)jsMethodName arguments:(NSArray *)args callback:(SEL)callback
{
    
    if (callback == NULL)
    {
        
        // No callback method
        [self callJS:jsMethodName arguments:args, nil];
        
    }
    else
    {
        
        // callback method defined, make sure it is defined in callback delegate
        
        if (self.callbackDelegate == NULL)
        {
            
            @throw [NSException exceptionWithName:@"CallbackDelegateNotSet" reason:@"Callback delegate not set." userInfo:nil];
            
        }
        else
        {
            
            if ([self.callbackDelegate respondsToSelector:callback])
            {
                
                [self callJS:self.bridgeJSFunction arguments:[self createCommandObj:jsMethodName arguments:args], NSStringFromSelector(callback), nil];
                
            }
            else
            {
                
                @throw [NSException exceptionWithName:@"CallbackNotDefinedInDelegate" reason:@"Specified callback method does not exist in callback delegate." userInfo:nil];
                
            }
            
        }
        
    }
    
}

//--------------------------------------------------------------------------
//
//  Delegates
//
//--------------------------------------------------------------------------

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    if (contentLoaded)
    {
        
        NSLog(@"shouldStartLoadWithRequest");
        
        NSString *currentURL = webView.request.URL.absoluteString;
        NSString *url = request.URL.absoluteString;
        
        if ((currentURL.length == 0) || ((url.length > 0) && ([currentURL rangeOfString:url].location == NSNotFound) && ([url rangeOfString:currentURL].location == NSNotFound)))
        {
            
            // Trying to go to different page
            
            NSLog(@"%@", currentURL);
            NSLog(@"%@", url);
            
            if ([request.URL.scheme isEqualToString:@"javascript"])
            {
                
                // JavaScript call via URL
                NSLog(@"========> Call JavaScript");
                
                NSString *jsExpressionToExecute = [url substringFromIndex:[url rangeOfString:@"javascript:"].length];
                
                [self stringByEvaluatingJavaScriptFromString:jsExpressionToExecute];
                
            }
            else if ([request.URL.scheme isEqualToString:self.responseProtocol])
            {
                
                // Oh look! Nice protocol found...This is my dirty trick to capture data coming back from HTML page
                NSLog(@"========> Caught data from WebView at shouldOverrideUrlLoading: %@ --> process response", url);
                
                [self processResponseFromWebView:url];
                
            }
            else if (![url isEqualToString:currentURL])
            {
                
                // OK, it is not that protocol and it is trying to go to different URL
                // so let's just open it
                NSLog(@"========> Location change captured, current: %@ --> to: %@", currentURL, url);
                
                // open same URL normally instead
                [[UIApplication sharedApplication] openURL:request.URL];
                
            }
            
            return NO;
            
        }
        
        return YES;
        
    }
    else
    {
        
        return YES;
        
    }
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
    NSLog(@"webViewDidStartLoad");
    contentLoaded = NO;
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    NSLog(@"webViewDidFinishLoad");
    contentLoaded = YES;
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
    NSLog(@"didFailLoadWithError");
    
}

@end
