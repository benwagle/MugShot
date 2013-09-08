//
//  ImageParser.m
//  Face Finder
//
//  Created by Mike Jaoudi on 9/7/13.
//  Copyright (c) 2013 Mike Jaoudi. All rights reserved.
//

#import "ImageParser.h"
#import "UIImage+OpenCV.h"
#import "OpenCVData.h"

@implementation ImageParser
@synthesize delegate;

+ (ImageParser *)sharedParser{
    static ImageParser *sharedParser = nil;
    @synchronized(self) {
        if (sharedParser == nil)
            sharedParser = [[self alloc] init];
    }
    return sharedParser;
}


- (id)init
{
    self = [super init];
    if (self) {
        imageSet = [[NSMutableSet alloc] init];
        
        faceDetector = [[FaceDetector alloc] init];
        
        faceRecognizer = [CustomFaceRecognizer sharedRecognizer];
        names = [[NSMutableDictionary alloc] init];
                 
        NSArray *array = [faceRecognizer getAllPeople];
        
        for (NSDictionary *dict in array) {
            [names setObject:[dict objectForKey:@"id"] forKey:[dict objectForKey:@"name"]];
        }
                 
        
        grabber = [[ImageGrabber alloc] init];
        grabber.delegate = self;
        
        passed = 0;
        failed = 0;
    }
    return self;
}

-(void)startWithImage:(UIImage*)image{
  // [grabber grabAllImages];
    //return;
 /*   NSLog(@"START!");
    UIImage *image = [UIImage imageNamed:@"MikeAndBen.jpg"];

    ImageData *imageData = [[ImageData alloc] initWithJSON:@{@"tags":@{@"data": @{@"id": @552452699, @"x":@0, @"y":@0}}} andImage:image andDelegate:self];*/
 //   NSLog(@"Name:%@",[grabber getNameForID:@"698952030"]);
    
    
    //[faceRecognizer trainModel];
 //   NSLog(@"End!");
    
   // UIImage *im2 = [UIImage imageNamed:@"Mike1.jpg"];
    cv::Mat image2 = [image CVMat];
    
    //std::vector<cv::Rect> faces2 = [faceDetector facesFromImage:image2];
    
    NSArray *array = [FaceDetector CGRectFromImage:image];
    
    for (int x=0; x<[array count]; x++) {
        cv::Rect face = [OpenCVData CGRectToFace:((CIFaceFeature*)array[x]).bounds];
      //  int faceID = [[[faceRecognizer recognizeFace:face inImage:image2] objectForKey:@"personName"] integerValue];
        NSDictionary *result = [faceRecognizer recognizeFace:face inImage:image2];
        NSLog(@"%@", result);
        [delegate foundPersonID:[result objectForKey:@"personName"] withImage:[self cropImage:image forRect:((CIFaceFeature*)array[x]).bounds]];
    }

    //  NSLog(@"%@",[faceRecognizer getAllPeople]);
    //  if([faceRecognizer trainModel]){
    //    NSLog(@"Train successful!");
    // }*/
}

-(void)checkForMore{
    if([imageSet count] == 0){
     //   [grabber nextPerson];
    }
}
-(void)recievedData:(ImageData *)image{
    [image analyze];
    [imageSet removeObject:image];
    
    [self checkForMore];
    
}

-(BOOL)addImage:(UIImage*)im forPerson:(NSInteger)x{
    cv::Mat image = [im CVMat];
    
    std::vector<cv::Rect> faces = [faceDetector facesFromImage:image];
    NSLog(@"Faces: %li",faces.size());
    if(faces.size() == 0){
        return NO;
    }
    
    [faceRecognizer learnFace:faces[0] ofPersonID:x fromImage:image];
    return YES;
}
-(void)addImageToDatabase:(UIImage*)image forID:(NSString*)tagID forFace:(cv::Rect)face{

    if ([names objectForKey:tagID] == nil) {
        int dataID = [faceRecognizer newPersonWithName:tagID];
        [names setObject:[NSNumber numberWithInt:dataID] forKey:tagID];
    }
    
    [delegate addImageToDatabase:image forName:@""];


    cv::Mat cvIm = [image CVMat];
   // std::vector<cv::Rect> faces2 = [faceDetector facesFromImage:cvIm];

    [faceRecognizer learnFace:face ofPersonID:[[names objectForKey:tagID] intValue] fromImage:cvIm];
    //int personID = [[names objectForKey:[NSString stringWithFormat:@"%i",tagID]] intValue];
  //  if([self addImage:image forPerson:personID]){
    //    NSLog(@"SHOW!!");

    //}
   // [delegate addImageToDatabase:image forName:[grabber getNameForID:tagID]];
    
}

-(BOOL)recievedImageData:(NSDictionary*)dict{
    
    if([faceRecognizer existImageID:[dict objectForKey:@"id"]]){
        NSLog(@"ALREADY EXISTS!");
        return NO;
    }
    ImageData *imageData = [[ImageData alloc] initWithJSON:dict];

    imageData.delegate = self;
    [imageSet addObject:imageData];
    return YES;
}

-(void)showImage:(UIImage*)image{
    failed++;
    NSLog(@"Passed:%i Failed:%i",passed,failed);
    [delegate addImageToDatabase:image forName:@""];

}

-(void)markImageAsFinishedforImageID:(NSString*)photoID{
    //NSLog(@"Finished");
    [faceRecognizer markImageIDFinished:photoID];
    passed++;
    NSLog(@"Passed:%i Failed:%i",passed,failed);
}

-(void)removeID:(NSString*)string{
    
    [[CustomFaceRecognizer sharedRecognizer] removeID:[[names objectForKey:string] intValue]];
    [faceRecognizer trainModel];
    
}

-(UIImage*)cropImage:(UIImage*)large forRect:(CGRect)rect{
    CGImageRef imageRef = CGImageCreateWithImageInRect([large CGImage], rect);
    UIImage *small = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return small;
}






@end
