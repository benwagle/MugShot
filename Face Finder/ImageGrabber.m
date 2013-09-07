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
-(void)grabAllImages{
   
  
   FBRequestConnection *requestConnection = [[FBRequestConnection alloc] init];
  [requestConnection addRequest:[FBRequest requestForGraphPath:@"me/photos?"] completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
       NSLog(@"Stuff:%@",result);
    }];
    [requestConnection start];
    //[self grabImagesAtPath:@"https://graph.facebook.com/me/photos?"];
   
}

-(void)grabImagesAtPath:(NSString*)path{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:path]];


    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {

        NSLog(@"Data %i",[[JSON objectForKey:@"data"] count]);

        for (NSDictionary *dict in [JSON objectForKey:@"data"]) {

                
                [self getImage:[dict objectForKey:@"picture"]];
          //  }
        }
        NSLog(@"%@",[JSON objectForKey:@"paging"]);
        [self grabImagesAtPath:[[JSON objectForKey:@"paging"] objectForKey:@"next"]];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON){

    }];
    [operation start];
}

-(void)getImage:(NSString*)imagePath{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:imagePath]];
    
    
    AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:request success:^(UIImage *image){
        [delegate recievedImage:image];
    }];
    [operation start];
}

@end
