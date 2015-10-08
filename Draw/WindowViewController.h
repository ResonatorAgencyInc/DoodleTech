//
//  WindowViewController.h
//  Draw
//
//  Created by Cameron Nursall on 2015-02-19.
//  Copyright (c) 2015 polat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuadDrawView.h"
#import <QuartzCore/QuartzCore.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ShareViewController.h"
#import "BackgroundTableViewController.h"
#import "SizeViewController.h"
#import "TestColorViewController.h"

#define BUTTON_OPACITY 0.35

@interface WindowViewController : UIViewController

- (void) changeBackground:(NSString*)img;
- (void) updateBrushSize:(float)sz;
- (void) changeTag:(uint)tag;
- (void) changedColour:(UIColor*)colour changedOpacity:(float)opacity changedGradient:(float)gradient;

@end

