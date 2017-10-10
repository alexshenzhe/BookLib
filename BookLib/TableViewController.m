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
#import "PopupView.h"
#import "Reachability.h"

@interface TableViewController () <JSONAnalysisDelegate, CameraCaptureControllerDelegate, BooksCollectionViewControllerDelegate, DetailViewControllerDelegate, UICollectionViewDelegate>

@property (nonatomic, strong) BooksCollectionViewController *favoriteCollectionViewController;
@property (nonatomic, strong) BooksCollectionViewController *readingCollectionViewController;
@property (nonatomic, strong) BooksCollectionViewController *haveReadCollectionViewController;
@property (nonatomic, strong) DetailViewController *detailViewController;   // 详细信息页
@property (nonatomic, strong) NSMutableArray *favoriteBookArray;            // 存放喜爱的书本信息
@property (nonatomic, strong) NSMutableArray *readingBookArray;             // 存放正在读的书本信息
@property (nonatomic, strong) NSMutableArray *haveReadBookArray;            // 存放已读书本信息
@property (nonatomic, strong) NSDictionary *currentDic;                     // 存储当前新增书本信息
@property (nonatomic, strong) JSONAnalysis *jsonAnalysis;
@property (nonatomic, strong) TableViewCell *tableViewCell;
@property (nonatomic, strong) PopupView *popupView;

@end

@implementation TableViewController

static NSString *const reusetableViewCell = @"tableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.showsVerticalScrollIndicator = NO;
    [self setNavigationBarStyleWithPopupView:NO];
    if (![self checkNetworkStatus]) {
        [self showMessageHUDWithString:@"网络连接失败，部分内容无法显示！"];
        return;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * 定义tableView样式
 */
- (instancetype)initWithStyle:(UITableViewStyle)style {
    return [super initWithStyle:UITableViewStyleGrouped];
}

#pragma mark - NavigatingBar Style

/**
 * 设置导航栏样式
 */
- (void)setNavigationBarStyleWithPopupView:(BOOL)isPopupView {
    if (!isPopupView) {
        // 默认时导航栏
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                   target:self
                                                                                   action:@selector(addBookInfo)];
        self.navigationItem.rightBarButtonItem = addButton;
        self.navigationItem.leftBarButtonItem = nil;
        self.title = @"书架";
    } else {
        // popupView 时导航栏
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                         style:UIBarButtonItemStylePlain
                                                                        target:self
                                                                        action:@selector(cancelToAddBook)];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"添加"
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(sureToAddBook)];
        self.navigationItem.leftBarButtonItem = cancelButton;
        self.navigationItem.rightBarButtonItem = doneButton;
        self.title = @"简介";
    }
}

/**
 * 取消添加
 */
- (void)cancelToAddBook {
    // 恢复页面滚动
    self.tableView.scrollEnabled = YES;
    [self.popupView hideCoverAndPopupView];
    [self setNavigationBarStyleWithPopupView:NO];
}

/**
 * 确定添加
 */
- (void)sureToAddBook {
    self.tableView.scrollEnabled = YES;
    // 保存当前书本信息到待读
    [self.favoriteBookArray addObject:self.currentDic];
    [self saveArrayToPlist:self.favoriteBookArray withBookGroup:@"favoriteBook"];
    [self.popupView hideCoverAndPopupView];
    [self setNavigationBarStyleWithPopupView:NO];
}

/**
 * 添加书本，显示选择提示框
 */
- (void)addBookInfo {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    // 手动输入
    UIAlertAction *inputAction = [UIAlertAction actionWithTitle:@"输入" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIAlertController *inputAlertController = [UIAlertController alertControllerWithTitle:@"输入条形码" message:@"请正确输入书本背后13位条形码数字" preferredStyle:UIAlertControllerStyleAlert];
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
            textField.placeholder = @"请输入13位条形码";
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

#pragma mark - Current Method

/**
 * 扫描条形码
 */
- (void)captureIsbnByCamera {
    CameraCaptureController *cameraCapture = [[CameraCaptureController alloc] init];
    cameraCapture.delegate = self;
    [self.navigationController pushViewController:cameraCapture animated:YES];
    // 开始识别条形码
    [cameraCapture cameraStartCapture];
}

/**
 * 查找书本信息
 */
- (void)searchBookInfoWithIsbn:(NSString *)isbnString {
    if (![self checkNetworkStatus]) {
        [self showMessageHUDWithString:@"网络连接失败，请检查网络！"];
        return;
    }
    NSString *JSONString = [NSString stringWithFormat:@"https://api.douban.com/v2/book/isbn/:%@", isbnString];
    self.jsonAnalysis = [[JSONAnalysis alloc] initAnalysisWithURL:[NSURL URLWithString:JSONString]];
    self.jsonAnalysis.delegate = self;
}

/**
 * 检查当前网络是否存在
 */
- (BOOL)checkNetworkStatus {
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            break;
    }
    if (!isExistenceNetwork) {
        return NO;
    }
    return YES;
}

/**
 * 保存到plist文件
 */
- (void)saveArrayToPlist:(NSMutableArray *)array withBookGroup:(NSString *)bookGroup {
    NSString *fileName = [NSString stringWithFormat:@"Documents/%@.plist", bookGroup];
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:fileName];
    NSLog(@"%@", path);
    BOOL success = [array writeToFile:path atomically:YES];
    if (! success) {
        [self showMessageHUDWithString:@"保存失败！"];
        return;
    }
    [self updateViewData];
}

