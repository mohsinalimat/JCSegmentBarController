//
//  JCSegmentBar.h
//  JCSegmentBarController
//
//  Created by 李京城 on 15/5/20.
//  Copyright (c) 2015年 李京城. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JCSegmentBar;
@class JCSegmentBarItem;
typedef void (^JCSegmentBarItemSeletedBlock)(JCSegmentBarItem *item);

@class JCSegmentBarController;
@interface JCSegmentBar : UICollectionView

@property(nonatomic, retain) UIColor *tintColor;
@property(nonatomic, retain) UIColor *barTintColor;
@property(nonatomic, retain) UIColor *selectedTintColor;

//@property(nonatomic, getter = isTranslucent) BOOL translucent;

- (void)didSeletedSegmentBarItem:(JCSegmentBarItemSeletedBlock)seletedBlock;

@end
