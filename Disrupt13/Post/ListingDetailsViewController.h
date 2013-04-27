//
//  PostDetailsViewController.h
//  Disrupt13
//
//  Created by Julie Ann Sakuda on 4/27/13.
//  Copyright (c) 2013 TC Disrupt 2013. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "JPSThumbnailAnnotation.h"

@interface ListingDetailsViewController : UIViewController

@property (strong, nonatomic) UIImage *listingImage;
@property (strong, nonatomic) CLLocation *userLoc;

@end
