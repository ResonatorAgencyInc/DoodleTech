//
//  Eraser.m
//  Draw
//
//  Created by Cameron Nursall on 2015-02-22.
//  Copyright (c) 2015 polat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Eraser.h"

@interface Eraser() {
    CGPoint previousPoint1;
    CGPoint previousPoint2;
    CGMutablePathRef path;
    CGPoint lastPoint;
    UIImage *drawingSnapshot;
    UIImageView *drawingImageView;
    //SDToolSettings *settings;
    CGPoint firstPoint;
    UIImageView *targetImageView;
    dispatch_block_t completion;
    float pathDistance;
}

@end

@implementation Eraser

/*

- (void)touchBegan:(UITouch *)touch inImageView:(UIImageView *)imageView withSettings:(SDToolSettings *)settings {
    
    targetImageView = imageView;
    settings = settings;
    firstPoint = [touch locationInView:imageView];
    
    
    drawingSnapshot = imageView.image;
    drawingImageView = targetImageView;
    
    if (path != nil) {
        CGPathRelease(path);
        path = nil;
    }
    
    //analyzer will report this leaks - this is released in the above method
    path = CGPathCreateMutable();
    pathDistance = 0.0;
    
    previousPoint1 = [touch previousLocationInView:drawingImageView];
    previousPoint2 = [touch previousLocationInView:drawingImageView];
    
    [self touchMoved:touch];
    
}

static const CGFloat kPointMinDistance = 5;
static const CGFloat kPointMinDistanceSquared = kPointMinDistance * kPointMinDistance;

- (void)touchMoved:(UITouch *)touch {
    
    CGPoint currentPoint = [touch locationInView:drawingImageView];
    
    // check if the point is farther than min dist from previous 
    CGFloat dx = currentPoint.x - lastPoint.x;
    CGFloat dy = currentPoint.y - lastPoint.y;
    
    if (dx * dx + dy * dy < kPointMinDistanceSquared) {
        return;
    }
    
    //call touch moved after the above check - image will be restored
    drawingImageView.image = drawingSnapshot;
    
    previousPoint2 = previousPoint1;
    previousPoint1 = [touch previousLocationInView:drawingImageView];
    currentPoint = [touch locationInView:drawingImageView];
    
    
    CGPoint mid1 = CGPointMake((previousPoint1.x + previousPoint2.x) * 0.5, (previousPoint1.y + previousPoint2.y) * 0.5);
    CGPoint mid2 = CGPointMake((currentPoint.x + previousPoint1.x) * 0.5, (currentPoint.y + previousPoint1.y) * 0.5);
    CGMutablePathRef subpath = CGPathCreateMutable();
    CGPathMoveToPoint(subpath, NULL, mid1.x, mid1.y);
    CGPathAddQuadCurveToPoint(subpath, NULL, previousPoint1.x, previousPoint1.y, mid2.x, mid2.y);
    
    CGPathAddPath(path, NULL, subpath);
    
    dx = currentPoint.x - lastPoint.x;
    dy = currentPoint.y - lastPoint.y;
    float lastDistance = sqrt(dx * dx + dy * dy);
    pathDistance += lastDistance;
    
    CGPathRelease(subpath);
    
    UIGraphicsBeginImageContextWithOptions(drawingImageView.frame.size, NO, 0.0);
    [drawingImageView.image drawInRect:drawingImageView.bounds];
    
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), settings.lineWidth);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeNormal);
    
    CGFloat red, green, blue, alpha;
    [settings.primaryColor getRed:&red green:&green blue:&blue alpha:&alpha];
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, alpha);
    
    [settings.secondaryColor getRed:&red green:&green blue:&blue alpha:&alpha];
    CGContextSetRGBFillColor(UIGraphicsGetCurrentContext(), red, green, blue, alpha);
    
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddPath(context, path);
    CGContextStrokePath(context);
    drawingImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (pathDistance > 100) {
        //commit changes and recreate path, faster
        drawingSnapshot = drawingImageView.image;
        if (path != nil) {
            CGPathRelease(path);
            path = nil;
        }
        pathDistance = 0.0;
        
        //analyzer will report this leaks - this is released in the above method
        path = CGPathCreateMutable();
        pathDistance = 0.0;
    }
    
    lastPoint = currentPoint;
    
}

- (void)touchEnded:(UITouch *)touch {
    
    //first reset the image, we're still adjusting/drawing the curve
    drawingImageView.image = drawingSnapshot;
    
    //finish the curve along to the final touch
    previousPoint2 = previousPoint1;
    previousPoint1 = [touch previousLocationInView:drawingImageView];
    CGPoint currentPoint = [touch locationInView:drawingImageView];
    
    CGPoint mid1 = CGPointMake((previousPoint1.x + previousPoint2.x) * 0.5, (previousPoint1.y + previousPoint2.y) * 0.5);
    CGPoint mid2 = CGPointMake((currentPoint.x + previousPoint1.x) * 0.5, (currentPoint.y + previousPoint1.y) * 0.5);
    CGMutablePathRef subpath = CGPathCreateMutable();
    CGPathMoveToPoint(subpath, NULL, mid1.x, mid1.y);
    CGPathAddQuadCurveToPoint(subpath, NULL, previousPoint1.x, previousPoint1.y, mid2.x, mid2.y);
    
    CGPathAddPath(path, NULL, subpath);
    
    CGFloat dx = currentPoint.x - lastPoint.x;
    CGFloat dy = currentPoint.y - lastPoint.y;
    float lastDistance = sqrt(dx * dx + dy * dy);
    pathDistance += lastDistance;
    
    CGPathRelease(subpath);
    
    UIGraphicsBeginImageContextWithOptions(drawingImageView.frame.size, NO, 0.0);
    [drawingImageView.image drawInRect:drawingImageView.bounds];
    
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), settings.lineWidth);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeNormal);
    
    CGFloat red, green, blue, alpha;
    [settings.primaryColor getRed:&red green:&green blue:&blue alpha:&alpha];
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, alpha);
    
    [settings.secondaryColor getRed:&red green:&green blue:&blue alpha:&alpha];
    CGContextSetRGBFillColor(UIGraphicsGetCurrentContext(), red, green, blue, alpha);
    
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddPath(context, path);
    CGContextStrokePath(context);
    drawingImageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    if (path != nil) {
        CGPathRelease(path);
        path = nil;
    }
    pathDistance = 0.0;
    drawingSnapshot = nil;
    if (completion) {
        completion();
    }
    
}*/
@end
