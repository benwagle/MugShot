//
//  ResultViewController.m
//  Face Finder
//
//  Created by Mike Jaoudi on 9/7/13.
//  Copyright (c) 2013 Mike Jaoudi. All rights reserved.
//

#import "ResultViewController.h"
#import "ImageParser.h"
#import "OpenCVData.h"

#import <FacebookSDK/FacebookSDK.h>
#import <AFNetworking/AFNetworking.h>

@interface ResultViewController ()

@end

@implementation ResultViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    testImageView.image = testImage;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getInfoForPersonID:(NSString*)string withImage:(UIImage *)image withFace:(cv::Rect)rect{
    userID = string;
    testImage = [self cropImage:image forRect:[OpenCVData faceToCGRect:rect]];
    largeImage = image;
    face = rect;
    
    FBRequestConnection *requestConnection = [[FBRequestConnection alloc] init];
    [requestConnection addRequest:[FBRequest requestForGraphPath:string] completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        
        name.text = [result objectForKey:@"name"];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://graph.facebook.com/%@/?fields=picture",[result objectForKey:@"id"]]]];
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSURLRequest *request2 = [NSURLRequest requestWithURL:[NSURL URLWithString:[[[JSON objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"]]];
            
            NSLog(@"URL%@",[[[JSON objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"]);
            NSLog(@"%@",JSON);
            AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:request2 success:^(UIImage *image) {
                imageView.image = image;
            }];
            [operation start];
            
            
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            
        }];
        [operation start];
        
        profileLink = [result objectForKey:@"link"];
        NSLog(@"Person:%@",result);
        // [self parseFriends:result];
    }];
    [requestConnection start];
}

-(IBAction)goBack:(id)sender{
    NSArray *childVC = self.navigationController.childViewControllers;
    [[CustomFaceRecognizer sharedRecognizer] clearIgnore];
    NSLog(@"%@",childVC);
    [self.navigationController popToViewController:[childVC objectAtIndex:1] animated:YES];
}
-(IBAction)wrongPerson:(id)sender{
    [[ImageParser sharedParser] removeID:userID];
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)correctPerson:(id)sender{
    [[ImageParser sharedParser] addImageToDatabase:largeImage forID:userID forFace:face];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:profileLink]];
    [self goBack:sender];
}

-(UIImage*)cropImage:(UIImage*)large forRect:(CGRect)r{
    CGRect rect = CGRectMake(r.origin.x - 30, r.origin.y - 30, r.size.width + 60, r.size.height + 60);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([large CGImage], rect);
    UIImage *small = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return small;
}



@end
