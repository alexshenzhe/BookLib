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

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier collectionViewController:(BooksCollectionViewController *)collectionViewController;

@end
