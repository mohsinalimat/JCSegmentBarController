//
//  JCViewController.m
//  JCSegmentBarController
//
//  Created by lijingcheng on 04/23/2015.
//  Copyright (c) 2014 lijingcheng. All rights reserved.
//

#import "JCViewController.h"

@interface JCViewController ()

@end

@implementation JCViewController

static NSString * const reuseIdentifier = @"cellId";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld : %ld", (long)indexPath.section, (long)indexPath.row];
    
    return cell;
}

@end