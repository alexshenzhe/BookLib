//
//  PopupDetailView.m
//  BookLib
//
//  Created by 沈喆 on 17/4/24.
//  Copyright © 2017年 沈喆. All rights reserved.
//

#import "PopupDetailView.h"

#define PARENTVIEWWIDTH (parentView.bounds.size.width)
#define PARENTVIEWHEIGHT (parentView.bounds.size.height)
#define PARENTVIEWOFFSETX (parentView.contentOffset.x)
#define PARENTVIEWOFFSETY (parentView.contentOffset.y)
@interface PopupDetailView ()

@property (nonatomic, weak) UIImageView *bookImageView; // 封面
@property (nonatomic, weak) UILabel *bookTitleLabel; // 书名
@property (nonatomic, weak) UILabel *authorLabel; // 作者
@property (nonatomic, weak) UILabel *publisherLabel; // 出版社
@property (nonatomic, weak) UITextView *summaryTextView; // 该要
@property (nonatomic, strong) UIView *coverView; // 阴影
@property (nonatomic, strong) UIView *popupView; // 弹窗
@property (nonatomic, copy) NSDictionary *bookInfoDic;

@end

@implementation PopupDetailView

- (instancetype)initWithParentView:(UITableView *)parentView bookInfoDic:(NSDictionary *)bookInfoDic{
    self = [super init];
    if (self) {
        self.bookInfoDic = bookInfoDic;
        [self createCoverWithParentView:parentView alpha:0.7];
        [self createPopupViewWithParentView:parentView];
        [self subviewsData];
    }
    return self;
}

+ (instancetype)popupViewWithParentView:(UITableView *)parentView bookInfoDic:(NSDictionary *)bookInfoDic{
    return [[self alloc] initWithParentView:parentView bookInfoDic:bookInfoDic];
}

/**
 创建阴影
 */
- (void)createCoverWithParentView:(UITableView *)parentView alpha:(float)alpha {
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
    
    [UIView animateWithDuration:0.2 animations:^{
        self.coverView.alpha = alpha;
    }];
}

/**
 清除阴影
 */
- (void)killCoverAndPopupView {
    [UIView animateWithDuration:0.25 animations:^{
        self.coverView.alpha = 0.0;
        self.popupView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.popupView removeFromSuperview];
        self.popupView = nil;
        [self.coverView removeFromSuperview];
        self.coverView = nil;
    }];
}

/**
 创建Popup View信息页
 */
- (void)createPopupViewWithParentView:(UITableView *)parentView {
    float textSize = 15.0;
    
    UIView *popupView = [[UIView alloc] init];
    // Popup View
    float detailX = PARENTVIEWOFFSETX + 40;
    float detailY = PARENTVIEWOFFSETY + detailX + 64;
    float detailW = PARENTVIEWWIDTH - detailX * 2;
    float detailH = PARENTVIEWHEIGHT - detailX * 2 - 64;
    popupView.frame = CGRectMake(detailX, detailY, detailW, detailH);
    popupView.backgroundColor = [UIColor whiteColor];
    popupView.alpha = 1.0;
    // 圆角
    popupView.layer.cornerRadius = 10.0;
    popupView.layer.masksToBounds = YES;
    [parentView addSubview:popupView];
    self.popupView = popupView;
    
    // 封面
    float imageW = detailW * 0.5;
    float imageH = imageW / 1.5 * 2;
    float imageX = (detailW - imageW) * 0.5;
    float imageY = 10;
    UIImageView *bookImageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, imageY, imageW, imageH)];
    [self.popupView addSubview:bookImageView];
    self.bookImageView = bookImageView;
    
    // 书名
    float titleX = 10;
    float titleY = imageH + imageY * 2;
    float titleW = detailW - titleX * 2;
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
    float summaryH = detailH - (summaryY + 10);
    UITextView *summaryTextView = [[UITextView alloc] initWithFrame:CGRectMake(summaryX, summaryY, summaryW, summaryH)];
    summaryTextView.editable = NO;
    [self.popupView addSubview:summaryTextView];
    self.summaryTextView = summaryTextView;
}

/**
 设置子控件数据
 */
- (void)subviewsData {
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

@end
