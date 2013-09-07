//
//  AppDelegate.h
//  Face Finder
//
//  Created by Mike Jaoudi on 9/6/13.
//  Copyright (c) 2013 Mike Jaoudi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

extern NSString *const FBSessionStateChangedNotification;


@class ViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ViewController *viewController;

@property (strong, nonatomic) NSString *loggedInUserID;

@property (strong, nonatomic) FBSession *loggedInSession;

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;
- (void) closeSession;
@end
