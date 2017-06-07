//
//  TableViewCell.h
//  BookLib
//
//  Created by 沈喆 on 17/4/17.
//  Copyright © 2017年 沈喆. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BooksCollectionViewController;
@interface TableViewCell : UITableViewCell

@property (nonatomic, strong) BooksCollectionViewController *collectionViewController;

/**
  初始化tableViewCell
 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier collectionViewController:(BooksCollectionViewController *)collectionViewController;

/**
  传递分组信息
 */
- (void)setTableViewSection:(NSInteger)section;

@end
