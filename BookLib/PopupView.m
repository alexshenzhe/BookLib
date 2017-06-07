//
//  PopupView.m
//  BookLib
//
//  Created by 沈喆 on 17/4/24.
//  Copyright © 2017年 沈喆. All rights reserved.
//

#import "PopupView.h"

@interface PopupView ()

@property (nonatomic, weak) UIImageView *bookImageView; // 封面
@property (nonatomic, weak) UILabel *bookTitleLabel; // 书名
@property (nonatomic, weak) UILabel *authorLabel; // 作者
@property (nonatomic, weak) UILabel *publisherLabel; // 出版社
@property (nonatomic, weak) UITextView *summaryTextView; // 该要
@property (nonatomic, weak) UILabel *pubdateLabel; // 出版年
@property (nonatomic, weak) UILabel *isbnLabel; // ISBN码
@property (nonatomic, weak) UILabel *priceLabel; // 价格
@property (nonatomic, weak) UILabel *pagesLabel; // 页数
@property (nonatomic, strong) UIView *coverView; // 阴影
@property (nonatomic, strong) UIView *popupView; // 弹窗
@property (nonatomic, copy) NSDictionary *bookInfoDic;

@end

@implementation PopupView


# pragma mark - Cover View

/**
  创建阴影
 */
- (void)showCoverAddToView:(UIView *)view orTableView:(UITableView *)tableView alpha:(float)alpha {
    UIView *coverView = [[UIView alloc] init];
    if (view) {
        coverView.frame = view.frame;
        [view addSubview:coverView];
    } else if (tableView) {
        float coverX = tableView.contentOffset.x;
        float coverY = tableView.contentOffset.y;
        float coverW = tableView.bounds.size.width;
        float coverH = tableView.bounds.size.height;
        coverView.frame = CGRectMake(coverX, coverY, coverW, coverH);
        [tableView addSubview:coverView];
    }
    self.coverView = coverView;
    self.coverView.backgroundColor = [UIColor blackColor];
    self.coverView.alpha = 0.0;
    [UIView animateWithDuration:0.5 animations:^{
        self.coverView.alpha = alpha;
    }];
}

/**
  清除阴影
 */
- (void)hideCoverAndPopupView {
    [UIView animateWithDuration:0.5 animations:^{
        self.coverView.alpha = 0.0;
        self.popupView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.popupView removeFromSuperview];
        self.popupView = nil;
        [self.coverView removeFromSuperview];
        self.coverView = nil;
    }];
}

# pragma mark - Detail Popup View

/**
  创建Detail PopupView
 */
- (instancetype)initPopupViewForDetailWithTableView:(UITableView *)parentTableView bookInfoDic:(NSDictionary *)bookInfoDic {
    self = [super init];
    if (self) {
        self.bookInfoDic = bookInfoDic;
//        [self showCoverWithTableView:parentTableView alpha:0.7];
        [self showCoverAddToView:nil orTableView:parentTableView alpha:0.7];
        [self showPopupViewForDetailWithTableView:parentTableView];
        [self showPopupViewForDetailData];
    }
    return self;
}

+ (instancetype)popupViewForDetailWithTableView:(UITableView *)parentTableView bookInfoDic:(NSDictionary *)bookInfoDic {
    return [[self alloc] initPopupViewForDetailWithTableView:parentTableView bookInfoDic:bookInfoDic];
}

/**
  创建Detail PopupView信息页frame
 */
