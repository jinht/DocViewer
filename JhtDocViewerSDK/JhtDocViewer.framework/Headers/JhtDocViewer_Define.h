//
//  JhtDocViewer_Define.h
//  JhtDocViewerDemo
//
//  Created by Jht on 2017/10/19.
//  Copyright © 2017年 JhtDocViewerDemo. All rights reserved.
//

#ifndef JhtDocViewer_Define_h
#define JhtDocViewer_Define_h


/** 屏幕的宽度 */
#define FrameW [UIScreen mainScreen].bounds.size.width
/** 屏幕的高度 */
#define FrameH [UIScreen mainScreen].bounds.size.height
/** 375的比例尺（iPhoneh 6） */
#define WidthScale375 ([UIScreen mainScreen].bounds.size.width/375)

/** 状态栏(StatusBar) 高度 */
#define KStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
/** 导航栏 高度 */
#define KNavBarHeight CGRectGetHeight(self.navigationController.navigationBar.frame)

/** 颜色转换  例：#000000 UIColorFromRGB(0x000000) */
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]



#endif /* JhtDocViewer_Define_h */
