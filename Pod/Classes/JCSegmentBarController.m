//
//  JCSegmentBarController.m
//  JCSegmentBarController
//
//  Created by 李京城 on 15/5/20.
//  Copyright (c) 2015年 李京城. All rights reserved.
//

#import "JCSegmentBarController.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

const CGFloat kSegmentBarHeight = 36.0f;

@interface JCSegmentBarController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

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

- (instancetype)init
{
    if (self = [super init]) {
        self.itemWidth = kScreenWidth/5;//default 1行完整显示5个
        
        _segmentBar = [[JCSegmentBar alloc] initWithFrame:CGRectZero];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = YES;
    
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsZero;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.view addSubview:self.collectionView];
    
//NSLog(@"1___%@",NSStringFromCGSize(self.collectionView.frame.size));
//    self.collectionView.
//    self.collectionView.backgroundColor = [UIColor yellowColor];
//    self.view.backgroundColor = [UIColor clearColor];
    
    [_segmentBar didSeletedSegmentBarItem:^(JCSegmentBarItem *item) {
        self.selectedItem = item;
        self.selectedIndex = item.tag;
        self.selectedViewController = self.viewControllers[self.selectedIndex];
        
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }];
    [self.view addSubview:_segmentBar];
    
    
    
    
}
//2015-05-26 15:39:40.107 Test[4656:67822] {{0, 0}, {375, 618}}
//2015-05-26 15:39:40.108 Test[4656:67822] {64, 0, 49, 0}

- (void)viewDidLayoutSubviews
{
    NSLog(@"%@",NSStringFromCGRect(self.collectionView.frame));
    NSLog(@"%@",NSStringFromUIEdgeInsets(self.collectionView.contentInset));

    if (self.navigationController.navigationBar.translucent) {
        
        _segmentBar.alpha = 0.68;
        //        self.collectionView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        
        
//        self.segmentBar.frame = CGRectMake(0, 64, kScreenWidth, kSegmentBarHeight);
        //        self.collectionView.frame = CGRectMake(0, 64+kSegmentBarHeight, kScreenWidth, kScreenHeight-kSegmentBarHeight-44);
        
//        if (self.tabBarController) {
//            
//            //            self.collectionView.frame = CGRectMake(0, 64+kSegmentBarHeight, kScreenWidth, kScreenHeight-kSegmentBarHeight-64-49);
//            
            self.collectionView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
//
//            
            self.collectionView.contentInset = UIEdgeInsetsMake(64, 0, 49, 0);
//        }
//        else {
//            self.collectionView.frame = CGRectMake(0, 64+kSegmentBarHeight, kScreenWidth, kScreenHeight-kSegmentBarHeight-64);
//            
//            
//        }
//        
//        NSLog(@"1, %@", NSStringFromUIEdgeInsets(self.collectionView.contentInset));
        
        
        
        
        
        
//        _segmentBar.alpha = 0.68;
////        self.collectionView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
//        
//        
//        self.segmentBar.frame = CGRectMake(0, 64, kScreenWidth, kSegmentBarHeight);
////        self.collectionView.frame = CGRectMake(0, 64+kSegmentBarHeight, kScreenWidth, kScreenHeight-kSegmentBarHeight-44);
//        
//        if (self.tabBarController) {
//            
////            self.collectionView.frame = CGRectMake(0, 64+kSegmentBarHeight, kScreenWidth, kScreenHeight-kSegmentBarHeight-64-49);
//       
//            self.collectionView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
//            
//            
//            self.collectionView.contentInset = UIEdgeInsetsMake(136, 0, -149, 0);
//        }
//        else {
//            self.collectionView.frame = CGRectMake(0, 64+kSegmentBarHeight, kScreenWidth, kScreenHeight-kSegmentBarHeight-64);
//            
//            
//        }
//        
//   NSLog(@"1, %@", NSStringFromUIEdgeInsets(self.collectionView.contentInset));
//        
//        self.collectionView.contentInset = UIEdgeInsetsMake(64+kSegmentBarHeight, 0, 49, 0);
    }
    else {
        _segmentBar.alpha = 1;
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
        self.segmentBar.frame = CGRectMake(0, 0, kScreenWidth, kSegmentBarHeight);
        
        if (self.tabBarController) {
            self.collectionView.frame = CGRectMake(0, kSegmentBarHeight, kScreenWidth, kScreenHeight-kSegmentBarHeight-64-49);
        }
        else {
            self.collectionView.frame = CGRectMake(0, kSegmentBarHeight, kScreenWidth, kScreenHeight-kSegmentBarHeight-64);
            
          
        }
        
        
//        UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*) self.collectionView.collectionViewLayout;
//        layout.itemSize = self.collectionView.bounds.size;
//        
//        self.collectionView.collectionViewLayout = layout;
    }
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.viewControllers.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"___%@",NSStringFromCGSize(collectionView.frame.size));
//    return collectionView.frame.size;
    return CGSizeMake(kScreenWidth, collectionView.frame.size.height-64-49);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    UIViewController *vc = self.viewControllers[indexPath.item];
    vc.view.frame = cell.contentView.bounds;
//    NSLog(@"%@,%@",NSStringFromCGRect(collectionView.bounds), NSStringFromCGRect(cell.contentView.bounds));
    [cell.contentView addSubview:vc.view];//考虑下是这样好，还是用childViewController好
//    cell.backgroundColor = [UIColor redColor];
    return cell;
}

@end
