//
//  DetailViewController.h
//  BookLib
//
//  Created by 沈喆 on 17/4/20.
//  Copyright © 2017年 沈喆. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;
@protocol DetailViewControllerDelegate <NSObject>

@optional
- (void)DetailViewControllerDelegate:(DetailViewController *)detailViewController withIndexPath:(NSIndexPath *)indexPath andTableViewCellSection:(NSInteger)section fromBookGroup:(NSString *)bookGroupFrom toBookGroup:(NSString *)bookGroupTo;

@end

@interface DetailViewController : UIViewController

@property (nonatomic, strong) NSIndexPath *indexPath; // collectionView的indexPath
@property (nonatomic, assign) NSInteger tableViewCellSection; // 分组信息
@property (nonatomic, strong) NSDictionary *bookInfoDic; // 当前的书本信息

@property (nonatomic, weak) id <DetailViewControllerDelegate> delegate;

@end
