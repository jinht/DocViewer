//
//  JhtShowDumpingViewParamModel.h
//  JhtDocViewerDemo
//
//  github主页: https://github.com/jinht
//  CSDN博客: http://blog.csdn.net/anticipate91
//
//  Created by Jht on 2017/1/11.
//  Copyright © 2017年 Jht. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 下滑提示框配置参数model */
@interface JhtShowDumpingViewParamModel : NSObject
#pragma mark optional
/** 提示框下拉整体坐标 
 *  default：CGRectMake(0, 0, FrameW, 65)
 */
@property (nonatomic, assign) CGRect showViewRect;
/** 提示框 文字 label坐标 
 *  default：CGRectMake(CGRectGetMaxX(_paramModel.showNetLostImageViewRect) + 8, _paramModel.showViewRect.size.height - 35, _paramModel.showViewRect.size.width - (CGRectGetMaxX(_paramModel.showNetLostImageViewRect) + 8) * 2, 25)
 */
@property (nonatomic, assign) CGRect showLabelRect;
/** 提示框 图标 坐标 
 *  default：CGRectMake(15, _paramModel.showViewRect.size.height - 35 + (25 - 20) / 2.0, 20, 20)
 */
@property (nonatomic, assign) CGRect showNetLostImageViewRect;
/** 提示框文字颜色 
 *  default：UIColorFromRGB(0x666666)
 */
@property (nonatomic, strong) UIColor *showTintColor;
/** 提示框字号大小 
 *  default：[UIFont boldSystemFontOfSize:15]
 */
@property (nonatomic, strong) UIFont *showFont;
/** 提示文字位置 
 *  default：NSTextAlignmentLeft
 */
@property(nonatomic, assign) NSTextAlignment showTextAlignment;
/** 提示框背景颜色 
 *  default：[UIColor whiteColor]
 */
@property (nonatomic, strong) UIColor *showBackgroundColor;
/** 提示框背景图片 
 *  default：[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"JhtDocViewerImages.bundle/dumpView"]
 */
@property (nonatomic, strong) NSString *showBackgroundImageName;
/** 是否隐藏警示小图标 
 *  default：NO
 */
@property (nonatomic, assign) BOOL isHiddenSignImageView;


@end
