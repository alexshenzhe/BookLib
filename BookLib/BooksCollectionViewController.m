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

static NSString *const reuseIdentifier = @"collectionCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerClass:[BooksCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.frame = CGRectMake(0, 0, self.collectionView.superview.frame.size.width, 314);
    self.collectionView.backgroundColor = [UIColor grayColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)favoriteBookArray {
    if (_favoriteBookArray == nil) {
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/userBook.plist"];
        NSArray *dicArray = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dic in dicArray) {
            [array addObject:dic];
        }
        _favoriteBookArray = array;
    }
    return _favoriteBookArray;
}

- (NSMutableArray *)haveReadBookArray {
    if (_haveReadBookArray == nil) {
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/haveReadBook.plist"];
        NSArray *dicArray = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dic in dicArray) {
            [array addObject:dic];
        }
        _haveReadBookArray = array;
    }
    return _haveReadBookArray;
}

- (NSMutableArray *)readingBookArray {
    if (_readingBookArray == nil) {
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/readingBook.plist"];
        NSArray *dicArray = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dic in dicArray) {
            [array addObject:dic];
        }
        _readingBookArray = array;
    }
    return _readingBookArray;
}

- (instancetype)init {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    if (self = [super initWithCollectionViewLayout:layout]) {
        layout.itemSize = CGSizeMake(200, 250);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
    }
    return self;
}

- (NSMutableArray *)whichSectionForBooksArray {
    NSMutableArray *array = [NSMutableArray array];
    if (self.bookSection == 0) {
        array = self.favoriteBookArray;
    } else if (self.bookSection == 1) {
        array = self.readingBookArray;
    } else if (self.bookSection == 2) {
        array = self.haveReadBookArray;
    }
    return array;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self whichSectionForBooksArray].count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BooksCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[BooksCollectionViewCell alloc] init];
    }
    cell.backgroundColor = [UIColor yellowColor];
    NSDictionary *dic = [NSDictionary dictionary];
    NSMutableArray *array = [NSMutableArray array];
    array = [self whichSectionForBooksArray];
    dic = array[indexPath.row];
    
    NSLog(@"title:%@", dic[@"title"]);
    NSURL *imageURL = [NSURL URLWithString:dic[@"images"][@"large"]];
    cell.bookImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
    cell.bookName = dic[@"title"];
    return cell;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/


// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = [NSDictionary dictionary];
    NSMutableArray *array = [NSMutableArray array];
    array = [self whichSectionForBooksArray];
    dic = array[indexPath.row];
    NSLog(@"我选择了NO.%ld，title:%@", indexPath.row, dic[@"title"]);
    return YES;
}


/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
