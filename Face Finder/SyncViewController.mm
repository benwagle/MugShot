//
//  SyncViewController.m
//  Face Finder
//
//  Created by Mike Jaoudi on 9/8/13.
//  Copyright (c) 2013 Mike Jaoudi. All rights reserved.
//

#import "SyncViewController.h"

@interface SyncViewController ()

@end

@implementation SyncViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated{
    ImageParser *parser = [ImageParser sharedParser];
    parser.delegate = self;
    [parser getAllImages];
}


-(void)showImage:(UIImage*)image{
    imageView.image = image;
}

-(void)foundPersonID:(NSString*)string withImage:(UIImage*)image withFace:(cv::Rect)rect{
    
}

-(void)finished{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
