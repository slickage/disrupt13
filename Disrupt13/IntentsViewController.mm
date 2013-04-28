//
//  IntentsViewController.m
//  Disrupt13
//
//  Created by James Wang on 4/28/13.
//  Copyright (c) 2013 TC Disrupt 2013. All rights reserved.
//

#import "IntentsViewController.h"

@interface IntentsViewController ()
  
@end

@implementation IntentsViewController

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
  Glympse::GString serverAddress =
  Glympse::CoreFactory::createString("sandbox.glympse.com");
  Glympse::GString apiKey =
  Glympse::CoreFactory::createString("6TB2HKaPgn4oBuG5");
  _glympse =
  Glympse::LiteFactory::createGlympse(apiKey, serverAddress);
  [GLYGlympseLite subscribe:self onPlatform:_glympse];
  _glympse->start();
	// Do any additional setup after loading the view.
  
  
  
  // Create ticket object.
  Glympse::GTicketLite ticketLite = Glympse::LiteFactory::createTicket(
                                                                       3600000, Glympse::CoreFactory::createString("Hello, world!"), NULL);
  // Add invites. You can add as many invites as you need.
  ticketLite->addInvite(Glympse::LC::INVITE_TYPE_EMAIL,
                        Glympse::CoreFactory::createString("reusetestuuid"),
                        Glympse::CoreFactory::createString("reusetestuuid@glympsegroups.com"));
  // Send the ticket.
  _glympse->sendTicket(ticketLite, Glympse::LC::SEND_WIZARD_DESTINATION_READONLY |
                       Glympse::LC::SEND_WIZARD_INVITES_READONLY |
                       Glympse::LC::SEND_WIZARD_MESSAGE_READONLY |
                       Glympse::LC::SEND_WIZARD_PROFILE_READONLY |
                       Glympse::LC::SEND_WIZARD_TIME_READONLY);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)glympseEvent:(const Glympse::GGlympseLite&)glympse
                code:(int)code
              param1:(const Glympse::GCommon&)param1
              param2:(const Glympse::GCommon&)param2
{
  // See Glympse::LC::EVENT_* for the list of all supported events.
}
- (void)subscribe
{
  [GLYGlympseLite subscribe:self onPlatform:_glympse];
}
- (void)unsubscribe
{
  [GLYGlympseLite unsubscribe:self onPlatform:_glympse];
}
@end
