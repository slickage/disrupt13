//
//  CameraViewController.m
//  Disrupt13
//
//  Created by Julie Ann Sakuda on 4/27/13.
//  Copyright (c) 2013 TC Disrupt 2013. All rights reserved.
//

#import "CameraViewController.h"

@interface CameraViewController () {
  __weak IBOutlet UIView *_cameraPreviewView;
  __weak IBOutlet UIButton *_takePhotoButton;
  __weak IBOutlet UIImageView *imageView;
  
  AVCaptureVideoPreviewLayer *_captureVideoPreviewLayer;
  UIImage *_capturedImage;
  AVCaptureStillImageOutput *_stillImageOutput;
  AVCaptureDeviceInput *_deviceInput;
  AVCaptureSession *_session;
}

@end

@implementation CameraViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
	// Do any additional setup after loading the view.
  AVCaptureSession *session = [[AVCaptureSession alloc] init];
  session.sessionPreset = AVCaptureSessionPresetPhoto;
	
	CALayer *viewLayer = _cameraPreviewView.layer;
	
	AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
  captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
	
	captureVideoPreviewLayer.frame = _cameraPreviewView.bounds;
	[viewLayer addSublayer:captureVideoPreviewLayer];
	
	AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
  
  if ([device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
    [device lockForConfiguration:nil];
    [device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
    [device unlockForConfiguration];
  }
	
	NSError *error = nil;
	AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
	if (!input) {
		// Handle the error appropriately.
		NSLog(@"ERROR: trying to open camera: %@", error);
	}
	[session addInput:input];
  
  _stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
  NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
  [_stillImageOutput setOutputSettings:outputSettings];
  
  [session addOutput:_stillImageOutput];
  
//  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//    [session startRunning];
//  });
  
  _deviceInput = input;
  _session = session;
  
  self.navigationItem.titleView = [LabelHelper createTitleView:@"Recycle"];
  self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ps_neutral"]];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  if (!_session.isRunning) {
    [_session startRunning];
  }
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  [_session startRunning];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)takePhotoPressed:(id)sender {
  
  AVCaptureConnection *videoConnection = nil;
	for (AVCaptureConnection *connection in _stillImageOutput.connections) {
		for (AVCaptureInputPort *port in [connection inputPorts]) {
			if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
				videoConnection = connection;
				break;
			}
		}
		if (videoConnection) { break; }
	}
	
	[_stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
    
    NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    
    _capturedImage = image;
    imageView.image = image;
    [self performSegueWithIdentifier:@"PushPostDetails" sender:self];
  }];
  
  // Flash the screen white and fade it out to give UI feedback that a still image was taken
  UIView *flashView = [[UIView alloc] initWithFrame:[_cameraPreviewView frame]];
  [flashView setBackgroundColor:[UIColor whiteColor]];
  [self.view addSubview:flashView];
  
  [UIView animateWithDuration:.4f
                   animations:^{
                     [flashView setAlpha:0.f];
                   }
                   completion:^(BOOL finished){
                     [flashView removeFromSuperview];
                   }
   ];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"PushPostDetails"]) {
    ListingDetailsViewController *dstVC = segue.destinationViewController;
    dstVC.listingImage = _capturedImage;
    dstVC.userLoc = _userLoc;
  }
}

- (IBAction)cancelPerformed:(id)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end
