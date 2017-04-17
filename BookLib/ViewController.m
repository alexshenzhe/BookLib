//
//  ViewController.m
//  BookLib
//
//  Created by 沈喆 on 17/4/12.
//  Copyright © 2017年 沈喆. All rights reserved.
//

#import "ViewController.h"
#import "JSONAnalysis.h"
#import "BookInfoCollectionViewCell.h"
#import "BooksNavController.h"
#import "MBProgressHUD.h"
#import "CameraCaptureController.h"
#import "BooksCollectionViewController.h"

@interface ViewController () <JSONAnalysisDelegate, CameraCaptureControllerDelegate>

//@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) BooksCollectionViewController *collectionViewController;
@property (nonatomic, strong) NSMutableArray *bookArray; // 存放书本信息
@property (nonatomic, strong) JSONAnalysis *jsonAnalysis;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewDidLoad");
    [self subviewsFrame];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)bookArray {
    NSLog(@"setbookArray");
    if (_bookArray == nil) {
        NSLog(@"in setbookArray");
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/userBook.plist"];
        NSArray *dicArray = [NSArray arrayWithContentsOfFile:path];
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dic in dicArray) {
            [array addObject:dic];
        }
        _bookArray = array;
    }
    return _bookArray;
}

/**
 设置子控件的frame
 */
- (void)subviewsFrame {
    // 设置导航栏按钮及文字
    UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(deleteBookInfo)];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBookInfo)];
    self.navigationItem.leftBarButtonItem = deleteButton;
    self.navigationItem.rightBarButtonItem = addButton;
    self.title = @"BOOKLib";
    
    // 创建collection
    self.collectionViewController = [[BooksCollectionViewController alloc] init];
    [self.view addSubview:self.collectionViewController.collectionView];
}

/**
 显示选择提示框
 */
- (void)addBookInfo {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *inputAction = [UIAlertAction actionWithTitle:@"输入" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIAlertController *inputAlertController = [UIAlertController alertControllerWithTitle:@"输入" message:@"请正确输入书本背后条形码数字" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *inputAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *textField = inputAlertController.textFields.firstObject;
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
            hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
            [self searchBookInfoWithIsbn:textField.text];
            [hud hideAnimated:YES];
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
        [self captureIsbnByCamera];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:inputAction];
    [alertController addAction:cameraAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

/**
 查找书本信息
 */
- (void)searchBookInfoWithIsbn:(NSString *)isbnString {
    NSString *JSONString = [NSString stringWithFormat:@"https://api.douban.com/v2/book/isbn/:%@", isbnString];
    self.jsonAnalysis = [[JSONAnalysis alloc] initAnalysisWithURL:[NSURL URLWithString:JSONString]];
    self.jsonAnalysis.delegate = self;
}

/**
 删除书本信息
 */
- (void)deleteBookInfo {
    [self.bookArray removeLastObject];
    self.collectionViewController.bookArray = self.bookArray;
    [self.collectionViewController.collectionView reloadData];
    [self saveArrayToPlist:self.bookArray];
}

/**
 扫描条形码
 */
- (void)captureIsbnByCamera {
    CameraCaptureController *cameraCapture = [[CameraCaptureController alloc] init];
    [self.navigationController pushViewController:cameraCapture animated:YES];
    [cameraCapture cameraStartCapture];
    cameraCapture.delegate = self;
}

/**
 保存到plist文件
 */
- (void)saveArrayToPlist:(NSMutableArray *)array {
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/userBook.plist"];
    NSLog(@"%@", path);
    BOOL success = [array writeToFile:path atomically:YES];
    if (! success) {
        [self errorHUDWithString:@"保存失败！"];
    }
}

/**
 显示错误文字提示框
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

# pragma mark - CameraReadControllerDelegate

- (void)cameraCaptureSuccess:(CameraCaptureController *)cameraCaptureController values:(NSString *)value {
    NSLog(@"isbn-----%@", value);
    [self searchBookInfoWithIsbn:value];
    [self.navigationController popViewControllerAnimated:YES];
}

# pragma mark - JSONAnalysisDelegate

- (void)JSONAnalysisSuccess:(JSONAnalysis *)jsonAnalysis dictionary:(NSDictionary *)dic {
    NSString *errorCode = dic[@"code"];
    NSLog(@"delegate:%@--------code:%@", dic, dic[@"code"]);
    NSLog(@"self.errorCode:%@", errorCode);
    if (errorCode) {
        NSString *errorString = [NSString stringWithFormat:@"查询错误，错误代码为%@", errorCode];
        NSLog(@"errorString%@", errorString);
        [self errorHUDWithString:errorString];
        return;
    }
    [self.bookArray addObject:dic];
    NSLog(@"bookArray:%@", self.bookArray);
    [self saveArrayToPlist:self.bookArray];
    self.collectionViewController.bookArray = self.bookArray;
    [self.collectionViewController.collectionView reloadData];
}

@end
