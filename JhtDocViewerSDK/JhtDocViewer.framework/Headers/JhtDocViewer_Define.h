//
//  JhtDocViewer_Define.h
//  JhtDocViewerDemo
//
//  Created by Jht on 2017/10/19.
//  Copyright © 2017年 JhtDocViewerDemo. All rights reserved.
//

#ifndef JhtDocViewer_Define_h
#define JhtDocViewer_Define_h


#define FrameW [UIScreen mainScreen].bounds.size.width
#define FrameH [UIScreen mainScreen].bounds.size.height
/** 375 比例尺 */
#define WidthScale375 ([UIScreen mainScreen].bounds.size.width/375)

/** 状态栏(StatusBar) 高度 */
#define KStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
/** 导航栏 高度 */
#define KNavBarHeight CGRectGetHeight(self.navigationController.navigationBar.frame)

/** 颜色转换  eg: #000000 UIColorFromRGB(0x000000) */
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

/** iPhoneX* */
#define JhtIsIphoneX (CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(375.0f, 812.0f)) || CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(812.0f, 375.0f)))
#define JhtIsIphoneXSMax (CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(414.0f, 896.0f)) || CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(896.0f, 414.0f)))
/** SafeAreaInsetsBottom */
#define JhtSafeAreaInsetsBottom ((JhtIsIphoneX || JhtIsIphoneXSMax) ? (34) : (0))


#endif /* JhtDocViewer_Define_h */
