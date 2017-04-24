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
@property (nonatomic, strong) UILabel *priceLabel; // 价格

@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UIView *bookDetailView;
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
        self.bookDetailView.alpha = 0.0;
    } completion:^(BOOL finished) {
        
        [self.bookDetailView removeFromSuperview];
        self.bookDetailView = nil;
        [self.coverView removeFromSuperview];
        self.coverView = nil;
    }];
}

/**
 创建详细信息页
 */
- (void)createDetailViewWithParentView:(UIView *)parentView {
    UIView *bookDetailView = [[UIView alloc] init];
    float detailX = 40;
    float detailY = detailX;
    float detailW = parentView.frame.size.width - detailX * 2;
    float detailH = parentView.frame.size.height - detailX * 2 - 64;
    bookDetailView.frame = CGRectMake(detailX, detailY, detailW, detailH);
    bookDetailView.backgroundColor = [UIColor whiteColor];
    bookDetailView.alpha = 1.0;
    self.bookDetailView = bookDetailView;
    [parentView addSubview:bookDetailView];
    
    UIImageView *bookImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 150, 200)];
    bookImageView.backgroundColor = [UIColor redColor];
    NSURL *imageURL = [NSURL URLWithString:self.bookInfoDic[@"images"][@"large"]];
    bookImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
    self.bookImageView = bookImageView;
    [self.bookDetailView addSubview:self.bookImageView];
}

@end
