//
//  SizeViewController.m
//  Draw
//
//  Created by Cameron Nursall on 2015-02-20.
//  Copyright (c) 2015 polat. All rights reserved.
//

#import "SizeViewController.h"

@interface SizeViewController () {
    UISlider *szslider;
}
@end

@implementation SizeViewController

- (void)viewDidLoad {
    [self setCurrent_size:_current_size];
    [self setFrench:_french];
    [super viewDidLoad];
    UILabel * lbl = (UILabel *)[[self view] viewWithTag:2];
    if ([self french]){
        [lbl setText:@"EPAISSEUR"];
    }
    szslider = (UISlider*)[[self view] viewWithTag:1];
    [szslider setValue:[self current_size]];
    [szslider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
}


-(IBAction)valueChanged:(UISlider*)sender {
    [self setCurrent_size:[sender value]];
    [[self delegate] updateBrushSize:[sender value]];
}

@end
