//
//  AppDelegate.m
//
//  Created by Kaoru Kawashima on 9/4/14.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this file,
//  You can obtain one at http://mozilla.org/MPL/2.0/.
//

#import "UnityiOSBridgeAppDelegate.h"
#import "UnityAppController+ViewHandling.h"
#import "UnityAppController+Rendering.h"
#import "UnityViewControllerBase.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface UnityiOSBridgeAppDelegate()

//@property (nonatomic, strong) UIViewController *viewController;

@end

@implementation UnityiOSBridgeAppDelegate

@synthesize uiWindow = _uiWindow;
@synthesize unityViewVisible = _unityViewVisible;

//--------------------------------------------------------------------------
//
//  Getter/Setter
//
//--------------------------------------------------------------------------

- (BOOL)unityViewVisible
{
    
    return _unityViewVisible;
    
}

- (void)setUnityViewVisible:(BOOL)unityViewVisible
{
    
    _unityViewVisible = unityViewVisible;
    
    // show/hide Unity view by hide/display view controller
    self.viewController.view.hidden = _unityViewVisible;
    [self unityPause:!_unityViewVisible];
    return;
    if (_unityViewVisible)
    {
        
        // Give control to Unity window
        [self.unityWindow makeKeyAndVisible];
        
    }
    else
    {
        
        // Give control back to UI window
        [self.uiWindow makeKeyAndVisible];
        
    }
    
}

//--------------------------------------------------------------------------
//
//  init
//
//--------------------------------------------------------------------------

- (id)init
{
    
    self = [super init];
    
    if (self)
    {
        
        //_unityViewVisible = false;
        _unityViewVisible = true;
        
    }
    
    return self;
    
}

//--------------------------------------------------------------------------
//
//  Overridden methods
//
//--------------------------------------------------------------------------

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    NSLog(@"=======UnityiOSBridgeAppDelegate");
    // Initialize Unity
    BOOL returnBOOL = [super application:application didFinishLaunchingWithOptions:launchOptions];
    /*
    self.unityViewController = [super unityViewController];
    //[self unityPause:true];
    
    // Window for custom UI and view
    self.uiWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Create root view controller for it
    UIViewController *uiWindowRootViewController = [[UIViewController alloc] init];
    self.uiWindow.rootViewController = uiWindowRootViewController;
    */
    // Actual view controller to hold stuff
    _viewController = [[UIViewController alloc] init];
    _viewController.view.backgroundColor = [UIColor clearColor];
    //[uiWindowRootViewController.view addSubview:_viewController.view];
    
    // Set up close button to hide Unity view // TODO: put in seperate method so it can be overridden
    _closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_closeButton setTitle:@"X" forState:UIControlStateNormal];
    _closeButton.frame = CGRectMake(0, 0, 45.0f, 30.0f);
    _closeButton.backgroundColor = UIColorFromRGB(0xFFFFFF);
    [_closeButton addTarget:self action:@selector(onCloseButtonPress) forControlEvents:UIControlEventTouchUpInside];
    
    //[self.uiWindow makeKeyAndVisible];
    
    // initially pause Unity if it needs to be, start only when it is in view
    // Currently it keeps running in background
    [self performSelector:@selector(setInitialUnityPauseState:) withObject:nil afterDelay:25];
    
    return returnBOOL;
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    [super applicationDidBecomeActive:application];
    
    // TODO: UnityPause true/false
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
    [super applicationWillResignActive:application];
    
    // TODO: UnityPause true/false
    
}

- (void)repaint
{
    
    // repaint only when Unity view is visible
    if (_unityViewVisible)
        [super repaint];
    
}

/*
- (void)createViewHierarchyImpl
{
    
	_rootView = _unityView;
	_rootController = [[UIViewController alloc] init]; // Creating normal UIViewController instead of UnityDefaultViewController
    
}

- (void)createViewHierarchy
{
 
	[self createViewHierarchyImpl];
	NSAssert(_rootView != nil, @"createViewHierarchyImpl must assign _rootView");
	NSAssert(_rootController != nil, @"createViewHierarchyImpl must assign _rootController");
    
	_rootView.contentScaleFactor = [UIScreen mainScreen].scale;
	_rootView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
	_rootController.wantsFullScreenLayout = TRUE;
	[_rootController.view addSubview:_rootView]; // Adding unity view as subview instead
	if([_rootController isKindOfClass: [UnityViewControllerBase class]])
		[(UnityViewControllerBase *)_rootController assignUnityView:_unityView];
    
}
*/

- (void)showGameUI
{
    
    [super showGameUI];
    
    // Show close button on top of Unity
    [_window addSubview:_closeButton];
    [_window bringSubviewToFront:_closeButton];
    
}

//--------------------------------------------------------------------------
//
//  Public methods
//
//--------------------------------------------------------------------------

- (void)onCloseButtonPress
{
    
    self.unityViewVisible = !_unityViewVisible;//false;
    
}

- (void)setInitialUnityPauseState
{
    
    self.unityViewVisible = _unityViewVisible;
    
}


@end

//--------------------------------------------------------------------------
//
//  Methods accessed from Unity
//
//--------------------------------------------------------------------------

void objectTouched(char *message, int someNumber)
{
    
    NSString *messageFromUnity = [NSString stringWithUTF8String:message];
    NSLog(@"%@%@", @"From Unity - ", messageFromUnity);
    
    // Hide Unity
    UnityiOSBridgeAppDelegate *delegate = (UnityiOSBridgeAppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.unityViewVisible = false;
    
}
