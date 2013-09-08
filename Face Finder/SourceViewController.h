//
//  SourceViewController.h
//  Face Finder
//
//  Created by Mike Jaoudi on 9/7/13.
//  Copyright (c) 2013 Mike Jaoudi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SourceViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

-(IBAction)pickImageFromPhotos:(id)sender;

@end
