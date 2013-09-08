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

@interface PreparingViewController ()

@end

@implementation PreparingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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
