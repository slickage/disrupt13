#import <UIKit/UIKit.h>
#import <GlympseKitLite/GlympseLite.h>
#import "LabelHelper.h"
#import "UIImageView+AFNetworking.h"
#import "R3APIClient.h"

@interface IntentsViewController : UIViewController<GLYListenerLite> {
  Glympse::GGlympseLite _glympse;
}
- (IBAction)issueGlimpseTicket:(id)sender;

@property (strong, nonatomic) NSDictionary *itemData;


@end
