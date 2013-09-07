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
@synthesize delegate;

- (id)init
{
    self = [super init];
    if (self) {
        imageQueue = [[NSMutableArray alloc] init];
        imageSet = [[NSMutableSet alloc] init];
        
        faceDetector = [[FaceDetector alloc] init];
        
        faceRecognizer = [[CustomFaceRecognizer alloc] initWithEigenFaceRecognizer];
        names = [[NSMutableDictionary alloc] init];
                 
        NSArray *array = [faceRecognizer getAllPeople];
        
        for (NSDictionary *dict in array) {
            [names setObject:[dict objectForKey:@"id"] forKey:[dict objectForKey:@"name"]];
        }
                 
        
        grabber = [[ImageGrabber alloc] init];
        grabber.delegate = self;
    }
    return self;
}

-(void)start{
    [grabber grabAllImages];
}

-(void)addImage:(ImageData*)image{
    image.delegate = self;
    [imageSet addObject:image];
}

-(void)addToQueue:(ImageData *)image{
    [imageQueue addObject:image];
    [image analyze];
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
-(void)addImageToDatabase:(UIImage*)image forID:(NSInteger)tagID{
    
    if ([names objectForKey:[NSString stringWithFormat:@"%i",tagID]] == nil) {
        [faceRecognizer newPersonWithName:[NSString stringWithFormat:@"%i",tagID]];
    }

    [delegate addImageToDatabase:image forName:[grabber getNameForID:tagID]];
}

-(void)recievedImageData:(ImageData*)imageData{
    [self addImage:imageData];
}



@end
