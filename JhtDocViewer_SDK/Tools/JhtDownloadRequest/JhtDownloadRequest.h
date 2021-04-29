//
//  JhtDownloadRequest.h
//  JhtTools
//
//  GitHub主页: https://github.com/jinht
//  CSDN博客: http://blog.csdn.net/anticipate91
//
//  Created by Jht on 16/7/10.
//  Copyright © 2016年 JhtDocViewer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JhtDownloadRequest : NSObject

#pragma mark - Public Method
/** 单例 */
+ (id)sharedInstance;

/** 下载文件功能
 *  URLString: 下载文件 URL
 *  downloadFileProgress: 下载的进度条（百分比）
 *  setupFilePath: 设置下载 路径
 *  downloadCompletionHandler: 下载完成后（下载完成后可拿到存储的路径）
 */
+ (void)createDownloadFileWithURLString:(NSString *)URLString downloadFileProgress:(void(^)(NSProgress *downloadProgress))downloadFileProgress setupFilePath:(NSURL *(^)(NSURLResponse *response))setupFilePath downloadCompletionHandler:(void (^)(NSURL *filePath, NSError *error))downloadCompletionHandler;

/** 停止 下载文件 */
+ (void)stopDownloadFile;


@end
