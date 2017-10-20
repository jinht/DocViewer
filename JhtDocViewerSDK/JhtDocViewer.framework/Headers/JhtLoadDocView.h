//
//  JhtLoadDocView.h
//  JhtDocViewerDemo
//
//  GitHub主页: https://github.com/jinht
//  CSDN博客: http://blog.csdn.net/anticipate91
//
//  Created by Jht on 2017/10/19.
//  Copyright © 2017年 JhtDocViewer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JhtFileModel;
@class JhtLoadDocViewParamModel;
@class OtherOpenButtonParamModel;
@class JhtShowDumpingViewParamModel;

/** 文本加载 View */
@interface JhtLoadDocView : UIView

#pragma mark - Public Method
/** 初始化
 *	fileModel：当前展示文件的model
 *	errorFView：展示错误提示View 父View（一般为self.navigationController.view）
 *	loadDocViewParamModel：文本加载 View 配置Model（内部均有default值，可传nil）
 *	showDumpingViewParamModelparamModel：提示框model相关参数（内部均有default值，可传nil）
 *	otherOpenButtonParamModel：《用其他应用打开按钮》配置Model（内部均有default值，可传nil）
 */
- (instancetype)initWithFrame:(CGRect)frame withFileModel:(JhtFileModel *)fileModel withShowErrorViewOfFatherView:(UIView *)errorFView withLoadDocViewParamModel:(JhtLoadDocViewParamModel *)loadDocViewParamModel withShowDumpingViewParamModel:(JhtShowDumpingViewParamModel *)showDumpingViewParamModel withOtherOpenButtonParamModel:(OtherOpenButtonParamModel *)otherOpenButtonParamModel;

/** 网络数据下载完成路径（NSUTF8StringEncoding） */
typedef void(^finishedDownloadCompletionHandler)(NSString *urlStr);
/** 网络下载完成之后 本地存储的路径（NSUTF8StringEncoding） */
- (void)finishedDownloadCompletionHandler:(finishedDownloadCompletionHandler)block;


@end
