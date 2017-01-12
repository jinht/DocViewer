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

/** 加载文本类 */
@interface JhtLoadDocViewController : JhtBaseViewController

#pragma mark required
/** 标题 */
@property (nonatomic, copy) NSString *titleStr;

/** 用于下载的model */
@property (nonatomic, strong) JhtFileModel *currentFileModel;


#pragma mark optional
/** 无网络连接提示语 */
@property (nonatomic, copy) NSString *lostNetHint;
/** 内存不足提示语 */
@property (nonatomic, copy) NSString *notEnoughMemoryHint;
/** 文件正在下载中的提示语 */
@property (nonatomic, copy) NSString *downloadingHint;
/** 文件下载失败提示语 */
@property (nonatomic, copy) NSString *downloadFailedHint;

/** 清理几天前的文件(默认0) */
@property (nonatomic, assign) NSInteger daysAgo;
/** 下载进度条填充颜色 */
@property (nonatomic, strong) UIColor *downloadProgressTintColor;

/** 提示框model相关参数 */
@property (nonatomic, strong) JhtShowDumpingViewParamModel *paramModel;


@end
