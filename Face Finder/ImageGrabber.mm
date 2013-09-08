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
    [self parseFriends:@{@"data": @[@{@"id":@1270333381, @"name":@"Or Barnatan"},@{@"id":@"me", @"name":@"Ben Wagle"}]}];
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
                [self addPerson:[d objectForKey:@"name"] forID:[d objectForKey:@"id"]];
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

-(void)addPerson:(NSString*)name forID:(NSString*)personID{
    if([people objectForKey:personID] == nil && personID != nil){
        [people setObject:name forKey:personID];
    }
}

-(NSString*)getNameForID:(NSString*)tagID{
    return [people objectForKey:tagID];
}




@end
