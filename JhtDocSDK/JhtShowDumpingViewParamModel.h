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

/** 提示框下拉整体坐标 */
@property (nonatomic, assign) CGRect showViewRect;
/** 提示框 文字 label坐标 */
@property (nonatomic, assign) CGRect showLabelRect;
/** 提示框 图标 坐标 */
@property (nonatomic, assign) CGRect showNetLostImageViewRect;
/** 提示框文字颜色 */
@property (nonatomic, strong) UIColor *showTintColor;
/** 提示框字号大小 */
@property (nonatomic, strong) UIFont *showFont;
/** 提示文字位置 */
@property(nonatomic, assign) NSTextAlignment showTextAlignment;
/** 提示框背景颜色 */
@property (nonatomic, strong) UIColor *showBackgroundColor;
/** 提示框背景图片 */
@property (nonatomic, strong) NSString *showBackgroundImageName;
/** 是否隐藏警示小图标  Yes：隐藏  NO：不隐藏(Default) */
@property (nonatomic, assign) BOOL isHiddenSignImageView;


@end
