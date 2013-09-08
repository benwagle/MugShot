//
//  SourceViewController.h
//  Face Finder
//
//  Created by Mike Jaoudi on 9/7/13.
//  Copyright (c) 2013 Mike Jaoudi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"


@interface SourceViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

-(IBAction)pickImageFromPhotos:(id)sender;
-(IBAction)facebookSync:(id)sender;

@end
