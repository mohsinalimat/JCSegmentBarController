//
//  JCSegmentBarController.h
//  JCSegmentBarController
//
//  Created by 李京城 on 15/5/20.
//  Copyright (c) 2015年 李京城. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCSegmentBar.h"
#import "JCSegmentBarItem.h"

@class JCSegmentBarController;
@protocol JCSegmentBarControllerDelegate<NSObject>
@optional
- (void)segmentBarController:(JCSegmentBarController *)segmentBarController didSelectItem:(JCSegmentBarItem *)item;
@end

@interface JCSegmentBarController : UIViewController


//@property(nonatomic,copy) NSArray *viewControllers;
//@property(nonatomic,assign) UIViewController *selectedViewController;
//@property(nonatomic) NSUInteger selectedIndex;



@property(nonatomic, copy) NSArray *items;

@property(nonatomic, readonly) JCSegmentBar *segmentBar;

@property(nonatomic, weak) JCSegmentBarItem *selectedItem;

- (void)setItems:(NSArray *)items animated:(BOOL)animated;

@property(nonatomic, assign) id<JCSegmentBarControllerDelegate> delegate;

@end
//@interface UIViewController (UITabBarControllerItem)
//
//@property(nonatomic,retain) UITabBarItem *tabBarItem; // Automatically created lazily with the view controller's title if it's not set explicitly.
//
//@property(nonatomic,readonly,retain) UITabBarController *tabBarController; // If the view controller has a tab bar controller as its ancestor, return it. Returns nil otherwise.
//
//@end
