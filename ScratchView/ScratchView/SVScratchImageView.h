//
//  SVScratchImageView.h
//  ScratchView
//
//  Created by sirko on 10/01/2015.
//  Copyright (c) 2015 sirko. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScratchViewDelegate

- (void)scratchImageView:(UIImageView*)imageView changeMaskingProgress:(CGFloat)progress;

@end

@interface SVScratchImageView : UIImageView

@property (strong, nonatomic) id<ScratchViewDelegate> delegate;
@property (assign, nonatomic) CGFloat progress;

@end

