//
//  TableViewCell.m
//  BookLib
//
//  Created by 沈喆 on 17/4/17.
//  Copyright © 2017年 沈喆. All rights reserved.
//

#import "TableViewCell.h"
#import "BooksCollectionViewController.h"

@interface TableViewCell ()

@end

@implementation TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

/**
 * 初始化
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier collectionViewController:(BooksCollectionViewController *)collectionViewController {
    self.collectionViewController = collectionViewController;
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 添加collectionView
        [self.contentView addSubview:self.collectionViewController.collectionView];
    }
    return self;
}

/**
 * 设置子控件frame
 */
- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionViewController.collectionView.frame = self.contentView.frame;
}

/**
 * 传递分组信息
 */
- (void)setTableViewSection:(NSInteger)section {
    self.collectionViewController.tableViewCellSection = section;
}

@end
