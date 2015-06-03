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
    vc1.title = @"fruit";
    JCViewController *vc2 = [storyboard instantiateViewControllerWithIdentifier:@"JCViewController"];
    vc2.title = @"apple";
    JCViewController *vc3 = [storyboard instantiateViewControllerWithIdentifier:@"JCViewController"];
    vc3.title = @"banana";
    JCViewController *vc4 = [storyboard instantiateViewControllerWithIdentifier:@"JCViewController"];
    vc4.title = @"pomelo";
    JCViewController *vc5 = [storyboard instantiateViewControllerWithIdentifier:@"JCViewController"];
    vc5.title = @"orange";
    JCViewController *vc6 = [storyboard instantiateViewControllerWithIdentifier:@"JCViewController"];
    vc6.title = @"cherry";
    JCViewController *vc7 = [storyboard instantiateViewControllerWithIdentifier:@"JCViewController"];
    vc7.title = @"grape";
    JCViewController *vc8 = [storyboard instantiateViewControllerWithIdentifier:@"JCViewController"];
    vc8.title = @"lemon";
    
    JCSegmentBarController *segmentBarController = [[JCSegmentBarController alloc] initWithViewControllers:@[vc1, vc2, vc3, vc4, vc5, vc6, vc7, vc8]];
    segmentBarController.title = @"JCSegmentBarController";
    segmentBarController.delegate = self;
//    segmentBarController.segmentBar.barTintColor = [UIColor yellowColor];
//    segmentBarController.segmentBar.tintColor = [UIColor blueColor];
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
    NSLog(@"%s: selectedIndex: %ld,title: %@", __func__, (long)segmentBarController.selectedIndex, item.titleLabel.text);
}

@end
