//
//  JCSegmentBarController.m
//  JCSegmentBarController
//
//  Created by 李京城 on 15/5/20.
//  Copyright (c) 2015年 李京城. All rights reserved.
//

#import "JCSegmentBarController.h"
#import <KVOController/FBKVOController.h>
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
    
    [self.KVOController observe:self.collectionView keyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld action:@selector(observeCollectionViewContentOffset:)];
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

- (void)observeCollectionViewContentOffset:(NSDictionary *)change
{
//    UICollectionViewOrientationMask direction = UICollectionViewOrientationMaskNone;
//    
//    CGFloat offsetX = [change[NSKeyValueChangeNewKey] CGPointValue].x;
//    
//    JCSegmentBarItem *item = nil;
//    
//    if (offsetX > [change[NSKeyValueChangeOldKey] CGPointValue].x) {
//        direction = UICollectionViewOrientationMaskLeft;
//        NSLog(@"right");
//    }
//    else if (offsetX < [change[NSKeyValueChangeOldKey] CGPointValue].x) {
//        direction = UICollectionViewOrientationMaskRight;
//        NSLog(@"left");
//    }
//    
//    if (self.selectedIndex == 0 && direction == UICollectionViewOrientationMaskRight) {
//        NSLog(@"111111111");
//        return;
//    }
//    
//    if (self.selectedIndex == (self.viewControllers.count - 1) && direction == UICollectionViewOrientationMaskLeft) {
//        NSLog(@"222222222");
//        return;
//    }
//
//    NSLog(@"jslfjslfjsdflsdfjsdlfsjfl");
    
//    NSLog(@"1    %f,%f", [change[NSKeyValueChangeNewKey] CGPointValue].x, [change[NSKeyValueChangeOldKey] CGPointValue].x);
//    
//    
//    NSLog(@"2    %f, %f", self.collectionView.contentSize.width, self.collectionView.contentOffset.x);
//    
//    if (self.selectedIndex == 0 && self.collectionView.contentOffset.x < 0) {
//        return;
//    }
//    
//    //    if (self.selectedIndex == 0 || self.selectedIndex == (self.viewControllers.count - 1)) {
//    //        return;
//    //    }
//    
////    CGFloat offsetX = scrollView.contentOffset.x;
//    CGFloat flag = (self.segmentBar.frame.size.width - self.collectionView.contentOffset.x)/self.segmentBar.frame.size.width - self.selectedIndex;
//    
//    NSLog(@"3    %f, %f", self.collectionView.contentOffset.x, flag);
    
    
    
    //    float n=12.223;
    //    int x=(int)n;
    //    float y=n-(float)x;
    
    
    
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

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//
//}

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
