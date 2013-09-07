//
//  ImageData.m
//  Face Finder
//
//  Created by Mike Jaoudi on 9/7/13.
//  Copyright (c) 2013 Mike Jaoudi. All rights reserved.
//

#import "ImageData.h"
#import <AFNetworking/AFNetworking.h>

@implementation TagInfo
@synthesize location, tagID;

@end

@implementation ImageData

-(id)initWithJSON:(NSDictionary*)JSON{
    self = [super init];
    
    tags = [[NSMutableArray alloc] init];
    
    [self getImage:[JSON objectForKey:@"picture"]];
    
    for (NSDictionary *dict in [[JSON objectForKey:@"tags"] objectForKey:@"data"]) {
   //     NSLog(@"dict %@",dict);
        [self addTagAtX:[[dict objectForKey:@"x"] integerValue] y:[[dict objectForKey:@"y"] integerValue] userID:[[dict objectForKey:@"id"] integerValue]];
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
    
}

@end
