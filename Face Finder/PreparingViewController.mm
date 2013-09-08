//
//  PreparingViewController.m
//  Face Finder
//
//  Created by Mike Jaoudi on 9/8/13.
//  Copyright (c) 2013 Mike Jaoudi. All rights reserved.
//

#import "PreparingViewController.h"
#import "CustomFaceRecognizer.h"
#import "SourceViewController.h"
#import "AppDelegate.h"

@interface PreparingViewController ()

@end

@implementation PreparingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(sessionStateChanged:)
     name:FBSessionStateChangedNotification
     object:nil];
    
    
	// Do any additional setup after loading the view.
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate openSessionWithAllowLoginUI:YES];
    
    
}


- (void)sessionStateChanged:(NSNotification*)notification {
    if (FBSession.activeSession.isOpen) {

    } else {
        
    }
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"Start!");

    [[CustomFaceRecognizer sharedRecognizer] trainModel];
    NSLog(@"End!");
    SourceViewController *sourceViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"source"];
    [self.navigationController pushViewController:sourceViewController animated:YES];
}

@end
