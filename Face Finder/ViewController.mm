//
//  ViewController.m
//  Face Finder
//
//  Created by Mike Jaoudi on 9/6/13.
//  Copyright (c) 2013 Mike Jaoudi. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>

#import "ViewController.h"
#import "OpenCVData.h"
#import "UIImage+OpenCV.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    faceDetector = [[FaceDetector alloc] init];
    
    faceRecognizer = [[CustomFaceRecognizer alloc] initWithEigenFaceRecognizer];
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
    
    ImageGrabber *grabber = [[ImageGrabber alloc] init];
    [grabber setDelegate:self];
    [grabber grabAllImages];
    
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen: {
            UIViewController *topViewController =
            [self.navController topViewController];
            if ([[topViewController modalViewController]
                 isKindOfClass:[SCLoginViewController class]]) {
                [topViewController dismissModalViewControllerAnimated:YES];
            }
        }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            // Once the user has logged in, we want them to
            // be looking at the root view.
            [self.navController popToRootViewControllerAnimated:NO];
            
            [FBSession.activeSession closeAndClearTokenInformation];
            
            [self showLoginView];
            break;
        default:
            break;
    }
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}


- (void)openSession
{
    [FBSession openActiveSessionWithReadPermissions:nil
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session,
       FBSessionState state, NSError *error) {
         [self sessionStateChanged:session state:state error:error];
     }];
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
