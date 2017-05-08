//
//  DetailViewController.m
//  BookLib
//
//  Created by 沈喆 on 17/4/20.
//  Copyright © 2017年 沈喆. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigationBarStyle];
    [self subviewsFrame];
}

/**
 设置导航栏内容
 */
- (void)setNavigationBarStyle {
    UIBarButtonItem *changeBookGroupButton = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(changeBookGroup)];
    self.navigationItem.rightBarButtonItem = changeBookGroupButton;
    
    NSString *titleString = self.bookInfoDic[@"title"];
    self.title = titleString;
}

/**
 编辑
 */
- (void)changeBookGroup {
    NSString *listOne = [NSString string];
    NSString *listTwo = [NSString string];
    NSString *bookGroupFrom = [NSString string];
    NSString *bookGroupOne = [NSString string];
    NSString *bookGroupTwo = [NSString string];
    if (self.tableViewCellSection == 0) {
        listOne = @"在读";
        listTwo = @"已读";
        bookGroupFrom = @"favoriteBook";
        bookGroupOne = @"readingBook";
        bookGroupTwo = @"haveReadBook";
    } else if (self.tableViewCellSection == 1) {
        listOne = @"待读";
        listTwo = @"已读";
        bookGroupFrom = @"readingBook";
        bookGroupOne = @"favoriteBook";
        bookGroupTwo = @"haveReadBook";
    } else if (self.tableViewCellSection == 2) {
        listOne = @"待读";
        listTwo = @"在读";
        bookGroupFrom = @"haveReadBook";
        bookGroupOne = @"favoriteBook";
        bookGroupTwo = @"readingBook";
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    // listOne
    UIAlertAction *listOneAction = [UIAlertAction actionWithTitle:listOne style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"listOne...");
        if ([self.delegate respondsToSelector:@selector(DetailViewControllerDelegate:withIndexPath:andTableViewCellSection:fromBookGroup:toBookGroup:)]) {
            [self.delegate DetailViewControllerDelegate:self withIndexPath:self.indexPath andTableViewCellSection:self.tableViewCellSection fromBookGroup:bookGroupFrom toBookGroup:bookGroupOne];
        }
    }];
    // listTwo
    UIAlertAction *listTwoAction = [UIAlertAction actionWithTitle:listTwo style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"listTwo...");
        if ([self.delegate respondsToSelector:@selector(DetailViewControllerDelegate:withIndexPath:andTableViewCellSection:fromBookGroup:toBookGroup:)]) {
            [self.delegate DetailViewControllerDelegate:self withIndexPath:self.indexPath andTableViewCellSection:self.tableViewCellSection fromBookGroup:bookGroupFrom toBookGroup:bookGroupTwo];
        }
    }];
    // 删除
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"delete...");
        if ([self.delegate respondsToSelector:@selector(DetailViewControllerDelegate:withIndexPath:andTableViewCellSection:fromBookGroup:toBookGroup:)]) {
            [self.delegate DetailViewControllerDelegate:self withIndexPath:self.indexPath andTableViewCellSection:self.tableViewCellSection fromBookGroup:bookGroupFrom toBookGroup:@"delete"];
        }
    }];
    // 取消
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:listOneAction];
    [alertController addAction:listTwoAction];
    [alertController addAction:deleteAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 设置子控件的frame
 */
- (void)subviewsFrame {
    // 封面
    float imageX = 20;
    float imageY = 84;
    float imageW = 200;
    float imageH = 250;
    UIImageView *bookImageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, imageY, imageW, imageH)];
    bookImageView.backgroundColor = [UIColor purpleColor];
    NSURL *imageURL = [NSURL URLWithString:self.bookInfoDic[@"images"][@"large"]];
    bookImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
    [self.view addSubview:bookImageView];
    
    // 作者
    float authorX = imageX * 2 + imageW;
    float authorY = imageY;
    float authorW = self.view.bounds.size.width - imageW - imageX * 3;
    float authorH = 40;
    UILabel *authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(authorX, authorY, authorW, authorH)];
    NSArray *authorArray = [NSArray array];
    authorArray = self.bookInfoDic[@"author"];
    NSMutableString *authors = [[NSMutableString alloc] init];
    if (authorArray.count > 1) {
        for (NSString *author in authorArray) {
            [authors appendFormat:@"%@ %@", authors, author];
        }
    } else {
        authors = [authorArray lastObject];
    }
    authorLabel.text = authors;
    [self.view addSubview:authorLabel];
    
    // 出版社
    float publisherX = authorX;
    float publisherY = authorY + authorH;
    float publisherW = authorW;
    float publisherH = authorH;
    UILabel *publisherLabel = [[UILabel alloc] initWithFrame:CGRectMake(publisherX, publisherY, publisherW, publisherH)];
    publisherLabel.text = self.bookInfoDic[@"publisher"];
    [self.view addSubview:publisherLabel];
    
    // 价格
    float priceX = authorX;
    float priceY = publisherY + publisherH;
    float priceW = authorW;
    float priceH = authorH;
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(priceX, priceY, priceW, priceH)];
    priceLabel.text = self.bookInfoDic[@"price"];
    [self.view addSubview:priceLabel];
    
    // 概要
    float summaryX = imageX;
    float summaryY = imageY + imageH;
    float summaryW = self.view.bounds.size.width - imageX * 2;
    float summaryH = 100;
    UITextView *summaryTextView = [[UITextView alloc] initWithFrame:CGRectMake(summaryX, summaryY, summaryW, summaryH)];
    summaryTextView.editable = NO;
    summaryTextView.text = self.bookInfoDic[@"summary"];
    [self.view addSubview:summaryTextView];
}

@end
