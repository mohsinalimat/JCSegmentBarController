//
//  JCSegmentBarController.m
//  JCSegmentBarController
//
//  Created by 李京城 on 15/5/20.
//  Copyright (c) 2015年 李京城. All rights reserved.
//

#import "JCSegmentBarController.h"
#import <objc/runtime.h>

const void *segmentBarControllerKey;
const void *segmentBarItemKey;
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
    
    CGFloat bottom = self.tabBarController ? self.tabBarController.tabBar.frame.size.height : 0;
    self.contentInset = UIEdgeInsetsMake(self.segmentBar.frame.origin.y + self.segmentBar.frame.size.height, 0, bottom, 0);
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
        self.selectedItem = item;
        self.selectedIndex = index;
        self.selectedViewController = self.viewControllers[self.selectedIndex];
        
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:animated];
        
        [self.segmentBar reloadData];
        
        [self changeSegmentBarContentOffset:index];
        
        if ([self.delegate respondsToSelector:@selector(segmentBarController:didSelectItem:)]) {
            [self.delegate segmentBarController:self didSelectItem:item];
        }
    }
}

- (void)changeSegmentBarContentOffset:(NSInteger)index
{
    CGFloat itemWidth = [UIScreen mainScreen].bounds.size.width/kDisplayCount;
    CGFloat offsetX = 0;
    
    if (index <= 2) {
        offsetX = 0;
    }
    else if (index >= (self.viewControllers.count - 3)) {
        offsetX = (self.viewControllers.count - kDisplayCount) * itemWidth;
    }
    else {
        offsetX = (index - kDisplayCount/2) * itemWidth;
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"%@", NSStringFromCGPoint(scrollView.contentOffset));
//    NSLog(@"%@", NSStringFromCGPoint(self.segmentBar.contentOffset));
    
//    float minX = 45.0;
//    float mid  = [UIScreen mainScreen].bounds.size.width/2 - minX;
//    float midM = [UIScreen mainScreen].bounds.size.width - minX;
//    for(UIImageView *v in subviews){
//        UIColor *c = gray;
//        if(v.frame.origin.x > minX
//           && v.frame.origin.x < mid)
//            // Left part
//            c = [self gradient:v.frame.origin.x
//                              top:minX+1
//                           bottom:mid-1];
//        else if(v.frame.origin.x > mid
//                && v.frame.origin.x < midM)
//            // Right part
//            c = [self gradient:v.frame.origin.x
//                              top:mid+1
//                           bottom:midM-1];
//        else if(v.frame.origin.x == mid)
//            c = orange;
//        v.tintColor= c;
//    }
}

- (UIColor *)gradient:(double)percent top:(double)topX bottom:(double)bottomX
{
    double t = (percent - bottomX) / (topX - bottomX);
    
    t = MAX(0.0, MIN(t, 1.0));
    
    const CGFloat *cgInit = CGColorGetComponents(self.segmentBar.tintColor.CGColor);
    const CGFloat *cgGoal = CGColorGetComponents(self.segmentBar.selectedTintColor.CGColor);
    
    double r = cgInit[0] + t * (cgGoal[0] - cgInit[0]);
    double g = cgInit[1] + t * (cgGoal[1] - cgInit[1]);
    double b = cgInit[2] + t * (cgGoal[2] - cgInit[2]);
    
    return [UIColor colorWithRed:r green:g blue:b alpha:1];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"___%s___", __func__);
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    NSLog(@"___%s___", __func__);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"___%s___", __func__);
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"___%s___", __func__);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"___%s___", __func__);
    
    [self scrollToItemAtIndex:fabs(scrollView.contentOffset.x/scrollView.frame.size.width) animated:NO];
}
//- (void)scrollToItemAtIndex:(NSInteger)index animated:(BOOL)animated
//{
//    if (index >= 0 && index < self.viewControllers.count) {
//        JCSegmentBarItem *item = (JCSegmentBarItem *)[self.segmentBar cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
//        self.selectedItem = item;
//        self.selectedIndex = index;
//        self.selectedViewController = self.viewControllers[self.selectedIndex];
//        
//        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:animated];
//        
//        [self.segmentBar reloadData];
//        
//        if ([self.delegate respondsToSelector:@selector(segmentBarController:didSelectItem:)]) {
//            [self.delegate segmentBarController:self didSelectItem:item];
//        }
//    }
//}
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
