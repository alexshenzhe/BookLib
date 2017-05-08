//
//  PopupDetailView.h
//  BookLib
//
//  Created by 沈喆 on 17/4/24.
//  Copyright © 2017年 沈喆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopupDetailView : UIView

/**
 创建popupView
 */
- (instancetype)initWithParentView:(UIView *)parentView infoDic:(NSDictionary *)infoDic;
+ (instancetype)popupViewWithParentView:(UIView *)parentView infoDic:(NSDictionary *)infoDic;


/**
 清除阴影及popupView
 */
- (void)killCover;

@end
