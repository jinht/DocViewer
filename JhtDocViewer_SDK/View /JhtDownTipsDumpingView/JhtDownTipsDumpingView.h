//
//  JhtDownTipsDumpingView.h
//  JhtDocViewerDemo
//
//  GitHub主页: https://github.com/jinht
//  CSDN博客: http://blog.csdn.net/anticipate91
//
//  Created by Jht on 2017/1/11.
//  Copyright © 2017年 JhtDocViewer. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JhtShowDumpingViewParamModel;

/** 下滑提示View */
@interface JhtDownTipsDumpingView : UIView

#pragma mark - Public Method
/** show
 *  view: 动画 父View
 *  text: 动画展示 文字
 *  model: 提示框 相关参数model
 */
+ (void)showWithFView:(UIView *)view text:(NSString *)text showDumpingViewParamModel:(JhtShowDumpingViewParamModel *)model;


@end
