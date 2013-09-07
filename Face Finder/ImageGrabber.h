//
//  ImageGrabber.h
//  Face Finder
//
//  Created by Mike Jaoudi on 9/7/13.
//  Copyright (c) 2013 Mike Jaoudi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageData.h"

@protocol ImageGrabberDelegate
@required
-(void)recievedImageData:(ImageData*)imageData;
@end

@interface ImageGrabber : NSObject{
    NSMutableDictionary *people;
}

-(void)grabAllImages;
-(NSString*)getNameForID:(NSInteger)tagID;

@property(nonatomic, strong) id<ImageGrabberDelegate> delegate;


@end
