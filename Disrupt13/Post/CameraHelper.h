//
//  CameraHelper.h
//  DareShare
//
//  Created by Julie Ann Sakuda on 4/13/13.
//  Copyright (c) 2013 Undefeated Games, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface CameraHelper : NSObject

+ (int) numberOfCameras;
+ (AVCaptureDevice *) frontFacingCamera;
+ (AVCaptureDevice *) backFacingCamera;

@end
