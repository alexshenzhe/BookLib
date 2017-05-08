//
//  PopupDetailView.m
//  BookLib
//
//  Created by 沈喆 on 17/4/24.
//  Copyright © 2017年 沈喆. All rights reserved.
//

#import "PopupDetailView.h"

@interface PopupDetailView ()

@property (nonatomic, strong) UIImageView *bookImageView; // 封面
@property (nonatomic, strong) UILabel *bookTitleLabel; // 书名
@property (nonatomic, strong) UILabel *authorLabel; // 作者
@property (nonatomic, strong) UILabel *publisherLabel; // 出版社
@property (nonatomic, strong) UITextView *summaryTextView; // 该要

@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UIView *popupView;
@property (nonatomic, copy) NSDictionary *bookInfoDic;
@end

@implementation PopupDetailView

- (instancetype)initWithParentView:(UIView *)parentView infoDic:(NSDictionary *)infoDic{
    self = [super init];
    if (self) {
        self.bookInfoDic = infoDic;
        [self createCoverWithParentView:parentView alpha:0.5];
        [self createDetailViewWithParentView:parentView];
        
    }
    return self;
}

+ (instancetype)popupViewWithParentView:(UIView *)parentView infoDic:(NSDictionary *)infoDic{
    return [[self alloc] initWithParentView:parentView infoDic:infoDic];
}

/**
 创建阴影
 */
- (void)createCoverWithParentView:(UIView *)parentView alpha:(float)alpha {
    self.coverView = [[UIView alloc] init];
    self.coverView.frame = parentView.frame;
    self.coverView.backgroundColor = [UIColor blackColor];
    self.coverView.alpha = 0.0;
    
    [parentView addSubview:self.coverView];
    [UIView animateWithDuration:0.2 animations:^{
        self.coverView.alpha = alpha;
    }];
}

/**
 清除阴影
 */
- (void)killCover {
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
 创建详细信息页
 */
- (void)createDetailViewWithParentView:(UIView *)parentView {
    UIView *popupView = [[UIView alloc] init];
    // popup view
    float detailX = 40;
    float detailY = detailX;
    float detailW = parentView.frame.size.width - detailX * 2;
    float detailH = parentView.frame.size.height - detailX * 2 - 64;
    popupView.frame = CGRectMake(detailX, detailY, detailW, detailH);
    popupView.backgroundColor = [UIColor whiteColor];
    popupView.alpha = 1.0;
    popupView.layer.cornerRadius = 5.0;
    popupView.layer.masksToBounds = YES;
    self.popupView = popupView;
    [parentView addSubview:self.popupView];
    
    // 封面
    float imageW = detailW * 0.5;
    float imageH = imageW / 1.5 * 2;
    float imageX = (detailW - imageW) * 0.5;
    float imageY = 10;
    UIImageView *bookImageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, imageY, imageW, imageH)];
    bookImageView.backgroundColor = [UIColor redColor];
    NSURL *imageURL = [NSURL URLWithString:self.bookInfoDic[@"images"][@"large"]];
    bookImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
    self.bookImageView = bookImageView;
    [self.popupView addSubview:self.bookImageView];
    
    // 书名
    float titleX = 0;
    float titleY = imageH + imageY * 2;
    float titleW = detailW;
    float titleH = 20;
    UILabel *bookTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(titleX, titleY, titleW, titleH)];
    bookTitleLabel.textAlignment = NSTextAlignmentCenter;
    bookTitleLabel.font = [UIFont systemFontOfSize:15];
    bookTitleLabel.text = self.bookInfoDic[@"title"];
    self.bookTitleLabel = bookTitleLabel;
    [self.popupView addSubview: self.bookTitleLabel];
    
    // 作者
    float authorX = titleX;
    float authorY = titleH + titleY + imageY;
    float authorW = detailW;
    float authorH = titleH;
    UILabel *authorLabel = [[UILabel alloc]initWithFrame:CGRectMake(authorX, authorY, authorW, authorH)];
    authorLabel.textAlignment = NSTextAlignmentCenter;
    authorLabel.font = [UIFont systemFontOfSize:15];
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
    self.authorLabel = authorLabel;
    [self.popupView addSubview: self.authorLabel];
    
    // 出版社
    float publisherX = titleX;
    float publisherY = authorH + authorY + imageY;
    float publisherW = titleW;
    float publisherH = titleH;
    UILabel *publisherLabel = [[UILabel alloc] initWithFrame:CGRectMake(publisherX, publisherY, publisherW, publisherH)];
    publisherLabel.textAlignment = NSTextAlignmentCenter;
    publisherLabel.font = [UIFont systemFontOfSize:15];
    publisherLabel.text = self.bookInfoDic[@"publisher"];
    self.publisherLabel = publisherLabel;
    [self.popupView addSubview:self.publisherLabel];
    
    // 概要
    float summaryX = titleX;
    float summaryY = publisherH + publisherY + imageY;
    float summaryW = titleW;
    float summaryH = detailH - (publisherH + publisherY);
    UITextView *summaryTextView = [[UITextView alloc] initWithFrame:CGRectMake(summaryX, summaryY, summaryW, summaryH)];
    summaryTextView.editable = NO;
    summaryTextView.text = self.bookInfoDic[@"summary"];
    self.summaryTextView = summaryTextView;
    [self.popupView addSubview:self.summaryTextView];
}

@end
