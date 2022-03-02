//
//  JhtDocWebView.m
//  JhtDocViewerDemo
//
//  GitHub主页: https://github.com/jinht
//  CSDN博客: http://blog.csdn.net/anticipate91
//
//  Created by Jht on 2017/1/6.
//  Copyright © 2017年 JhtDocViewer. All rights reserved.
//

#import "JhtDocWebView.h"
#import "sys/utsname.h"
#import <WebKit/WebKit.h>
#import "JhtDefaultManager.h"
#import "JhtDocViewer_Define.h"
#import "OtherOpenButtonParamModel.h"

@interface JhtDocWebView () <WKNavigationDelegate, WKUIDelegate, UIDocumentInteractionControllerDelegate> {
    // 用三方打开文件
    UIDocumentInteractionController *_documentController;
}
/** 加载Doc的webView */
@property (nonatomic, strong) WKWebView *wkWebView;
/** 《用其他应用打开》按钮 */
@property (nonatomic, strong) UIButton *otherOpenButton;

@end


@implementation JhtDocWebView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self addSubview:self.wkWebView];
        
        // 其他应用打开
        _documentController = [[UIDocumentInteractionController alloc] init];
        
        _documentController.delegate = self;
        // 添加@"用其他应用打开"按钮
        [self addSubview:self.otherOpenButton];
    }
    
    return self;
}


#pragma mark - Getter
- (WKWebView *)wkWebView {
    if (!_wkWebView) {
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - 45 - JhtSafeAreaInsetsBottom)];
        
        _wkWebView.UIDelegate = self;
        _wkWebView.navigationDelegate = self;
        _wkWebView.allowsBackForwardNavigationGestures = YES;
//        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
//        config.preferences.minimumFontSize = 0.0f;
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_10_3
        if (@available(iOS 11.0, *)) {
            _wkWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _wkWebView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            _wkWebView.scrollView.scrollIndicatorInsets = _wkWebView.scrollView.contentInset;
        }
#endif
    }
    
    return _wkWebView;
}

- (UIButton *)otherOpenButton {
    if (!_otherOpenButton) {
        _otherOpenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        NSDictionary *dic = [JhtDefaultManager getConfigDataWithType:JhtDefaultType_OtherOpenButtonParam];
        
        _otherOpenButton.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 45 - JhtSafeAreaInsetsBottom, CGRectGetWidth(self.frame), 45);
        _otherOpenButton.titleLabel.font = [UIFont systemFontOfSize:[dic[@"titleFont"] floatValue]];
        [_otherOpenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_otherOpenButton setTitle:dic[@"title_Normal"] forState:UIControlStateNormal];
        [_otherOpenButton setTitle:dic[@"title_Hlighted"] forState:UIControlStateHighlighted];
        _otherOpenButton.backgroundColor = UIColorFromRGB(0x265A6C);
        
        [_otherOpenButton addTarget:self action:@selector(dwvPresentOptionsMenu) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _otherOpenButton;
}

#pragma mark Getter Method
/** 显示@"用其他应用打开"打开的菜单栏 */
- (void)dwvPresentOptionsMenu {
    [_documentController presentOptionsMenuFromRect:self.bounds inView:self.superview animated:YES];
}


#pragma mark - Setter
- (void)setOtherOpenButtonParamModel:(OtherOpenButtonParamModel *)otherOpenButtonParamModel {
    _otherOpenButtonParamModel = otherOpenButtonParamModel;
    
    if (!CGRectEqualToRect(_otherOpenButtonParamModel.btnFrame, CGRectZero)) {
        self.otherOpenButton.frame = _otherOpenButtonParamModel.btnFrame;
    }
    if (_otherOpenButtonParamModel.backgroundColor) {
        self.otherOpenButton.backgroundColor = _otherOpenButtonParamModel.backgroundColor;
    }
    
    self.otherOpenButton.hidden = _otherOpenButtonParamModel.isHiddenBtn;
    if (self.otherOpenButton.hidden) {
        self.wkWebView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        
    } else {
        self.wkWebView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - 45 - JhtSafeAreaInsetsBottom);
    }
    
    if (_otherOpenButtonParamModel.title_Normal) {
        [self.otherOpenButton setTitle:_otherOpenButtonParamModel.title_Normal forState:UIControlStateNormal];
    }
    if (_otherOpenButtonParamModel.titleColor_Normal) {
        [self.otherOpenButton setTitleColor:_otherOpenButtonParamModel.titleColor_Normal forState:UIControlStateNormal];
    }
    if (_otherOpenButtonParamModel.title_Hlighted) {
        [self.otherOpenButton setTitle:_otherOpenButtonParamModel.title_Hlighted forState:UIControlStateHighlighted];
    }
    if (_otherOpenButtonParamModel.titleColor_Hlighted) {
        [self.otherOpenButton setTitleColor:_otherOpenButtonParamModel.titleColor_Hlighted forState:UIControlStateHighlighted];
    }
    
    if (_otherOpenButtonParamModel.titleFont) {
        self.otherOpenButton.titleLabel.font = _otherOpenButtonParamModel.titleFont;
    }
    
    if (_otherOpenButtonParamModel.cornerRadius) {
        self.otherOpenButton.layer.cornerRadius = _otherOpenButtonParamModel.cornerRadius;
    }
}

