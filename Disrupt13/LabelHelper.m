//
//  LabelHelper.m
//  Disrupt13
//
//  Created by Julie Ann Sakuda on 4/27/13.
//  Copyright (c) 2013 TC Disrupt 2013. All rights reserved.
//

#import "LabelHelper.h"

@implementation LabelHelper

+ (UIView *)createTitleView:(NSString *)titleText {
  UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 44)];
  [titleView setBackgroundColor:[UIColor clearColor]];
  
  UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 43)];
  [titleLabel setTextAlignment:NSTextAlignmentCenter];
  titleLabel.text = [titleText uppercaseString];
  titleLabel.backgroundColor = [UIColor clearColor];
  titleLabel.textColor = [UIColor whiteColor];
  
  UIFont *font = [UIFont fontWithName:@"Cuprum-Bold" size:22.0];
  
  [titleLabel setFont:font];
  [titleView addSubview:titleLabel];
  
  return titleView;
}

@end
