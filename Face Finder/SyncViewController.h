//
//  SyncViewController.h
//  Face Finder
//
//  Created by Mike Jaoudi on 9/8/13.
//  Copyright (c) 2013 Mike Jaoudi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageParser.h"

@interface SyncViewController : UIViewController<ImageParserDelegate>{
    IBOutlet UIImageView *imageView;
}

@end
