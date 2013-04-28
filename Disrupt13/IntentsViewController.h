#import <UIKit/UIKit.h>
#import <GlympseKitLite/GlympseLite.h>
#import "LabelHelper.h"

@interface IntentsViewController : UIViewController<GLYListenerLite> {
  Glympse::GGlympseLite _glympse;
}
- (IBAction)issueGlimpseTicket:(id)sender;

@end
