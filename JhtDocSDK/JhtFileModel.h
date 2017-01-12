//
//  JhtFileModel.h
//  JhtTools
//
//  github主页: https://github.com/jinht
//  CSDN博客: http://blog.csdn.net/anticipate91
//
//  Created by Jht on 16/7/11.
//  Copyright © 2016年 靳海涛. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 文件类型 */
typedef NS_ENUM(NSUInteger, JhtFileType) {
    // word || doc || docx
    Type_Docx = 0,
    // excel || xls || xlsx
    Type_Xlsx = 1,
    // ppt || pptx
    Type_Pptx = 2,
    // pdf
    Type_Pdf = 3,
    // txt
    Type_Txt = 4,
};


/** 下载文档的Model */
@interface JhtFileModel : NSObject
/** 文件ID */
@property (nonatomic, copy) NSString *fileId;
/** 文件名 */
@property (nonatomic, copy) NSString *fileName;
/** 文件下载路径 */
@property (nonatomic, copy) NSString *url;
/** 如果是本地的，绝对路径 */
@property (nonatomic, copy) NSString *fileAbsolutePath;

/** 文件类型 */
@property (nonatomic, assign) JhtFileType viewFileType;

/** 注意单位一定要是：KB,MB,GB,Bytes */
@property (nonatomic, copy) NSString *fileSize;
/** 附件文件大小 */
@property (nonatomic, copy) NSString *attachmentFileSize;


@end

/** for example：
    fileModel.fileId = @"577e2300c94f6e51316a299d";
    fileModel.fileName = @"哈哈哈.docx";
    fileModel.url = @"http://mexue-inform-file.oss-cn-beijing.aliyuncs.com/577e2300c94f6e51316a299d";
    fileModel.fileType = @"docx";
    fileModel.fileSize = @"21.39KB";
    fileModel.attachmentFileSize = @"21906";
 */


