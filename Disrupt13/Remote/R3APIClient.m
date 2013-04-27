#import "R3APIClient.h"

static NSString * const kAPIBaseURLString = @"http://localhost:3000/";

@implementation R3APIClient

+ (R3APIClient *)sharedClient {
  static R3APIClient *_sharedClient = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    _sharedClient = [[R3APIClient alloc] initWithBaseURL:[NSURL URLWithString:kAPIBaseURLString]];
    [R3APIClient loadCookies];
  });
  return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
  self = [super initWithBaseURL:url];
  if (self) {
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
    [self setDefaultHeader:@"Accept" value:@"application/json"];
  }
  return self;
}

+ (void)saveCookies{
  NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject: [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setObject: cookiesData forKey: @"sessionCookies"];
  [defaults synchronize];
}

+ (void)loadCookies{
  NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey: @"sessionCookies"]];
  NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
  for (NSHTTPCookie *cookie in cookies){
    [cookieStorage setCookie: cookie];
  }
}


//UIImage *resizedImage = [_capturedImage imageByScalingAndCroppingForSize:CGSizeMake(320,320)];
//NSData *imageData = UIImageJPEGRepresentation(resizedImage, 0.5);
//
//NSDictionary *parameters = @{ @"post[likes]" : @0,
//                              @"post[dislikes]" : @0,
//                              @"post[dare_id]" : [_selectedDare objectForKey:@"id"] };
//
//NSMutableURLRequest *request = [apiClient multipartFormRequestWithMethod:@"POST" path:@"/posts" parameters:parameters constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
//  [formData appendPartWithFileData:imageData name:@"post[photo]" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
//}];
//
//AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//[operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
//  NSLog(@"%@", [NSString stringWithFormat:@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite]);
//}];
//[apiClient enqueueHTTPRequestOperation:operation];


@end
