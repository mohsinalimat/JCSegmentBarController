//
//  JCSegmentBarItem.m
//  JCSegmentBarController
//
//  Created by 李京城 on 15/5/20.
//  Copyright (c) 2015年 李京城. All rights reserved.
//

#import "JCSegmentBarItem.h"

@implementation JCSegmentBarItem

- (void)awakeFromNib
{
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.contentView addSubview:self.titleLabel];
    
    self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.iconImageView];
}

- (void)layoutSubviews
{
    if(self.iconImageView.image) {
        self.iconImageView.frame = CGRectMake(5.0f, 5.0f, 20.0f, 20.0f);
        [self.titleLabel sizeToFit];
        self.titleLabel.frame = CGRectMake(25.0f, 5.0f, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
    }
    else {
        self.titleLabel.frame = self.contentView.bounds;
    }
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.titleLabel.text = @"";
    self.iconImageView.image = nil;
}

@end
