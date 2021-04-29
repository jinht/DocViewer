//
//  JhtLoadDocView.m
//  JhtDocViewerDemo
//
//  GitHub主页: https://github.com/jinht
//  CSDN博客: http://blog.csdn.net/anticipate91
//
//  Created by Jht on 2017/10/19.
//  Copyright © 2017年 JhtDocViewer. All rights reserved.
//

#import "JhtLoadDocView.h"
#import "JhtFileModel.h"
#import "JhtDocWebView.h"
#import "JhtDownloadView.h"
#import "JhtDefaultManager.h"
#import "JhtDownloadRequest.h"
#import "JhtDocViewer_Define.h"
#import "JhtDocFileOperations.h"
#import "JhtNetworkCheckTools.h"
#import "JhtDownTipsDumpingView.h"
#import "JhtLoadDocViewParamModel.h"
#import "OtherOpenButtonParamModel.h"
#import "JhtShowDumpingViewParamModel.h"

@interface JhtLoadDocView () <UIAlertViewDelegate> {
    finishedDownloadCompletionHandler _block;
    
    // 当前 文件model
    JhtFileModel *_currentFileModel;
    
    // errorView 父View（一般为self.navigationController.view）
    UIView *_errorFView;
}
/** 下载 View */
@property (nonatomic, strong) JhtDownloadView *downloadView;
/** 文件操作类 */
@property (nonatomic, strong) JhtDocFileOperations *fileUtil;
/** webView展示页 */
@property (nonatomic, strong) JhtDocWebView *docWebView;
/** 加载Doc的webView */
@property (nonatomic, strong) WKWebView *wkWebView;
/** 阻尼下拉动画View */
@property (nonatomic, strong) UIView *dumpingView;

/** JhtLoadDocView 配置Model */
@property (nonatomic, strong) JhtLoadDocViewParamModel *loadDocViewParamModel;
/** JhtShowDumpingView 配置Model */
@property (nonatomic, strong) JhtShowDumpingViewParamModel *showDumpingViewParamModel;

@end


#define KB (1024)
#define MB (KB * 1024)
#define GB (MB * 1024)
/** 状态栏 + 导航栏的高度 */
#define KLDVStatusAndNavBarHeight (KStatusBarHeight + 44)

@implementation JhtLoadDocView

#pragma mark - Public Method
- (instancetype)initWithFrame:(CGRect)frame fileModel:(JhtFileModel *)fileModel showErrorViewOfFatherView:(UIView *)errorFView loadDocViewParamModel:(JhtLoadDocViewParamModel *)loadDocViewParamModel showDumpingViewParamModel:(JhtShowDumpingViewParamModel *)showDumpingViewParamModel otherOpenButtonParamModel:(OtherOpenButtonParamModel *)otherOpenButtonParamModel {
    self = [super initWithFrame:frame];
    
    if (self) {
        _currentFileModel = fileModel;
        _errorFView = errorFView;
        self.loadDocViewParamModel = loadDocViewParamModel;
        self.showDumpingViewParamModel = showDumpingViewParamModel;
        self.otherOpenButtonParamModel = otherOpenButtonParamModel;
        
        // 创建文件工具类
        [self ldvCreatefileUtil];
        
        // CreateUI
        [self ldvCreateUI];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 清理几天前 downloadFilesPath && otherAppFilesPath 文件
            [self.fileUtil cleanFileAfterDays:self.loadDocViewParamModel.daysAgo filePathArray:nil];
        });
    }
    
    return self;
}

- (void)finishedDownloadCompletionHandler:(finishedDownloadCompletionHandler)block {
    _block = block;
}


#pragma mark - Private Method
/** 创建文件工具类 */
- (void)ldvCreatefileUtil {
    _fileUtil = [JhtDocFileOperations sharedInstance];
    _fileUtil.fileName = _currentFileModel.fileName;
}

#pragma mark UI
/** CreateUI */
- (void)ldvCreateUI {
    // 设置背景颜色
    self.backgroundColor = [UIColor whiteColor];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [_fileUtil stitchLocalFilePath];
    if (_currentFileModel.fileAbsolutePath) {
        // 本地存在，直接创建WebView
        [self ldvCreateWebView];
        
    } else if ([fileManager fileExistsAtPath:filePath]) {
        // 如果存在，获取本地文件大小
        CGFloat fileSize = [self ldvFileSizeForPath:filePath];
        if ([_currentFileModel.attachmentFileSize floatValue] > fileSize) {
            // 本地的附件文本大小 和 应该从网络下载的不一致
            [_fileUtil removeFileWhenDownloadFileFailure];
            // 生成下载页面
            [self ldvCreateDownloadUI];
            
        } else {
            // 本地存在，直接创建WebView
            [self ldvCreateWebView];
        }
    } else {
        // 本地不存在，应该先下载
        [self ldvCreateDownloadUI];
    }
}

