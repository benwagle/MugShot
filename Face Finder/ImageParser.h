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

@interface ImageParser : NSObject<ImageDataDelegate>{
    NSMutableArray *imageQueue;
    NSMutableSet *imageSet;
    
    CustomFaceRecognizer *faceRecognizer;
    FaceDetector *faceDetector;
}

-(void)addImage:(ImageData*)image;

@end
