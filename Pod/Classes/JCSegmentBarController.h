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

@property (nonatomic, assign) CGFloat itemWidth;
@property(nonatomic, copy) NSArray *viewControllers;

@property(nonatomic, strong, readonly) JCSegmentBar *segmentBar;

@property(nonatomic, assign) NSUInteger selectedIndex;
@property(nonatomic, weak) JCSegmentBarItem *selectedItem;
@property(nonatomic, weak) UIViewController *selectedViewController;

@property(nonatomic, weak) id<JCSegmentBarControllerDelegate> delegate;

- (instancetype)initWithViewControllers:(NSArray *)viewControllers;

//- (void)scrollToViewWithIndex:(NSInteger)index animated:(BOOL)animated;

//- (void)setItems:(NSArray *)items animated:(BOOL)animated;

@end

@interface UIViewController (JCSegmentBarControllerItem)

@property(nonatomic, strong, readonly) JCSegmentBarItem *segmentBarItem; // Automatically created lazily with the view controller's title if it's not set explicitly.

@property(nonatomic, strong, readonly) JCSegmentBarController *segmentBarController; // If the view controller has a tab bar controller as its ancestor, return it. Returns nil otherwise.

@end
