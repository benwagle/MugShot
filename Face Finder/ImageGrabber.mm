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
        people = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void)grabAllImages{
    
    /*
    FBRequestConnection *requestConnection = [[FBRequestConnection alloc] init];
    [requestConnection addRequest:[FBRequest requestForGraphPath:@"me/friends"] completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        //       NSLog(@"Stuff:%@",result);
        [self parseFriends:result];
    }];
    [requestConnection start];
    */
    /* ,@{@"id":@"me", @"name":@"Mike Jaoudi"}*/
    [self parseFriends:@{@"data": @[@{@"id":@100003700054145, @"name":@"Ben Wagle"},@{@"id":@"me", @"name":@"Mike Jaoudi"}]}];
}

-(void)parseFriends:(NSDictionary*)JSON{
    for (NSDictionary *dict in [JSON objectForKey:@"data"]) {
        
        [people setObject:[dict objectForKey:@"name"] forKey:[dict objectForKey:@"id"]];
        
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
            
            for (NSDictionary *d in [[dict objectForKey:@"tags"] objectForKey:@"data"]) {
                [self addPerson:[d objectForKey:@"name"] forID:[[d objectForKey:@"id"] integerValue]];
            }
            
            [delegate recievedImageData:dict];
            
            
            
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

-(void)addPerson:(NSString*)name forID:(NSInteger)personID{
    if([people objectForKey:[NSString stringWithFormat:@"%i",personID]] == nil){
        [people setObject:name forKey:[NSString stringWithFormat:@"%i",personID]];
    }
}

-(NSString*)getNameForID:(NSInteger)tagID{
    return [people objectForKey:[NSString stringWithFormat:@"%i",tagID]];
}




@end
