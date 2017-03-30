//
//  JhtLoadDocViewController.h
//  JhtTools
//
//  github主页: https://github.com/jinht
//  CSDN博客: http://blog.csdn.net/anticipate91
//
//  Created by Jht on 16/7/10.
//  Copyright © 2016年 靳海涛. All rights reserved.
//

#import "JhtBaseViewController.h"
@class JhtFileModel;
@class JhtShowDumpingViewParamModel;

/** 网络数据下载完成路径 */
typedef void(^finishedDownloadCompletionHandler)(NSString *urlStr);

/** 加载文本类 */
@interface JhtLoadDocViewController : JhtBaseViewController
#pragma mark - property
#pragma mark required
/** 标题 */
@property (nonatomic, strong) NSString *titleStr;

/** 用于下载的model */
@property (nonatomic, strong) JhtFileModel *currentFileModel;


#pragma mark optional
/** 无网络连接提示语
 *  default：@"当前网络暂不可用，请检查网络设置"
 */
@property (nonatomic, strong) NSString *lostNetHint;
/** 内存不足提示语 
 *  default：@"手内内存不足，请进行清理"
 */
@property (nonatomic, strong) NSString *notEnoughMemoryHint;
/** 文件正在下载中的提示语 
 *  default：@"正在加载中..."
 */
@property (nonatomic, strong) NSString *downloadingHint;
/** 文件下载失败提示语 
 *  default：@"文件下载失败"
 */
@property (nonatomic, strong) NSString *downloadFailedHint;

/** 清理几天前的文件
 *  default：0
 */
@property (nonatomic, assign) NSInteger daysAgo;
/** 下载进度条填充颜色
 *  default：UIColorFromRGB(0x61CBF5)
 */
@property (nonatomic, strong) UIColor *downloadProgressTintColor;

/** 提示框model相关参数 */
@property (nonatomic, strong) JhtShowDumpingViewParamModel *paramModel;



#pragma mark - Public Method
/** 网络下载完成之后 本地存储的路径 */
- (void)finishedDownloadCompletionHandler:(finishedDownloadCompletionHandler)block;


@end
