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

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier collectionViewController:(BooksCollectionViewController *)collectionViewController {
    self.collectionViewController = collectionViewController;
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 添加collectionView
        [self.contentView addSubview:self.collectionViewController.collectionView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionViewController.collectionView.frame = self.contentView.frame;
}

- (void)setTableViewSection:(NSInteger)section {
    self.collectionViewController.tableViewSection = section;
//    [self.collectionViewController.collectionView reloadData];
}

@end
