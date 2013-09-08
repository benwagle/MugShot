//
//  ImageData.m
//  Face Finder
//
//  Created by Mike Jaoudi on 9/7/13.
//  Copyright (c) 2013 Mike Jaoudi. All rights reserved.
//

#import "ImageData.h"
#import "UIImage+OpenCV.h"
#import "OpenCVData.h"
#import <AFNetworking/AFNetworking.h>

@implementation TagInfo
@synthesize location, tagID, faceRect, face;

-(NSInteger)getDistanceToPoint:(CGRect)rect{
    if(!CGRectEqualToRect(faceRect, CGRectZero)){
        return INFINITY;
    }
    CGPoint point = CGPointMake(rect.origin.x + rect.size.width/2, rect.origin.y + rect.size.height/2);
    
    return sqrt( pow(self.location.x - point.x,2) + pow(self.location.y - point.y,2));
}


@end

static FaceDetector *faceDetector;

@implementation ImageData
@synthesize delegate, imageID;

-(id)initWithJSON:(NSDictionary*)JSON{
    self = [super init];
    
    tags = [[NSMutableArray alloc] init];
    
    self.imageID = [JSON objectForKey:@"id"];
    
    [self getImage:[JSON objectForKey:@"source"]];
    

    
    if(faceDetector == nil)
    {
        faceDetector = [[FaceDetector alloc] init];
    }
    for (NSDictionary *dict in [[JSON objectForKey:@"tags"] objectForKey:@"data"]) {
        NSLog(@"%@",dict);

        [self addTagAtX:[[dict objectForKey:@"x"] integerValue] y:[[dict objectForKey:@"y"] integerValue] userID:[dict objectForKey:@"id"]];
    }
    
    return self;
}

-(id)initWithJSON:(NSDictionary *)JSON andImage:(UIImage*)i andDelegate:(id<ImageDataDelegate>)d{
    self = [super init];
    
    tags = [[NSMutableArray alloc] init];
    self.delegate = d;
    NSLog(@"DICT %@",JSON);
    
    for (NSDictionary *dict in [[JSON objectForKey:@"tags"] objectForKey:@"data"]) {
        NSLog(@"%@",dict);

      //  [self addTagAtX:[[dict objectForKey:@"x"] integerValue] y:[[dict objectForKey:@"y"] integerValue] userID:[[dict objectForKey:@"id"] integerValue]];
    }
  //  [self addTagAtX:0 y:0 userID:552452699];
    
    if(faceDetector == nil)
    {
        faceDetector = [[FaceDetector alloc] init];
    }
    
    image = i;
    [self.delegate recievedData:self];
    
    return self;
}

-(void)getImage:(NSString*)imagePath{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:imagePath]];
    NSLog(@"GET IT!");
    
    AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:request success:^(UIImage *i){
        image = i;
        [self.delegate recievedData:self];
    }];
    [operation start];
}

-(void)addTagAtX:(NSInteger)x y:(NSInteger)y userID:(NSString*)uid{
    if(uid == nil){
        return;
    }
    TagInfo *tag = [[TagInfo alloc] init];
    tag.location = CGPointMake(x, y);
    tag.tagID = uid;
    [tags addObject:tag];
}

-(void)analyze{
    cv::Mat im = [image CVMat];

 //   std::vector<cv::Rect> faces = [faceDetector facesFromImage:im];
    NSArray *faces = [FaceDetector CGRectFromImage:image];
 //   NSLog(@"Found:%li",faces.size());
   // NSLog(@"Found:%i faces",[faces count]);
    [delegate showImage:image];

    if([faces count] == 0){
       // NSLog(@"NONE!");
    //    [delegate showImage:image];
        [delegate markImageAsFinishedforImageID:self.imageID];
        return;
    }
    
    for (int y=0;y<[tags count];y++) {
        TagInfo *tag = tags[y];

        int min = INFINITY;
        TagInfo *minTag;
        int minIndex = 0;
        

        for (int x=0; x<[faces count]; x++) {
            CGRect rect = ((CIFaceFeature*)faces[x]).bounds;
            int distance = [tag getDistanceToPoint:rect];
            if(distance < min){
                min = distance;
                minTag = tag;
                minIndex = x;
            }
        }
        
        minTag.faceRect = ((CIFaceFeature*)faces[minIndex]).bounds;
        minTag.face = [OpenCVData CGRectToFace:((CIFaceFeature*)faces[minIndex]).bounds];

        
    }
    

    for (TagInfo *tag in tags) {
        if(CGRectEqualToRect(tag.faceRect, CGRectZero)){
            continue;
            NSLog(@"Skip");
        }

        //[delegate addImageToDatabase:[self cropImage:image forRect:tag.faceRect] forID:tag.tagID forFace:tag.face];
        [delegate addImageToDatabase:image forID:tag.tagID forFace:tag.face];
        

    }
    [delegate markImageAsFinishedforImageID:self.imageID];
}

@end
