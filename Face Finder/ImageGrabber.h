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
-(BOOL)recievedImageData:(NSDictionary*)dict;
-(void)checkForMore;
@end

@interface ImageGrabber : NSObject{
    NSMutableDictionary *people;
    int personIndex;
    NSMutableArray *friendQueue;
    int peopleProcessing;
    
    NSMutableSet *friendNumbers;
}

-(void)grabAllImages;
-(NSString*)getNameForID:(NSString*)tagID;
-(void)nextPerson;

@property(nonatomic, strong) id<ImageGrabberDelegate> delegate;


@end
