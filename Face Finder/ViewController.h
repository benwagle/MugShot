//
//  ViewController.h
//  Face Finder
//
//  Created by Mike Jaoudi on 9/6/13.
//  Copyright (c) 2013 Mike Jaoudi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomFaceRecognizer.h"
#import "FaceDetector.h"
#import "ImageParser.h"

@interface ViewController : UIViewController<ImageParserDelegate>{
    CustomFaceRecognizer *faceRecognizer;
    FaceDetector *faceDetector;

    IBOutlet UIImageView *imageView;
    IBOutlet UILabel *nameLabel;
}



@end
