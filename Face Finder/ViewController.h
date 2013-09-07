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
#import "ImageGrabber.h"

@interface ViewController : UIViewController<ImageGrabberDelegate>{
    CustomFaceRecognizer *faceRecognizer;
    FaceDetector *faceDetector;

    IBOutlet UIImageView *imageView;
}



@end
