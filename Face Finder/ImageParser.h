//
//  ImageParser.h
//  Face Finder
//
//  Created by Mike Jaoudi on 9/7/13.
//  Copyright (c) 2013 Mike Jaoudi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageData.h"
#import "CustomFaceRecognizer.h"
#import "FaceDetector.h"
#import "ImageGrabber.h"

@protocol ImageParserDelegate
@required
-(void)showImage:(UIImage*)image;
-(void)foundPersonID:(NSString*)string withImage:(UIImage*)image withFace:(cv::Rect)rect;
-(void)finished;


@end

@interface ImageParser : NSObject<ImageDataDelegate, ImageGrabberDelegate>{
    NSMutableSet *imageSet;
    
    CustomFaceRecognizer *faceRecognizer;
    FaceDetector *faceDetector;
    
    ImageGrabber *grabber;
    
    NSMutableDictionary *names;
    
    NSInteger passed;
    NSInteger failed;
}

//-(void)addImage:(ImageData*)image;
-(void)start;
-(void)startWithImage:(UIImage*)image;
+ (ImageParser *)sharedParser;
-(void)removeID:(NSString*)string;
-(void)getAllImages;
-(void)addPerson:(NSString*)tagID; 


@property(nonatomic, strong) id<ImageParserDelegate> delegate;

@end
