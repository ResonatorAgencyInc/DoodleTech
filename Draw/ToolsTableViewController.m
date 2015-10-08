//
//  ToolsTableViewController.m
//  Draw
//
//  Created by Cameron Nursall on 2015-02-20.
//  Copyright (c) 2015 polat. All rights reserved.
//

#import "ToolsTableViewController.h"

@interface ToolsTableViewController ()

@property NSArray *tooltypes;
@property NSArray *typeicons;
@property NSString *currenttool;
@property int typecount;

@end

@implementation ToolsTableViewController

//Custom Methods
- (void)initVariables {
    self.tooltypes = @[@"Pen", @"Brush", @"Line", @"Bucket", @"Eraser"];
    self.typeicons = @[@"pen-ink-mini.png", @"paint-brush-mini.png", @"ruler-triangle-mini.png", @"paint-mini.png", @"eraser-mini.png"];
    self.currenttool = [self.tooltypes objectAtIndex:0];
    self.typecount = [self.tooltypes count];
}

//Override methods
- (void)viewDidLoad {
    [self initVariables];
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
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
    return self.typecount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ToolCell" forIndexPath:indexPath];
    
    // Configure the cell...
    UIImageView *icon = (UIImageView*)[cell viewWithTag:0];
    UILabel *label = (UILabel*)[cell viewWithTag:1];
    
    [icon setImage: [UIImage imageNamed:[self.typeicons objectAtIndex:indexPath.section]]];
    [label setText: [self.tooltypes objectAtIndex:indexPath.section]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //NSString *tool = [self.tooltypes objectAtIndex:indexPath.section];
    //[self.delegate  selectTool:tool];
}


@end
