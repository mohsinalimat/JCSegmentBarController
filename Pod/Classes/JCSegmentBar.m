//
//  JCSegmentBar.m
//  JCSegmentBarController
//
//  Created by 李京城 on 15/5/20.
//  Copyright (c) 2015年 李京城. All rights reserved.
//

#import "JCSegmentBar.h"
#import "JCSegmentBarItem.h"
#import "JCSegmentBarController.h"

@interface JCSegmentBar ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, weak) JCSegmentBarController *segmentBarController;

@property (nonatomic, copy) JCSegmentBarItemSeletedBlock seletedBlock;

@end

@implementation JCSegmentBar

static NSString * const reuseIdentifier = @"segmentBarItemId";

- (id)initWithFrame:(CGRect)frame
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = UIEdgeInsetsZero;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    
    if (self = [super initWithFrame:frame collectionViewLayout:flowLayout]) {
        self.barTintColor = [UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1];
        self.tintColor = [UIColor darkGrayColor];
        self.selectedTintColor = [UIColor redColor];
        
        self.delegate = self;
        self.dataSource = self;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        [self registerClass:[JCSegmentBarItem class] forCellWithReuseIdentifier:reuseIdentifier];
    }
    
    return self;
}

- (void)didSeletedSegmentBarItem:(JCSegmentBarItemSeletedBlock)seletedBlock
{
    self.seletedBlock = seletedBlock;
}

#pragma mark - UICollectionViewDelegate | UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    self.backgroundColor = self.barTintColor;
    self.segmentBarController = (JCSegmentBarController *)[self jc_getViewController];
    
    return self.segmentBarController.viewControllers.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.segmentBarController.itemWidth, self.frame.size.height);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *vc = self.segmentBarController.viewControllers[indexPath.item];
    
    JCSegmentBarItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    item.titleLabel.text = vc.title;
    item.tag = indexPath.item;
    
    if (self.segmentBarController.selectedIndex == indexPath.item) {
        item.titleLabel.textColor = self.selectedTintColor;
        
        [UIView animateWithDuration:0.3f animations:^{
            item.transform = CGAffineTransformMakeScale(1.2, 1.2);
        }];
    }
    else {
        item.titleLabel.textColor = self.tintColor;
        
        [UIView animateWithDuration:0.3f animations:^{
            item.transform = CGAffineTransformIdentity;
        }];
    }
    
    return item;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.seletedBlock) {
        self.seletedBlock((JCSegmentBarItem *)[collectionView cellForItemAtIndexPath:indexPath]);
        
        [collectionView reloadData];
    }
}

#pragma mark - private method

- (UIViewController *)jc_getViewController
{
    UIResponder *responder = [self nextResponder];
    
    while (responder) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
        responder = [responder nextResponder];
    }
    
    return nil;
}

@end
