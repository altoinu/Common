//
//  AppLaunchChecker.m
//
//  Created by Kaoru Kawashima on 12/5/13.
//  Copyright (c) 2013 Kaoru Kawashima. All rights reserved.
//
//  This Source Code Form is subject to the terms of the Mozilla Public
//  License, v. 2.0. If a copy of the MPL was not distributed with this file,
//  You can obtain one at http://mozilla.org/MPL/2.0/.
//

#import "AppLaunchChecker.h"

NSDictionary *_launchOptions;

@implementation AppLaunchChecker

+ (void)load {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doAppLaunchCheck:) name:@"UIApplicationDidFinishLaunchingNotification" object:nil];
    
}

+ (void)doAppLaunchCheck:(NSNotification *)notification {
    
    NSLog(@"=======AppLaunchCheker!!!!");
    
    _launchOptions = [notification userInfo];
    
}

+ (NSDictionary *)getLaunchOptions {
    
    return _launchOptions;
    
}

@end
