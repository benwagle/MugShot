//
//  ResultViewController.h
//  Face Finder
//
//  Created by Mike Jaoudi on 9/7/13.
//  Copyright (c) 2013 Mike Jaoudi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultViewController : UIViewController{
    IBOutlet UILabel *name;
    IBOutlet UIImageView *imageView;
    IBOutlet UIImageView *testImageView;
    
    NSString *userID;
    UIImage *testImage;
    
    NSString *profileLink;
    UIImage *largeImage;
    cv::Rect face;
}

-(void)getInfoForPersonID:(NSString*)string withImage:(UIImage *)image withFace:(cv::Rect)rect;
-(IBAction)goBack:(id)sender;
-(IBAction)wrongPerson:(id)sender;
-(IBAction)correctPerson:(id)sender;
-(UIImage*)cropImage:(UIImage*)large forRect:(CGRect)r;


@end
