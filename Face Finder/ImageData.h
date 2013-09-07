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

@end

@class ImageData;
@protocol ImageDataDelegate
@required
-(void)recievedData:(ImageData*)image;
-(void)addImageToDatabase:(UIImage*)image forID:(NSInteger)tagID;
@end

@interface ImageData : NSObject{
    UIImage *image;
    NSMutableArray *tags;
    
}

-(id)initWithJSON:(NSDictionary*)JSON;
-(void)analyze;

@property(nonatomic, strong) id<ImageDataDelegate> delegate;

@end
