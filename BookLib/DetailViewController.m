//
//  DetailViewController.m
//  BookLib
//
//  Created by 沈喆 on 17/4/20.
//  Copyright © 2017年 沈喆. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NSString *titleString = self.bookDic[@"title"];
    NSLog(@"DetailViewController,dic=%@", self.bookDic[@"title"]);
    self.title = titleString;
    [self subviewsFrame];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 设置子控件的frame
 */
- (void)subviewsFrame {
    UIImageView *bookImage = [[UIImageView alloc] init];
    bookImage.frame = CGRectMake(20, 84, 200, 250);
    bookImage.backgroundColor = [UIColor purpleColor];
    NSURL *imageURL = [NSURL URLWithString:self.bookDic[@"images"][@"large"]];
    bookImage.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
    [self.view addSubview:bookImage];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
