//
//  QuadDrawView.h
//  Free Hand Drawing
//
//  Created by polat on 03/08/14.
//  Copyright (c) 2014 polat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuadDrawView : UIView{
    
    NSMutableArray *pathArray;
    NSMutableArray *bufferArray;
    UIBezierPath *path;
    UIImage *incrementalImage;
    CGPoint pts[4];
    uint ctr;
    float opacity;
    float tool_size;
    UIColor *paint;
    BOOL isEraserActive;
}

-(void)setOpacity:(float)op;
-(void)setToolSize:(float)sz;
-(void)setColour:(UIColor*)colour;
-(void)clearCanvas;
-(void)undo;
-(void)redo;
-(void)updateBackground:(NSString *)imgname;
-(NSMutableArray*)getPathArray;
-(NSMutableArray*)getBufferArray;
-(UIImage*)getIncremental;
-(BOOL)getEraserAct;
-(void)setPathArray:(NSMutableArray*)path_arr;
-(void)setBufferArray:(NSMutableArray*)buf_arr;
-(void)setIncremental:(UIImage*)img;
-(void)setEraserAct:(BOOL)eraser_act;
-(void)customInit;

@end
