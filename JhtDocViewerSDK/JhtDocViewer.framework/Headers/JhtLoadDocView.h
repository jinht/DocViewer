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
@class JhtDocFileOperations;
@class JhtLoadDocViewParamModel;
@class OtherOpenButtonParamModel;
@class JhtShowDumpingViewParamModel;

/** 文本加载 View */
@interface JhtLoadDocView : UIView

#pragma mark - property(optional)
/** otherOpenButton 配置Model */
@property (nonatomic, strong) OtherOpenButtonParamModel *otherOpenButtonParamModel;



#pragma mark - Public Method
/** 初始化
 *  fileModel：当前 文件model
 *  errorFView：errorView 父View（一般为self.navigationController.view）
 *  loadDocViewParamModel：loadDocView 配置Model（内部均有default值，可为nil）
 *  showDumpingViewParamModelparamModel：showDumpingView 配置Model（内部均有default值，可为nil）
 *  otherOpenButtonParamModel：otherOpenButton 配置Model（内部均有default值，可为nil）
 */
- (instancetype)initWithFrame:(CGRect)frame withFileModel:(JhtFileModel *)fileModel withShowErrorViewOfFatherView:(UIView *)errorFView withLoadDocViewParamModel:(JhtLoadDocViewParamModel *)loadDocViewParamModel withShowDumpingViewParamModel:(JhtShowDumpingViewParamModel *)showDumpingViewParamModel withOtherOpenButtonParamModel:(OtherOpenButtonParamModel *)otherOpenButtonParamModel;

typedef void(^finishedDownloadCompletionHandler)(NSString *urlStr);
/** 网络下载完成之后 本地存储的路径（NSUTF8StringEncoding） */
- (void)finishedDownloadCompletionHandler:(finishedDownloadCompletionHandler)block;


@end
