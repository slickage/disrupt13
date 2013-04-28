//
//  ListingsViewController.m
//  Disrupt13
//
//  Created by Julie Ann Sakuda on 4/27/13.
//  Copyright (c) 2013 TC Disrupt 2013. All rights reserved.
//

#import "ListingsViewController.h"

@interface ListingsViewController () {
  __weak IBOutlet MKMapView *_mapView;
  
  CLLocationManager *_locManager;
  CLLocation *_userLoc;
}

@end

@implementation ListingsViewController

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
}

- (void)viewDidAppear:(BOOL)animated {
  [self performSegueWithIdentifier:@"ShowLogin" sender:self];
//  [self startCL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
  [manager stopUpdatingLocation];
  UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Unable to Retrieve Location"
                                                    message:@"Unable to detect your location. Please make sure location services is enabled and working."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
  [message show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *) locations {
  NSLog(@"%@", [locations lastObject]);
  // got a location, stop getting location updates
  [manager stopUpdatingLocation];
  
  _userLoc = [locations lastObject];
  
  MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:MKCoordinateRegionMakeWithDistance(_userLoc.coordinate, 1000, 1000)];
  [_mapView setRegion:adjustedRegion animated:NO];
  
  JPSThumbnailAnnotation *annot = [[JPSThumbnailAnnotation alloc] init];
  annot.coordinate = _userLoc.coordinate;
  [_mapView addAnnotation:annot];
}

- (void)startCL {
  // Test for location services
  if (![CLLocationManager locationServicesEnabled]) {
    //    [self doLog:@"User has disabled location services"];
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Unable to Retrieve Location"
                                                      message:@"Please enable location services for the Atlantis application to use this feature."
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];
    return;
  }
  // Test for authorization
  if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
    //    [self doLog:@"User has denied location services"];
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Unable to Retrieve Location"
                                                      message:@"Please enable location services for the Atlantis application to use this feature."
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];
    return;
  }
  
  if (!_locManager) {
    _locManager = [[CLLocationManager alloc] init];
    _locManager.delegate = self;
    _locManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locManager.distanceFilter = 5.0f; // in meters
  }
  [_locManager startUpdatingLocation];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"ShowCameraView"]) {
    UINavigationController *navController = segue.destinationViewController;
    CameraViewController *dstVC = (CameraViewController *) [navController topViewController];
    dstVC.userLoc = _userLoc;
  }
}

@end
