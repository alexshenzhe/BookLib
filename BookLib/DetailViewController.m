//
//  DetailViewController.m
//  BookLib
//
//  Created by 沈喆 on 17/4/20.
//  Copyright © 2017年 沈喆. All rights reserved.
//

#import "DetailViewController.h"
#import "MBProgressHUD.h"
#import "PopupView.h"

@interface DetailViewController ()

@property (nonatomic, weak) UIImageView *bookImageView; // 封面
@property (nonatomic, weak) UILabel *authorTitleLabel; // 作者标题
@property (nonatomic, weak) UILabel *authorLabel; // 作者
//@property (nonatomic, weak) UILabel *publisherLabel; // 出版社
@property (nonatomic, weak) UILabel *priceTitleLabel; // 价格标题
@property (nonatomic, weak) UILabel *priceLabel; // 价格
//@property (nonatomic, weak) UILabel *pubdateLabel; // 出版时间
//@property (nonatomic, weak) UILabel *isbnLabel; // ISBN码
@property (nonatomic, weak) UILabel *ratingTitleLabel; // 评分标题
@property (nonatomic, weak) UILabel *ratingLabel; // 评分
@property (nonatomic, weak) UIButton *authorIntroButton; // 作者简介按钮
@property (nonatomic, weak) UIButton *summaryButton; // 内容简介按钮
@property (nonatomic, weak) UIButton *catalogButton; // 目录按钮
@property (nonatomic, weak) UIButton *copyrightButton; // 版权信息按钮
@property (nonatomic, weak) UITextView *introTextView; // 简介显示文本
@property (nonatomic, strong) PopupView *popupView;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigationBarStyle];
    [self subviewsFrame];
    [self subviewsData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - NavigationBar Style

/**
 设置导航栏内容
 */
- (void)setNavigationBarStyle {
    UIBarButtonItem *changeBookGroupButton = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editBookGroup)];
    self.navigationItem.rightBarButtonItem = changeBookGroupButton;
    self.navigationItem.leftBarButtonItem = nil;
    
    self.title = self.bookInfoDic[@"title"];
}

/**
 编辑
 */
