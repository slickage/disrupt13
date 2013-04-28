#import <UIKit/UIKit.h>
#import <GlympseKitLite/GlympseLite.h>

@interface IntentsViewController : UIViewController<GLYListenerLite> {
  Glympse::GGlympseLite _glympse;
}

@end
