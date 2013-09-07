//
//  ImageParser.m
//  Face Finder
//
//  Created by Mike Jaoudi on 9/7/13.
//  Copyright (c) 2013 Mike Jaoudi. All rights reserved.
//

#import "ImageParser.h"
#import "UIImage+OpenCV.h"


@implementation ImageParser

- (id)init
{
    self = [super init];
    if (self) {
        imageQueue = [[NSMutableArray alloc] init];
        imageSet = [[NSMutableSet alloc] init];
        
        faceDetector = [[FaceDetector alloc] init];
        
        faceRecognizer = [[CustomFaceRecognizer alloc] initWithEigenFaceRecognizer];
    }
    return self;
}

-(void)addImage:(ImageData*)image{
    image.delegate = self;
    [imageSet addObject:image];
}

-(void)addToQueue:(ImageData *)image{
    [imageQueue addObject:image];
    NSLog(@"%i images",[imageQueue count]);
}

-(void)recievedData:(ImageData *)image{
    [imageSet removeObject:image];
    [self addToQueue:image];
}

-(void)addFile:(NSString*)fileName forPerson:(NSInteger)x{
    UIImage *im = [UIImage imageNamed:fileName];
    cv::Mat image = [im CVMat];
    
    std::vector<cv::Rect> faces = [faceDetector facesFromImage:image];
    NSLog(@"Faces: %li",faces.size());
    
    [faceRecognizer learnFace:faces[0] ofPersonID:x fromImage:image];
}

@end
