//
//  OpacityViewController.m
//  Draw
//
//  Created by Cameron Nursall on 2015-02-20.
//  Copyright (c) 2015 polat. All rights reserved.
//

#import "OpacityViewController.h"

@interface OpacityViewController (){
    UISlider *opslider;
    float currentvalue;
}
@end

@implementation OpacityViewController

-(void)setCurrentvalue:(float)value{
    currentvalue = value;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    opslider = (UISlider*)[self.view viewWithTag:1];
    opslider.value = currentvalue;
    [opslider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)valueChanged:(UISlider*)sender {
    currentvalue = sender.value;
    [self.delegate updateOpacity:sender.value];
}

@end
