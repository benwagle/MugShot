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
}

-(void)getInfoForPersonID:(NSString*)string withImage:(UIImage*)image;
-(IBAction)goBack:(id)sender;
-(IBAction)wrongPerson:(id)sender;


@end
