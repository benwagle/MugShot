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
  //  NSLog(@"AHH!");

    
	// Do any additional setup after loading the view, typically from a nib.
    

    
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

-(void)foundPersonID:(NSString*)string withImage:(UIImage*)image withFace:(cv::Rect)rect{
    ResultViewController *resultViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"result"];
    [resultViewController getInfoForPersonID:string withImage:image withFace:rect];
    [self.navigationController pushViewController:resultViewController animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    appeared = NO;
}



@end
