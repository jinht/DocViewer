//
//  JhtDocFileOperations.m
//  JhtDocViewerDemo
//
//  GitHub主页: https://github.com/jinht
//  CSDN博客: http://blog.csdn.net/anticipate91
//
//  Created by Jht on 2017/1/6.
//  Copyright © 2017年 JhtDocViewer. All rights reserved.
//

#import "JhtDocFileOperations.h"

/** 系统默认 存放 从其他app分享过来文件的 文件夹名（后半段） */
static NSString *const KJht_folderName_Default_OtherAppFiles = @"/Documents/Inbox";
/** 存放 从其他app分享过来文件的 文件夹名（后半段） */
static NSString *const KJht_folderName_OtherAppFiles = @"/Documents/JhtFolderNameWithOtherAppFiles";

/** 默认 本地文件 加载到到内存中 文件夹名（后半段） */
static NSString *const KJht_folderName_Default_LoadToMemoryFiles = @"Documents/JhtDoc";
/** 系统默认 存放 下载文件的 文件夹名（后半段） */
static NSString *const KJht_folderName_DownloadFiles = @"/Download/Files";

@implementation JhtDocFileOperations
/** 存放 app下载文件 沙盒路径 */
@synthesize downloadFilesPath = _downloadFilesPath;
/** 存放 从其他app分享过来文件 沙盒路径 */
@synthesize otherAppFilesPath = _otherAppFilesPath;

#pragma mark - Public Method
+ (instancetype)sharedInstance {
    static JhtDocFileOperations *JhtDocUtil = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if (JhtDocUtil == nil) {
            JhtDocUtil = [[self alloc] init];
        }
    });
    
    return JhtDocUtil;
}

#pragma mark 保存
- (void)copyLocalWithFileName:(NSString *)fileName basePath:(NSString *)basePath localPath:(NSString *)localPath {
    // 兼容处理
    if (fileName.length == 0) {
        return;
    }
    if (localPath.length == 0) {
        localPath = KJht_folderName_Default_LoadToMemoryFiles;
    }
    if (basePath.length == 0) {
        basePath = NSHomeDirectory();
    }
    // 储存方式
    NSString *path = [basePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@", localPath, fileName]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    if (![fileManager fileExistsAtPath:path]) {
        // 创建目录
        [fileManager createDirectoryAtPath:[path componentsSeparatedByString:[NSString stringWithFormat:@"/%@", fileName]][0]  withIntermediateDirectories:YES attributes:nil error:&error];
        NSString *filename = [fileName componentsSeparatedByString:@"."][0];
        NSString *type = [fileName componentsSeparatedByString:@"."][1];
        
        NSString *bundle = [[NSBundle mainBundle] pathForResource:filename ofType:type];
        
        // 用NSData保存到内存
        NSData *fileData = [[NSData alloc] initWithContentsOfFile:bundle];
        [fileData writeToFile:path atomically:YES];
    }
}

#pragma mark 生成路径
- (NSString *)stitchLocalFilePath {
    // 生成 下载文件 沙盒路径
    NSString *filePath = [self stitchDownloadFilePath];
    NSString *fileTypePath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", self.fileName]];
    
    return fileTypePath;
}

- (NSString *)stitchDownloadFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *downLoadPath = [paths objectAtIndex:0];
    NSString *downLoadFilesPath = [NSString stringWithFormat:@"%@%@", downLoadPath, KJht_folderName_DownloadFiles];
	
    return downLoadFilesPath;
}

