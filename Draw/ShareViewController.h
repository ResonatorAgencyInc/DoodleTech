//
//  ShareViewController.h
//  Draw
//
//  Created by Cameron Nursall on 2015-02-23.
//  Copyright (c) 2015 polat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TwitterKit/TwitterKit.h>
#import "TweetViewController.h"

#define MOVE_OFFSET 172
#define MOVE_TIME 0.24
#define DEFAULT_LIMIT 107
#define BUTTON_OPACITY 0.35


@interface ShareViewController : UIViewController {
    BOOL keyboard_up;
}

@property UIImage *img;
@property (strong, nonatomic) NSString *person;
@property (strong, nonatomic) NSString *invention;
@property BOOL french;

@property (weak, nonatomic) IBOutlet UITextField *text_field_person;
@property (weak, nonatomic) IBOutlet UITextField *text_field_invention;

@end

