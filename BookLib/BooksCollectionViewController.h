//
//  BooksCollectionViewController.h
//  BookLib
//
//  Created by 沈喆 on 17/4/17.
//  Copyright © 2017年 沈喆. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BooksCollectionViewController;
@protocol BooksCollectionViewControllerDelegate <NSObject>

@optional
/**
  代理方法：被点击后传递相应书本的index以及所在组，书本信息
 */
- (void)booksConllectionViewController:(BooksCollectionViewController *)booksConllectionViewController didSelectAtItemIndexPath:(NSIndexPath *)indexPath withTableViewSection:(NSInteger)section withData:(NSDictionary *)dic;

@end

@interface BooksCollectionViewController : UICollectionViewController

@property (nonatomic, strong) NSMutableArray *favoriteBookArray; // 存放喜爱的书本信息
@property (nonatomic, strong) NSMutableArray *readingBookArray; // 存放正在读的书本信息
@property (nonatomic, strong) NSMutableArray *haveReadBookArray; // 存放已读书本信息
@property (nonatomic, assign) NSInteger tableViewCellSection; // 分组信息

@property (nonatomic, weak) id <BooksCollectionViewControllerDelegate> delegate;

@end