/** 获取本地文件大小 */
- (long long)ldvFileSizeForPath:(NSString *)filePath {
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]) {
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    
    return 0;
}

/** 生成下载页面 */
- (void)ldvCreateDownloadUI {
    // 下载文件View
    self.downloadView = [[JhtDownloadView alloc] initWithFrame:CGRectMake(0, 0, FrameW, FrameH - KLDVStatusAndNavBarHeight) downloadingHint:self.loadDocViewParamModel.downloadingHint lostNetHint:self.loadDocViewParamModel.lostNetHint downloadProgressTintColor:self.loadDocViewParamModel.downloadProgressTintColor fileModel:_currentFileModel];
    
    __weak typeof(self) weakSelf = self;
    // 点击block 0-重新加载，1-点击关闭
    [self.downloadView clickBtnBlock:^(NSInteger index) {
        if (index == 0) {
            // 重新加载
            [weakSelf ldvRetryClick];
        } else {
            // 点击关闭
            [weakSelf ldvCloseClick];
        }
    }];
    [self addSubview:self.downloadView];
    
    // 是否具备下载条件（网络 && 存储空间）
    [self ldvJudgeDownloadConditions];
}

#pragma mark 判断是否具备下载条件（网络 && 存储空间）
/** 判断是否具备下载条件（网络） */
- (void)ldvJudgeDownloadConditions {
    if ([self ldvCurrentFreeDiskSpaceToFileSize] < 0) {
        // 内存不足
        [self ldvShowDumpingView:self.loadDocViewParamModel.notEnoughMemoryHint];
        self.downloadView.downloadBtn.hidden = NO;
        
    } else {
        if (([JhtNetworkCheckTools currentNetWork_Status] == NetWorkStatus_2G) || ([JhtNetworkCheckTools currentNetWork_Status] == NetWorkStatus_3G) || ([JhtNetworkCheckTools currentNetWork_Status] == NetWorkStatus_4G)) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"下载流量提醒" message:@"当前处于非wifi环境，继续查看将会产生手机流量" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            
            alert.tag = 123;
            [alert show];
            
        } else if ([JhtNetworkCheckTools currentNetWork_Status] == NetWorkStatus_None) {
            // 没网啥都不做
        } else {
            // 开始下载
            [self ldvDrawProgressUIForDowningFile];
        }
    }
}

