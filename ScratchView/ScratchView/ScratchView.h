//
//  ScratchView.h
//  ScratchView
//
//  Created by sirko on 12/01/2015.
//  Copyright (c) 2015 sirko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVScratchImageView.h"

IB_DESIGNABLE

@interface ScratchView : UIView <ScratchViewDelegate>

@property (strong, nonatomic) IBInspectable UIImage *scratchImage;
@property (strong, nonatomic) IBInspectable UIImage *backgroundImage;

@end
