//
//  JhtFileModel.h
//  JhtTools
//
//  GitHub主页: https://github.com/jinht
//  CSDN博客: http://blog.csdn.net/anticipate91
//
//  Created by Jht on 16/7/11.
//  Copyright © 2016年 JhtDocViewer. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 文件类型 */
typedef NS_ENUM(NSUInteger, Jht_FileType) {
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


/** 下载文件的Model */
@interface JhtFileModel : NSObject

#pragma mark - property
#pragma mark required
/** 文件ID */
@property (nonatomic, strong) NSString *fileId;
/** 文件名 */
@property (nonatomic, strong) NSString *fileName;
/** 文件下载路径 */
@property (nonatomic, strong) NSString *url;
/** 如果是本地的，绝对路径 */
@property (nonatomic, strong) NSString *fileAbsolutePath;

/** 文件类型 */
@property (nonatomic, assign) Jht_FileType viewFileType;

/** 注意单位一定要是：KB,MB,GB,Bytes */
@property (nonatomic, strong) NSString *fileSize;
/** 附件文件大小 */
@property (nonatomic, strong) NSString *attachmentFileSize;


@end

/** for example：
    fileModel.fileId = @"577e2300c94f6e51316a299d";
    fileModel.fileName = @"哈哈哈.docx";
    fileModel.url = @"http://inform-file.oss-cn-beijing.aliyuncs.com/577e2300c94f6e51316a299d";
    fileModel.fileType = @"docx";
    fileModel.fileSize = @"21.39KB";
    fileModel.attachmentFileSize = @"21906";
 */

