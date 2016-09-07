//
//  JhtLoadDocViewController.m
//  JhtTools
//
//  Created by Jht on 16/7/10.
//  Copyright © 2016年 靳海涛. All rights reserved.
//

#import "JhtLoadDocViewController.h"
#import "JhtFileModel.h"
#import <WebKit/WebKit.h>

@interface JhtLoadDocViewController () <UIWebViewDelegate, WKNavigationDelegate, WKUIDelegate, UIDocumentInteractionControllerDelegate, UIAlertViewDelegate> {
    // 加载Doc的webView
    UIWebView *_webView;
    
    WKWebView *_wkWebView;
    // 用其他应用打开
    UIButton *_otherOpenButton;
    // 用三方打开文件
    UIDocumentInteractionController *_documentController;
}

/** 文件类型图片 */
@property (nonatomic, strong) UIImageView *iconFileImageView;
/** 文件名称 */
@property (nonatomic, strong) UILabel *iconFileDescribeLabel;
/** 进度条 */
@property (nonatomic, strong) UIProgressView *fileProgressView;
/** 下载进度文案 */
@property (nonatomic, strong) UILabel *downloadingStateLabel;
/** 关闭按钮 */
@property (nonatomic, strong) UIButton *closeBtn;
/** 重试按钮 */
@property (nonatomic, strong) UIButton *retryBtn;

@end

#define KB (1024)
#define MB (KB * 1024)
#define GB (MB * 1024)
@implementation JhtLoadDocViewController

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // 关闭 《正在加载》的View
    [self bsStopLoadingView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 移除父类的tableView
    [_baseTableView removeFromSuperview];
    
    // 设置导航栏
    [self ldSetNav];
    
    // 清除几天前的数据；
    [self ldCleanFileAfterDays:0];
    
    // 判断有无网络进行创建UI界面
    [self ldJudgeNetState];
}



#pragma mark - setNav
/** 设置导航栏 */
- (void)ldSetNav {
    // 设置导航栏返回按钮
    [self bsCreateNavigationBarLeftBtn];
    
    // 设置导航栏标题
    [self bsCreateNavigationBarTitleViewWithLabelTitle:self.titleStr];
}



#pragma mark - UI界面
/** 判断有无网络进行创建UI界面 */
- (void)ldJudgeNetState {
    // 设置背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    // 判断是否有网络， 有网络 或者 本地数据；
    NSUserDefaults *defalts = [NSUserDefaults standardUserDefaults];
    NSString *netState = [defalts objectForKey:@"netStatus"];
    if (![netState isEqualToString:@"0"] || self.currentFileModel.fileAbsolutePath) {
        // 有网络连接
        [self ldCreateUI];
    } else {
        // 无网络连接
        netState = @"网络暂不可用";
        [self JhtShowHint:@"网络暂不可用"];
    }
}

#pragma mark 根据本地是否有，进行创建下载页或者本地浏览页
/** 根据本地是否有，进行创建下载页或者本地浏览页 */
- (void)ldCreateUI {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [self ldGetLocalFilePath];
    if (self.currentFileModel.fileAbsolutePath) {
        // 本地有，直接加载创建WebView；
        [self ldCreateWebView];
    } else if([fileManager fileExistsAtPath:filePath]) {
        //如果存在,获取本地文件大小；
        CGFloat fileSize = [self ldFileSizeForPath:filePath];
        if ([_currentFileModel.attachmentFileSize floatValue] > fileSize) {
            // 本地的附件文本大小 和 应该从网络下载的不一致！
            [self ldRemoveFileWhenDownloadFileFailure];
            // 生成下载页面
            [self ldCreateDownloadUI];
        } else {
            // 本地有，直接加载创建WebView；
            [self ldCreateWebView];
        }
    } else {
        // 本地没有，应该先下载；
        [self ldCreateDownloadUI];
    }
}

