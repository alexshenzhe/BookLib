//
//  JSONAnalysis.m
//  testProject
//
//  Created by 沈喆 on 17/4/10.
//  Copyright © 2017年 沈喆. All rights reserved.
//

#import "JSONAnalysis.h"
#import "DoubanData.h"

@interface JSONAnalysis ()

@end

@implementation JSONAnalysis

+ (id)analysisWithURL:(NSURL *)url {
    NSData *JSONData = [NSData dataWithContentsOfURL:url];
    NSError *error = nil;
    id JSONObject = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:&error];
    if (JSONObject != nil && error == nil) {
        return JSONObject;
    }else{        
        NSLog(@"JSON解析错误：%@", error);
        return nil;   
    }
}

@end
