//
//  QuadDrawView.m
//  Free Hand Drawing
//
//  Created by polat on 03/08/14.
//  Copyright (c) 2014 polat. All rights reserved.
//

#import "QuadDrawView.h"



@implementation QuadDrawView


-(NSMutableArray*)getPathArray {
    return pathArray;
}
-(NSMutableArray*)getBufferArray {
    return bufferArray;
}

-(UIImage*)getIncremental {
    return incrementalImage;
}

-(BOOL)getEraserAct {
    return isEraserActive;
}

-(void)setPathArray:(NSMutableArray*)path_arr {
    pathArray = path_arr;
}
-(void)setBufferArray:(NSMutableArray*)buf_arr {
    bufferArray = buf_arr;
}

-(void)setIncremental:(UIImage*)img {
    incrementalImage = img;
}

-(void)setEraserAct:(BOOL)eraser_act {
    isEraserActive = eraser_act;
}

-(void)updateBackground:(NSString *) imgname {
    UIImage *newimg = [UIImage imageNamed:imgname];
    if (newimg != NULL) {
        UIColor *backcolor = [UIColor colorWithPatternImage:newimg];
        [self setBackgroundColor:backcolor];
    }
}

-(void)setOpacity:(float)op {
    opacity = op;
}

-(void)setToolSize:(float)sz {
    tool_size = sz;
}

-(void)setColour:(UIColor*)colour {
    paint = colour;
}


-(void)customInit {
    path = [UIBezierPath bezierPath];
    isEraserActive = FALSE;
    //default values
    tool_size = 10.0;
    paint = [UIColor blackColor];
    opacity = 1.0;
    [path setLineWidth:tool_size];
    [path setLineCapStyle:kCGLineCapRound];
    
    // undo redo array
    pathArray=[[NSMutableArray alloc]init];
    bufferArray=[[NSMutableArray alloc]init];
    [self drawBitmap];
    [self setNeedsDisplay];
    [path removeAllPoints];
    ctr = 0;
}


//This is a work in progress, could not get the eraser to behave in the efficient version
//so this is a hybrid version where drawing with the pen is faster then erasing
- (void)drawRect:(CGRect)rect {
    CGSize canvas_sz =[self bounds].size;
    if ((rect.origin.x == 0) && (rect.origin.y == 0) && (rect.size.height == canvas_sz.height) && (rect.size.width == canvas_sz.width)) {
        [incrementalImage drawInRect:rect];
        [path setLineWidth:tool_size];
        [[UIColor clearColor] setStroke];
        if (isEraserActive){
            UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
            [incrementalImage drawAtPoint:rect.origin];
            [path setLineWidth:tool_size];
            [[UIColor clearColor] setStroke];
            [path strokeWithBlendMode:kCGBlendModeCopy alpha:opacity];
            incrementalImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
        else {
            [path strokeWithBlendMode:kCGBlendModeNormal alpha:opacity];

        }
    }
    else {
        if (!isEraserActive) {
            UIImage *subimage;
            CGImageRef imageRef = CGImageCreateWithImageInRect([incrementalImage CGImage], rect);
            subimage = [UIImage imageWithCGImage:imageRef];
            CGImageRelease(imageRef);
            [subimage drawAtPoint:rect.origin];
            [path setLineWidth:tool_size];
            [paint setStroke];
            [path strokeWithBlendMode:kCGBlendModeNormal alpha:opacity];
        }
    }
}




- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    ctr = 0;
    UITouch *touch = [touches anyObject];
    pts[0] = [touch locationInView:self];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    ctr++;
    pts[ctr] = p;
    if (ctr == 3)
    {
        pts[2] = CGPointMake((pts[1].x + pts[3].x)/2.0, (pts[1].y + pts[3].y)/2.0);
        [path    moveToPoint:pts[0]];
        [path addQuadCurveToPoint:pts[2] controlPoint:pts[1]];
        if (!isEraserActive){
            [self setNeedsDisplayInRect:[self point0:pts[0] point1:pts[1] point2:pts[2]]];
        }
        else {
            [self setNeedsDisplay];
        }
        pts[0] = pts[2];
        pts[1] = pts[3];
        ctr = 1;
        
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (ctr == 0) // only one point acquired = user tapped on the screen
    {
        [path addArcWithCenter:pts[0] radius:tool_size/2 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
        // draw "point"
    }
    else if (ctr == 1)
    {
        [path moveToPoint:pts[0]];
        [path addLineToPoint:pts[1]];
    }
    else if (ctr == 2)
    {
        [path moveToPoint:pts[0]];
        [path addQuadCurveToPoint:pts[2] controlPoint:pts[1]];
    }
    [bufferArray removeAllObjects];
    [self drawBitmap];
    [self setNeedsDisplay];
    [path removeAllPoints];
    ctr = 0;
}


- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}

- (void)drawBitmap
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    if (!incrementalImage)
    {
        UIBezierPath *rectpath = [UIBezierPath bezierPathWithRect:self.bounds];
        [[UIColor clearColor] setFill];
        [rectpath fill];
    }
    else {
        [self addToPathArray:incrementalImage];
    }
    [incrementalImage drawAtPoint:CGPointZero];
    [path setLineWidth:tool_size];
    if (isEraserActive) {
        [[UIColor clearColor] setStroke];
        [path strokeWithBlendMode:kCGBlendModeCopy alpha:opacity];
    }
    else {
        [paint setStroke];
        [path strokeWithBlendMode:kCGBlendModeNormal alpha:opacity];
    }
    
    incrementalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}


