//
//  PopupView.m
//  BookLib
//
//  Created by 沈喆 on 17/4/24.
//  Copyright © 2017年 沈喆. All rights reserved.
//

#import "PopupView.h"

#define PARENTVIEWWIDTH (parentView.bounds.size.width)
#define PARENTVIEWHEIGHT (parentView.bounds.size.height)
#define PARENTVIEWOFFSETX (parentView.contentOffset.x)
#define PARENTVIEWOFFSETY (parentView.contentOffset.y)
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

# pragma mark - Detail Popup View

/**
 创建Detail PopupView
 */
- (instancetype)initPopupViewForDetailWithView:(UITableView *)parentView bookInfoDic:(NSDictionary *)bookInfoDic {
    self = [super init];
    if (self) {
        self.bookInfoDic = bookInfoDic;
        [self showCoverWithParentView:parentView alpha:0.7];
        [self showPopupViewForDetailWithView:parentView];
        [self showPopupViewForDetailData];
    }
    return self;
}

+ (instancetype)popupViewForDetailWithView:(UITableView *)parentView bookInfoDic:(NSDictionary *)bookInfoDic {
    return [[self alloc] initPopupViewForDetailWithView:parentView bookInfoDic:bookInfoDic];
}

/**
 创建Detail PopupView信息页frame
 */
- (void)showPopupViewForDetailWithView:(UITableView *)parentView {
    float textSize = 15.0;
    
    UIView *popupView = [[UIView alloc] init];
    // Popup View
    float popupViewX = PARENTVIEWOFFSETX + 40;
    float popupViewY = PARENTVIEWOFFSETY + popupViewX + 64;
    float popupViewW = PARENTVIEWWIDTH - popupViewX * 2;
    float popupViewH = PARENTVIEWHEIGHT - popupViewX * 2 - 64;
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
        [self showCoverWithView:parentView alpha:0.7];
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
    float textSize = 15.0;
    
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
    
    // title
    float titleX = 0;
    float titleY = 30;
    float titleW = popupViewW;
    float titleH = 30;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(titleX, titleY, titleW, titleH)];
    titleLabel.text = @"版权信息";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.popupView addSubview:titleLabel];
    
    float defauleLabelW = 50;
    float defaultLabelH = 30;
    // 出版社
    float publisherX = 15;
    float publisherY = titleY * 2.5;
    UILabel *publisherTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(publisherX, publisherY, defauleLabelW, defaultLabelH)];
    publisherTextLabel.font = [UIFont systemFontOfSize:textSize];
    publisherTextLabel.textColor = [UIColor darkGrayColor];
    publisherTextLabel.text = @"出版社";
    publisherTextLabel.textAlignment = NSTextAlignmentLeft;
    [self.popupView addSubview:publisherTextLabel];
    
    UILabel *publisherLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, publisherY, 215, defaultLabelH)];
    publisherLabel.font = [UIFont systemFontOfSize:textSize];
    publisherLabel.textAlignment = NSTextAlignmentRight;
    [self.popupView addSubview:publisherLabel];
    self.publisherLabel = publisherLabel;
    
    // 出版时间
    float pubdateX = publisherX;
    float pubdateY = defaultLabelH + publisherY;
    UILabel *pubdateTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(pubdateX, pubdateY, defauleLabelW, defaultLabelH)];
    pubdateTextLabel.font = [UIFont systemFontOfSize:textSize];
    pubdateTextLabel.textColor = [UIColor darkGrayColor];
    pubdateTextLabel.text = @"出版年";
    pubdateTextLabel.textAlignment = NSTextAlignmentLeft;
    [self.popupView addSubview:pubdateTextLabel];
    
    UILabel *pubdateLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, pubdateY, 215, defaultLabelH)];
    pubdateLabel.font = [UIFont systemFontOfSize:textSize];
    pubdateLabel.textAlignment = NSTextAlignmentRight;
    [self.popupView addSubview:pubdateLabel];
    self.pubdateLabel = pubdateLabel;
    
    // ISBN码
    float isbnX = publisherX;
    float isbnY = defaultLabelH + pubdateY;
    UILabel *isbnTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(isbnX, isbnY, defauleLabelW, defaultLabelH)];
    isbnTextLabel.font = [UIFont systemFontOfSize:textSize];
    isbnTextLabel.textColor = [UIColor darkGrayColor];
    isbnTextLabel.text = @"ISBN";
    isbnTextLabel.textAlignment = NSTextAlignmentLeft;
    [self.popupView addSubview:isbnTextLabel];
    
    UILabel *isbnLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, isbnY, 215, defaultLabelH)];
    isbnLabel.font = [UIFont systemFontOfSize:textSize];
    isbnLabel.textAlignment = NSTextAlignmentRight;
    [self.popupView addSubview:isbnLabel];
    self.isbnLabel = isbnLabel;
    
    // 价格
    float priceX = publisherX;
    float priceY = defaultLabelH + isbnY;
    UILabel *priceTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(priceX, priceY, defauleLabelW, defaultLabelH)];
    priceTextLabel.font = [UIFont systemFontOfSize:textSize];
    priceTextLabel.textColor = [UIColor darkGrayColor];
    priceTextLabel.text = @"价格";
    priceTextLabel.textAlignment = NSTextAlignmentLeft;
    [self.popupView addSubview:priceTextLabel];
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, priceY, 215, defaultLabelH)];
    priceLabel.font = [UIFont systemFontOfSize:textSize];
    priceLabel.textAlignment = NSTextAlignmentRight;
    [self.popupView addSubview:priceLabel];
    self.priceLabel = priceLabel;
    
    // 页数
    float pagesX = publisherX;
    float pagesY = defaultLabelH + priceY;
    UILabel *pagesTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(pagesX, pagesY, defauleLabelW, defaultLabelH)];
    pagesTextLabel.font = [UIFont systemFontOfSize:textSize];
    pagesTextLabel.textColor = [UIColor darkGrayColor];
    pagesTextLabel.text = @"页数";
    pagesTextLabel.textAlignment = NSTextAlignmentLeft;
    [self.popupView addSubview:pagesTextLabel];
    
    UILabel *pagesLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, pagesY, 215, defaultLabelH)];
    pagesLabel.font = [UIFont systemFontOfSize:textSize];
    pagesLabel.textAlignment = NSTextAlignmentRight;
    [self.popupView addSubview:pagesLabel];
    self.pagesLabel = pagesLabel;
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

# pragma mark - Cover View

/**
 创建阴影
 */
- (void)showCoverWithParentView:(UITableView *)parentView alpha:(float)alpha {
    float coverX = PARENTVIEWOFFSETX;
    float coverY = PARENTVIEWOFFSETY;
    float coverW = PARENTVIEWWIDTH;
    float coverH = PARENTVIEWHEIGHT;
    UIView *coverView = [[UIView alloc] init];
    coverView.frame = CGRectMake(coverX, coverY, coverW, coverH);
    coverView.backgroundColor = [UIColor blackColor];
    coverView.alpha = 0.0;
    [parentView addSubview:coverView];
    self.coverView = coverView;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.coverView.alpha = alpha;
    }];
}

- (void)showCoverWithView:(UIView *)parentView alpha:(float)alpha {
    UIView *coverView = [[UIView alloc] init];
    coverView.frame = parentView.frame;
    coverView.backgroundColor = [UIColor blackColor];
    coverView.alpha = 0.0;
    [parentView addSubview:coverView];
    self.coverView = coverView;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.coverView.alpha = alpha;
    }];
}

/**
 清除阴影
 */
- (void)killCoverAndPopupView {
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

@end