- (void)setFilePath:(NSString *)filePath {
    _filePath = filePath;
    // 赋值
    NSURL *url = [NSURL fileURLWithPath:filePath];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED <= 90000
    // iOS9. One year later things are OK.
//    [self.wkWebView loadFileURL:url allowingReadAccessToURL:url];
//    [self.wkWebView loadData:data MIMEType:url textEncodingName:@"UTF-8" baseURL:nil];
        NSString *lastName =[[url lastPathComponent] lowercaseString];
        if ([lastName containsString:@".txt"]) {
        //如果为UTF8格式的则body不为空
            NSString *body =[NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
     //如果不是 则进行GBK编码再解码一次
            if (!body) {
                body =[NSString stringWithContentsOfURL:url encoding:0x80000632 error:nil];
            }
            //不行用GB18030编码再解码一次
            if (!body) {
                body =[NSString stringWithContentsOfURL:url encoding:0x80000631 error:nil];
            }
            if (body) {
                body =[body stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"];//替换换行符为HTML换行符
                [self.wkWebView loadHTMLString:body baseURL:nil];
                return;
            }
            [self.wkWebView loadFileURL:url allowingReadAccessToURL:url];
        }else{
            NSURLRequest *request =[NSURLRequest requestWithURL:url];
            [self.wkWebView loadFileURL:url allowingReadAccessToURL:url];
        }
    
#else
    // iOS8. Things can be workaround-ed
//    NSURL *fileURL = [self dwvFileURLForBuggyWKWebView:url];
//    NSURLRequest *request = [NSURLRequest requestWithURL:fileURL];
//    [self.wkWebView loadRequest:request];
    NSURL *fileURL = [self dwvFileURLForBuggyWKWebView:url];
    NSString *lastName =[[url lastPathComponent] lowercaseString];
        if ([lastName containsString:@".txt"]) {
        //如果为UTF8格式的则body不为空
            NSString *body =[NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
     //如果不是 则进行GBK编码再解码一次
            if (!body) {
                body =[NSString stringWithContentsOfURL:url encoding:0x80000632 error:nil];
            }
            //不行用GB18030编码再解码一次
            if (!body) {
                body =[NSString stringWithContentsOfURL:url encoding:0x80000631 error:nil];
            }
            if (body) {
                body =[body stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"];//替换换行符为HTML换行符
                [self.wkWebView loadHTMLString:body baseURL:nil];
                return;
            }
            [self.wkWebView loadFileURL:url allowingReadAccessToURL:url];
        }else{
            NSURLRequest *request = [NSURLRequest requestWithURL:fileURL];
            [self.wkWebView loadRequest:request];
        }
#endif

    // 其他应用打开
    _documentController.URL = [NSURL fileURLWithPath:filePath];
}

#pragma mark Setter Method
/** 将文件copy到temp目录 ~~~ WKWebView */
- (NSURL *)dwvFileURLForBuggyWKWebView:(NSURL *)fileURL {
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


#pragma mark - UIDocumentInteractionControllerDelegate
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {
    // 获取view所在的viewController
    return [self dwvGetViewController];
}

- (UIView *)documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller {
    return self.superview;
}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController *)controller {
    return self.superview.frame;
}

/** 点击预览窗口的“Done”(完成)按钮时调用 */
- (void)documentInteractionControllerDidEndPreview:(UIDocumentInteractionController *)controller {
}


#pragma mark UIDocumentInteractionControllerDelegate Sel
/** 获取view所在的viewController */
- (UIViewController *)dwvGetViewController {
    for (UIView *next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    
    return nil;
}


#pragma mark - WKUIDelegate
/** 创建一个新的WebVeiw */
- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    return nil;
}

/** WebVeiw关闭（9.0中的新方法） */
- (void)webViewDidClose:(WKWebView *)webView NS_AVAILABLE(10_11, 9_0) {
    
}

/** 显示一个JS的Alert（与JS交互） */
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
}

/** 弹出一个输入框（与JS交互的） */
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler {
    
}

/** 显示一个确认框（JS的） */
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    
}


#pragma mark - WKNavigationDelegate
/** 页面开始加载时调用 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [self dwvAddLoadingView];
}

/** 当内容开始返回时调用 */
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}

/** 页面加载完成之后调用 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self dwvRemoveLoadingView];
}

/** 页面加载失败时调用 */
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(nonnull NSError *)error {
    [self dwvRemoveLoadingView];
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

#pragma mark WKNavigationDelegate Method
/** 添加@“本地文件加载中...”View */
- (void)dwvAddLoadingView {
    // 背景View
    CGFloat loadingViewWidth = (10 + 10 + 140);
    UIView *loadingView = [[UIView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - loadingViewWidth) / 2.0, ([UIScreen mainScreen].bounds.size.height - 22 - [[UIApplication sharedApplication] statusBarFrame].size.height - 44) / 2.0, loadingViewWidth, 22)];
    
    loadingView.tag = 100;
    [self addSubview:loadingView];
    
    // 加载菊花
    UIActivityIndicatorView *loadingActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    loadingActivityIndicator.frame = CGRectMake(0, (CGRectGetHeight(loadingView.frame) - 10) / 2.0, 10, 10);
    [loadingActivityIndicator startAnimating];
    [loadingView addSubview:loadingActivityIndicator];
    
    // 文字label
    UILabel *loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(loadingActivityIndicator.frame) + 10, 0, 140, 22)];
    loadingLabel.text = @"本地文件加载中...";
    loadingLabel.textColor = [UIColor colorWithRed:0.47f green:0.47f blue:0.47f alpha:1.00f];
    loadingLabel.textAlignment = NSTextAlignmentCenter;
    [loadingView addSubview:loadingLabel];
}

/** 移除@"本地文件加载中..."View */
- (void)dwvRemoveLoadingView {
    UIView *loadingView = [self viewWithTag:100];
    [loadingView removeFromSuperview];
}


@end
