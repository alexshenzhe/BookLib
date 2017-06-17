//
//  BooksCollectionViewController.m
//  BookLib
//
//  Created by 沈喆 on 17/4/17.
//  Copyright © 2017年 沈喆. All rights reserved.
//

#import "BooksCollectionViewController.h"
#import "BooksCollectionViewCell.h"

@interface BooksCollectionViewController ()

@end

@implementation BooksCollectionViewController

static NSString *const reusecollectionCell = @"collectionCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerClass:[BooksCollectionViewCell class] forCellWithReuseIdentifier:reusecollectionCell];
    // collectionView 背景颜色
    self.collectionView.backgroundColor = [UIColor whiteColor];
    // 隐藏滚动条
    self.collectionView.showsHorizontalScrollIndicator = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * 重写init方法，设置layout
 */
- (instancetype)init {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    if (self = [super initWithCollectionViewLayout:layout]) {
        layout.itemSize = CGSizeMake(200 , 200 * 1.4 + 20);
        // 定义滚动方向
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
    }
    return self;
}

/**
 * 判断第几组tableViewCell
 */
- (NSMutableArray *)whichSectionForBooksArray {
    NSMutableArray *array = [NSMutableArray array];
    switch (self.tableViewCellSection) {
        case 0:
            array = self.favoriteBookArray;
            break;
        case 1:
            array = self.readingBookArray;
            break;
        case 2:
            array = self.haveReadBookArray;
            break;
    }
    return array;
}

# pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self whichSectionForBooksArray].count;
}


/**
 * 设置collectionView内容
 */
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BooksCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reusecollectionCell forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[BooksCollectionViewCell alloc] init];
    }
    cell.backgroundColor = [UIColor whiteColor];
    NSDictionary *dic = [NSDictionary dictionary];
    NSMutableArray *array = [NSMutableArray array];
    array = [self whichSectionForBooksArray];
    dic = array[indexPath.row];
    // 异步加载图片
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"title:%@", dic[@"title"]);
        NSURL *imageURL = [NSURL URLWithString:dic[@"images"][@"large"]];
        UIImage *bookImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
        // 主线程更新图片
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.bookImage = bookImage;
            cell.bookName = dic[@"title"];
        });
    });
    
    
    return cell;
}

# pragma mark - UICollectionViewDelegate

/**
 * 点击事件处理
 */
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = [NSDictionary dictionary];
    NSMutableArray *array = [NSMutableArray array];
    array = [self whichSectionForBooksArray];
    dic = array[indexPath.row];
    if ([self.delegate respondsToSelector:@selector(booksConllectionViewController:didSelectAtItemIndexPath:withTableViewSection:withData:)]) {
        [self.delegate booksConllectionViewController:self didSelectAtItemIndexPath:indexPath withTableViewSection:self.tableViewCellSection withData:dic];
    }
    return YES;
}

@end