- (void)showPopupViewForDetailWithTableView:(UITableView *)parentTableView {
    float textSize = 15.0;
    
    UIView *popupView = [[UIView alloc] init];
    // Popup View
    float popupViewX = parentTableView.contentOffset.x + 40;
    float popupViewY = parentTableView.contentOffset.y + popupViewX + 64;
    float popupViewW = parentTableView.bounds.size.width - popupViewX * 2;
    float popupViewH = parentTableView.bounds.size.height - popupViewX * 2 - 64;
    popupView.frame = CGRectMake(popupViewX, popupViewY, popupViewW, popupViewH);
    popupView.backgroundColor = [UIColor whiteColor];
    popupView.alpha = 0.0;
    // 圆角
    popupView.layer.cornerRadius = 10.0;
    popupView.layer.masksToBounds = YES;
    [parentTableView addSubview:popupView];
    [UIView animateWithDuration:0.5 animations:^{
        popupView.alpha = 1.0;
    }];
    self.popupView = popupView;
    
    // 封面
    float imageW = popupViewW * 0.5;
    float imageH = imageW / 1.5 * 2;
    float imageX = (popupViewW - imageW) * 0.5;
    float imageY = 10;
    UIImageView *bookImageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, imageY, imageW, imageH)];
    // 添加四个边阴影
    bookImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    bookImageView.layer.shadowOffset = CGSizeMake(0, 0);
    bookImageView.layer.shadowOpacity = 0.5;
    bookImageView.layer.shadowRadius = 5.0;
    [self.popupView addSubview:bookImageView];
    self.bookImageView = bookImageView;
    
    // 书名
    float titleX = 10;
    float titleY = imageH + imageY * 2;
    float titleW = popupViewW - titleX * 2;
    float titleH = 20;
    UILabel *bookTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleX, titleY, titleW, titleH)];
    bookTitleLabel.textAlignment = NSTextAlignmentCenter;
    bookTitleLabel.font = [UIFont systemFontOfSize:20];
    [self.popupView addSubview:bookTitleLabel];
    self.bookTitleLabel = bookTitleLabel;
    
    // 作者
    float authorX = titleX;
    float authorY = titleH + titleY + imageY;
    float authorW = titleW;
    float authorH = titleH;
    UILabel *authorLabel = [[UILabel alloc]initWithFrame:CGRectMake(authorX, authorY, authorW, authorH)];
    authorLabel.textAlignment = NSTextAlignmentCenter;
    authorLabel.font = [UIFont systemFontOfSize:textSize];
    [self.popupView addSubview:authorLabel];
    self.authorLabel = authorLabel;
    
    // 出版社
    float publisherX = titleX;
    float publisherY = authorH + authorY + imageY;
    float publisherW = titleW;
    float publisherH = titleH;
    UILabel *publisherLabel = [[UILabel alloc] initWithFrame:CGRectMake(publisherX, publisherY, publisherW, publisherH)];
    publisherLabel.textAlignment = NSTextAlignmentCenter;
    publisherLabel.font = [UIFont systemFontOfSize:textSize];
    [self.popupView addSubview:publisherLabel];
    self.publisherLabel = publisherLabel;
    
    // 概要
    float summaryX = titleX;
    float summaryY = publisherH + publisherY + imageY;
    float summaryW = titleW;
    float summaryH = popupViewH - (summaryY + 10);
    UITextView *summaryTextView = [[UITextView alloc] initWithFrame:CGRectMake(summaryX, summaryY, summaryW, summaryH)];
    summaryTextView.editable = NO;
    summaryTextView.showsVerticalScrollIndicator = NO;
    [self.popupView addSubview:summaryTextView];
    self.summaryTextView = summaryTextView;
}

/**
  设置Detail PopupView数据
 */
- (void)showPopupViewForDetailData {
    // 封面
    NSURL *imageURL = [NSURL URLWithString:self.bookInfoDic[@"images"][@"large"]];
    self.bookImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
    // 书名
    self.bookTitleLabel.text = self.bookInfoDic[@"title"];
    // 作者
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
    self.authorLabel.text = authors;
    // 出版社
    self.publisherLabel.text = self.bookInfoDic[@"publisher"];
    // 简介
    self.summaryTextView.text = self.bookInfoDic[@"summary"];
}

# pragma mark - Copyright Info Popup View

/**
  创建版权信息PopupView
 */
