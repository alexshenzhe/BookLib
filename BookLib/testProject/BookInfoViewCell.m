//
//  BookInfoViewCell.m
//  testProject
//
//  Created by 沈喆 on 17/4/10.
//  Copyright © 2017年 沈喆. All rights reserved.
//

#import "BookInfoViewCell.h"

@interface BookInfoViewCell ()
@end

@implementation BookInfoViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubview];
    }
    return self;
}

- (void)initSubview {
    _bookImageView = [[UIImageView alloc] init];
    
    _bookImageView.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:_bookImageView];
    
    _bookNameLabel = [[UILabel alloc] init];
    
    [self.contentView addSubview:_bookNameLabel];
}


/**
 设置子控件frame
 */
- (void)layoutSubviews {
    float imageX = 0;
    float imageY = 0;
    float imageW = self.bounds.size.width;
    float imageH = self.bounds.size.height - 20;
    _bookImageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
    
    float labelX = imageX;
    float labelY = imageH;
    float labelW = imageW;
    float labelH = 20;
    _bookNameLabel.frame = CGRectMake(labelX, labelY, labelW, labelH);
    _bookNameLabel.backgroundColor = [UIColor cyanColor];
}

@end
