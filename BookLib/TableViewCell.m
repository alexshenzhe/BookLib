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

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 创建collection
        self.collectionViewController = [[BooksCollectionViewController alloc] init];
        self.collectionViewController.collectionView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [self.contentView addSubview:self.collectionViewController.collectionView];
        NSLog(@"2.%@", self.collectionViewController);
        
        NSLog(@"2.collectionView=%@", self.collectionViewController.collectionView);
        
    }
    return self;
}

@end
