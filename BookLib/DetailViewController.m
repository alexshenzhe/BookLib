//
//  DetailViewController.m
//  BookLib
//
//  Created by 沈喆 on 17/4/20.
//  Copyright © 2017年 沈喆. All rights reserved.
//

#import "DetailViewController.h"
#import "MBProgressHUD.h"

@interface DetailViewController ()

@property (nonatomic, weak) UIImageView *bookImageView; // 封面
@property (nonatomic, weak) UILabel *authorLabel; // 作者
@property (nonatomic, weak) UILabel *publisherLabel; // 出版社
@property (nonatomic, weak) UILabel *priceLabel; // 价格
@property (nonatomic, weak) UILabel *pubdateLabel; // 出版时间
@property (nonatomic, weak) UILabel *ratingLabelTitle; // 评分标题
@property (nonatomic, weak) UILabel *ratingLabel; // 评分
@property (nonatomic, weak) UIButton *authorIntroButton; // 作者简介按钮
@property (nonatomic, weak) UIButton *summaryButton; // 内容简介按钮
@property (nonatomic, weak) UIButton *catalogButton; // 目录按钮
@property (nonatomic, weak) UITextView *IntroTextView; // 简介显示文本

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigationBarStyle];
    [self subviewsFrame];
    [self subviewsData];
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
        if ([self.delegate respondsToSelector:@selector(DetailViewControllerDelegate:withIndexPath:andTableViewCellSection:fromBookGroup:toBookGroup:)]) {
            [self.delegate DetailViewControllerDelegate:self withIndexPath:self.indexPath andTableViewCellSection:self.tableViewCellSection fromBookGroup:bookGroupFrom toBookGroup:bookGroupOne];
        }
    }];
    // listTwo
    UIAlertAction *listTwoAction = [UIAlertAction actionWithTitle:listTwo style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([self.delegate respondsToSelector:@selector(DetailViewControllerDelegate:withIndexPath:andTableViewCellSection:fromBookGroup:toBookGroup:)]) {
            [self.delegate DetailViewControllerDelegate:self withIndexPath:self.indexPath andTableViewCellSection:self.tableViewCellSection fromBookGroup:bookGroupFrom toBookGroup:bookGroupTwo];
        }
    }];
    // 删除
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
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
    float screenWidth = self.view.bounds.size.width;

    // 封面
    float imageX = 20;
    float imageY = 84;
    float imageW = (screenWidth - 2 * imageX) * 0.5 - imageX;
    float imageH = imageW * 1.4;
    UIImageView *bookImageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, imageY, imageW, imageH)];
    bookImageView.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:bookImageView];
    self.bookImageView = bookImageView;
    
    // 作者
    float authorX = imageW + imageX * 2;
    float authorY = imageY;
    float authorW = screenWidth - imageW - imageX * 3;
    float authorH = imageH / 7;
    UILabel *authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(authorX, authorY, authorW, authorH)];
    authorLabel.font = [UIFont systemFontOfSize:textSize];
    [self.view addSubview:authorLabel];
    self.authorLabel = authorLabel;
    
    // 出版社
    float publisherX = authorX;
    float publisherY = authorH + authorY;
    float publisherW = authorW;
    float publisherH = authorH;
    UILabel *publisherLabel = [[UILabel alloc] initWithFrame:CGRectMake(publisherX, publisherY, publisherW, publisherH)];
    publisherLabel.font = [UIFont systemFontOfSize:textSize];
    [self.view addSubview:publisherLabel];
    self.publisherLabel = publisherLabel;
    
    // 价格
    float priceX = authorX;
    float priceY = publisherH + publisherY;
    float priceW = authorW;
    float priceH = authorH;
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(priceX, priceY, priceW, priceH)];
    priceLabel.font = [UIFont systemFontOfSize:textSize];
    [self.view addSubview:priceLabel];
    self.priceLabel = priceLabel;
    
    // 出版时间
    float pubdateX = authorX;
    float pubdateY = priceH + priceY;
    float pubdateW = authorW;
    float pubdateH = authorH;
    UILabel *pubdateLabel = [[UILabel alloc] initWithFrame:CGRectMake(pubdateX, pubdateY, pubdateW, pubdateH)];
    pubdateLabel.font = [UIFont systemFontOfSize:textSize];
    [self.view addSubview:pubdateLabel];
    self.pubdateLabel = pubdateLabel;
    
    // 评分
    float ratingX = authorX;
    float ratingY = pubdateH + pubdateY;
    float ratingW = authorW;
    float ratingH = authorH;
    UILabel *ratingLabelTitle = [[UILabel alloc] initWithFrame:CGRectMake(ratingX, ratingY, ratingW, ratingH)];
    UILabel *ratingLabel = [[UILabel alloc] initWithFrame:CGRectMake(ratingX, ratingY + ratingH, ratingW, ratingH)];
    ratingLabelTitle.font = [UIFont systemFontOfSize:textSize];
    ratingLabel.font = [UIFont systemFontOfSize:raingSize];
    [self.view addSubview:ratingLabelTitle];
    [self.view addSubview:ratingLabel];
    self.ratingLabelTitle = ratingLabelTitle;
    self.ratingLabel = ratingLabel;
    
    // 作者简介/内容简介／目录标题按钮
    float numOfButton = 3;
    float space = 5;
    float buttonW = 100;
    float buttonH = authorH;
    float buttonX = (screenWidth - ((buttonW + space) * numOfButton - space)) * 0.5;
    float buttonY = imageY + imageH + 5;
    UIButton *authorIntroButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonW, buttonH)];
    UIButton *summaryButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonX + buttonW + space, buttonY, buttonW, buttonH)];
    UIButton *catalogButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonX + buttonW * 2 + space * 2, buttonY, buttonW, buttonH)];
    authorIntroButton.titleLabel.font = [UIFont systemFontOfSize:titleSize];
    summaryButton.titleLabel.font = [UIFont systemFontOfSize:titleSize];
    catalogButton.titleLabel.font = [UIFont systemFontOfSize:titleSize];
    [authorIntroButton addTarget:self action:@selector(authorIntroButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [summaryButton addTarget:self action:@selector(summaryButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [catalogButton addTarget:self action:@selector(catalogButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:authorIntroButton];
    [self.view addSubview:summaryButton];
    [self.view addSubview:catalogButton];
    self.authorIntroButton = authorIntroButton;
    self.summaryButton = summaryButton;
    self.catalogButton = catalogButton;
    
    // 作者简介／概要／目录
    float authorIntroX = imageX;
    float authorIntroY = buttonY + buttonH;
    float authorIntroW = self.view.bounds.size.width - imageX * 2;
    float authorIntroH = self.view.bounds.size.height - authorIntroY - imageX;
    UITextView *IntroTextView = [[UITextView alloc] initWithFrame:CGRectMake(authorIntroX, authorIntroY, authorIntroW, authorIntroH)];
    IntroTextView.editable = NO;
    IntroTextView.font = [UIFont systemFontOfSize:introSize];
    [self.view addSubview:IntroTextView];
    self.IntroTextView = IntroTextView;
}

/**
 作者简介按钮点击事件
 */
- (void)authorIntroButtonClick {
    [self currentButtonClick:@"author_intro" clickedButton:self.authorIntroButton notClickButton:self.summaryButton and:self.catalogButton];
}

/**
 内容简介按钮点击事件
 */
- (void)summaryButtonClick {
    [self currentButtonClick:@"summary" clickedButton:self.summaryButton notClickButton:self.authorIntroButton and:self.catalogButton];
}

/**
 目录按钮点击事件
 */
- (void)catalogButtonClick {
    [self currentButtonClick:@"catalog" clickedButton:self.catalogButton notClickButton:self.authorIntroButton and:self.summaryButton];
}

/**
 通用点击事件
 */
- (void)currentButtonClick:(NSString *)buttonName clickedButton:(UIButton *)clickedButton notClickButton:(UIButton *)oneButton and:(UIButton *)twoButton {
    oneButton.userInteractionEnabled = YES;
    twoButton.userInteractionEnabled = YES;
    clickedButton.userInteractionEnabled = NO;
    oneButton.selected = YES;
    twoButton.selected = YES;
    clickedButton.selected = NO;
    oneButton.backgroundColor = [UIColor lightGrayColor];
    twoButton.backgroundColor = [UIColor lightGrayColor];
    clickedButton.backgroundColor = [UIColor grayColor];
    [oneButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [twoButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [clickedButton setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    NSString *introString = self.bookInfoDic[buttonName];
    if (introString.length == 0) {
        [self errorHUDWithString:@"无相关内容"];
        introString = @"空";
    }
    self.IntroTextView.text = introString;
}

/**
 显示错误文字弹出框
 */
- (void)errorHUDWithString:(NSString *)string {
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        // 设置显示模式
        hud.mode = MBProgressHUDModeText;
        hud.label.text = string;
        hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
        [hud hideAnimated:YES afterDelay:2.f];
    });
}

/**
 设置子控件数据
 */
- (void)subviewsData {
    // 封面
    NSURL *imageURL = [NSURL URLWithString:self.bookInfoDic[@"images"][@"large"]];
    self.bookImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
    
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
    self.authorLabel.text = [NSString stringWithFormat:@"作者：%@", authors];
    
    // 出版社
    self.publisherLabel.text = [NSString stringWithFormat:@"出版社：%@", self.bookInfoDic[@"publisher"]];
    
    // 价格
    self.priceLabel.text = [NSString stringWithFormat:@"定价：%@", self.bookInfoDic[@"price"]];
    
    // 出版日期
    self.pubdateLabel.text = [NSString stringWithFormat:@"出版年：%@", self.bookInfoDic[@"pubdate"]];
    
    // 评分
    self.ratingLabelTitle.text = @"豆瓣评分：";
    self.ratingLabel.text = self.bookInfoDic[@"rating"][@"average"];
    
    // 作者简介／概要
    [self authorIntroButtonClick];
    [self.authorIntroButton setTitle:@"作者简介" forState:UIControlStateNormal];
    [self.summaryButton setTitle:@"内容简介" forState:UIControlStateNormal];
    [self.catalogButton setTitle:@"目录" forState:UIControlStateNormal];
}

@end
