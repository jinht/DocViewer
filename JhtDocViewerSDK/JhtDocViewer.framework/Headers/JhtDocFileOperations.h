//
//  JhtDocFileOperations.h
//  JhtDocViewerDemo
//
//  GitHub主页: https://github.com/jinht
//  CSDN博客: http://blog.csdn.net/anticipate91
//
//  Created by Jht on 2017/1/6.
//  Copyright © 2017年 JhtDocViewer. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 文件操作类 */
@interface JhtDocFileOperations : NSObject

#pragma mark - property
/** 文件名称 */
@property (nonatomic, strong) NSString *fileName;



#pragma mark - Public Method
/** 单例 */
+ (instancetype)sharedInstance;


#pragma mark 保存
/** 将本地文件 保存到内存中
 *  fileName：是以.为分割的格式       eg：哈哈哈.doc
 *  basePath：是本地路径的基地址      eg：NSHomeDirectory()
 *  localPath：本地路径中存储的文件夹  eg：Documents/JhtDoc
 */
- (void)copyLocalWithFileName:(NSString *)fileName withBasePath:(NSString *)basePath withLocalPath:(NSString *)localPath;


#pragma mark 生成路径
/** 生成本地文件完整路径 */
- (NSString *)stitchLocalFilePath;
/** 生成下载文件沙盒路径 */
- (NSString *)stitchDownloadFilePath;
/** “其他应用”===>“本应用”打开，通过传递过来的url，获得本地地址 */
- (NSString *)findLocalPathFromAppLicationOpenUrl:(NSURL *)url;


#pragma mark 清理
/** 文件下载失败时，清除文件路径 */
- (void)removeFileWhenDownloadFileFailure;
/** 清理几天前Download/Files里面文件 */
- (void)cleanFileAfterDays:(NSInteger)day;


@end
