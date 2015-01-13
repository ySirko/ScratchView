//
//  ScratchView.m
//  ScratchView
//
//  Created by sirko on 12/01/2015.
//  Copyright (c) 2015 sirko. All rights reserved.
//

#import "ScratchView.h"
#import "SVScratchImageView.h"

static CGFloat const DefaultWinProgress = 0.65;

@implementation ScratchView

#pragma mark - Lifecycle

- (void)awakeFromNib
{
  SVScratchImageView *scratchableImageView = [[SVScratchImageView alloc] initWithFrame:self.bounds];
  UIImageView *backgrounImageView = [[UIImageView alloc] initWithFrame:self.bounds];
  
  if (self.scratchImage) {
    scratchableImageView.image = self.scratchImage;
  }
  
  if (self.backgroundImage) {
    backgrounImageView.image = self.backgroundImage;
  }
  
  [self addSubview:scratchableImageView];
  [self addSubview:backgrounImageView];
  
  [self addConstarintsToImageView:scratchableImageView];
  [self addConstarintsToImageView:backgrounImageView];
  
  [self bringSubviewToFront:scratchableImageView];
  scratchableImageView.delegate = self;
}

#pragma mark - Private Methods

- (void)addConstarintsToImageView:(UIImageView*)imageView
{
  imageView.translatesAutoresizingMaskIntoConstraints = NO;
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(leading)-[imageView]-(trailing)-|"
                                                               options:0
                                                               metrics:@{@"leading":@0, @"trailing":@0}
                                                                 views:NSDictionaryOfVariableBindings(imageView)]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(top)-[imageView]-(bottom)-|"
                                                               options:0
                                                               metrics:@{@"top":@0, @"bottom":@0}
                                                                 views:NSDictionaryOfVariableBindings(imageView)]];
}

- (void)scratchImageView:(UIImageView *)imageView changeMaskingProgress:(CGFloat)progress
{
  if (progress > DefaultWinProgress) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"YOU LOSE!" message:@"FUCK YOU!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
  }
  NSLog(@"Line: %d %s Progress:%f", __LINE__, __PRETTY_FUNCTION__, progress);
}

@end
