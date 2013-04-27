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
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end