#pragma mark 生成下载页面
/** 生成下载页面 */
- (void)ldCreateDownloadUI {
    NSString *fileTypeName = @"";
    
    if ([_currentFileModel.fileType isEqualToString:@"doc"] || [_currentFileModel.fileType isEqualToString:@"docx"]) {
        fileTypeName = @"word.png";
    } else if ([_currentFileModel.fileType isEqualToString:@"xls"] || [_currentFileModel.fileType isEqualToString:@"xlsx"]) {
        fileTypeName = @"excel.png";
    } else if ( [_currentFileModel.fileType isEqualToString:@"ppt"] || [_currentFileModel.fileType  isEqualToString:@"pptx"]) {
        fileTypeName = @"ppt.png";
    } else if ([_currentFileModel.fileType isEqualToString:@"pdf"]) {
        fileTypeName = @"pdf.png";
    } else if ([_currentFileModel.fileType isEqualToString:@"txt"]) {
        fileTypeName = @"txt.png";
    } else {
        fileTypeName = @"未知格式.png";
    }
    
    _iconFileImageView = [[UIImageView alloc] initWithFrame:CGRectMake((FrameW - 100) / 2.f, 65.f, 100.f, 100.f)];
    _iconFileImageView.image = [UIImage imageNamed:fileTypeName];
    [self.view addSubview:_iconFileImageView];
    
    CGSize filesize = [_currentFileModel.fileName boundingRectWithSize:CGSizeMake(FrameW - 90, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.f]} context:nil].size;
    CGFloat  describeHeight = filesize.height;
    
    _iconFileDescribeLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, CGRectGetMaxY(_iconFileImageView.frame) + 25, FrameW - 90, describeHeight)];
    _iconFileDescribeLabel.textAlignment = NSTextAlignmentCenter;
    _iconFileDescribeLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    _iconFileDescribeLabel.font = [UIFont systemFontOfSize:16.f];
    _iconFileDescribeLabel.textColor = UIColorFromRGB(0x333333);
    _iconFileDescribeLabel.text = _currentFileModel.fileName;
    _iconFileDescribeLabel.numberOfLines = 0;
    [self.view addSubview:_iconFileDescribeLabel];
    
    [self ldJudgeNetworkThenDownloadFile];
}

