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
  
  self.navigationItem.titleView = [ListingDetailsViewController createTitleView:@"Recycle"];
  self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ps_neutral"]];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)recyclePerformed:(id)sender {
  UIImage *resizedImage = [_imageView.image imageByScalingAndCroppingForSize:CGSizeMake(640, 640)];
  NSData *imageData = UIImagePNGRepresentation(resizedImage);
  
  NSNumber *lat = [NSNumber numberWithDouble:[_userLoc coordinate].latitude];
  NSNumber *lon = [NSNumber numberWithDouble:[_userLoc coordinate].longitude];
 
  
  NSDictionary *parameters = @{ @"item[heading]" : @"item-heading",
                                @"item[description]" : _textView.text,
                                @"item[latlon][latitude]" : lat,
                                @"item[latlon][longitude]" : lon
                                };
  
  NSTimeInterval timeInMiliseconds = [[NSDate date] timeIntervalSince1970];
  NSLog(@"Posting: %@", [NSString stringWithFormat:@"photo-%f.png", timeInMiliseconds]);
  R3APIClient *apiClient = [R3APIClient sharedClient];
  NSMutableURLRequest *request = [apiClient multipartFormRequestWithMethod:@"POST" path:@"/items" parameters:parameters constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
    [formData appendPartWithFileData:imageData name:@"item[photo]" fileName:[NSString stringWithFormat:@"photo-%f.png", timeInMiliseconds] mimeType:@"image/png"];
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

+ (UIView *)createTitleView:(NSString *)titleText {
  UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 44)];
  [titleView setBackgroundColor:[UIColor clearColor]];
  
  UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 43)];
  [titleLabel setTextAlignment:NSTextAlignmentCenter];
  titleLabel.text = [titleText uppercaseString];
  titleLabel.backgroundColor = [UIColor clearColor];
  titleLabel.textColor = [UIColor whiteColor];
  
  UIFont *font = [UIFont fontWithName:@"Cuprum-Bold" size:22.0];
  
  [titleLabel setFont:font];
  [titleView addSubview:titleLabel];
  
  return titleView;
}

@end
