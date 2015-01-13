//
//  SVTail.m
//  ScratchView
//
//  Created by sirko on 10/01/2015.
//  Copyright (c) 2015 sirko. All rights reserved.
//

#import "SVTail.h"

@interface SVTail ()
{
  char *data;
}

@end

@implementation SVTail

#pragma mark - Initialize

- (instancetype)initWithMaxSize:(CGSize)maxSize
{
  self = [super init];
  if (self) {
    size_t size = maxSize.width * maxSize.height;
    data = malloc(size);
    self.maxSize = maxSize;
    [self fillWithValue:0];
  }
  return self;
}

#pragma mark - Public Methods

- (void)fillWithValue:(char)value
{
  char *temporary = data;
  int size = self.maxSize.width * self.maxSize.height;
  for (int index = 0; index < size ; index++) {
    *temporary = value;
    temporary++;
  }
}

#pragma mark - Private Methods

- (long)getIndexForPoint:(CGPoint)point
{
  return point.x + self.maxSize.width * point.y;
}

#pragma mark - Custom Accessors

- (char)getValueForPoint:(CGPoint)point
{
  long index = [self getIndexForPoint:point];
  
  if (index >= self.maxSize.width * self.maxSize.height) {
    return 1;
  }
  
  return data[index];
}

- (void)setValue:(char)value forPoint:(CGPoint)point
{
  long index = [self getIndexForPoint:point];
  
  if (index < self.maxSize.width * self.maxSize.height) {
    data[index] = value;
  }
}

#pragma mark - Lifecycle

-(void)dealloc
{
  if (data) {
    free(data);
  }
}

@end
