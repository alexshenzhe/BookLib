//
//  PopupDetailView.h
//  BookLib
//
//  Created by 沈喆 on 17/4/24.
//  Copyright © 2017年 沈喆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopupDetailView : UIView

- (instancetype)initWithParentView:(UIView *)parentView infoDic:(NSDictionary *)infoDic;
+ (instancetype)popupViewWithParentView:(UIView *)parentView infoDic:(NSDictionary *)infoDic;
- (void)killCover;

@end