#pragma mark 判断硬盘和网络情况，开始下载文件
/** 判断网络情况，开始下载文件 */
- (void)ldJudgeNetworkThenDownloadFile {
    if ([self ldCurrentFreeDiskSpaceToFileSize] < 0) {
        [self JhtShowHint:@"手机内存不足"];
    } else {
        NSUserDefaults *defalts = [NSUserDefaults standardUserDefaults];
        NSString *netState = [defalts objectForKey:@"netStatus"];

        if ([netState isEqualToString:@"0"]) {
            netState = @"网络暂不可用，请稍后重试！";
            [self JhtShowHint:netState];
        } else if ([netState isEqualToString:@"1"]) {
            netState = @"NB的WIFI";
            // 开始下载；
            [self ldDrawProgressUIForDowningFile];
        } else if ([netState isEqualToString:@"2"] || [netState isEqualToString:@"3"] || [netState isEqualToString:@"4"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"流量提醒" message:@"当前处于非wifi环境，继续查看将会产生手机流量。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
            alert.tag = 123;
            [alert show];
        }
    }
}

/** 获取当前设备硬盘存储容量 与文件大小 做差， < 0 说明内存不足 */
- (CGFloat)ldCurrentFreeDiskSpaceToFileSize {
    long long freeSpace = [[[[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil] objectForKey:NSFileSystemFreeSize] longLongValue];
    // 去除180M左右保护空间
    freeSpace -= (180 * 1024 * 1024);
    
    double bytes = 1.0 * freeSpace;
    double kigabytes = bytes / KB;
    double megabytes = bytes / MB;
    double gigabytes = bytes / GB;
    // KB,MB,GB,Bytes
    if ([_currentFileModel.fileSize rangeOfString:@"KB"].length) {
        return kigabytes - [[_currentFileModel.fileSize componentsSeparatedByString:@"KB"][0] floatValue];
        
    } else if ([_currentFileModel.fileSize rangeOfString:@"GB"].length) {
        return gigabytes - [[_currentFileModel.fileSize componentsSeparatedByString:@"GB"][0] floatValue];
        
    } else if ([_currentFileModel.fileSize rangeOfString:@"MB"].length) {
        return megabytes - [[_currentFileModel.fileSize componentsSeparatedByString:@"GB"][0] floatValue];
        
    } else if ([_currentFileModel.fileSize rangeOfString:@"Bytes"].length) {
        return bytes - [[_currentFileModel.fileSize componentsSeparatedByString:@"Bytes"][0] floatValue];
    } else {
        // 做的兼容处理；如果给的_currentFileModel.fileSize不符合规则；那么就不比较；直接返回1；
        return 1;
    }
}

#pragma mark 绘制下载进度状况
/** 绘制下载进度状况 */
- (void)ldDrawProgressUIForDowningFile {
    self.fileProgressView.hidden = NO;
    self.downloadingStateLabel.hidden = NO;
    self.closeBtn.hidden = NO;
    
    /**
     *  下载文件功能
     *
     *  @param URLString                 要下载文件的URL
     *  @param downloadFileProgress      下载的进度条，百分比
     *  @param setupFilePath             设置下载的路径
     *  @param downloadCompletionHandler 下载完成后（下载完成后可拿到存储的路径）
     */
    [JhtDownloadRequest createDownloadFileWithURLString:_currentFileModel.url downloadFileProgress:^(NSProgress *downloadProgress) {
        [self.fileProgressView setProgress:downloadProgress.fractionCompleted animated:YES];
    } setupFilePath:^NSURL *(NSURLResponse *response) {
        NSString *cachePath = [NSString stringWithFormat:@"%@", _currentFileModel.fileName];
        NSString *filePath =[self ldGetDownloadFilePath];
        BOOL isDir = NO;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL existed = [fileManager fileExistsAtPath:filePath isDirectory:&isDir];
        if (!(isDir == YES && existed == YES)) {
            [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        NSString *localPath = [filePath stringByAppendingPathComponent:cachePath];
        
        return [NSURL fileURLWithPath:localPath];
    } downloadCompletionHandler:^(NSURL *filePath, NSError *error) {
        NSLog(@"下载路径:%@", filePath);
        if (!error) {
            self.fileProgressView.hidden = YES;
            self.downloadingStateLabel.hidden = YES;
            self.iconFileDescribeLabel.hidden = YES;
            self.iconFileImageView.hidden = YES;
            self.closeBtn.hidden = YES;
            self.retryBtn.hidden = YES;
            
            _webView.hidden = NO;
            _otherOpenButton.hidden = NO;
            
            [self ldCreateWebView];
        } else {
            self.iconFileDescribeLabel.hidden = NO;
            self.iconFileImageView.hidden = NO;
            self.fileProgressView.hidden = NO;
            self.closeBtn.hidden = NO;
            self.downloadingStateLabel.hidden = NO;
            self.retryBtn.hidden = NO;
            self.downloadingStateLabel.text = @"文件下载失败";
            
            _webView.hidden = YES;
            _otherOpenButton.hidden = YES;
            
            [self ldRemoveFileWhenDownloadFileFailure];
        }
    }];
}



#pragma  mark - 关于文件路径的操作
#pragma mark 获取文件大小
- (long long)ldFileSizeForPath:(NSString *)filePath {
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

#pragma mark 文件下载失败时，清除文件路径
- (void)ldRemoveFileWhenDownloadFileFailure {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fileName = [self ldGetLocalFilePath];
    if ([fileManager fileExistsAtPath:fileName]) {
        [fileManager removeItemAtPath:fileName error:nil];
    }
}

#pragma mark 获取下载总沙盒路径
- (NSString *)ldGetDownloadFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/Download/Files", path];
    return filePath;
}

#pragma mark 获取本地文件名
- (NSString *)ldGetLocalFilePath {
    // 获取下载总沙盒路径
    NSString *filePath = [self ldGetDownloadFilePath];
    
    NSString *fileTypePath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", _currentFileModel.fileName]];
    return fileTypePath;
}

#pragma mark 几天天后清理Download/Files里面文件
- (void)ldCleanFileAfterDays:(NSInteger)day {
    NSString *filePath = [self ldGetDownloadFilePath];
    NSString *path = @"";
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *directoryEnumerator = [fileManager enumeratorAtPath:filePath];
    while ((path = [directoryEnumerator nextObject]) != nil) {
        NSString *subFilePath = [filePath stringByAppendingPathComponent:path];
        
        // 遍历文件属性
        NSError *error = nil;
        NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:subFilePath error:&error];
        if (fileAttributes != nil) {
            NSDate *fileCreateDate = [fileAttributes objectForKey:NSFileCreationDate];
            if (fileCreateDate) {
                NSDate *date2 = [NSDate date];
                NSTimeInterval aTimer = [date2 timeIntervalSinceDate:fileCreateDate];
                
                // 如果文件创建时间间隔大于day天，则删除
                if (aTimer > day*24*60*60) {
                    if([fileManager fileExistsAtPath:subFilePath]) {
                        // 如果存在
                        [fileManager removeItemAtPath:subFilePath error:nil];
                    }
                }
            }
        }
    }
}



#pragma mark - WebView
#pragma mark 创建WebView
/** 创建WebView */
- (void)ldCreateWebView {
    // 网络下载成功,本地路径
    NSString *filePath = [self ldGetLocalFilePath];
    // 非网络下载的路径
    if (self.currentFileModel.fileAbsolutePath) {
        filePath = self.currentFileModel.fileAbsolutePath;
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, FrameW, FrameH - 64 - 45)];
        _wkWebView.UIDelegate = self;
        _wkWebView.navigationDelegate = self;
        _wkWebView.allowsBackForwardNavigationGestures = YES;
        
        NSURL *url = [NSURL fileURLWithPath:filePath];
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
            // iOS9. One year later things are OK.
            [_wkWebView loadFileURL:url allowingReadAccessToURL:url];
        } else {
            // iOS8. Things can be workaround-ed
            NSURL *fileURL = [self ldFileURLForBuggyWKWebView8:url];
            NSURLRequest *request = [NSURLRequest requestWithURL:fileURL];
            [_wkWebView loadRequest:request];
        }
        
        [self.view addSubview:_wkWebView];
    } else {
        // 清除WebView的缓存
        NSURLCache *cache = [NSURLCache sharedURLCache];
        [cache removeAllCachedResponses];
        [cache setDiskCapacity:0];
        [cache setMemoryCapacity:0];
        
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, FrameW, FrameH - 64 - 45)];
        [_webView setScalesPageToFit:YES];
        _webView.delegate = self;
        
        NSURL *url = [NSURL fileURLWithPath:filePath];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [_webView loadRequest:request];
        
        [self.view addSubview:_webView];
    }
    
    // 其他应用打开
    _documentController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
    _documentController.delegate = self;
    _otherOpenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _otherOpenButton.frame = CGRectMake(0, FrameH - 64 - 45, FrameW, 45);
    _otherOpenButton.titleLabel.font = [UIFont systemFontOfSize:17.f];
    [_otherOpenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_otherOpenButton setTitle:@"用其他应用打开" forState:UIControlStateNormal];
    _otherOpenButton.backgroundColor = [UIColor redColor];
    [self.view addSubview:_otherOpenButton];
    [_otherOpenButton addTarget:self action:@selector(ldOtherOpenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

/** @"用其他应用打开" Btn触发事件 */
- (void)ldOtherOpenBtnClick:(UIButton *)btn {
    [self ldPresentOptionsMenu];
}

/** 显示@"用其他应用打开"打开的菜单栏 */
- (void)ldPresentOptionsMenu {
    [_documentController presentOptionsMenuFromRect:self.view.bounds inView:self.view animated:YES];
}



#pragma mark - Get
/** 进度条 */
- (UIProgressView *)fileProgressView {
    if (!_fileProgressView) {
        _fileProgressView = [[UIProgressView alloc] initWithFrame:CGRectMake(45/2.f, CGRectGetMaxY(self.iconFileDescribeLabel.frame) + 29, FrameW - (45/2.f + 61/2.f), 10)];
        [_fileProgressView setProgressViewStyle:UIProgressViewStyleDefault];
        _fileProgressView.progressTintColor = UIColorFromRGB(0x61cbf5);
        CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 3.0f);
        _fileProgressView.transform = transform;
        _fileProgressView.layer.masksToBounds = YES;
        _fileProgressView.layer.cornerRadius = 2.f;
        [self.view addSubview:_fileProgressView];
    }
    return _fileProgressView;
}

/** 关闭按钮 */
- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeBtn.frame = CGRectMake(FrameW - 65/2.f, CGRectGetMaxY(self.iconFileDescribeLabel.frame) + 19, 20, 20);
//        _closeBtn.backgroundColor = [UIColor redColor];
        NSString *closeImagePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"JhtDocViewerImages.bundle/close"];
        UIImage *closeBtnImage = [UIImage imageWithContentsOfFile:closeImagePath];
        [_closeBtn setImage:closeBtnImage forState:UIControlStateNormal];
        [self.view addSubview:_closeBtn];
        [_closeBtn addTarget:self action:@selector(ldCloseClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

/** 重试按钮 */
- (UIButton *)retryBtn {
    if (!_retryBtn) {
        _retryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _retryBtn.frame = CGRectMake((FrameW - 80.f)/2.f, CGRectGetMaxY(_downloadingStateLabel.frame) + 10, 80, 30);
        _retryBtn.backgroundColor = UIColorFromRGB(0x61cbf5);
        [_retryBtn setTitle:@"重新加载" forState:UIControlStateNormal];
        _retryBtn.titleLabel.font = [UIFont systemFontOfSize:16.f];
        [_retryBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _retryBtn.layer.cornerRadius = 3.f;
        _retryBtn.layer.masksToBounds = YES;
        
        [_retryBtn addTarget:self action:@selector(ldRetryClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_retryBtn];
    }
    return _retryBtn;
}

/** 下载进度文案label */
- (UILabel *)downloadingStateLabel {
    if (!_downloadingStateLabel) {
        _downloadingStateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _downloadingStateLabel.text = @"正在加载中...";
        _downloadingStateLabel.font = [UIFont systemFontOfSize:14.f];
        _downloadingStateLabel.textColor = UIColorFromRGB(0x808080);
        [_downloadingStateLabel sizeToFit];
        [self.view addSubview:_downloadingStateLabel];
        _downloadingStateLabel.frame = CGRectMake((FrameW - CGRectGetWidth(_downloadingStateLabel.frame)) / 2.f, CGRectGetMaxY(self.iconFileDescribeLabel.frame) + 29 + 19, _downloadingStateLabel.frame.size.width + 50, _downloadingStateLabel.frame.size.height);
    }
    return _downloadingStateLabel;
}



#pragma mark - Get Sel
/** 重新加载按钮触发方法 */
- (void)ldRetryClick {
    NSUserDefaults *defalts = [NSUserDefaults standardUserDefaults];
    NSString *netState = [defalts objectForKey:@"netStatus"];
    if ([netState isEqualToString:@"0"]) {
        netState = @"网络暂不可用，请稍后重试！";
        [self JhtShowHint:netState];
        return;
    }
    self.downloadingStateLabel.text = @"正在加载中...";
    self.retryBtn.hidden = YES;
    // 进行下载；
    [self ldJudgeNetworkThenDownloadFile];
}

/** 红色那个关闭点击事件 */
- (void)ldCloseClick {
    [self ldRemoveFileWhenDownloadFileFailure];
    // 停止 下载文件
    [JhtDownloadRequest stopDownloadFile];
    self.fileProgressView.progress = 0;
}



#pragma mark - UIDocumentInteractionControllerDelegate
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {
    return self;
}

- (UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller {
    return self.view;
}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController *)controller {
    return self.view.frame;
}

/** 点击预览窗口的“Done”(完成)按钮时调用 */
- (void)documentInteractionControllerDidEndPreview:(UIDocumentInteractionController *)controller {
}

#pragma mark 将文件copy到tmp目录 ~~~ WKWebView
/** 将文件copy到tmp目录 ~~~ WKWebView */
- (NSURL *)ldFileURLForBuggyWKWebView8:(NSURL *)fileURL {
    NSError *error = nil;
    if (!fileURL.fileURL || ![fileURL checkResourceIsReachableAndReturnError:&error]) {
        return nil;
    }
    // Create "/temp/www" directory
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *temDirURL = [[NSURL fileURLWithPath:NSTemporaryDirectory()] URLByAppendingPathComponent:@"www"];
    [fileManager createDirectoryAtURL:temDirURL withIntermediateDirectories:YES attributes:nil error:&error];
    
    NSURL *dstURL = [temDirURL URLByAppendingPathComponent:fileURL.lastPathComponent];
    // Now copy given file to the temp directory
    [fileManager removeItemAtURL:dstURL error:&error];
    [fileManager copyItemAtURL:fileURL toURL:dstURL error:&error];
    // Files in "/temp/www" ld flawlesly :)
    return dstURL;
}



#pragma mark - UIWebViewDelegate
- (void)webViewDidStartld:(UIWebView *)webView {
    [self bsShowLoadingView];
}

- (void)webViewDidFinishld:(UIWebView *)webView {
    [self bsStopLoadingView];
    
}

- (void)webView:(UIWebView *)webView didFailldWithError:(NSError *)error {
    [self bsStopLoadingView];
}



#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [self bsShowLoadingView];
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self bsStopLoadingView];
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
    [self bsStopLoadingView];
}

/*
 // 接收到服务器跳转请求之后再执行
 - (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)  navigation {
 
 }
 
 // 在收到响应后，决定是否跳转
 - (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
 
 }
 
 // 在发送请求之前，决定是否跳转
 - (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
 
 }
 */



#pragma mark - WKUIDelegate
// 1.创建一个新的WebVeiw
- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    return nil;
}

// 2.WebVeiw关闭（9.0中的新方法）
- (void)webViewDidClose:(WKWebView *)webView NS_AVAILABLE(10_11, 9_0) {
    
}

// 3.显示一个JS的Alert（与JS交互）
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
}

// 4.弹出一个输入框（与JS交互的）
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler {
    
}

// 5.显示一个确认框（JS的）
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    
}



#pragma mark - alertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 123) {
        // 开始下载
        [self ldDrawProgressUIForDowningFile];
    }
}


@end