/** 获取当前设备硬盘存储容量 与文件大小 做差 < 0 说明内存不足 */
- (CGFloat)ldvCurrentFreeDiskSpaceToFileSize {
    long long freeSpace = [[[[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil] objectForKey:NSFileSystemFreeSize] longLongValue];
    // 去除200M左右保护空间
    freeSpace -= (200 * 1024 * 1024);
    
    double bytes = 1.0 * freeSpace;
    double kigabytes = bytes / KB;
    double megabytes = bytes / MB;
    double gigabytes = bytes / GB;
    // Bytes，KB，MB，GB
    if ([_currentFileModel.fileSize rangeOfString:@"KB"].length) {
        return kigabytes - [[_currentFileModel.fileSize componentsSeparatedByString:@"KB"][0] floatValue];
        
    } else if ([_currentFileModel.fileSize rangeOfString:@"GB"].length) {
        return gigabytes - [[_currentFileModel.fileSize componentsSeparatedByString:@"GB"][0] floatValue];
        
    } else if ([_currentFileModel.fileSize rangeOfString:@"MB"].length) {
        return megabytes - [[_currentFileModel.fileSize componentsSeparatedByString:@"GB"][0] floatValue];
        
    } else if ([_currentFileModel.fileSize rangeOfString:@"Bytes"].length) {
        return bytes - [[_currentFileModel.fileSize componentsSeparatedByString:@"Bytes"][0] floatValue];
        
    } else {
        // 做的兼容处理，如果给的_currentFileModel.fileSize不符合规则，那么就不比较，直接返回1
        return 1;
    }
}

#pragma mark 绘制下载进度状况
/** 绘制下载进度状况 */
- (void)ldvDrawProgressUIForDowningFile {
    self.downloadView.fileProgressView.hidden = NO;
    self.downloadView.downloadingStateLabel.hidden = NO;
    self.downloadView.closeBtn.hidden = NO;
    self.downloadView.downloadBtn.hidden = YES;
    
    /** 下载文件功能
     *  URLString: 要下载文件的URL
     *  downloadFileProgress: 下载的进度条，百分比
     *  setupFilePath: 设置下载的路径
     *  downloadCompletionHandler: 下载完成后（下载完成后可拿到存储的路径）
     */
    [JhtDownloadRequest createDownloadFileWithURLString:_currentFileModel.url downloadFileProgress:^(NSProgress *downloadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.downloadView.fileProgressView setProgress:downloadProgress.fractionCompleted animated:YES];
        });
    } setupFilePath:^NSURL *(NSURLResponse *response) {
        NSString *cachePath = [NSString stringWithFormat:@"%@", _currentFileModel.fileName];
        NSString *filePath = [_fileUtil stitchDownloadFilePath];
        BOOL isDir = NO;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL existed = [fileManager fileExistsAtPath:filePath isDirectory:&isDir];
        if (!(isDir == YES && existed == YES)) {
            [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        NSString *localPath = [filePath stringByAppendingPathComponent:cachePath];
        
        return [NSURL fileURLWithPath:localPath];
        
    } downloadCompletionHandler:^(NSURL *filePath, NSError *error) {
        NSLog(@"fileDownloadError ==> %@", error);
        if (!error) {
            self.downloadView.hidden = YES;
            // 创建WebView
            [self ldvCreateWebView];
            // 网络下载成功，本地路径
            NSString *pathUrl = [[_fileUtil stitchLocalFilePath] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            NSLog(@"pathUrl ===> %@\n\n\n%@", [_fileUtil stitchLocalFilePath], pathUrl);
            // 本地路径
            if (_block) {
                _block(pathUrl);
            }
            
            self.docWebView.hidden = NO;
            
        } else {
            self.downloadView.hidden = NO;
            self.downloadView.downloadingStateLabel.text = self.loadDocViewParamModel.downloadFailedHint;
            self.downloadView.downloadBtn.hidden = NO;
            
            self.docWebView.hidden = YES;
            // 文件下载失败时，清除文件路径
            [_fileUtil removeFileWhenDownloadFileFailure];
        }
    }];
}


#pragma mark - WebView
/** 创建WebView */
- (void)ldvCreateWebView {
    // 网络下载成功，本地路径
    NSString *filePath = [_fileUtil stitchLocalFilePath];
    // 非网络下载的路径
    if (_currentFileModel.fileAbsolutePath) {
        filePath = _currentFileModel.fileAbsolutePath;
    }
    
    [self addSubview:self.docWebView];
    self.docWebView.filePath = filePath;
    self.docWebView.otherOpenButtonParamModel = self.otherOpenButtonParamModel;
}


#pragma mark - Getter
- (JhtDocWebView *)docWebView {
    if (!_docWebView) {
        _docWebView = [[JhtDocWebView alloc] initWithFrame:CGRectMake(0, 0, FrameW, FrameH - KLDVStatusAndNavBarHeight)];
    }
    
    return _docWebView;
}

- (WKWebView *)wkWebView {
    return self.docWebView.wkWebView;
}

- (JhtLoadDocViewParamModel *)loadDocViewParamModel {
    if (!_loadDocViewParamModel) {
        _loadDocViewParamModel = [[JhtLoadDocViewParamModel alloc] init];
    }
    NSDictionary *dic = [JhtDefaultManager getConfigDataWithType:JhtDefaultType_LoadDocViewParam];
    
    _loadDocViewParamModel.lostNetHint = (_loadDocViewParamModel.lostNetHint.length > 0 ? _loadDocViewParamModel.lostNetHint : dic[@"lostNetHint"]);
    _loadDocViewParamModel.notEnoughMemoryHint = (_loadDocViewParamModel.notEnoughMemoryHint.length > 0 ? _loadDocViewParamModel.notEnoughMemoryHint : dic[@"notEnoughMemoryHint"]);
    
    if ([JhtNetworkCheckTools currentNetWork_Status] == NetWorkStatus_None) {
        _loadDocViewParamModel.downloadingHint = _loadDocViewParamModel.lostNetHint;
    } else {
        _loadDocViewParamModel.downloadingHint = (_loadDocViewParamModel.downloadingHint.length > 0 ? _loadDocViewParamModel.downloadingHint : dic[@"downloadingHint"]);
    }
    
    if ([JhtNetworkCheckTools currentNetWork_Status] == NetWorkStatus_None) {
        _loadDocViewParamModel.downloadFailedHint = _loadDocViewParamModel.lostNetHint;
    } else {
        _loadDocViewParamModel.downloadFailedHint = (_loadDocViewParamModel.downloadFailedHint.length > 0 ? _loadDocViewParamModel.downloadFailedHint : dic[@"downloadFailedHint"]);
    }
    
    _loadDocViewParamModel.daysAgo = (_loadDocViewParamModel.daysAgo > [dic[@"daysAgo"] integerValue] ? _loadDocViewParamModel.daysAgo : [dic[@"daysAgo"] integerValue]);
    _loadDocViewParamModel.downloadProgressTintColor = (_loadDocViewParamModel.downloadProgressTintColor ? _loadDocViewParamModel.downloadProgressTintColor : UIColorFromRGB(0x61CBF5));
    
    return _loadDocViewParamModel;
}

- (JhtShowDumpingViewParamModel *)showDumpingViewParamModel {
    if (!_showDumpingViewParamModel) {
        _showDumpingViewParamModel = [[JhtShowDumpingViewParamModel alloc] init];
    }
    _showDumpingViewParamModel.showViewFrame = (!CGRectEqualToRect(_showDumpingViewParamModel.showViewFrame, CGRectZero)) ? _showDumpingViewParamModel.showViewFrame : CGRectMake(0, 0, FrameW, 65);
    
    _showDumpingViewParamModel.showBackgroundColor = _showDumpingViewParamModel.showBackgroundColor ? _showDumpingViewParamModel.showBackgroundColor : [UIColor whiteColor];
    _showDumpingViewParamModel.showBackgroundImageName = _showDumpingViewParamModel.showBackgroundImageName.length ? _showDumpingViewParamModel.showBackgroundImageName : @"dumpView";
    
    _showDumpingViewParamModel.formerWarningIconFrame = (!CGRectEqualToRect(_showDumpingViewParamModel.formerWarningIconFrame, CGRectZero)) ? _showDumpingViewParamModel.formerWarningIconFrame : CGRectMake(15, (_showDumpingViewParamModel.showViewFrame.size.height - 35) + ((KSDPMShowLabelHeight - 20) / 2.0), 20, 20);
    
    _showDumpingViewParamModel.showLabelFrame = (_showDumpingViewParamModel.showLabelFrame.size.height > 0 && _showDumpingViewParamModel.showLabelFrame.size.width > 0) ? _showDumpingViewParamModel.showLabelFrame : CGRectMake(CGRectGetMaxX(_showDumpingViewParamModel.formerWarningIconFrame) + 8, _showDumpingViewParamModel.showViewFrame.size.height - 35, _showDumpingViewParamModel.showViewFrame.size.width - (CGRectGetMaxX(_showDumpingViewParamModel.formerWarningIconFrame) + 8) * 2, KSDPMShowLabelHeight);
    _showDumpingViewParamModel.showTextColor = _showDumpingViewParamModel.showTextColor ? _showDumpingViewParamModel.showTextColor : UIColorFromRGB(0x666666);
    _showDumpingViewParamModel.showTextFont = _showDumpingViewParamModel.showTextFont ? _showDumpingViewParamModel.showTextFont : [UIFont boldSystemFontOfSize:15];
    
    return _showDumpingViewParamModel;
}

#pragma mark Getter Method
/** 重新加载按钮触发方法 */
- (void)ldvRetryClick {
    if ([JhtNetworkCheckTools currentNetWork_Status] == NetWorkStatus_None) {
        [self ldvShowDumpingView:self.loadDocViewParamModel.lostNetHint];
        
        // 改变下载过程中提示文字
        self.downloadView.downloadingStateLabel.text = self.loadDocViewParamModel.downloadingHint;
        // 隐藏进度条和关闭按钮
        self.downloadView.fileProgressView.hidden = YES;
        self.downloadView.closeBtn.hidden = YES;
        
        return;
    }
    
    self.downloadView.downloadingStateLabel.text = self.loadDocViewParamModel.downloadingHint;
    self.downloadView.downloadBtn.hidden = YES;
    // 断是否具备下载条件（网络 && 存储空间）
    [self ldvJudgeDownloadConditions];
}

/** 红色那个关闭点击事件 */
- (void)ldvCloseClick {
    [_fileUtil removeFileWhenDownloadFileFailure];
    // 停止 下载文件
    [JhtDownloadRequest stopDownloadFile];
    self.downloadView.fileProgressView.progress = 0;
}

/** 展示弹框 */
- (void)ldvShowDumpingView:(NSString *)title {
    if (_errorFView) {
        [JhtDownTipsDumpingView showWithFView:_errorFView text:title showDumpingViewParamModel:self.showDumpingViewParamModel];
    }
}


#pragma mark - Setter
- (void)setOtherOpenButtonParamModel:(OtherOpenButtonParamModel *)otherOpenButtonParamModel {
    _otherOpenButtonParamModel = otherOpenButtonParamModel;
    
    self.docWebView.otherOpenButtonParamModel = _otherOpenButtonParamModel;
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 123) {
        if (buttonIndex == 1) {
            // 开始下载
            [self ldvDrawProgressUIForDowningFile];
            
        } else {
            // 展示下载
            self.downloadView.hidden = NO;
            self.downloadView.fileProgressView.hidden = YES;
            self.downloadView.closeBtn.hidden = YES;
            self.downloadView.downloadBtn.hidden = NO;
            self.downloadView.downloadingStateLabel.hidden = NO;
            self.downloadView.downloadingStateLabel.text = @"该文件暂不支持在线预览,请下载后查看";
            self.docWebView.hidden = YES;
        }
    }
}


@end
