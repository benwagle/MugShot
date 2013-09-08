//
//  ViewController.m
//  Face Finder
//
//  Created by Mike Jaoudi on 9/6/13.
//  Copyright (c) 2013 Mike Jaoudi. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>

#import "AppDelegate.h"
#import "ViewController.h"
#import "OpenCVData.h"
#import "UIImage+OpenCV.h"
#import "ResultViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"AHH!");
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(sessionStateChanged:)
     name:FBSessionStateChangedNotification
     object:nil];
    
	// Do any additional setup after loading the view, typically from a nib.
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate openSessionWithAllowLoginUI:YES];
    
}

-(void)viewWillAppear:(BOOL)animated{
    imageView.image = setImage;

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    appeared = YES;
    
    
    if(FBSession.activeSession.isOpen){
        parser = [ImageParser sharedParser];
        [parser setDelegate:self];
        [parser startWithImage:setImage];
    }
}

- (void)sessionStateChanged:(NSNotification*)notification {
    if (FBSession.activeSession.isOpen && appeared) {
        NSLog(@"WORKED!!");

    } else {
       
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)addImageToDatabase:(UIImage *)image forName:(NSString *)name{
    imageView.image = image;
}

-(void)showImage:(UIImage *)image{
    imageView.image = image;
}

-(void)setImage:(UIImage*)image{
    NSLog(@"IMAGE!");
    setImage = image;
}

-(void)foundPersonID:(NSString*)string{
    ResultViewController *resultViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"result"];
    [resultViewController getInfoForPersonID:string];
    [self.navigationController pushViewController:resultViewController animated:YES];
}



@end
