//
//  ImageData.h
//  Face Finder
//
//  Created by Mike Jaoudi on 9/7/13.
//  Copyright (c) 2013 Mike Jaoudi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TagInfo : NSObject

@property() CGPoint location;
@property() NSInteger tagID;

@end

@class ImageData;
@protocol ImageDataDelegate
@required
-(void)recievedData:(ImageData*)image;
@end

@interface ImageData : NSObject{
    UIImage *image;
    NSMutableArray *tags;
}

-(id)initWithJSON:(NSDictionary*)JSON;
-(void)analyze;

@property(nonatomic, strong) id<ImageDataDelegate> delegate;

@end
