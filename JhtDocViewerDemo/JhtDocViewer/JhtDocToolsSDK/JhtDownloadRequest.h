//
//  CKHttpCommunicate.h
//  MumMum
//
//  Created by Jht on 16/7/10.
//  Copyright © 2016年 靳海涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JhtDownloadRequest : NSObject

+ (id)sharedInstance;
/** 下载文件功能
 *  @param URLString                 要下载文件的URL
 *  @param downloadFileProgress      下载的进度条，百分比
 *  @param setupFilePath             设置下载的路径
 *  @param downloadCompletionHandler 下载完成后（下载完成后可拿到存储的路径）
 */
+ (void)createDownloadFileWithURLString:(NSString *)URLString
             downloadFileProgress:(void(^)(NSProgress *downloadProgress))downloadFileProgress
                    setupFilePath:(NSURL*(^)(NSURLResponse *response))setupFilePath
        downloadCompletionHandler:(void (^)(NSURL *filePath, NSError *error))downloadCompletionHandler;

/** 停止 下载文件 */
+ (void)stopDownloadFile;


@end
