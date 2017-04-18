//
//  BooksCollectionViewCell.m
//  testProject
//
//  Created by 沈喆 on 17/4/10.
//  Copyright © 2017年 沈喆. All rights reserved.
//

#import "BooksCollectionViewCell.h"

@interface BooksCollectionViewCell ()

@property (nonatomic, strong) UIImageView *bookImageView;
@property (nonatomic, strong) UILabel *bookNameLabel;

@end

@implementation BooksCollectionViewCell

/**
 重写get方法
 */
- (UIImageView *)bookImageView {
    if (! _bookImageView) {
        float imageX = 0;
        float imageY = 0;
        float imageW = self.bounds.size.width;
        float imageH = self.bounds.size.height - 20;
        UIImageView *bookImageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, imageY, imageW, imageH)];
        _bookImageView = bookImageView;
        [self.contentView addSubview:bookImageView];
    }
    return _bookImageView;
}

- (UILabel *)bookNameLabel {
    if (! _bookNameLabel) {
        float labelX = 0;
        float labelY = self.bounds.size.height - 20;
        float labelW = self.bounds.size.width;
        float labelH = 20;
        UILabel *bookNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, labelW, labelH)];
        bookNameLabel.textAlignment = NSTextAlignmentCenter;
        bookNameLabel.font = [UIFont systemFontOfSize:13.0];
        _bookNameLabel = bookNameLabel;
        [self.contentView addSubview:bookNameLabel];
    }
    return _bookNameLabel;
}

/**
 重写set方法
 */
- (void)setBookImage:(UIImage *)bookImage {
    _bookImage = bookImage;
    self.bookImageView.image = bookImage;
}

- (void)setBookName:(NSString *)bookName {
    _bookName = bookName;
    self.bookNameLabel.text = bookName;
}

@end
