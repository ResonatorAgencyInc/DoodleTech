//
//  TweetViewController.h
//  Draw
//
//  Created by Cameron Nursall on 2015-03-08.
//  Copyright (c) 2015 polat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TwitterKit/TwitterKit.h>

#define ALERT_DELAY 4.0

@class TweetViewController;

@protocol TweetViewControllerDelegate <NSObject>
@end

@interface TweetViewController : UIViewController {
    UIActivityIndicatorView *indicator;
    UIView *overlay;
    UIButton *cancel;
    UIButton *postit;
    UIAlertController *alert;
}

@property UIImage *img;
@property NSString *text;
@property BOOL french;
@property (nonatomic, weak) id<TweetViewControllerDelegate> delegate;

@end
