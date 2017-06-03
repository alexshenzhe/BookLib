//
//  PopupView.h
//  BookLib
//
//  Created by 沈喆 on 17/4/24.
//  Copyright © 2017年 沈喆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopupView : UIView

/**
 创建Detail PopupView
 */
- (instancetype)initPopupViewForDetailWithView:(UITableView *)parentView bookInfoDic:(NSDictionary *)bookInfoDic;
+ (instancetype)popupViewForDetailWithView:(UITableView *)parentView bookInfoDic:(NSDictionary *)bookInfoDic;

- (instancetype)initPopupViewForCopyrightInfoWithView:(UIView *)parentView bookInfoDic:(NSDictionary *)bookInfoDic;
+ (instancetype)popupViewForCopyrightInfoWithView:(UIView *)parentView bookInfoDic:(NSDictionary *)bookInfoDic;
/**
 清除阴影及popupView
 */
- (void)killCoverAndPopupView;

@end
