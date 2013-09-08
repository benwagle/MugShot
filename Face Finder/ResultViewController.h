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
}

-(void)getInfoForPersonID:(NSString*)string;
-(IBAction)goBack:(id)sender;
-(IBAction)wrongPerson:(id)sender;


@end
