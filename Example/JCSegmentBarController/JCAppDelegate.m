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
    UIViewController *vc4 = [[UIViewController alloc] init];
    vc4.title = @"礼品";
    vc4.view.backgroundColor = [UIColor lightGrayColor];
    JCViewController *vc5 = [storyboard instantiateViewControllerWithIdentifier:@"JCViewController"];
    vc5.title = @"首饰";
    JCViewController *vc6 = [storyboard instantiateViewControllerWithIdentifier:@"JCViewController"];
    vc6.title = @"食品";
    JCViewController *vc7 = [storyboard instantiateViewControllerWithIdentifier:@"JCViewController"];
    vc7.title = @"烟酒";
    JCViewController *vc8 = [storyboard instantiateViewControllerWithIdentifier:@"JCViewController"];
    vc8.title = @"电器";
    
    JCSegmentBarController *segmentBarController = [[JCSegmentBarController alloc] initWithViewControllers:@[vc1, vc2, vc3, vc4, vc5, vc6, vc7, vc8]];
    segmentBarController.title = @"JCSegmentBarController";
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:segmentBarController];
//    nav.navigationBar.barTintColor = [UIColor lightGrayColor];
    
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[nav];
    self.window.rootViewController = tabBarController;
    
    return YES;
}

@end
