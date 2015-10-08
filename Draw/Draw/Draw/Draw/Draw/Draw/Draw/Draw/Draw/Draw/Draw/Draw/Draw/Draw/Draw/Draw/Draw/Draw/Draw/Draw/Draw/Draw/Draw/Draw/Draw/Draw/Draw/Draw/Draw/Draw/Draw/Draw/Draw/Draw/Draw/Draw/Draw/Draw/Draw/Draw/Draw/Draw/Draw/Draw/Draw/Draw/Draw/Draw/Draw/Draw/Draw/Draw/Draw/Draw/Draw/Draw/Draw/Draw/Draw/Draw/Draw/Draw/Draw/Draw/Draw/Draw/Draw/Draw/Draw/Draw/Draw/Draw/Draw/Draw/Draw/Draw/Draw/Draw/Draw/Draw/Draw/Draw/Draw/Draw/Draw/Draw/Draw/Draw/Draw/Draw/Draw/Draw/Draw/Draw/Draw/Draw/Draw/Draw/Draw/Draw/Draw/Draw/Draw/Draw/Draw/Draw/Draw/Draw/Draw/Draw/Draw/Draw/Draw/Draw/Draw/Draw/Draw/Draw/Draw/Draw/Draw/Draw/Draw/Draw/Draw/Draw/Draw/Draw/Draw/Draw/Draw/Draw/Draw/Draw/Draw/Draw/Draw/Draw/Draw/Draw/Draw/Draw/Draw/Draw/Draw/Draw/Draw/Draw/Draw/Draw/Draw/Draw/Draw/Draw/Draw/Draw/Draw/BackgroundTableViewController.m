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
}

@end

@implementation BackgroundTableViewController


- (void)viewDidLoad {
    backgrounds = @[@"plain_sunset-1568065.jpg", @"Pond_coastal_plain_Cape_Cod_Massachusetts_DP44.jpg", @"Nullarbor_Plain_Rainbow_DSC04547.jpg", @"37212899.jpg", @"2175903.jpg"];
    imgCount = [backgrounds count];
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

    UIImageView *imagev = [cell.contentView.subviews objectAtIndex:0];
    [imagev setImage: [UIImage imageNamed:[backgrounds objectAtIndex:indexPath.section]]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.currentBackground = [backgrounds objectAtIndex:indexPath.section];
    [self.delegate changeBackground:self.currentBackground];
}

@end
