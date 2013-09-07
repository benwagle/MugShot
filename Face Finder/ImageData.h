//
//  ImageData.h
//  Face Finder
//
//  Created by Mike Jaoudi on 9/7/13.
//  Copyright (c) 2013 Mike Jaoudi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FaceDetector.h"

@interface TagInfo : NSObject

-(NSInteger)getDistanceToPoint:(CGRect)rect;

@property() CGPoint location;
@property() NSInteger tagID;
@property() CGRect faceRect;
@property() cv::Rect face;

@end

@class ImageData;
@protocol ImageDataDelegate
@required
-(void)recievedData:(ImageData*)image;
-(void)addImageToDatabase:(UIImage*)image forID:(NSInteger)tagID forFace:(cv::Rect)face;
-(void)showImage:(UIImage*)image;
-(void)markImageAsFinishedforImageID:(NSString*)photoID;
@end

@interface ImageData : NSObject{
    UIImage *image;
    NSMutableArray *tags;
}

-(id)initWithJSON:(NSDictionary*)JSON;
-(id)initWithJSON:(NSDictionary *)JSON andImage:(UIImage*)i andDelegate:(id<ImageDataDelegate>)d;
-(void)analyze;

@property(nonatomic, strong) id<ImageDataDelegate> delegate;
@property(nonatomic, strong) NSString *imageID;

@end
