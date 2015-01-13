//
//  SVTail.h
//  ScratchView
//
//  Created by sirko on 10/01/2015.
//  Copyright (c) 2015 sirko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface SVTail : NSObject

@property (assign, nonatomic) CGSize maxSize;

- (instancetype)initWithMaxSize:(CGSize)maxSize;

- (char)getValueForPoint:(CGPoint)point;
- (void)setValue:(char)value forPoint:(CGPoint)point;

- (void)fillWithValue:(char)value;

@end