/**
 * 刷新页面数据
 */
- (void)updateViewData {
    [self.favoriteCollectionViewController.collectionView reloadData];
    [self.tableView reloadData];
}

/**
 * 显示错误文字弹出框
 */
- (void)showMessageHUDWithString:(NSString *)string {
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        // 设置显示模式
        hud.mode = MBProgressHUDModeText;
        hud.label.text = string;
        hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
        // 持续时间
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

/**
 * 通用懒加载
 */
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

# pragma mark - Show PopupView

/**
 * 显示弹窗
 */
- (void)showPopupDetailViewWithBookInfoDic:(NSDictionary *)bookInfoDic {
    self.popupView = [PopupView popupViewForDetailWithTableView:self.tableView bookInfoDic:bookInfoDic];
    // 禁止tableview页面滚动
    self.tableView.scrollEnabled = NO;
    // 修改导航栏功能
    [self setNavigationBarStyleWithPopupView:YES];
}

# pragma mark - DetailViewControllerDelegate

-(void)DetailViewControllerDelegate:(DetailViewController *)detailViewController withIndexPath:(NSIndexPath *)indexPath andTableViewCellSection:(NSInteger)section fromBookGroup:(NSString *)bookGroupFrom toBookGroup:(NSString *)bookGroupTo {
    NSMutableArray *arrayFrom = [NSMutableArray array];
    NSMutableArray *arrayTo = [NSMutableArray array];
    // 判断当前所属组
    switch (section) {
        case 0:
            arrayFrom = self.favoriteBookArray;
            break;
        case 1:
            arrayFrom = self.readingBookArray;
            break;
        case 2:
            arrayFrom = self.haveReadBookArray;
            break;
    }
    // 在当前组删除书本信息
    [arrayFrom removeObjectAtIndex:indexPath.row];
    [self saveArrayToPlist:arrayFrom withBookGroup:bookGroupFrom];
    //  如果是删除操作则退出页面
    if ([bookGroupTo isEqualToString:@"delete"]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    // 判断组并保存
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
    self.detailViewController = [[DetailViewController alloc] init];
    self.detailViewController.delegate = self;
    // 传递组信息／书本索引／书本信息
    self.detailViewController.tableViewCellSection = section;
    self.detailViewController.indexPath = indexPath;
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
        [self showMessageHUDWithString:errorString];
        return;
    }
    self.currentDic = dic;
    [self showPopupDetailViewWithBookInfoDic:dic];
}

#pragma mark - TableViewDataSource

/**
 * 组
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

/**
 * 行
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

/**
 * 行数据
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BooksCollectionViewController *collectionViewController = [[BooksCollectionViewController alloc] init];
    // 为不同组添加内容
    switch (indexPath.section) {
        case 0:
            self.favoriteCollectionViewController = collectionViewController;
            collectionViewController.favoriteBookArray = self.favoriteBookArray;
            break;
        case 1:
            self.readingCollectionViewController = collectionViewController;
            collectionViewController.readingBookArray = self.readingBookArray;
            break;
        case 2:
            self.haveReadCollectionViewController = collectionViewController;
            collectionViewController.haveReadBookArray = self.haveReadBookArray;
            break;
    }
    self.tableViewCell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusetableViewCell collectionViewController:collectionViewController];
    collectionViewController.delegate = self;
    // 传递分组信息
    [self.tableViewCell setTableViewSection:indexPath.section];
    return self.tableViewCell;
}

/**
 * 行高
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 314;
}

/**
 * 头标题高
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

/**
 * 头标题
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *headerString = [NSString string];
    switch (section) {
        case 0:
            headerString = @"待读";
            break;
        case 1:
            headerString = @"在读";
            break;
        case 2:
            headerString = @"已读";
            break;
    }
    return headerString;
}

@end
