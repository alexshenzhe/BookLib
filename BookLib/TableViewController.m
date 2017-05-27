//
//  TableViewController.m
//  BookLib
//
//  Created by 沈喆 on 17/4/17.
//  Copyright © 2017年 沈喆. All rights reserved.
//

#import "TableViewController.h"
#import "TableViewCell.h"
#import "JSONAnalysis.h"
#import "BooksNavController.h"
#import "MBProgressHUD.h"
#import "CameraCaptureController.h"
#import "BooksCollectionViewController.h"
#import "BooksCollectionViewCell.h"
#import "DetailViewController.h"
#import "PopupDetailView.h"

@interface TableViewController () <JSONAnalysisDelegate, CameraCaptureControllerDelegate, BooksCollectionViewControllerDelegate, DetailViewControllerDelegate, UICollectionViewDelegate>

@property (nonatomic, strong) BooksCollectionViewController *favoriteCollectionViewController;
@property (nonatomic, strong) BooksCollectionViewController *readingCollectionViewController;
@property (nonatomic, strong) BooksCollectionViewController *haveReadCollectionViewController;
@property (nonatomic, strong) DetailViewController *detailViewController; // 详细信息页
@property (nonatomic, strong) NSMutableArray *favoriteBookArray; // 存放喜爱的书本信息
@property (nonatomic, strong) NSMutableArray *readingBookArray; // 存放正在读的书本信息
@property (nonatomic, strong) NSMutableArray *haveReadBookArray; // 存放已读书本信息
@property (nonatomic, strong) NSDictionary *currentDic; // 存储当前新增书本信息
@property (nonatomic, strong) JSONAnalysis *jsonAnalysis;
@property (nonatomic, strong) TableViewCell *tableViewCell;
@property (nonatomic, strong) PopupDetailView *popupView;

@end

@implementation TableViewController

static NSString *const reusetableViewCell = @"tableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNavigationBarStyle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 定义tableView样式
 */
- (instancetype)initWithStyle:(UITableViewStyle)style {
    return [super initWithStyle:UITableViewStyleGrouped];
}

/**
 设置子控件frame
 */
- (void)setNavigationBarStyle {
    // 设置导航栏按钮及文字
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBookInfo)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.navigationItem.leftBarButtonItem = nil;
    self.title = @"首页";
}

/**
 显示选择提示框
 */
- (void)addBookInfo {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    // 手动输入
    UIAlertAction *inputAction = [UIAlertAction actionWithTitle:@"输入" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIAlertController *inputAlertController = [UIAlertController alertControllerWithTitle:@"输入" message:@"请正确输入书本背后条形码数字" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *inputAction = [UIAlertAction actionWithTitle:@"搜索" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *textField = inputAlertController.textFields.firstObject;
            // loading动画
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
            hud.backgroundView.color = [UIColor colorWithWhite:0.f alpha:0.1f];
            
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
                [self searchBookInfoWithIsbn:textField.text];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES];
                });
            });
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [inputAlertController addAction:inputAction];
        [inputAlertController addAction:cancelAction];
        [inputAlertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"请输入条形码";
        }];
        [self presentViewController:inputAlertController animated:YES completion:nil];
    }];
    // 扫描条形码
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"扫描条形码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self captureIsbnByCamera];
    }];
    // 取消
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:inputAction];
    [alertController addAction:cameraAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
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
 查找书本信息
 */
- (void)searchBookInfoWithIsbn:(NSString *)isbnString {
    NSString *JSONString = [NSString stringWithFormat:@"https://api.douban.com/v2/book/isbn/:%@", isbnString];
    self.jsonAnalysis = [[JSONAnalysis alloc] initAnalysisWithURL:[NSURL URLWithString:JSONString]];
    self.jsonAnalysis.delegate = self;
}

/**
 保存到plist文件
 */
- (void)saveArrayToPlist:(NSMutableArray *)array withBookGroup:(NSString *)bookGroup {
    NSString *fileName = [NSString stringWithFormat:@"Documents/%@.plist", bookGroup];
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:fileName];
    NSLog(@"%@", path);
    BOOL success = [array writeToFile:path atomically:YES];
    if (! success) {
        [self errorHUDWithString:@"保存失败！"];
        return;
    }
    [self updateViewData];
}

/**
 刷新页面数据
 */
- (void)updateViewData {
    [self.favoriteCollectionViewController.collectionView reloadData];
    [self.tableView reloadData];
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

# pragma mark - Lazyload Method

- (NSMutableArray *)favoriteBookArray {
    if (_favoriteBookArray == nil) {
        _favoriteBookArray = [self loadingArray:_favoriteBookArray withPlistName:@"favoriteBook.plist"];
    }
    return _favoriteBookArray;
}

- (NSMutableArray *)readingBookArray {
    if (_readingBookArray == nil) {
        _readingBookArray = [self loadingArray:_readingBookArray withPlistName:@"readingBook.plist"];
    }
    return _readingBookArray;
}

- (NSMutableArray *)haveReadBookArray {
    if (_haveReadBookArray == nil) {
        _haveReadBookArray = [self loadingArray:_haveReadBookArray withPlistName:@"haveReadBook.plist"];
    }
    return _haveReadBookArray;
}

- (NSMutableArray *)loadingArray:(NSMutableArray *)loadArray withPlistName:(NSString *)plistName {
    NSString *plistPath = [NSString stringWithFormat:@"Documents/%@", plistName];
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:plistPath];
    NSArray *dicArray = [NSArray arrayWithContentsOfFile:path];
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in dicArray) {
        [array addObject:dic];
    }
    return array;
}


