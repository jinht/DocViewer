//
//  JhtDownloadRequest.m
//  JhtTools
//
//  GitHub主页: https://github.com/jinht
//  CSDN博客: http://blog.csdn.net/anticipate91
//
//  Created by Jht on 16/7/10.
//  Copyright © 2016年 JhtDocViewer. All rights reserved.
//

#import "JhtDownloadRequest.h"
#import "AFHTTPSessionManager.h"

#define TIME_NETOUT 20.0f

@implementation JhtDownloadRequest {
    AFHTTPSessionManager *_HTTPManager;
    NSURLSessionDownloadTask *_dataTask;
}

#pragma mark - Init
- (id)init {
    if (self = [super init]) {
        _HTTPManager = [AFHTTPSessionManager manager];
        _HTTPManager.requestSerializer.HTTPShouldHandleCookies = YES;
        
        _HTTPManager.requestSerializer  = [AFHTTPRequestSerializer serializer];
        _HTTPManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [_HTTPManager.requestSerializer setTimeoutInterval:TIME_NETOUT];
        
        // 版本号信息 放入 请求头中
        [_HTTPManager.requestSerializer setValue:[NSString stringWithFormat:@"iOS-%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]] forHTTPHeaderField:@"MM-Version"];
        
        [_HTTPManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept" ];
        _HTTPManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/html", @"text/plain", nil];
    }
    
    return self;
}


#pragma mark - Public Method
+ (id)sharedInstance {
    static JhtDownloadRequest * HTTPCommunicate;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        HTTPCommunicate = [[JhtDownloadRequest alloc] init];
    });
    
    return HTTPCommunicate;
}

+ (void)createDownloadFileWithURLString:(NSString *)URLString downloadFileProgress:(void(^)(NSProgress *downloadProgress))downloadFileProgress setupFilePath:(NSURL *(^)(NSURLResponse *response))setupFilePath downloadCompletionHandler:(void (^)(NSURL *filePath, NSError *error))downloadCompletionHandler {
    if (URLString) {
        [[JhtDownloadRequest sharedInstance]createUnloginedDownloadFileWithURLString:URLString downloadFileProgress:downloadFileProgress setupFilePath:setupFilePath downloadCompletionHandler:downloadCompletionHandler];
    }
}

/** 停止 下载文件 */
+ (void)stopDownloadFile {
    [[JhtDownloadRequest sharedInstance] pause];
}


#pragma mark - Private Method
- (void)createUnloginedDownloadFileWithURLString:(NSString *)URLString downloadFileProgress:(void(^)(NSProgress *downloadProgress))downloadFileProgress setupFilePath:(NSURL*(^)(NSURLResponse *response))setupFilePath downloadCompletionHandler:(void (^)(NSURL *filePath, NSError *error))downloadCompletionHandler {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString] cachePolicy:1 timeoutInterval:15];
    
    _dataTask = [_HTTPManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        // 下载进度
        downloadFileProgress(downloadProgress);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        // 设置保存目录
        return setupFilePath(response);
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        // 下载完成
        downloadCompletionHandler(filePath,error);
        
    }];
    
    [_dataTask resume];
}

/** 暂停 下载文件 */
- (void)pause {
    // 暂停
    [_dataTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        
    }];
    
    _dataTask = nil;
}


@end
