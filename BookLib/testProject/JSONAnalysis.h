//
//  JSONAnalysis.h
//  testProject
//
//  Created by 沈喆 on 17/4/10.
//  Copyright © 2017年 沈喆. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JSONAnalysis;
@protocol JSONAnalysisDelegate <NSObject>

@optional
/**
 * 代理方法：传递解析结果
 */
- (void)JSONAnalysisSuccess:(JSONAnalysis *)jsonAnalysis dictionary:(NSDictionary *)dic;

@end

@interface JSONAnalysis : NSObject

@property (nonatomic, weak) id<JSONAnalysisDelegate> delegate;

/**
 * 创建
 */
- (instancetype)initAnalysisWithURL:(NSURL *)url;
+ (instancetype)analysisWithURL:(NSURL *)url;

@end
