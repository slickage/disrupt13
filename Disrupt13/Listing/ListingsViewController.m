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

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
  }
  return self;
}
- (void)viewDidLoad {
  [super viewDidLoad];
  
  UINib *thisNib = [UINib nibWithNibName:@"ListingCell" bundle:nil];
  [_listingsTableView registerNib:thisNib forCellReuseIdentifier:@"ListingCell"];
  
  [_listingsTableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"ps_neutral"]]];
  
  self.navigationItem.titleView = [ListingsViewController createTitleView:@"Reuse.io"];
}

- (void)viewDidAppear:(BOOL)animated {
//  [self performSegueWithIdentifier:@"ShowLogin" sender:self];
  if (!_userLoc) {
    [self startCL];
  }
  
	NSIndexPath *selection = [_listingsTableView indexPathForSelectedRow];
	if (selection) {
		[_listingsTableView deselectRowAtIndexPath:selection animated:YES];
  }
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
  // got a location, stop getting location updates
  [manager stopUpdatingLocation];
  
  _userLoc = [locations lastObject];
  
  MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:MKCoordinateRegionMakeWithDistance(_userLoc.coordinate, 1000, 1000)];
  [_mapView setRegion:adjustedRegion animated:NO];
  
  MapAnnotation *annot = [[MapAnnotation alloc] initWithCoordinate:_userLoc.coordinate];
  annot.title = @"You";
  [_mapView addAnnotation:annot];
  
  // getting items after user loc is set
  R3APIClient *apiClient = [R3APIClient sharedClient];
  NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                          [NSNumber numberWithDouble:_userLoc.coordinate.latitude], @"latitude",
                          [NSNumber numberWithDouble:_userLoc.coordinate.longitude], @"longitude", nil];
  [apiClient getPath:@"/items" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSLog(@"%@", responseObject);
    _items = [responseObject objectForKey:@"items"];
    [self addItemsToMap];
    [_listingsTableView reloadData];
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"Error: %@", error);
  }];
}

- (void)addItemsToMap {
  for (int i = 0; i < [_items count]; i++) {
    NSDictionary *listing = [_items objectAtIndex:i];
    
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([[listing objectForKey:@"latitude"] doubleValue], [[listing objectForKey:@"longitude"] doubleValue]);
    
    MapAnnotation *annotation = [[MapAnnotation alloc] initWithCoordinate:coord];
    annotation.title = [listing objectForKey:@"description"];;
    
    [_mapView addAnnotation:annotation];
  }
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


#pragma mark -
#pragma mark UITableViewDataSource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [_items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellIdentifier = @"ListingCell";
  ListingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (cell == nil) cell = [[ListingCell alloc] init];
  NSString *label = @"";
  if ([_items count] > 0) {
    NSDictionary *item = [_items objectAtIndex:indexPath.row];
    label = [item objectForKey:@"description"];
    [cell.label setText:label];
//    NSLog(@"%d row : %@", indexPath.row, label);
  }
  return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [self performSegueWithIdentifier:@"PushDetailsView" sender:self];
}

#pragma mark -
#pragma mark MKMapViewDelegate methods

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
  for (MKPinAnnotationView *mkaView in views) {
    // Only update custom items
    if (![mkaView isKindOfClass:[MKAnnotationView class]])
      continue;
    
    id<MKAnnotation> annotation = mkaView.annotation;
    NSLog(@"%@", [annotation title]);
    if ([[annotation title] isEqualToString:@"You"]) {
      mkaView.pinColor = MKPinAnnotationColorRed;
    }
    else {
      mkaView.pinColor = MKPinAnnotationColorPurple;
    }
    
    //Add buttons to each one
    UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    mkaView.rightCalloutAccessoryView = button;
  }
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