- (void)editBookGroup {
    // 默认分组
    NSMutableArray *currentLists = [NSMutableArray arrayWithObjects:@"待读", @"在读", @"已读", nil];
    NSMutableArray *currentGroups = [NSMutableArray arrayWithObjects:@"favoriteBook", @"readingBook", @"haveReadBook", nil];
    // 当前所在组
    NSInteger section = self.tableViewCellSection;
    NSString *listFrom = [NSString stringWithString:currentLists[section]];
    NSString *GroupFrom = [NSString stringWithString:currentGroups[section]];
    NSLog(@"当前组：%@", listFrom);
    // 去除当前组
    [currentLists removeObjectAtIndex:section];
    [currentGroups removeObjectAtIndex:section];
    // 取出其他组
    NSString *listFirst = [NSString stringWithString:currentLists[0]];
    NSString *listSecond = [NSString stringWithString:currentLists[1]];
    NSString *GroupFirst = [NSString stringWithString:currentGroups[0]];
    NSString *GroupSecond = [NSString stringWithString:currentGroups[1]];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    // List First
    UIAlertAction *listOneAction = [UIAlertAction actionWithTitle:listFirst style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([self.delegate respondsToSelector:@selector(DetailViewControllerDelegate:withIndexPath:andTableViewCellSection:fromBookGroup:toBookGroup:)]) {
            [self.delegate DetailViewControllerDelegate:self withIndexPath:self.indexPath andTableViewCellSection:self.tableViewCellSection fromBookGroup:GroupFrom toBookGroup:GroupFirst];
        }
    }];
    // List Second
    UIAlertAction *listTwoAction = [UIAlertAction actionWithTitle:listSecond style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([self.delegate respondsToSelector:@selector(DetailViewControllerDelegate:withIndexPath:andTableViewCellSection:fromBookGroup:toBookGroup:)]) {
            [self.delegate DetailViewControllerDelegate:self withIndexPath:self.indexPath andTableViewCellSection:self.tableViewCellSection fromBookGroup:GroupFrom toBookGroup:GroupSecond];
        }
    }];
    // 删除
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if ([self.delegate respondsToSelector:@selector(DetailViewControllerDelegate:withIndexPath:andTableViewCellSection:fromBookGroup:toBookGroup:)]) {
            [self.delegate DetailViewControllerDelegate:self withIndexPath:self.indexPath andTableViewCellSection:self.tableViewCellSection fromBookGroup:GroupFrom toBookGroup:@"delete"];
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

#pragma mark - Subview Frame & Data

/**
 设置子控件的frame
 */
- (void)subviewsFrame {
    float textSize = 13.0;
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
    // 添加四个边阴影
    bookImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    bookImageView.layer.shadowOffset = CGSizeMake(0, 0); // 阴影偏移
    bookImageView.layer.shadowOpacity = 0.5; // 阴影透明度
    bookImageView.layer.shadowRadius = 5.0; // 阴影半径
    
    [self.view addSubview:bookImageView];
    self.bookImageView = bookImageView;
    
    // 作者
    float authorTitleX = imageW + imageX * 2;
    float authorTitleY = imageY;
    float authorTitleW = 60;
    float authorTitleH = imageH / 7;
    float authorW = screenWidth - (authorTitleX + authorTitleW + imageX);
    UILabel *authorTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(authorTitleX, authorTitleY, authorTitleW, authorTitleH)];
    authorTitleLabel.font = [UIFont systemFontOfSize:textSize];
    authorTitleLabel.textColor = [UIColor darkGrayColor];
    [self.view addSubview:authorTitleLabel];
    self.authorTitleLabel = authorTitleLabel;
    
    UILabel *authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(authorTitleX + authorTitleW, authorTitleY, authorW, authorTitleH)];
    authorLabel.font = [UIFont systemFontOfSize:textSize];
    authorLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:authorLabel];
    self.authorLabel = authorLabel;
    
    // 价格
    float priceTitleX = authorTitleX;
    float priceTitleY = authorTitleY + authorTitleH;
    float priceTitleW = authorTitleW;
    float priceTitleH = authorTitleH;
    UILabel *priceTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(priceTitleX, priceTitleY, priceTitleW, priceTitleH)];
    priceTitleLabel.font = [UIFont systemFontOfSize:textSize];
    priceTitleLabel.textColor = [UIColor darkGrayColor];
    [self.view addSubview:priceTitleLabel];
    self.priceTitleLabel = priceTitleLabel;
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(priceTitleX + priceTitleW, priceTitleY, authorW, priceTitleH)];
    priceLabel.font = [UIFont systemFontOfSize:textSize];
    priceLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:priceLabel];
    self.priceLabel = priceLabel;
    
    // 版权信息按钮
    float copyrightButtonX = authorTitleX;
    float copyrightButtonY = priceTitleY + priceTitleH;
    float copyrightButtonW = 60;
    float copyrightButtonH = authorTitleH;
    UIButton *copyrightButton = [[UIButton alloc] initWithFrame:CGRectMake(copyrightButtonX, copyrightButtonY, copyrightButtonW, copyrightButtonH)];
    copyrightButton.titleLabel.font = [UIFont systemFontOfSize:titleSize];
    [copyrightButton addTarget:self action:@selector(copyrightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    copyrightButton.titleLabel.font = [UIFont systemFontOfSize:textSize];
    copyrightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [copyrightButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:copyrightButton];
    self.copyrightButton = copyrightButton;
    
    // 评分
    float ratingX = authorTitleX;
    float ratingY = copyrightButtonH + copyrightButtonY;
    float ratingW = authorTitleW;
    float ratingH = authorTitleH;
    UILabel *ratingTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(ratingX, ratingY, ratingW, ratingH)];
    ratingTitleLabel.font = [UIFont systemFontOfSize:textSize];
    ratingTitleLabel.textColor = [UIColor darkGrayColor];
    [self.view addSubview:ratingTitleLabel];
    self.ratingTitleLabel = ratingTitleLabel;
    
    UILabel *ratingLabel = [[UILabel alloc] initWithFrame:CGRectMake(ratingX, ratingY + ratingH, ratingW, ratingH)];
    ratingLabel.font = [UIFont systemFontOfSize:raingSize];
    [self.view addSubview:ratingLabel];
    self.ratingLabel = ratingLabel;
    
    // 作者简介/内容简介／目录标题按钮
    float numOfButton = 3;
    float space = 5;
    float buttonW = 60;
    float buttonH = authorTitleH;
    float buttonX = (screenWidth - ((buttonW + space) * numOfButton - space)) * 0.5;
    float buttonY = imageY + imageH + 20;
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
    float authorIntroY = buttonY + buttonH + 10;
    float authorIntroW = self.view.bounds.size.width - imageX * 2;
    float authorIntroH = self.view.bounds.size.height - authorIntroY - imageX;
    UITextView *introTextView = [[UITextView alloc] initWithFrame:CGRectMake(authorIntroX, authorIntroY, authorIntroW, authorIntroH)];
    introTextView.editable = NO;
    introTextView.showsVerticalScrollIndicator = NO;
    introTextView.font = [UIFont systemFontOfSize:introSize];
    [self.view addSubview:introTextView];
    self.introTextView = introTextView;
}

/**
 设置子控件数据
 */
- (void)subviewsData {
    // 封面
    NSURL *imageURL = [NSURL URLWithString:self.bookInfoDic[@"images"][@"large"]];
    self.bookImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
    // 作者
    self.authorTitleLabel.text = @"作者";
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
    self.authorLabel.text = [NSString stringWithFormat:@"%@", authors];
    // 价格
    self.priceTitleLabel.text = @"定价";
    self.priceLabel.text = [NSString stringWithFormat:@"%@", self.bookInfoDic[@"price"]];
    // 版权信息
    [self.copyrightButton setTitle:@"版权信息" forState:UIControlStateNormal];
    // 评分
    self.ratingTitleLabel.text = @"豆瓣评分";
    self.ratingLabel.text = self.bookInfoDic[@"rating"][@"average"];
    // 作者简介／概要
    [self authorIntroButtonClick];
    [self.authorIntroButton setTitle:@"作者" forState:UIControlStateNormal];
    [self.summaryButton setTitle:@"内容" forState:UIControlStateNormal];
    [self.catalogButton setTitle:@"目录" forState:UIControlStateNormal];
}

#pragma mark - Button Click

/**
 作者按钮点击事件
 */
- (void)authorIntroButtonClick {
    [self currentButtonClick:@"author_intro" clickedButton:self.authorIntroButton notClickButton:self.summaryButton and:self.catalogButton];
}

/**
 内容按钮点击事件
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
 版权信息按钮点击事件
 */
- (void)copyrightButtonClick {
    [self setNavigationBarStyle];
    self.popupView = [PopupView popupViewForCopyrightInfoWithView:self.navigationController.view bookInfoDic:self.bookInfoDic];
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
    // 设置相应显示的内容
    NSString *introString = self.bookInfoDic[buttonName];
    if (introString.length == 0) {
        [self errorHUDWithString:@"无相关内容"];
        introString = @"空";
    }
    self.introTextView.text = introString;
}


@end
