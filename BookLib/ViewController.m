//
//  ViewController.m
//  BookLib
//
//  Created by 沈喆 on 17/4/12.
//  Copyright © 2017年 沈喆. All rights reserved.
//

#import "ViewController.h"
#import "JSONAnalysis.h"
#import "BookInfoViewCell.h"
//#import "DoubanData.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

//@property (nonatomic, copy) NSString *bookTitle;      // 书名
//@property (nonatomic, copy) NSString *isbn13;     // ISBN码
//@property (nonatomic, copy) NSString *image;      // 图片
//@property (nonatomic, copy) NSString *publisher;  // 出版社
//@property (nonatomic, copy) NSString *price;      // 价格
//@property (nonatomic, copy) NSString *author;     // 作者
@property (nonatomic, strong) NSMutableArray *bookArray; // 存放书本信息

@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewDidLoad");
    [self subviewsFrame];
    
    //    self.bookArray = [NSMutableArray array];
}

- (void) subviewsFrame {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(150, 200);
    layout.minimumInteritemSpacing = 10;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 200) collectionViewLayout:layout];
    [self.collectionView registerClass:[BookInfoViewCell class] forCellWithReuseIdentifier:@"collectionCell"];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.collectionView];
    
    UIButton *button = [[UIButton alloc] init];
    button.frame = CGRectMake(self.view.bounds.size.width * 0.5, self.view.bounds.size.height * 0.5, 100, 50);
    button.backgroundColor = [UIColor greenColor];
    [button addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (NSMutableArray *)bookArray {
    NSLog(@"setbookArray");
    if (_bookArray == nil) {
        NSLog(@"in setbookArray");
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/userBook.plist"];
        NSArray *dicArray = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dic in dicArray) {
            //            DoubanData *doubanData = [DoubanData dataWithDic:dic];
            //            [array addObject:doubanData];
            [array addObject:dic];
        }
        _bookArray = array;
    }
    return _bookArray;
}

- (void)clickButton:(NSURL *)url {
    NSDictionary *dic = [JSONAnalysis analysisWithURL:[NSURL URLWithString:@"https://api.douban.com/v2/book/isbn/:9787540458027"]];
    NSLog(@"dic:%@", dic);
    [self.bookArray addObject:dic];
    NSLog(@"bookArray:%@", self.bookArray);
    [self saveArrayToPlist:self.bookArray];
    [self.collectionView reloadData];
}

- (void)saveArrayToPlist:(NSMutableArray *)array {
    // 获取沙盒目录
    //    NSArray *pathArray =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, NO);
    //    NSString *documents = [pathArray objectAtIndex:0];
    NSLog(@"array:%@", array);
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/userBook.plist"];
    NSLog(@"%@", path);
    BOOL success = [array writeToFile:path atomically:YES];
    if (! success) {
        NSLog(@" 保存失败了");
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.bookArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BookInfoViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor yellowColor];
    NSLog(@"%ld", indexPath.row);
    NSDictionary *dic = [NSDictionary dictionary];
    dic = _bookArray[indexPath.row];
    NSURL *imageURL = [NSURL URLWithString:dic[@"image"]];
    cell.bookImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
    cell.bookNameLabel.text = dic[@"title"];
    
    return cell;
}


@end
