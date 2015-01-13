//
//  SVScratchImageView.m
//  ScratchView
//
//  Created by sirko on 10/01/2015.
//  Copyright (c) 2015 sirko. All rights reserved.
//

#import "SVScratchImageView.h"
#import "SVTail.h"

static NSInteger SVDefaultPenRadius = 15;

@interface SVScratchImageView ()

@property (assign, nonatomic) CGFloat filledTilesCounter;
@property (assign, nonatomic) NSInteger tilesX;
@property (assign, nonatomic) NSInteger tilesY;

@property (strong, nonatomic) SVTail *maskedMatrix;

@property (assign, nonatomic) CGColorSpaceRef colorSpace;
@property (assign, nonatomic) CGContextRef imageContext;

@end

@implementation SVScratchImageView

#pragma mark - Initialize

- (void)initialize
{
  self.userInteractionEnabled = YES;
  self.filledTilesCounter = 0;
 
  if (!self.image) {
    self.tilesX = 0;
    self.tilesY = 0;
    
    self.maskedMatrix = nil;
    
    if (self.colorSpace) {
      CGColorSpaceRelease(self.colorSpace);
    }
    if (self.imageContext) {
      CGContextRelease(self.imageContext);
    }
    
  }else {
    CGSize size = CGSizeMake(self.image.size.width * self.image.scale, self.image.size.height * self.image.scale);
    
    if (!self.colorSpace) {
      self.colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    if (self.imageContext) {
      CGContextRelease(self.imageContext);
    }
    
    self.imageContext = CGBitmapContextCreate(0, size.width, size.height, 8, size.width * 4, self.colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(self.imageContext, CGRectMake(0.f, 0.f, size.width, size.height), self.image.CGImage);
    CGContextSetBlendMode(self.imageContext, kCGBlendModeClear);
    
    self.tilesX = size.width/(2 * SVDefaultPenRadius);
    self.tilesY = size.height/(2 * SVDefaultPenRadius);
    
    self.maskedMatrix = [[SVTail alloc] initWithMaxSize:CGSizeMake(self.tilesX, self.tilesY)];
  }
  
}

#pragma mark - Touch Event

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  [super setImage:[self getImageWithTouches:touches]];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
  [super setImage:[self getImageWithTouches:touches]];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  [super setImage:[self getImageWithTouches:touches]];
}

#pragma mark - Private Methods

- (void)setImage:(UIImage *)image {
  if (image != self.image) {
    [super setImage:image];
    [self initialize];
  }
}

- (CGFloat)getProgress
{
  return (self.filledTilesCounter/(self.maskedMatrix.maxSize.width * self.maskedMatrix.maxSize.height));
}

- (UIImage*)getImageWithTouches:(NSSet*)touches
{
  CGSize size = CGSizeMake(self.image.size.width * self.image.scale, self.image.size.height * self.image.scale);
  CGContextRef context = self.imageContext;
  CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
  CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.f].CGColor);
  
  int temporaryTileCounter = self.filledTilesCounter;
  for (UITouch *touch in touches) {
    CGContextBeginPath(context);
    CGPoint point = [touch locationInView:self];
    CGRect rectangle = CGRectMake(point.x, point.y, 2 * SVDefaultPenRadius, 2 * SVDefaultPenRadius);
    rectangle.origin = [self convertUIPoint:rectangle.origin toQuartzOriginWithSize:self.bounds.size];
    if (UITouchPhaseBegan == touch.phase) {
      rectangle.origin = [self scalePoint:rectangle.origin withSize:self.bounds.size toSize:size];
      rectangle.origin.x -= SVDefaultPenRadius;
      rectangle.origin.y -= SVDefaultPenRadius;
      CGContextAddEllipseInRect(context, rectangle);
      
      /*UIImage *image = [UIImage imageNamed:@"Retro_Sweeney_Blob.png"];
      [image drawInRect:rectangle blendMode:kCGBlendModeOverlay alpha:0.5f];
      context = UIGraphicsGetCurrentContext();
      
      UIGraphicsBeginImageContextWithOptions(self.image.size, YES, 0.f);
      CGContextRef temporaryContext = UIGraphicsGetCurrentContext();
      UIImage *image = [UIImage imageNamed:@"Retro_Sweeney_Blob.png"];
      [image drawInRect:(CGRect){CGPointMake(40.f, 40.f), self.image.size} blendMode:kCGBlendModeOverlay alpha:0.5f];
      CGContextDrawImage(temporaryContext, (CGRect){ [self convertUIPoint:rectangle.origin toQuartzOriginWithSize:self.image.size], image.size}, image.CGImage);
      
      context = CGContextGet;*/
      
      /*UIGraphicsBeginImageContext(self.image.size);
      CGContextRef temp = UIGraphicsGetCurrentContext();
      CGContextDrawImage(temp, (CGRect){[self convertUIPoint:CGPointMake(rectangle.origin.x + SVDefaultPenRadius, rectangle.origin.y + SVDefaultPenRadius) toQuartzOriginWithSize:self.image.size], CGSizeMake(20.f, 20.f)}, [UIImage imageNamed:@"Retro_Sweeney_Blob.png"].CGImage);
      
      context = temp;
      self.imageContext = context;*/
      
      CGContextFillPath(context);
      [self fillTileWithPoint:rectangle.origin];
    } else if (UITouchPhaseMoved == touch.phase) {
      rectangle.origin = [self scalePoint:rectangle.origin withSize:self.bounds.size toSize:size];
      
      CGPoint previousPoint = [touch previousLocationInView:self];
      previousPoint = [self convertUIPoint:previousPoint toQuartzOriginWithSize:self.bounds.size];
      previousPoint = [self scalePoint:previousPoint withSize:self.bounds.size toSize:size];
      
      CGContextSetStrokeColor(context, CGColorGetComponents([UIColor clearColor].CGColor));
      CGContextSetLineCap(context, kCGLineCapRound);
      CGContextSetLineWidth(context, 2 * SVDefaultPenRadius);
      CGContextMoveToPoint(context, previousPoint.x, previousPoint.y);
      CGContextAddLineToPoint(context, rectangle.origin.x, rectangle.origin.y);
      CGContextStrokePath(context);
      
      /*UIGraphicsBeginImageContext(self.image.size);
      CGContextRef temp = UIGraphicsGetCurrentContext();
      CGContextDrawImage(temp, (CGRect){[self convertUIPoint:CGPointMake(rectangle.origin.x + SVDefaultPenRadius, rectangle.origin.y + SVDefaultPenRadius) toQuartzOriginWithSize:self.image.size], CGSizeMake(20.f, 20.f)}, [UIImage imageNamed:@"Retro_Sweeney_Blob.png"].CGImage);
      
      context = temp;
      self.imageContext = context;*/
      
      [self fillTileWithTwoPoints:rectangle.origin end:previousPoint];
    }
  }
  
  if(temporaryTileCounter != self.filledTilesCounter) {
    [self.delegate scratchImageView:(UIImageView*)self changeMaskingProgress:[self getProgress]];
  }
  
  CGImageRef cgImage = CGBitmapContextCreateImage(context);
  UIImage *image = [UIImage imageWithCGImage:cgImage];
  CGImageRelease(cgImage);
  return image;
}

