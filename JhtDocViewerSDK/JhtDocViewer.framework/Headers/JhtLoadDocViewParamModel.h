//
//  JhtLoadDocViewParamModel.h
//  JhtDocViewerDemo
//
//  GitHub主页: https://github.com/jinht
//  CSDN博客: http://blog.csdn.net/anticipate91
//
//  Created by Jht on 2017/10/19.
//  Copyright © 2017年 JhtDocViewerDemo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OtherOpenButtonParamModel;
@class JhtShowDumpingViewParamModel;

/** 文本加载 View 配置Model */
@interface JhtLoadDocViewParamModel : NSObject

#pragma mark - property
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
 *  default：@"玩命加载中..."
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
@property (nonatomic, strong) JhtShowDumpingViewParamModel *showDumpingViewParamModelparamModel;

/** 《用其他应用打开按钮》配置Model */
@property (nonatomic, strong) OtherOpenButtonParamModel *otherOpenButtonParamModel;


@end
