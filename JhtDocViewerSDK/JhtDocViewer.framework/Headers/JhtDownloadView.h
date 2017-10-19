//
//  JhtDownloadView.h
//  JhtDocViewerDemo
//
//  GitHub主页: https://github.com/jinht
//  CSDN博客: http://blog.csdn.net/anticipate91
//
//  Created by Jht on 2017/1/5.
//  Copyright © 2017年 JhtDocViewer. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JhtFileModel;

/** 展示下载的 View */
@interface JhtDownloadView : UIView

#pragma mark - property
#pragma mark optional
/** 文件类型图片 */
@property (nonatomic, strong) UIImageView *iconFileImageView;
/** 文件名称label */
@property (nonatomic, strong) UILabel *iconFileDescribeLabel;

/** 下载进度文案label */
@property (nonatomic, strong) UILabel *downloadingStateLabel;
/** 下载进度条填充颜色
 *  default：UIColorFromRGB(0x61CBF5)
 */
@property (nonatomic, strong) UIColor *downloadProgressTintColor;
/** 进度条 */
@property (nonatomic, strong) UIProgressView *fileProgressView;

/** 关闭按钮 */
@property (nonatomic, strong) UIButton *closeBtn;
/** 下载按钮 */
@property (nonatomic, strong) UIButton *downloadBtn;

/** 文件正在下载中的提示语
 *  default：@"玩命加载中..."
 */
@property (nonatomic, strong) NSString *downloadingHint;
/** 无网络连接提示语 
 *  default：@"当前网络暂不可用，请检查网络设置"
 */
@property (nonatomic, strong) NSString *lostNetHint;



#pragma mark - Public Method
/** 初始化下载的展示View
 *  downloadingHint：文件正在下载中的提示语
 *  lostNetHint：无网络连接提示语
 *  downloadProgressTintColor：下载进度条颜色
 *  model：用于下载的model
 */
- (id)initWithFrame:(CGRect)frame withDownloadingHint:(NSString *)downloadingHint withLostNetHint:(NSString *)lostNetHint withDownloadProgressTintColor:(UIColor *)downloadProgressTintColor withFileModel:(JhtFileModel *)model;

/** 点击按钮block 0：重新加载，1：点击关闭 */
typedef void(^clickBlock)(NSInteger index);
/** 点击按钮回调的block 0：重新加载，1：点击关闭 */
- (void)clickBtnBlock:(clickBlock)block;


@end
