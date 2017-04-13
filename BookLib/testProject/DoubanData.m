//
//  DoubanData.m
//  testProject
//
//  Created by 沈喆 on 17/4/11.
//  Copyright © 2017年 沈喆. All rights reserved.
//

#import "DoubanData.h"

@implementation DoubanData

- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
//        [dic setValuesForKeysWithDictionary:dic];
        self.bookTitle = [dic objectForKey:@"title"];     // 书名
        self.isbn13 = [dic objectForKey:@"isbn13"];     // ISBN码
        self.image = [dic objectForKey:@"image"];      // 图片
        self.publisher = [dic objectForKey:@"publisher"];  // 出版社
        self.price = [dic objectForKey:@"price"];      // 价格
        self.author = [dic objectForKey:@"author"];    // 作者
        self.images = [dic objectForKey:@"images"];
    }
    return self;
}

+ (instancetype)dataWithDic:(NSDictionary *)dic {
    return [[self alloc] initWithDic:dic];
}

@end
