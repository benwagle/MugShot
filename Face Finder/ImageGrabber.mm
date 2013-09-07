//
//  ImageGrabber.m
//  Face Finder
//
//  Created by Mike Jaoudi on 9/7/13.
//  Copyright (c) 2013 Mike Jaoudi. All rights reserved.
//

#import "ImageGrabber.h"
#import <AFNetworking/AFNetworking.h>
#import <FacebookSDK/FacebookSDK.h>

@implementation ImageGrabber

@synthesize delegate;

- (id)init
{
    self = [super init];
    if (self) {
        parser = [[ImageParser alloc] init];
    }
    return self;
}

-(void)grabAllImages{
  
   FBRequestConnection *requestConnection = [[FBRequestConnection alloc] init];
  [requestConnection addRequest:[FBRequest requestForGraphPath:@"me/friends"] completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
       NSLog(@"Stuff:%@",result);
      [self parseFriends:result];
    }];
    [requestConnection start];
   
}

-(void)parseFriends:(NSDictionary*)JSON{
    for (NSDictionary *dict in [JSON objectForKey:@"data"]) {
        FBRequestConnection *requestConnection = [[FBRequestConnection alloc] init];
        [requestConnection addRequest:[FBRequest requestForGraphPath:[NSString stringWithFormat:@"%@/photos",[dict objectForKey:@"id"]]] completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            //NSLog(@"Stuff:%@",result);
            [self parseJSON:result];
        }];
        [requestConnection start];
    }
}

-(void)parseJSON:(NSDictionary*)JSON{
    for (NSDictionary *dict in [JSON objectForKey:@"data"]) {
        if([[[dict objectForKey:@"tags"] objectForKey:@"data"] count] > 0){
            
            ImageData *imageData = [[ImageData alloc] initWithJSON:dict];
            [parser addImage:imageData];

        }
    }
    [self grabImagesAtPath:[[JSON objectForKey:@"paging"] objectForKey:@"next"]];


}

-(void)grabImagesAtPath:(NSString*)path{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:path]];


    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {

        [self parseJSON:JSON];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){

    }];
    [operation start];
}



@end
