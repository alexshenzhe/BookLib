//
//  JSONAnalysis.m
//  testProject
//
//  Created by 沈喆 on 17/4/10.
//  Copyright © 2017年 沈喆. All rights reserved.
//

#import "JSONAnalysis.h"
#import "DoubanData.h"

@interface JSONAnalysis () <NSURLSessionDataDelegate>
//@property (nonatomic, copy) NSDictionary *dic;
@property (nonatomic, strong) NSMutableArray *bookArray; // 存放书本信息
@end

@implementation JSONAnalysis

+ (id)analysisWithURL:(NSURL *)url {
    NSError *errorData = nil;
    NSData *JSONData = [NSData dataWithContentsOfURL:url options:0 error:&errorData];
    NSLog(@"JSONData:%@", JSONData);
    NSLog(@"errorData%@", errorData);
    if (errorData) {
        return nil;
    }
    NSError *error = nil;
    id JSONObject = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:&error];
    NSLog(@"JSONObj:%@", JSONObject);
    if (JSONObject != nil && error == nil) {
        return JSONObject;
    }else{
        NSLog(@"JSON解析错误：%@", error);
        NSLog(@"error:%@", error);
        return nil;
    }
}

//- (instancetype)initAnalysisWithURL:(NSURL *)url {
//    if (self = [super init]) {
//        NSURLRequest *request = [NSURLRequest requestWithURL:url];
//        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:(id<NSURLSessionDataDelegate>)self delegateQueue:[NSOperationQueue mainQueue]];
//        NSURLSessionDataTask *task = [session dataTaskWithRequest:request];
//        [task resume];
//    }
//    return self;
//}
//
//- (NSDictionary *)backDictinary {
//    
//    return self.dic;
//}
//
//# pragma mark - NSURLSessionDataDelegate
//
//// 1.接收到服务器的响应
//- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
//    // 允许处理服务器的响应，才会继续接收服务器返回的数据
//    completionHandler(NSURLSessionResponseAllow);
//}
//
//// 2.接收到服务器的数据（可能调用多次）
//- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
//    NSLog(@"1.%@", session);
//    NSLog(@"2.%@", dataTask);
//    NSError *error = nil;
//    self.dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
//    NSLog(@"3.%@", self.dic);
//}
//
//// 3.请求成功或者失败（如果失败，error有值）
//- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
//    // 请求完成,成功或者失败的处理
//}

@end
