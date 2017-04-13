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
#import "BooksNavController.h"
#import "MBProgressHUD.h"
//#import "DoubanData.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *bookArray; // 存放书本信息

@property (nonatomic, strong) UICollectionView *collectionView;

//@property (nonatomic, strong) JSONAnalysis *jsonana;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewDidLoad");
    [self subviewsFrame];
    
    
    //    self.bookArray = [NSMutableArray array];
}

- (void)subviewsFrame {
    // 导航栏按钮、文字
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBookInfo)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.title = @"BOOKLib";
    // collection & layout
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(150, 200);
    layout.minimumInteritemSpacing = 10;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 270) collectionViewLayout:layout];
    [self.collectionView registerClass:[BookInfoViewCell class] forCellWithReuseIdentifier:@"collectionCell"];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.collectionView];
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

// 显示选择提示框
- (void)addBookInfo {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *inputAction = [UIAlertAction actionWithTitle:@"输入" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIAlertController *inputAlertController = [UIAlertController alertControllerWithTitle:@"111" message:@"222" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *inputAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *textField = inputAlertController.textFields.firstObject;
            
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            // Change the background view style and color.
            hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
            hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
            // 全局队列异步操作
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(queue, ^{
                [self searchBookInfoWithIsbn:textField.text];
//                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.douban.com/v2/book/isbn/:%@", textField.text]];
//                self.jsonana = [[JSONAnalysis alloc] initAnalysisWithURL:url];
//                [self searchBookInfoWithIsbn:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.collectionView reloadData];
                    [hud hideAnimated:YES];
                });
            });
            
            NSLog(@"%@", textField.text);
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [inputAlertController addAction:inputAction];
        [inputAlertController addAction:cancelAction];
        [inputAlertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"请输入条形码";
        }];
        [self presentViewController:inputAlertController animated:YES completion:nil];
    }];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"扫描条形码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        nil;
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:inputAction];
    [alertController addAction:cameraAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

// 通过条形码查询书籍
- (void)searchBookInfoWithIsbn:(NSString *)isbnString {
//    NSDictionary *dic = [self.jsonana backDictinary];
//    NSLog(@"viewController dic = %@", dic);
//    NSLog(@"dic---:%@", jsonana.dic);
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.douban.com/v2/book/isbn/:%@", isbnString]];
    NSDictionary *dic = [JSONAnalysis analysisWithURL:url];
    NSLog(@"dic:%@", dic);
    if (dic == nil) {
        [self errorHUDWithString:@"查询失败！"];
        return;
    }
    [self.bookArray addObject:dic];
    NSLog(@"bookArray:%@", self.bookArray);
    [self saveArrayToPlist:self.bookArray];
    [self.collectionView reloadData];
}


// 将字典数组保存到plist文件
- (void)saveArrayToPlist:(NSMutableArray *)array {
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/userBook.plist"];
    NSLog(@"%@", path);
    BOOL success = [array writeToFile:path atomically:YES];
    if (! success) {
        [self errorHUDWithString:@"保存失败！"];
    }
}
// 错误文字提示框
- (void)errorHUDWithString:(NSString *)string {
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        // Set the text mode to show only text.
        hud.mode = MBProgressHUDModeText;
        hud.label.text = string;
        // Move to bottm center.
        hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
        
        [hud hideAnimated:YES afterDelay:2.f];
    });
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
//    NSLog(@"%ld", indexPath.row);
    NSDictionary *dic = [NSDictionary dictionary];
    dic = _bookArray[indexPath.row];
    NSURL *imageURL = [NSURL URLWithString:dic[@"images"][@"large"]];
    cell.bookImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
    cell.bookNameLabel.text = dic[@"title"];
    
    return cell;
}


@end
