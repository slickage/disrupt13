#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <AddressBook/AddressBook.h>
#import "JPSThumbnailAnnotationView.h"
#import "JPSThumbnailAnnotation.h"
#import "CameraViewController.h"
#import "R3APIClient.h"

@interface ListingsViewController : UIViewController<MKMapViewDelegate, UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDataSource, CLLocationManagerDelegate>

@property (strong, nonatomic) NSArray *items;
@property (weak, nonatomic) IBOutlet UITableView *listingsTableView;

@end
