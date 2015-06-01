//
//  JCAppDelegate.m
//  JCSegmentBarController
//
//  Created by CocoaPods on 04/23/2015.
//  Copyright (c) 2014 lijingcheng. All rights reserved.
//

#import "JCAppDelegate.h"
#import "JCViewController.h"
#import "JCSegmentBarController.h"

@interface JCAppDelegate ()<JCSegmentBarControllerDelegate>

@end

@implementation JCAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    
    JCViewController *vc1 = [storyboard instantiateViewControllerWithIdentifier:@"JCViewController"];
    vc1.title = @"服装";
    JCViewController *vc2 = [storyboard instantiateViewControllerWithIdentifier:@"JCViewController"];
    vc2.title = @"钟表";
    JCViewController *vc3 = [storyboard instantiateViewControllerWithIdentifier:@"JCViewController"];
    vc3.title = @"鞋帽";
    JCViewController *vc4 = [storyboard instantiateViewControllerWithIdentifier:@"JCViewController"];
    vc4.title = @"礼品";
    JCViewController *vc5 = [storyboard instantiateViewControllerWithIdentifier:@"JCViewController"];
    vc5.title = @"首饰";
    JCViewController *vc6 = [storyboard instantiateViewControllerWithIdentifier:@"JCViewController"];
    vc6.title = @"食品";
    JCViewController *vc7 = [storyboard instantiateViewControllerWithIdentifier:@"JCViewController"];
    vc7.title = @"烟酒";
    JCViewController *vc8 = [storyboard instantiateViewControllerWithIdentifier:@"JCViewController"];
    vc8.title = @"电器";
    JCViewController *vc9 = [storyboard instantiateViewControllerWithIdentifier:@"JCViewController"];
    vc9.title = @"玩具";
    JCViewController *vc10 = [storyboard instantiateViewControllerWithIdentifier:@"JCViewController"];
    vc10.title = @"奶粉";
    
    JCSegmentBarController *segmentBarController = [[JCSegmentBarController alloc] initWithViewControllers:@[vc1, vc2, vc3, vc4, vc5, vc6, vc7, vc8, vc9, vc10]];
    segmentBarController.title = @"JCSegmentBarController";
    segmentBarController.delegate = self;
//    segmentBarController.segmentBar.barTintColor = [UIColor yellowColor];
//    segmentBarController.segmentBar.tintColor = [UIColor greenColor];
//    segmentBarController.segmentBar.selectedTintColor = [UIColor purpleColor];
//    segmentBarController.segmentBar.translucent = NO;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:segmentBarController];
    nav.navigationBar.barTintColor = [UIColor orangeColor];
    self.window.rootViewController = nav;
    
//    UITabBarController *tabBarController = [[UITabBarController alloc] init];
//    tabBarController.viewControllers = @[nav];
//    self.window.rootViewController = tabBarController;
    
    return YES;
}

- (void)segmentBarController:(JCSegmentBarController *)segmentBarController didSelectItem:(JCSegmentBarItem *)item
{
    NSLog(@"__%s__", __func__);
}

@end