- (NSString *)findLocalPathFromAppLicationOpenUrl:(NSURL *)url {
//    NSString *str = [NSString stringWithFormat:@"\n发送请求的应用程序的 Bundle ID: %@\n\n文件的NSURL: %@", options[UIApplicationOpenURLOptionsSourceApplicationKey], url];
    // url示例
    // @"file:///private/var/mobile/Containers/Data/Application/A2E0485F-1341-48A3-BD40-6D09CB8559F5/Documents/Inbox/2-6.pptx"
    
    /*
     // 从路径中获得完整的文件名（带后缀） 2.pptx
     NSString *exestr = ;
     NSLog(@"%@", exestr);
     // 获得文件名（不带后缀） file:/private/var/mobile/Containers/Data/Application/BEBCB59D-DAE2-4743-9421-62A64AFFCE0B/Documents/Inbox/2
     exestr = [[url description]  stringByDeletingPathExtension];
     NSLog(@"%@", exestr);
     
     // 获得文件的后缀名（不带'.'） pptx
     exestr = [[url description]  pathExtension];
     NSLog(@"%@", exestr);
     */
    
    // url转码
//    NSLog(@"%@", url);
    NSString *urlStr = [[url description]  stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    // 将inbox里这个文档拷贝到KJht_folderName_OtherAppFiles目录下
    NSString *appfilePath = [self copyFromInboxWithFileName:[urlStr  lastPathComponent]];
//    NSLog(@"%@", appfilePath);
    
    return appfilePath;
}

#pragma mark 清理
- (void)removeFileWhenDownloadFileFailure {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fileName = [self stitchLocalFilePath];
    if ([fileManager fileExistsAtPath:fileName]) {
        [fileManager removeItemAtPath:fileName error:nil];
    }
}

- (void)cleanFileAfterDays:(CGFloat)day filePathArray:(NSArray *)filePathArray {
    // app下载文件 沙盒路径
    _downloadFilesPath = [self stitchDownloadFilePath];
    // 从别的app分享过来文件 沙盒路径
    _otherAppFilesPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", KJht_folderName_OtherAppFiles]];
    NSArray *clearFilesPathArray = @[_downloadFilesPath, _otherAppFilesPath];
    
    if (filePathArray.count) {
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:clearFilesPathArray];
        [tempArray addObjectsFromArray:filePathArray];
        
        clearFilesPathArray = [tempArray copy];
    }
    
    // 并发异步 进行文件操作
    dispatch_queue_t queue = dispatch_queue_create("com.JhtDocViewerDemo", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < clearFilesPathArray.count; i ++) {
            NSString *filePath = clearFilesPathArray[i];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSDirectoryEnumerator *directoryEnumerator = [fileManager enumeratorAtPath:filePath];
            NSString *path;
            while ((path = [directoryEnumerator nextObject]) != nil) {
                NSString *subFilePath = [filePath stringByAppendingPathComponent:path];
                
                // 遍历文件属性
                NSError *error = nil;
                NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:subFilePath error:&error];
                if (fileAttributes != nil) {
                    NSDate *fileCreateDate = [fileAttributes objectForKey:NSFileCreationDate];
                    if (fileCreateDate) {
                        NSDate *nowDate = [NSDate date];
                        NSTimeInterval timeInterval = [nowDate timeIntervalSinceDate:fileCreateDate];
                        
                        // 文件创建时间 与当前时间 间隔 > day ===> 删除
                        // (2 * 60): 2min的延迟，避免误删除当次要打开的文件
                        if (timeInterval > (day > 0 ? (day * 24 * 60 * 60) : (2 * 60))) {
                            // 判断文件是否存在
                            if ([fileManager fileExistsAtPath:subFilePath]) {
                                [fileManager removeItemAtPath:subFilePath error:nil];
                            }
                        }
                    }
                }
            }
        }
    });
}


#pragma mark - Private Method
/** 将inbox里这个文档拷贝到KJht_folderName_OtherAppFiles文件夹下
 *  fileName: Documents/Inbox文件夹下的文件名
 *  return: 文件的新地址
 */
- (NSString *)copyFromInboxWithFileName:(NSString *)fileName {
    // 其他app 分享过来的文件 默认存放的文件夹
    NSString *tempFileDir = [NSHomeDirectory() stringByAppendingString:KJht_folderName_Default_OtherAppFiles];
    
    // 文件的新地址
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@", KJht_folderName_OtherAppFiles, fileName]];
    
    // 创建KJht_folderName_OtherAppFiles文件夹
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", KJht_folderName_OtherAppFiles]] isDirectory:&isDir];
    if (!isDirExist) {
        NSError *error;
        [fileManager createDirectoryAtPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", KJht_folderName_OtherAppFiles]] withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    // 删除KJht_folderName_OtherAppFiles文件夹下所有文件
//    [self deleteWithLocalPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", KJht_folderName_OtherAppFiles]]];
    
    // 用NSData方式保存
    NSData *fileData = [[NSData alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", tempFileDir, fileName]];
    [fileData writeToFile:path atomically:YES];
    
    // 删除Inbox文件夹（文件所在的原始文件夹）下所有文件
    [self deleteWithLocalPath:tempFileDir];
    
    return path;
}

/** 删除文件下的所有所有文档 */
- (void)deleteWithLocalPath:(NSString *)filePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *directoryEnumerator = [fileManager enumeratorAtPath:filePath];
    NSString *path;
    while ((path = [directoryEnumerator nextObject]) != nil) {
        NSString *subFilePath = [filePath stringByAppendingPathComponent:path];
        if ([fileManager fileExistsAtPath:subFilePath]) {
            // 如果存在
            [fileManager removeItemAtPath:subFilePath error:nil];
        }
    }
}


#pragma mark - Getter
- (NSString *)downloadFilesPath {
    if (!_downloadFilesPath) {
        _downloadFilesPath = [self stitchDownloadFilePath];
    }
    
    return _downloadFilesPath;
}

- (NSString *)otherAppFilesPath {
    if (!_otherAppFilesPath) {
        _otherAppFilesPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", KJht_folderName_OtherAppFiles]];
    }
    
    return _otherAppFilesPath;
}


@end
