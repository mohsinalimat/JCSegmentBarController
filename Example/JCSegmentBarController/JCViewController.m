//
//  JCViewController.m
//  JCSegmentBarController
//
//  Created by 李京城 on 15/5/22.
//  Copyright (c) 2015年 lijingcheng. All rights reserved.
//

#import "JCViewController.h"
#import "JCSegmentBarController.h"

@implementation JCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const reuseIdentifier = @"cellId";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@, %ld", self.title, (long)indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s: selectedIndex: %ld,title: %@", __func__, (long)self.segmentBarController.selectedIndex, self.segmentBarItem.titleLabel.text);
}

@end
