//
//  UnityiOSBridgeAppDelegate.h
//
//  Created by Kaoru Kawashima on 1/13/14.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this file,
//  You can obtain one at http://mozilla.org/MPL/2.0/.
//

/*
 Need following modification to source Unity iOS project and files
 
 - Turn automatic reference counting on under Build Settings
 
 - Build Phases/Compile Sources - add compiler flag "-fno-objc-arc" on Unity .m .mm files
 
 - Put these lines of code in corresponding files of Unity project
 
 main.mm
 
 // Custom elements for Unity iOS Bridge **************************************
 // change to UnityiOSBridgeAppDelegate
 const char* AppControllerClassName = "[Name of custom app delegate class that extends UnityiOSBridgeAppDelegate]";
 // ***************************************************************************
 
 // add for automatic reference counting
 @autoreleasepool { }
 
 // remove for automatic reference counting
 NSAutoreleasePool* pool = [NSAutoreleasePool new];
 [pool release];
 
 
 UnityAppController.h
 * Add following code to @interface UnityAppController
 // Custom elements for Unity iOS Bridge **************************************
 
 // Get reference to Unity view controller
 - (UIViewController *)unityViewController;
 
 // Get reference to Unity window
 - (UIWindow *)unityWindow;
 
 - (void)unityPause:(BOOL)pause;
 
 // ***************************************************************************
 
 
 UnityAppController.mm
 * Add following code to @implementation UnityAppController
 // Custom elements for Unity iOS Bridge **************************************
 
 - (UIViewController *)unityViewController
 {
 return UnityGetGLViewController();
 }
 
 - (UIWindow *)unityWindow
 {
 return _mainDisplay->window;
 }
 
 - (void)unityPause:(BOOL)pause
 {
 UnityPause(pause);
 }
 // ***************************************************************************
 
 */

#import "UnityAppController.h"

@interface UnityiOSBridgeAppDelegate : UnityAppController

// Unity view controller reference holder
@property (nonatomic, strong) UIViewController *unityViewController; // TODO: make readyonly?

// A separate window to hold custom UI and view
@property (nonatomic, strong) UIWindow *uiWindow; // TODO: make readonly?

// View on top of Unity Player.
// If we want to display custom iOS UI everything should be placed here.
// Hide this to see Unity
@property (nonatomic, strong) UIViewController *viewController; // TODO: make readyonly?

// Button displayed on top of Unity to close view (displays viewController over it)
@property (nonatomic, strong) UIButton *closeButton;

// Set to true/false to show/hide Unity view
@property (atomic) BOOL unityViewVisible;

- (void)onCloseButtonPress;

@end