-(void)addToPathArray:(UIImage*)image{
    [pathArray addObject:image];
    if ([pathArray count] > 10) {
        [pathArray removeObjectAtIndex:0];
    }
}

-(void)addToBufferArray:(UIImage *)image{
    [bufferArray insertObject:image atIndex:0];
    if ([bufferArray count] > 10) {
        [bufferArray removeLastObject];
    }
}

-(void)undo{
    if([pathArray count] > 0){
        if (incrementalImage) {
            [self addToBufferArray:incrementalImage];
        }
        incrementalImage = [pathArray lastObject];
        [pathArray removeLastObject];
        [self setNeedsDisplay];
    }
}

-(void)redo{
    if([bufferArray count] > 0){
        if (incrementalImage) {
            [self addToPathArray:incrementalImage];
        }
        incrementalImage = [bufferArray objectAtIndex:0];
        [bufferArray removeObjectAtIndex:0];
        [self setNeedsDisplay];
    }
}


- (void) clearCanvas{
    incrementalImage = nil;
    [pathArray removeAllObjects];
    [bufferArray removeAllObjects];
    [self drawBitmap];
    [self setNeedsDisplay];
}

- (CGRect) point0:(CGPoint)p0 point1:(CGPoint)p1 point2:(CGPoint)p2 {
    CGFloat mod = tool_size * 1.1;
    CGFloat minx = MIN(MIN(p0.x, p1.x), p2.x);
    CGFloat miny = MIN(MIN(p0.y, p1.y), p2.y);
    CGFloat maxx = MAX(MAX(p0.x, p1.x), p2.x);
    CGFloat maxy = MAX(MAX(p0.y, p1.y), p2.y);
    CGRect bownds = CGRectMake(minx - mod, miny - mod, maxx - minx + mod + mod, maxy - miny + mod + mod);
    if (bownds.origin.x < 0) {
        bownds.origin.x = 0;
    }
    else if (bownds.origin.x > self.bounds.size.width) {
        bownds.origin.x = self.bounds.size.width;
        bownds.size.width = 0;
    }
    if (bownds.origin.y < 0) {
        bownds.origin.y = 0;
    }
    else if (bownds.origin.y >self.bounds.size.height) {
        bownds.origin.y = self.bounds.size.height;
    }
    if (bownds.origin.x + bownds.size.width > self.bounds.size.width) {
        bownds.size.width = self.bounds.size.width - bownds.origin.x;
    }
    if (bownds.origin.y + bownds.size.height > self.bounds.size.height) {
        bownds.size.height = self.bounds.size.height - bownds.origin.y;
    }
    return bownds;
    
}

@end




