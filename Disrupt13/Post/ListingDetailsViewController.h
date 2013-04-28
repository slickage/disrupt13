#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "JPSThumbnailAnnotation.h"
#import "UIImageView+AFNetworking.h"
#import "UIImage+Extras.h"
#import "R3APIClient.h"

@interface ListingDetailsViewController : UIViewController

@property (strong, nonatomic) UIImage *listingImage;
@property (strong, nonatomic) CLLocation *userLoc;
@property (strong, nonatomic) NSDictionary *selectedItem;
@end
