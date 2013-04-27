//
//  CameraHelper.m
//  DareShare
//
//  Created by Julie Ann Sakuda on 4/13/13.
//  Copyright (c) 2013 Undefeated Games, Inc. All rights reserved.
//

#import "CameraHelper.h"

@implementation CameraHelper

+ (int) numberOfCameras {
  return [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo].count;
}

// Find a camera with the specificed AVCaptureDevicePosition, returning nil if one is not found
+ (AVCaptureDevice *) cameraWithPosition:(AVCaptureDevicePosition) position
{
  NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
  for (AVCaptureDevice *device in devices) {
    if ([device position] == position) {
      return device;
    }
  }
  return nil;
}

// Find a front facing camera, returning nil if one is not found
+ (AVCaptureDevice *) frontFacingCamera {
  return [self cameraWithPosition:AVCaptureDevicePositionFront];
}

// Find a back facing camera, returning nil if one is not found
+ (AVCaptureDevice *) backFacingCamera {
  return [self cameraWithPosition:AVCaptureDevicePositionBack];
}

@end
