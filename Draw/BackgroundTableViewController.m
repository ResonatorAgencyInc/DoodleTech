//
//  BackgroundTableViewController.m
//  Draw
//
//  Created by Cameron Nursall on 2015-02-19.
//  Copyright (c) 2015 polat. All rights reserved.
//

#import "BackgroundTableViewController.h"

@interface BackgroundTableViewController () {
    int imgCount;
    NSArray *backgrounds;
    NSArray *small_backgrounds;
}

@end

@implementation BackgroundTableViewController


- (void)viewDidLoad {
    backgrounds = @[@"HiRes 21.jpg", @"HiRes 41.jpg", @"iStock_000009509902_Large1.jpg", @"iStock_000014427448_Large1.jpg", @"iStock_000017124788_Full1.jpg", @"iStock_000019745738_Double1.jpg", @"iStock_000027044374_Full1.jpg", @"iStock_000027128226_Double1.jpg", @"iStock_000027733133_Full1.jpg", @"iStock_000034045744_Double1.jpg", @"iStock_000034061454_Medium1.jpg", @"iStock_000040341042_Double1.jpg", @"iStock_000048547986_XXXLarge1.jpg"];
    small_backgrounds = @[@"HiRes 21-SM.jpg", @"HiRes 41-SM.jpg", @"iStock_000009509902_Large1-SM.jpg", @"iStock_000014427448_Large1-SM.jpg", @"iStock_000017124788_Full1-SM.jpg", @"iStock_000019745738_Double1-SM.jpg", @"iStock_000027044374_Full1-SM.jpg", @"iStock_000027128226_Double1-SM.jpg", @"iStock_000027733133_Full1-SM.jpg", @"iStock_000034045744_Double1-SM.jpg", @"iStock_000034061454_Medium1-SM.jpg", @"iStock_000040341042_Double1-SM.jpg", @"iStock_000048547986_XXXLarge1-SM.jpg"];
    imgCount = (int)[backgrounds count];
    [super viewDidLoad];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return imgCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImageCell" forIndexPath:indexPath];
    
    UIImageView *imagev = [[[cell contentView] subviews] objectAtIndex:0];
    [imagev setImage: [UIImage imageNamed:[small_backgrounds objectAtIndex:[indexPath section]]]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[self delegate] changeBackground:[backgrounds objectAtIndex:[indexPath section]]];
    [self dismissViewControllerAnimated:FALSE completion:nil];
}

@end
