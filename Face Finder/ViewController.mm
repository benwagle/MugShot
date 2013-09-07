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


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(sessionStateChanged:)
     name:FBSessionStateChangedNotification
     object:nil];
    
	// Do any additional setup after loading the view, typically from a nib.
    faceDetector = [[FaceDetector alloc] init];
    
    faceRecognizer = [[CustomFaceRecognizer alloc] initWithEigenFaceRecognizer];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate openSessionWithAllowLoginUI:YES];
    /*[faceRecognizer newPersonWithName:@"Ben"];
    [faceRecognizer newPersonWithName:@"Mike"];
    [faceRecognizer newPersonWithName:@"Or"];*/
    
   /* [self addFile:@"Ben1.jpg" forPerson:1];
    [self addFile:@"Ben2.jpg" forPerson:1];
    [self addFile:@"Ben3.jpg" forPerson:1];
    [self addFile:@"Ben4.jpg" forPerson:1];
    [self addFile:@"Ben5.jpg" forPerson:1];
    [self addFile:@"Ben6.jpg" forPerson:1];
    [self addFile:@"Ben7.jpg" forPerson:1];
    [self addFile:@"Ben8.jpg" forPerson:1];
    [self addFile:@"Mike1.jpg" forPerson:2];
    [self addFile:@"Mike2.jpg" forPerson:2];
    [self addFile:@"Mike3.jpg" forPerson:2];
    [self addFile:@"Mike4.jpg" forPerson:2];
    [self addFile:@"Mike5.jpg" forPerson:2];
    [self addFile:@"Mike6.jpg" forPerson:2];
    [self addFile:@"Mike7.jpg" forPerson:2];
    [self addFile:@"Mike8.jpg" forPerson:2];

    [self addFile:@"Or1.jpg" forPerson:3];
    [self addFile:@"Or2.jpg" forPerson:3];
    [self addFile:@"Or3.jpg" forPerson:3];
  //  [self addFile:@"Or4.jpg" forPerson:3];
    [self addFile:@"Or5.jpg" forPerson:3];
    [self addFile:@"Or6.jpg" forPerson:3];
    [self addFile:@"Or7.jpg" forPerson:3];
    [self addFile:@"Or8.jpg" forPerson:3];*/
    
 /*   [faceRecognizer trainModel];
    
    UIImage *im2 = [UIImage imageNamed:@"Or9.jpg"];
    cv::Mat image2 = [im2 CVMat];
    
    std::vector<cv::Rect> faces2 = [faceDetector facesFromImage:image2];
    
    NSLog(@"%@",[faceRecognizer recognizeFace:faces2[0] inImage:image2]);
    //  NSLog(@"%@",[faceRecognizer getAllPeople]);
    //  if([faceRecognizer trainModel]){
    //    NSLog(@"Train successful!");
    // }*/
    
}

- (void)sessionStateChanged:(NSNotification*)notification {
    if (FBSession.activeSession.isOpen) {
        NSLog(@"WORKED!!");
                   ImageGrabber *grabber = [[ImageGrabber alloc] init];
         [grabber setDelegate:self];
         [grabber grabAllImages];
    } else {
       
    }
}


-(void)addFile:(NSString*)fileName forPerson:(NSInteger)x{
    UIImage *im = [UIImage imageNamed:fileName];
    cv::Mat image = [im CVMat];
    
    std::vector<cv::Rect> faces = [faceDetector facesFromImage:image];
    NSLog(@"Faces: %li",faces.size());
    
    [faceRecognizer learnFace:faces[0] ofPersonID:x fromImage:image];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImage *)convertImageToGrayScale:(UIImage *)image
{
    // Create image rectangle with current image width/height
    CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    // Grayscale color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    
    // Create bitmap content with current image size and grayscale colorspace
    CGContextRef context = CGBitmapContextCreate(nil, image.size.width, image.size.height, 8, 0, colorSpace, kCGImageAlphaNone);
    
    // Draw image into current context, with specified rectangle
    // using previously defined context (with grayscale colorspace)
    CGContextDrawImage(context, imageRect, [image CGImage]);
    
    // Create bitmap image info from pixel data in current context
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    
    // Create a new UIImage object
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    
    // Release colorspace, context and bitmap information
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    CFRelease(imageRef);
    
    // Return the new grayscale image
    return newImage;
}

-(void)recievedImage:(UIImage *)image{
    imageView.image = image;
}


@end
