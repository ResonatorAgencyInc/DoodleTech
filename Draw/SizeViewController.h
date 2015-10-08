//
//  SizeViewController.h
//  Draw
//
//  Created by Cameron Nursall on 2015-02-20.
//  Copyright (c) 2015 polat. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SizeViewController;

@protocol SizeViewControllerDelegate <NSObject>

- (void) updateBrushSize:(float)sz;

@end

@interface SizeViewController : UIViewController

@property float current_size;
@property BOOL french;
@property (nonatomic, weak) id<SizeViewControllerDelegate> delegate;

@end

