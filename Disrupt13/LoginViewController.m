//
//  LoginViewController.m
//  Disrupt13
//
//  Created by Julie Ann Sakuda on 4/27/13.
//  Copyright (c) 2013 TC Disrupt 2013. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
  
  FBLoginView *loginView = [[FBLoginView alloc] init];
  // Align the button in the center horizontally
  loginView.frame = CGRectOffset(loginView.frame,
                                 (self.view.center.x - (loginView.frame.size.width / 2)),
                                 5);
  loginView.delegate = self;
  [self.view addSubview:loginView];
  [loginView sizeToFit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
  NSLog(@"HERE");
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user {
  NSLog(@"%@", [user name]);
}

- (IBAction)loginPressed:(id)sender {
//  NSArray *permissions =
////  [NSArray arrayWithObjects:@"email", @"read_friendlists", nil];
//  [NSArray arrayWithObjects:@"email", nil];  
//  if ([[FBSession activeSession] isOpen]) {
//    NSLog(@"OPEN");
//    return;
//  }
//  [FBSession openActiveSessionWithReadPermissions:permissions
//                                     allowLoginUI:YES
//                                completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
//                                  /* handle success + failure in block */
//                                  NSLog(@"%@", [error description]);
//                                  NSLog(@"%@", [[[FBSession activeSession] accessTokenData] accessToken]);
//                                }];
}

@end