- (instancetype)initPopupViewForCopyrightInfoWithView:(UIView *)parentView bookInfoDic:(NSDictionary *)bookInfoDic {
    self = [super init];
    if (self) {
        self.bookInfoDic = bookInfoDic;
        [self showCoverAddToView:parentView orTableView:nil alpha:0.7];
        [self showPopupViewForCopyrightInfoWithView:parentView];
        [self showPopupViewForCopyrightInfoData];
    }
    return self;
}

+ (instancetype)popupViewForCopyrightInfoWithView:(UIView *)parentView bookInfoDic:(NSDictionary *)bookInfoDic {
    return [[self alloc] initPopupViewForCopyrightInfoWithView:parentView bookInfoDic:bookInfoDic];
}

/**
  创建版权页 PopupView的frame
 */
- (void)showPopupViewForCopyrightInfoWithView:(UIView *)parentView {
    UIView *popupView = [[UIView alloc] init];
    // Popup View
    float popupViewW = 300;
    float popupViewH = 300;
    float popupViewX = ([UIScreen mainScreen].bounds.size.width - popupViewW) * 0.5;
    float popupViewY = ([UIScreen mainScreen].bounds.size.height - popupViewW) * 0.5;
    popupView.frame = CGRectMake(popupViewX, popupViewY, popupViewW, popupViewH);
    popupView.backgroundColor = [UIColor whiteColor];
    popupView.alpha = 0.0;
    // 圆角
    popupView.layer.cornerRadius = 10.0;
    popupView.layer.masksToBounds = YES;
    [parentView addSubview:popupView];
    [UIView animateWithDuration:0.5 animations:^{
        popupView.alpha = 1.0;
    }];
    self.popupView = popupView;

    float textSize = 15.0;
    float defauleLabelW = 50;
    float defaultLabelH = 30;
    
    // title
    float titleX = 0;
    float titleY = 30;
    float titleW = popupViewW;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleX, titleY, titleW, defaultLabelH)];
    // 字体加粗
    [titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
    titleLabel.text = @"版权信息";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.popupView addSubview:titleLabel];
    
    // 出版社
    float publisherX = 15;
    float publisherY = titleY * 2.5;
    float dataX = 70;
    float dataW = popupViewW - defauleLabelW - publisherX * 2;
    UILabel *publisherTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(publisherX, publisherY, defauleLabelW, defaultLabelH)];
    publisherTextLabel.font = [UIFont systemFontOfSize:textSize];
    publisherTextLabel.textColor = [UIColor grayColor];
    publisherTextLabel.text = @"出版社";
    publisherTextLabel.textAlignment = NSTextAlignmentLeft;
    [self.popupView addSubview:publisherTextLabel];
    
    UILabel *publisherLabel = [[UILabel alloc] initWithFrame:CGRectMake(dataX, publisherY, dataW, defaultLabelH)];
    publisherLabel.font = [UIFont systemFontOfSize:textSize];
    publisherLabel.textAlignment = NSTextAlignmentRight;
    [self.popupView addSubview:publisherLabel];
    self.publisherLabel = publisherLabel;
    
    // 出版时间
    float pubdateX = publisherX;
    float pubdateY = defaultLabelH + publisherY;
    UILabel *pubdateTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(pubdateX, pubdateY, defauleLabelW, defaultLabelH)];
    pubdateTextLabel.font = [UIFont systemFontOfSize:textSize];
    pubdateTextLabel.textColor = [UIColor grayColor];
    pubdateTextLabel.text = @"出版年";
    pubdateTextLabel.textAlignment = NSTextAlignmentLeft;
    [self.popupView addSubview:pubdateTextLabel];
    
    UILabel *pubdateLabel = [[UILabel alloc] initWithFrame:CGRectMake(dataX, pubdateY, dataW, defaultLabelH)];
    pubdateLabel.font = [UIFont systemFontOfSize:textSize];
    pubdateLabel.textAlignment = NSTextAlignmentRight;
    [self.popupView addSubview:pubdateLabel];
    self.pubdateLabel = pubdateLabel;
    
    // ISBN码
    float isbnX = publisherX;
    float isbnY = defaultLabelH + pubdateY;
    UILabel *isbnTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(isbnX, isbnY, defauleLabelW, defaultLabelH)];
    isbnTextLabel.font = [UIFont systemFontOfSize:textSize];
    isbnTextLabel.textColor = [UIColor grayColor];
    isbnTextLabel.text = @"ISBN";
    isbnTextLabel.textAlignment = NSTextAlignmentLeft;
    [self.popupView addSubview:isbnTextLabel];
    
    UILabel *isbnLabel = [[UILabel alloc] initWithFrame:CGRectMake(dataX, isbnY, dataW, defaultLabelH)];
    isbnLabel.font = [UIFont systemFontOfSize:textSize];
    isbnLabel.textAlignment = NSTextAlignmentRight;
    [self.popupView addSubview:isbnLabel];
    self.isbnLabel = isbnLabel;
    
    // 价格
    float priceX = publisherX;
    float priceY = defaultLabelH + isbnY;
    UILabel *priceTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(priceX, priceY, defauleLabelW, defaultLabelH)];
    priceTextLabel.font = [UIFont systemFontOfSize:textSize];
    priceTextLabel.textColor = [UIColor grayColor];
    priceTextLabel.text = @"价格";
    priceTextLabel.textAlignment = NSTextAlignmentLeft;
    [self.popupView addSubview:priceTextLabel];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(dataX, priceY, dataW, defaultLabelH)];
    priceLabel.font = [UIFont systemFontOfSize:textSize];
    priceLabel.textAlignment = NSTextAlignmentRight;
    [self.popupView addSubview:priceLabel];
    self.priceLabel = priceLabel;
    
    // 页数
    float pagesX = publisherX;
    float pagesY = defaultLabelH + priceY;
    UILabel *pagesTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(pagesX, pagesY, defauleLabelW, defaultLabelH)];
    pagesTextLabel.font = [UIFont systemFontOfSize:textSize];
    pagesTextLabel.textColor = [UIColor grayColor];
    pagesTextLabel.text = @"页数";
    pagesTextLabel.textAlignment = NSTextAlignmentLeft;
    [self.popupView addSubview:pagesTextLabel];
    
    UILabel *pagesLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, pagesY, 215, defaultLabelH)];
    pagesLabel.font = [UIFont systemFontOfSize:textSize];
    pagesLabel.textAlignment = NSTextAlignmentRight;
    [self.popupView addSubview:pagesLabel];
    self.pagesLabel = pagesLabel;
    
    // 关闭按钮
    float closeButtonW = popupViewW;
    float closeButtonH = 40;
    float closeButtonX = 0;
    float closeButtonY = popupViewH - closeButtonH;
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(closeButtonX, closeButtonY, closeButtonW, closeButtonH)];
    [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    closeButton.titleLabel.font = [UIFont systemFontOfSize:textSize];
    [closeButton addTarget:self action:@selector(hideCoverAndPopupView) forControlEvents:UIControlEventTouchUpInside];
    closeButton.titleLabel.font = [UIFont systemFontOfSize:textSize];
    [closeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [self.popupView addSubview:closeButton];
}

/**
  设置版权页Data
 */
- (void)showPopupViewForCopyrightInfoData {
    // 出版社
    self.publisherLabel.text = self.bookInfoDic[@"publisher"];
    // 出版日期
    self.pubdateLabel.text = self.bookInfoDic[@"pubdate"];
    // ISBN码
    self.isbnLabel.text = self.bookInfoDic[@"isbn13"];
    // 价格
    self.priceLabel.text = self.bookInfoDic[@"price"];
    // 页数
    self.pagesLabel.text = self.bookInfoDic[@"pages"];
}

@end
