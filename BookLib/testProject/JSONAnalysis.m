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
@property (nonatomic, strong) NSMutableArray *bookArray; // to save book info
@property (nonatomic, copy) NSDictionary *dic; // to save the dictionary from JSON
@end

@implementation JSONAnalysis

- (instancetype)initAnalysisWithURL:(NSURL *)url {
    if (self = [super init]) {
        // 全局队列异步操作
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:(id<NSURLSessionDataDelegate>)self delegateQueue:[NSOperationQueue mainQueue]];
            NSURLSessionDataTask *task = [session dataTaskWithRequest:request];
            [task resume];
        });
    }
    return self;
}

#pragma mark - NSURLSessionDataDelegate

// 接收到服务器的响应
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    // 允许处理服务器的响应，才会继续接收服务器返回的数据
    completionHandler(NSURLSessionResponseAllow);
}

// 接收到服务器的数据
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    NSLog(@"1.%@", session);
    NSLog(@"2.%@", dataTask);
    NSError *error = nil;
    self.dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    // call delegate
    if ([self.delegate respondsToSelector:@selector(JSONAnalysisSuccess:dictionary:)]) {
        [self.delegate JSONAnalysisSuccess:self dictionary:self.dic];
    }
    NSLog(@"3.%@", self.dic);
}

// 请求成功或者失败的处理
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {

}

@end
