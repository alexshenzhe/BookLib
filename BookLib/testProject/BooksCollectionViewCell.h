//
//  BooksCollectionViewCell.h
//  testProject
//
//  Created by 沈喆 on 17/4/10.
//  Copyright © 2017年 沈喆. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BooksCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *bookImage; // 封面图片
@property (nonatomic, copy) NSString *bookName; // 书本名称

@end
