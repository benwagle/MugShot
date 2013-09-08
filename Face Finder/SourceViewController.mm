//
//  SourceViewController.m
//  Face Finder
//
//  Created by Mike Jaoudi on 9/7/13.
//  Copyright (c) 2013 Mike Jaoudi. All rights reserved.
//

#import "SourceViewController.h"
#import "ViewController.h"

@interface SourceViewController ()

@end

@implementation SourceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(IBAction)pickImageFromPhotos:(id)sender{
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.delegate = self;
    pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:pickerController animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *im = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    ViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"loading"];
    [viewController setImage:im];
    [self.navigationController pushViewController:viewController
                                         animated:YES];
}
                                                 
                                                 
@end
