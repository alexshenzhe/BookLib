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
- (void)JSONAnalysisSuccess:(JSONAnalysis *)jsonAnalysis dictionary:(NSDictionary *)dic;

@end

@class DoubanData;
@interface JSONAnalysis : NSObject

@property (nonatomic, weak) id<JSONAnalysisDelegate> delegate;

- (instancetype)initAnalysisWithURL:(NSURL *)url;

@end
