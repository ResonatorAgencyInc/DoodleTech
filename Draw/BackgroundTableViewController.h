//
//  BackgroundTableViewController.h
//  Draw
//
//  Created by Cameron Nursall on 2015-02-19.
//  Copyright (c) 2015 polat. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BackgroundTableViewController;

@protocol BackgroundTableViewControllerDelegate <NSObject>

- (void) changeBackground:(NSString*)img;

@end

@interface BackgroundTableViewController : UITableViewController

@property (nonatomic, weak) id<BackgroundTableViewControllerDelegate> delegate;

@end