void drawPattern(void *inf, CGContextRef context)
{
  UIImage *image = [UIImage imageNamed:@"Retro_Sweeney_Blob.png"];
  CGContextDrawImage(context, (CGRect){CGPointZero, image.size}, image.CGImage);
}

- (CGPoint)convertUIPoint:(CGPoint)point toQuartzOriginWithSize:(CGSize)frameSize
{
  point.y = frameSize.height - point.y;
  return point;
}

- (CGPoint)scalePoint:(CGPoint)point withSize:(CGSize)previousSize toSize:(CGSize)currentSize
{
  return CGPointMake(currentSize.width * point.x/previousSize.width, currentSize.height * point.y/previousSize.height);
}

- (void)fillTileWithPoint:(CGPoint) point
{
  CGFloat x,y;
  char value;
  
  point.x = MAX(MIN(point.x, self.image.size.width - 1), 0);
  point.y = MAX(MIN(point.y, self.image.size.height - 1), 0);
  
  x = point.x * self.maskedMatrix.maxSize.width/self.image.size.width;
  y = point.y * self.maskedMatrix.maxSize.height/self.image.size.height;
  
  value = [self.maskedMatrix getValueForPoint:CGPointMake(roundf(x), roundf(y))];
  
  if (!value){
    [self.maskedMatrix setValue:1 forPoint:CGPointMake(roundf(x), roundf(y))];
    self.filledTilesCounter++;
  }
}

- (void)fillTileWithTwoPoints:(CGPoint)begin end:(CGPoint)end
{
  CGFloat incX,incY;
  CGPoint i;
  
  incX = (begin.x < end.x ? 1 : -1) * self.image.size.width/self.tilesX;
  incY = (begin.y < end.y ? 1 : -1) * self.image.size.height/self.tilesY;
  
  i = begin;
  while(i.x <= end.x && i.y <= end.y){
    [self fillTileWithPoint:i];
    i.x += incX;
    i.y += incY;
  }
  
  [self fillTileWithPoint:end];
}

@end
