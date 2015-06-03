//
//  JCSegmentBarController.m
//  JCSegmentBarController
//
//  Created by 李京城 on 15/5/20.
//  Copyright (c) 2015年 李京城. All rights reserved.
//

#import "JCSegmentBarController.h"
#import <objc/runtime.h>

static const void *segmentBarControllerKey;
static const void *segmentBarItemKey;

const NSInteger kDisplayCount = 5;// 1 line can display 5 JCSegmentBarItem

@interface JCSegmentBarController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, assign) UIEdgeInsets contentInset;

@end

@implementation JCSegmentBarController

static NSString * const reuseIdentifier = @"contentCellId";

- (instancetype)initWithViewControllers:(NSArray *)viewControllers
{
    if (self = [self init]) {
        self.viewControllers = viewControllers;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsZero;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.view addSubview:self.collectionView];
    
    [self.segmentBar didSeletedSegmentBarItem:^(NSInteger index) {
        [self scrollToItemAtIndex:index animated:NO];
    }];
    [self.view addSubview:self.segmentBar];
    
    self.navigationController.navigationBar.translucent = self.segmentBar.translucent;
    
    CGFloat bottom = self.tabBarController ? self.tabBarController.tabBar.frame.size.height : 0;
    self.contentInset = UIEdgeInsetsMake(self.segmentBar.frame.origin.y + self.segmentBar.frame.size.height, 0, bottom, 0);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    for (int i = 0; i < self.viewControllers.count; i++) {
        JCSegmentBarItem *item = (JCSegmentBarItem *)[self.segmentBar cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        
        objc_setAssociatedObject(self.viewControllers[i], &segmentBarItemKey, item, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(self.viewControllers[i], &segmentBarControllerKey, self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (JCSegmentBar *)segmentBar
{
    if (!_segmentBar) {
        _segmentBar = [[JCSegmentBar alloc] initWithFrame:CGRectZero];
    }
    
    return _segmentBar;
}

- (void)scrollToItemAtIndex:(NSInteger)index animated:(BOOL)animated
{
    if (index >= 0 && index < self.viewControllers.count && index != self.selectedIndex) {
        JCSegmentBarItem *item = (JCSegmentBarItem *)[self.segmentBar cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
        
        [self selected:item unSelected:self.selectedItem];
        
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:animated];
        
        [self adjustSegmentBarContentOffset:index];
        
        if ([self.delegate respondsToSelector:@selector(segmentBarController:didSelectItem:)]) {
            [self.delegate segmentBarController:self didSelectItem:item];
        }
    }
}

- (void)selected:(JCSegmentBarItem *)selectedItem unSelected:(JCSegmentBarItem *)unSelectedItem
{
    selectedItem.titleLabel.textColor = self.segmentBar.selectedTintColor;
    unSelectedItem.titleLabel.textColor = self.segmentBar.tintColor;
    
    CGFloat duration = unSelectedItem ? 0.3f : 0.0f;
    
    [UIView animateWithDuration:duration animations:^{
        selectedItem.transform = CGAffineTransformMakeScale(1.2, 1.2);
        unSelectedItem.transform = CGAffineTransformIdentity;
    }];
    
    self.selectedItem = selectedItem;
    self.selectedIndex = selectedItem.tag;
    self.selectedViewController = self.viewControllers[self.selectedIndex];
}

- (void)adjustSegmentBarContentOffset:(NSInteger)index
{
    CGFloat itemWidth = [UIScreen mainScreen].bounds.size.width/kDisplayCount;
    CGFloat offsetX = 0;
    
    if (index <= floor(kDisplayCount/2)) {
        offsetX = 0;
    }
    else if (index >= (self.viewControllers.count - ceil(kDisplayCount/2))) {
        offsetX = (self.viewControllers.count - kDisplayCount) * itemWidth;
    }
    else {
        offsetX = (index - floor(kDisplayCount/2)) * itemWidth;
    }
    
    [self.segmentBar setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.viewControllers.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return collectionView.frame.size;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    UIScrollView *scrollView = (UIScrollView *)((UIViewController *)self.viewControllers[indexPath.item]).view;
    scrollView.frame = cell.contentView.bounds;
    scrollView.contentInset = self.contentInset;
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    [cell.contentView addSubview:scrollView];
    
    return cell;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollToItemAtIndex:fabs(scrollView.contentOffset.x/scrollView.frame.size.width) animated:NO];
}

@end

#pragma mark - 

@implementation UIViewController (JCSegmentBarControllerItem)

- (JCSegmentBarController *)segmentBarController
{
    return objc_getAssociatedObject(self, &segmentBarControllerKey);
}

- (JCSegmentBarItem *)segmentBarItem
{
    return objc_getAssociatedObject(self, &segmentBarItemKey);
}

@end
