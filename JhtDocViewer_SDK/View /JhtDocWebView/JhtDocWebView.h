//
//  JhtDocWebView.h
//  JhtDocViewerDemo
//
//  GitHub主页: https://github.com/jinht
//  CSDN博客: http://blog.csdn.net/anticipate91
//
//  Created by Jht on 2017/1/6.
//  Copyright © 2017年 JhtDocViewer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WKWebView;
@class OtherOpenButtonParamModel;

/** 加载文件的WebView */
@interface JhtDocWebView : UIView

#pragma mark - property
/** 加载Doc的webView */
@property (nonatomic, strong, readonly) WKWebView *wkWebView;

/** 文件路径 */
@property (nonatomic, strong) NSString *filePath;
/** OtherOpenButton 配置Model */
@property (nonatomic, strong) OtherOpenButtonParamModel *otherOpenButtonParamModel;


@end
