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

@end

@implementation JCSegmentBar

static NSString * const reuseIdentifier = @"segmentBarItemId";

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor whiteColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        [self registerClass:[JCSegmentBarItem class] forCellWithReuseIdentifier:reuseIdentifier];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsZero;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.itemSize = CGSizeMake(100, 40);
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.frame = self.bounds;
    
//    [self reloadData];
}

//- (UICollectionView *)segmentBar
//{
//    if (!_segmentBar) {
//        CGRect frame = self.view.bounds;
//        frame.size.height = SEGMENT_BAR_HEIGHT;

//        UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - 1, frame.size.width, 1)];
//        [separator setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
//        [separator setBackgroundColor:UIColorFromRGB(0xdcdcdc)];
//        [_segmentBar addSubview:separator];
//    }
//    return _segmentBar;
//}

#pragma mark - UICollectionViewDelegate | UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.segmentBarController.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JCSegmentBarItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
//    UIViewController *vc = self.viewControllers[indexPath.row];
    item.titleLabel.text = @"aaa";
    item.iconImageView.image = nil;
    
    return item;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.bounds.size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    UIViewController *vc = self.viewControllers[indexPath.row];
//    if ([_delegate respondsToSelector:@selector(slideSegment:didSelectedViewController:)]) {
//        [_delegate slideSegment:collectionView didSelectedViewController:vc];
//    }
//    [self setSelectedIndex:indexPath.row];
//    [self scrollToViewWithIndex:self.selectedIndex animated:NO];
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
