//
//  JhtFileModel.h
//  JhtTools
//
//  Created by Jht on 16/7/11.
//  Copyright © 2016年 靳海涛. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/** 用于下载文档的Model */
@interface JhtFileModel : NSObject

@property (nonatomic, copy) NSString *fileId;
@property (nonatomic, copy) NSString *vFileName;
@property (nonatomic, copy) NSString *vContentType;
@property (nonatomic, copy) NSString *vUrl;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *vFileId;
@property (nonatomic, copy) NSString *contentType;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *fileType;

// 注意这里一定要是：KB,MB,GB,Bytes
@property (nonatomic, copy) NSString *fileSize;
@property (nonatomic, copy) NSString *attachmentFileSize;

/** 如果是本地的，绝对路径 */
@property (nonatomic, copy) NSString *fileAbsolutePath;


@end

