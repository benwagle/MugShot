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
@synthesize location, tagID, faceRect;

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
@synthesize delegate;

-(id)initWithJSON:(NSDictionary*)JSON{
    self = [super init];
    
    tags = [[NSMutableArray alloc] init];
    
    [self getImage:[JSON objectForKey:@"picture"]];
    
    for (NSDictionary *dict in [[JSON objectForKey:@"tags"] objectForKey:@"data"]) {
        [self addTagAtX:[[dict objectForKey:@"x"] integerValue] y:[[dict objectForKey:@"y"] integerValue] userID:[[dict objectForKey:@"id"] integerValue]];
    }
    
    if(faceDetector == nil)
    {
        faceDetector = [[FaceDetector alloc] init];
    }
    
    return self;
}

-(void)getImage:(NSString*)imagePath{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:imagePath]];
    
    
    AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:request success:^(UIImage *i){
        image = i;
        [self.delegate recievedData:self];
    }];
    [operation start];
}

-(void)addTagAtX:(NSInteger)x y:(NSInteger)y userID:(NSInteger)uid{
    TagInfo *tag = [[TagInfo alloc] init];
    tag.location = CGPointMake(x, y);
    tag.tagID = uid;
    [tags addObject:tag];
}

-(void)analyze{
    cv::Mat im = [image CVMat];

    std::vector<cv::Rect> faces = [faceDetector facesFromImage:im];
    
    for (int x=0; x<faces.size(); x++) {
        CGRect rect = [OpenCVData faceToCGRect:faces[x]];
        int min = INFINITY;
        TagInfo *minTag;
        for (TagInfo *tag in tags) {
            int distance = [tag getDistanceToPoint:rect];
            if(distance < min){
                min = distance;
                minTag = tag;
            }
            
        }
        minTag.faceRect = rect;
    }
    for (TagInfo *tag in tags) {
        if(CGRectEqualToRect(tag.faceRect, CGRectZero)){
            continue;
        }
        
        [delegate addImageToDatabase:[self cropImage:image forRect:tag.faceRect] forID:tag.tagID];
    }
}

-(UIImage*)cropImage:(UIImage*)large forRect:(CGRect)rect{
    CGImageRef imageRef = CGImageCreateWithImageInRect([large CGImage], rect);
    UIImage *small = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return small;
}

@end
