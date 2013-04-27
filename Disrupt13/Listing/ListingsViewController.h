//
//  ListingsViewController.h
//  Disrupt13
//
//  Created by Julie Ann Sakuda on 4/27/13.
//  Copyright (c) 2013 TC Disrupt 2013. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <AddressBook/AddressBook.h>
#import "JPSThumbnailAnnotationView.h"
#import "JPSThumbnailAnnotation.h"

@interface ListingsViewController : UIViewController<MKMapViewDelegate, UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDataSource, CLLocationManagerDelegate>

@end
