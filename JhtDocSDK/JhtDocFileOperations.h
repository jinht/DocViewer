//
//  JhtDocFileOperations.h
//  JhtDocViewerDemo
//
//  github主页: https://github.com/jinht
//  CSDN博客: http://blog.csdn.net/anticipate91
//
//  Created by Jht on 2017/1/6.
//  Copyright © 2017年 Jht. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 文件操作类 */
@interface JhtDocFileOperations : NSObject

#pragma mark - property
/** 文件名称 */
@property (nonatomic, copy) NSString *fileName;



#pragma mark - Public Method
/** 单例 */
+ (instancetype)sharedInstance;

/** 生成本地文件完整路径 */
- (NSString *)stitchLocalFilePath;
/** 生成下载文件沙盒路径 */
- (NSString *)stitchDownloadFilePath;

/** 文件下载失败时，清除文件路径 */
- (void)removeFileWhenDownloadFileFailure;
/** 清理几天前Download/Files里面文件 */
- (void)cleanFileAfterDays:(NSInteger)day;
/** “其他应用”===>“本应用”打开，通过传递过来的url，获得本地地址 */
- (NSString *)findLocalPathFromAppLicationOpenUrl:(NSURL *)url;

/** 将本地文件 保存到内存中
 *  fileName：是以.为分割的格式       eg：哈哈哈.doc
 *  basePath：是本地路径的基地址      eg：NSHomeDirectory()
 *  localPath：本地路径中存储的文件夹  eg：Documents/JhtDoc
 */
- (void)copyLocalWithFileName:(NSString *)fileName withBasePath:(NSString *)basePath withLocalPath:(NSString *)localPath;


@end
