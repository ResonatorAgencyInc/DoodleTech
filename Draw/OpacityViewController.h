//
//  OpacityViewController.h
//  Draw
//
//  Created by Cameron Nursall on 2015-02-20.
//  Copyright (c) 2015 polat. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OpacityViewController;

@protocol OpacityViewControllerDelegate <NSObject>

- (void) updateOpacity:(float)op;

@end

@interface OpacityViewController : UIViewController

@property (assign) id<OpacityViewControllerDelegate> delegate;

-(void)setCurrentvalue:(float)value;

@end

