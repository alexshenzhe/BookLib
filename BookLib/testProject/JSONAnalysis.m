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
@end

@implementation JSONAnalysis

- (instancetype)initAnalysisWithURL:(NSURL *)url {
    if (self = [super init]) {
        // 全局队列异步操作
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            // 解析
            NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
            NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:(id<NSURLSessionDataDelegate>)self delegateQueue:[NSOperationQueue mainQueue]];
            NSURLSessionDataTask *task = [session dataTaskWithRequest:request];
            [task resume];
        });
    }
    return self;
}

+ (instancetype)analysisWithURL:(NSURL *)url {
    return [[self alloc] initAnalysisWithURL:url];
}

#pragma mark - NSURLSessionDataDelegate

/**
 * 接收到服务器的响应
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    // 允许处理服务器的响应，才会继续接收服务器返回的数据
    completionHandler(NSURLSessionResponseAllow);
}

/**
 * 接收到服务器的数据
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    // 通知代理
    if ([self.delegate respondsToSelector:@selector(JSONAnalysisSuccess:dictionary:)]) {
        [self.delegate JSONAnalysisSuccess:self dictionary:dic];
    }
}

/**
 * 请求成功或者失败的处理
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    // 暂时不做处理
}

@end
