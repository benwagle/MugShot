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
        
        passed = 0;
        failed = 0;
    }
    return self;
}

-(void)start{
    [grabber grabAllImages];
 /*   NSLog(@"START!");
    UIImage *image = [UIImage imageNamed:@"MikeAndBen.jpg"];

    ImageData *imageData = [[ImageData alloc] initWithJSON:@{@"tags":@{@"data": @{@"id": @552452699, @"x":@0, @"y":@0}}} andImage:image andDelegate:self];*/
}

-(void)checkForMore{
    if([imageSet count] == 0){
        [grabber nextPerson];
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
-(void)addImageToDatabase:(UIImage*)image forID:(NSInteger)tagID forFace:(cv::Rect)face{

    if ([names objectForKey:[NSString stringWithFormat:@"%i",tagID]] == nil) {
        int dataID = [faceRecognizer newPersonWithName:[NSString stringWithFormat:@"%i",tagID]];
        [names setObject:[NSNumber numberWithInt:dataID] forKey:[NSString stringWithFormat:@"%i",tagID]];
    }
    


    cv::Mat cvIm = [image CVMat];
   // std::vector<cv::Rect> faces2 = [faceDetector facesFromImage:cvIm];

    [faceRecognizer learnFace:face ofPersonID:[[names objectForKey:[NSString stringWithFormat:@"%i",tagID]] intValue] fromImage:cvIm];
    //int personID = [[names objectForKey:[NSString stringWithFormat:@"%i",tagID]] intValue];
  //  if([self addImage:image forPerson:personID]){
    //    NSLog(@"SHOW!!");

    //}
   // [delegate addImageToDatabase:image forName:[grabber getNameForID:tagID]];
    
}

-(BOOL)recievedImageData:(NSDictionary*)dict{

    if([faceRecognizer existImageID:[dict objectForKey:@"id"]]){
       // NSLog(@"ALREADY EXISTS!");
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




@end
