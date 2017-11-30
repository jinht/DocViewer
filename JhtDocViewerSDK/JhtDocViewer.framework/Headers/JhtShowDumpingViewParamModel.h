//
//  JhtShowDumpingViewParamModel.h
//  JhtDocViewerDemo
//
//  GitHub主页: https://github.com/jinht
//  CSDN博客: http://blog.csdn.net/anticipate91
//
//  Created by Jht on 2017/1/11.
//  Copyright © 2017年 JhtDocViewer. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 展示文字label的高度 */
static const NSInteger KSDPMShowLabelHeight = 25;


/** 下滑提示框配置参数model */
@interface JhtShowDumpingViewParamModel : NSObject

#pragma mark - property
#pragma mark optional
/** 提示框下拉整体坐标 
 *  default：CGRectMake(0, 0, FrameW, 65)
 */
@property (nonatomic, assign) CGRect showViewFrame;

/** 提示框背景颜色
 *  default：[UIColor whiteColor]
 */
@property (nonatomic, strong) UIColor *showBackgroundColor;
/** 提示框背景图片
 *  default：[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"JhtDocViewerImages.bundle/dumpView"]
 */
@property (nonatomic, strong) NSString *showBackgroundImageName;

/** 是否隐藏前面警示
 *  default：NO
 */
@property (nonatomic, assign) BOOL isHiddenFormerWarningIcon;
/** 前面警示图标 坐标
 *  default：CGRectMake(15, (_paramModel.showViewFrame.size.height - 35) + ((showLabelHeight - 20) / 2.0), 20, 20)
 */
@property (nonatomic, assign) CGRect formerWarningIconFrame;

/** 提示框 文字 label坐标
 *  default：CGRectMake(CGRectGetMaxX(_paramModel.showNetLostImageViewRect) + 8, _paramModel.showViewFrame.size.height - 35, _paramModel.showViewFrame.size.width - (CGRectGetMaxX(_paramModel.showNetLostImageViewRect) + 8) * 2, showLabelHeight)
 */
@property (nonatomic, assign) CGRect showLabelFrame;
/** 提示框文字颜色 
 *  default：UIColorFromRGB(0x666666)
 */
@property (nonatomic, strong) UIColor *showTextColor;
/** 提示框文字字号大小
 *  default：[UIFont boldSystemFontOfSize:15]
 */
@property (nonatomic, strong) UIFont *showTextFont;
/** 提示文字位置属性
 *  default：NSTextAlignmentLeft
 */
@property (nonatomic, assign) NSTextAlignment showTextAlignment;


@end
