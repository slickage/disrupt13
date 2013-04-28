//
//  PostDetailsViewController.m
//  Disrupt13
//
//  Created by Julie Ann Sakuda on 4/27/13.
//  Copyright (c) 2013 TC Disrupt 2013. All rights reserved.
//

#import "ListingDetailsViewController.h"

@interface ListingDetailsViewController () {
  __weak IBOutlet UITextView *_textView;
  __weak IBOutlet MKMapView *_mapView;
  __weak IBOutlet UIImageView *_imageView;
}

@end

@implementation ListingDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
	// Do any additional setup after loading the view.
  _imageView.image = _listingImage;
  
  MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:MKCoordinateRegionMakeWithDistance(_userLoc.coordinate, 1000, 1000)];
  [_mapView setRegion:adjustedRegion animated:NO];
  
  JPSThumbnailAnnotation *annot = [[JPSThumbnailAnnotation alloc] init];
  annot.coordinate = _userLoc.coordinate;
  [_mapView addAnnotation:annot];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)recyclePerformed:(id)sender {
  UIImage *resizedImage = [_imageView.image imageByScalingAndCroppingForSize:CGSizeMake(320,320)];
  NSData *imageData = UIImagePNGRepresentation(resizedImage);
  
  NSDictionary *parameters = @{ @"item[heading]" : @"item-heading",
                                @"item[description]" : @"item-desc",
                                @"item[latlon][latitude]" : @1,
                                @"item[latlon][latitude]" : @2,
                                };
  
  R3APIClient *apiClient = [R3APIClient sharedClient];
  NSMutableURLRequest *request = [apiClient multipartFormRequestWithMethod:@"POST" path:@"/items" parameters:parameters constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
    [formData appendPartWithFileData:imageData name:@"item[photo]" fileName:@"photo.jpg" mimeType:@"image/png"];
  }];
  
  AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
  [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
    NSLog(@"%@", [NSString stringWithFormat:@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite]);
  }];
  [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
    [self dismissViewControllerAnimated:YES completion:nil];
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    [self dismissViewControllerAnimated:YES completion:nil];
  }];
  [apiClient enqueueHTTPRequestOperation:operation];
}

@end
