#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"

@interface R3APIClient : AFHTTPClient

+ (R3APIClient *)sharedClient;
+ (void)saveCookies;
+ (void)loadCookies;

@end