# pragma mark - show PopupView

- (void)showPopupDetailViewWithBookInfo:(NSDictionary *)bookInfo {
    self.popupView = [PopupDetailView popupViewWithParentView:self.view infoDic:bookInfo];
    // 禁止页面滚动
    self.tableView.scrollEnabled = NO;
    // 修改导航栏功能
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelToAddBook)];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(sureToAddBook)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = doneButton;
}

- (void)cancelToAddBook {
    NSLog(@"CANCEL");
    // 恢复页面滚动
    self.tableView.scrollEnabled = YES;
    [self.popupView killCoverAndPopupView];
    [self setNavigationBarStyle];
}

- (void)sureToAddBook {
    NSLog(@"SURE");
    self.tableView.scrollEnabled = YES;
    // 保存当前书本信息到待读
    [self.favoriteBookArray addObject:self.currentDic];
    [self saveArrayToPlist:self.favoriteBookArray withBookGroup:@"favoriteBook"];
    [self.popupView killCoverAndPopupView];
    [self setNavigationBarStyle];
}

# pragma mark - DetailViewControllerDelegate

-(void)DetailViewControllerDelegate:(DetailViewController *)detailViewController withIndexPath:(NSIndexPath *)indexPath andTableViewCellSection:(NSInteger)section fromBookGroup:(NSString *)bookGroupFrom toBookGroup:(NSString *)bookGroupTo {
    NSMutableArray *arrayFrom = [NSMutableArray array];
    NSMutableArray *arrayTo = [NSMutableArray array];
    //  判断当前所属组
    if (section == 0) {
        arrayFrom = self.favoriteBookArray;
    } else if (section == 1) {
        arrayFrom = self.readingBookArray;
    } else if (section == 2) {
        arrayFrom = self.haveReadBookArray;
    }
    // 在当前组删除书本信息
    [arrayFrom removeObjectAtIndex:indexPath.row];
    [self saveArrayToPlist:arrayFrom withBookGroup:bookGroupFrom];
    //  如果是删除操作则退出页面
    if ([bookGroupTo isEqualToString:@"delete"]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    // 判断选择保存的组
    if ([bookGroupTo isEqualToString:@"favoriteBook"]) {
        arrayTo = self.favoriteBookArray;
    } else if ([bookGroupTo isEqualToString:@"readingBook"]) {
        arrayTo = self.readingBookArray;
    } else if ([bookGroupTo isEqualToString:@"haveReadBook"]) {
        arrayTo = self.haveReadBookArray;
    }
    [arrayTo addObject:detailViewController.bookInfoDic];
    [self saveArrayToPlist:arrayTo withBookGroup:bookGroupTo];
    // 退出详细页
    [self.navigationController popViewControllerAnimated:YES];
}

# pragma mark - BooksCollectionViewControllerDelegate

- (void)booksConllectionViewController:(BooksCollectionViewController *)booksConllectionViewController didSelectAtItemIndexPath:(NSIndexPath *)indexPath withTableViewSection:(NSInteger)section withData:(NSDictionary *)dic {
    NSLog(@"我选择了NO.%ld，title:%@", indexPath.row, dic[@"title"]);
    self.detailViewController = [[DetailViewController alloc] init];
    self.detailViewController.delegate = self;
    // 传递组信息
    self.detailViewController.tableViewCellSection = section;
    // 传递书本索引
    self.detailViewController.indexPath = indexPath;
    // 传递书本信息
    self.detailViewController.bookInfoDic = dic;
    [self.navigationController pushViewController:self.detailViewController animated:YES];
}

# pragma mark - CameraReadControllerDelegate

- (void)cameraCaptureSuccess:(CameraCaptureController *)cameraCaptureController values:(NSString *)value {
    [self searchBookInfoWithIsbn:value];
    [self.navigationController popViewControllerAnimated:YES];
}

# pragma mark - JSONAnalysisDelegate

- (void)JSONAnalysisSuccess:(JSONAnalysis *)jsonAnalysis dictionary:(NSDictionary *)dic {
    NSString *errorCode = dic[@"code"];
    if (errorCode) {
        NSString *errorString = [NSString stringWithFormat:@"查询失败，错误代码为%@", errorCode];
        NSLog(@"errorString%@", errorString);
        [self errorHUDWithString:errorString];
        return;
    }
    self.currentDic = dic;
    [self showPopupDetailViewWithBookInfo:dic];
}

#pragma mark - TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BooksCollectionViewController *collectionViewController = [[BooksCollectionViewController alloc] init];
    // 为不同组添加内容
    if (indexPath.section == 0) {
        self.favoriteCollectionViewController = collectionViewController;
        collectionViewController.favoriteBookArray = self.favoriteBookArray;
    } else if (indexPath.section == 1) {
        self.readingCollectionViewController = collectionViewController;
        collectionViewController.readingBookArray = self.readingBookArray;
    } else if (indexPath.section == 2) {
        self.haveReadCollectionViewController = collectionViewController;
        collectionViewController.haveReadBookArray = self.haveReadBookArray;
    }
    self.tableViewCell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusetableViewCell collectionViewController:collectionViewController];
    collectionViewController.delegate = self;
    // 传递分组信息
    [self.tableViewCell setTableViewSection:indexPath.section];
    return self.tableViewCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 314;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *headerString = [NSString string];
    if (section == 0) {
        headerString = @"待读";
    } else if (section == 1) {
        headerString = @"在读";
    } else if (section == 2){
        headerString = @"已读";
    }
    return headerString;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
