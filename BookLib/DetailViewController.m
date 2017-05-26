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
    float textSize = 15.0;
    float raingSize = 30.0;
    float introSize = 15.0;
    float titleSize = 18.0;

    // 封面
    float imageX = 20;
    float imageY = 84;
    float imageW = (self.view.bounds.size.width - 2 * imageX) * 0.5 - imageX;
    float imageH = imageW * 1.4;
    UIImageView *bookImageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, imageY, imageW, imageH)];
    bookImageView.backgroundColor = [UIColor purpleColor];
    NSURL *imageURL = [NSURL URLWithString:self.bookInfoDic[@"images"][@"large"]];
    bookImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
    [self.view addSubview:bookImageView];
    
    // 作者
    float authorX = imageW + imageX * 2;
    float authorY = imageY;
    float authorW = self.view.bounds.size.width - imageW - imageX * 3;
    float authorH = imageH / 7;
    UILabel *authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(authorX, authorY, authorW, authorH)];
    authorLabel.font = [UIFont systemFontOfSize:textSize];
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
    authorLabel.text = [NSString stringWithFormat:@"作者：%@", authors];
    [self.view addSubview:authorLabel];
    
    // 出版社
    float publisherX = authorX;
    float publisherY = authorH + authorY;
    float publisherW = authorW;
    float publisherH = authorH;
    UILabel *publisherLabel = [[UILabel alloc] initWithFrame:CGRectMake(publisherX, publisherY, publisherW, publisherH)];
    publisherLabel.font = [UIFont systemFontOfSize:textSize];
    publisherLabel.text = [NSString stringWithFormat:@"出版社：%@", self.bookInfoDic[@"publisher"]];
    [self.view addSubview:publisherLabel];
    
    // 价格
    float priceX = authorX;
    float priceY = publisherH + publisherY;
    float priceW = authorW;
    float priceH = authorH;
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(priceX, priceY, priceW, priceH)];
    priceLabel.font = [UIFont systemFontOfSize:textSize];
    priceLabel.text = [NSString stringWithFormat:@"定价：%@", self.bookInfoDic[@"price"]];
    [self.view addSubview:priceLabel];
    
    // 出版时间
    float pubdateX = authorX;
    float pubdateY = priceH + priceY;
    float pubdateW = authorW;
    float pubdateH = authorH;
    UILabel *pubdateLabel = [[UILabel alloc] initWithFrame:CGRectMake(pubdateX, pubdateY, pubdateW, pubdateH)];
    pubdateLabel.font = [UIFont systemFontOfSize:textSize];
    pubdateLabel.text = [NSString stringWithFormat:@"出版年：%@", self.bookInfoDic[@"pubdate"]];
    [self.view addSubview:pubdateLabel];
    
    // 评分
    float ratingX = authorX;
    float ratingY = pubdateH + pubdateY;
    float ratingW = authorW;
    float ratingH = authorH;
    UILabel *ratingLabelTitle = [[UILabel alloc] initWithFrame:CGRectMake(ratingX, ratingY, ratingW, ratingH)];
    UILabel *ratingLabel = [[UILabel alloc] initWithFrame:CGRectMake(ratingX, ratingY + ratingH, ratingW, ratingH)];
    ratingLabelTitle.font = [UIFont systemFontOfSize:textSize];
    ratingLabel.font = [UIFont systemFontOfSize:raingSize];
    ratingLabelTitle.text = @"豆瓣评分：";
    ratingLabel.text = self.bookInfoDic[@"rating"][@"average"];
    [self.view addSubview:ratingLabelTitle];
    [self.view addSubview:ratingLabel];
    
    // 作者简介／概要
    float authorIntroX = imageX;
    float authorIntroY = imageY + imageH;
    float authorIntroW = self.view.bounds.size.width - imageX * 2;
    float authorIntroH = self.view.bounds.size.height - authorIntroY;
    UILabel *authorIntroTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(authorIntroX, authorIntroY, authorIntroW, ratingH)];
    authorIntroTitleLabel.textColor = [UIColor brownColor];
    authorIntroTitleLabel.font = [UIFont systemFontOfSize:titleSize];
    authorIntroTitleLabel.text = @"作者简介";
    UITextView *authorIntroTextView = [[UITextView alloc] initWithFrame:CGRectMake(authorIntroX, authorIntroY + ratingH, authorIntroW, authorIntroH)];
    authorIntroTextView.editable = NO;
    authorIntroTextView.font = [UIFont systemFontOfSize:introSize];
    NSString *authorIntro = [NSString stringWithFormat:@"%@", self.bookInfoDic[@"author_intro"]];
    if (authorIntro.length == 0) {
        authorIntroTitleLabel.text = @"内容简介";
        authorIntro = self.bookInfoDic[@"summary"];
    }
    authorIntroTextView.text = authorIntro;
    [self.view addSubview:authorIntroTitleLabel];
    [self.view addSubview:authorIntroTextView];
}

@end
