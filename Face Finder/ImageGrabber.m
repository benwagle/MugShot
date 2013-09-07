//
//  ImageGrabber.m
//  Face Finder
//
//  Created by Mike Jaoudi on 9/7/13.
//  Copyright (c) 2013 Mike Jaoudi. All rights reserved.
//

#import "ImageGrabber.h"
#import <AFNetworking/AFNetworking.h>

@implementation ImageGrabber

@synthesize delegate;
-(void)grabAllImages{
    [self grabImagesAtPath:@"https://graph.facebook.com/552452699/photos?access_token=CAACEdEose0cBALrNC1O0M2UMcnMoyOtN8gjuM72MIfuJliQcwL0ZCCGcd5ESY6mDc8yIeqLzT1HhKX3jxTY673lN2lvvTobUh7Jn266gHoTwR04J5xAMY910B0WplcE3tynoheONXzen4PB94EL60JSVYZAXBO7Ty5EPNJoJpQYtXMmEIj8uhNnzP1vfVZAYZA9ZBW3GLMQZDZD"];
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
