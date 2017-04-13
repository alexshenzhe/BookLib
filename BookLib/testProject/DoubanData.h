//
//  DoubanData.h
//  testProject
//
//  Created by 沈喆 on 17/4/11.
//  Copyright © 2017年 沈喆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DoubanData : NSObject
@property (nonatomic, copy) NSString *bookTitle;      // 书名
@property (nonatomic, copy) NSString *isbn13;     // ISBN码
@property (nonatomic, copy) NSString *image;      // 图片
@property (nonatomic, copy) NSString *publisher;  // 出版社
@property (nonatomic, copy) NSString *price;      // 价格
@property (nonatomic, copy) NSString *author;     // 作者
@property (nonatomic, copy) NSDictionary *images; // 图片

- (instancetype)initWithDic:(NSDictionary *)dic;
+ (instancetype)dataWithDic:(NSDictionary *)dic;
@end
