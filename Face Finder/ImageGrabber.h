//
//  ImageGrabber.h
//  Face Finder
//
//  Created by Mike Jaoudi on 9/7/13.
//  Copyright (c) 2013 Mike Jaoudi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageParser.h"

@protocol ImageGrabberDelegate
@required
-(void)recievedImage:(UIImage*)image;
@end

@interface ImageGrabber : NSObject{
    ImageParser *parser;
}

-(void)grabAllImages;

@property(nonatomic, strong) id<ImageGrabberDelegate> delegate;


@end
