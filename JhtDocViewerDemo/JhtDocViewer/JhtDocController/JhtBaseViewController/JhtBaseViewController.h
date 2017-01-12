//
//  JhtBaseViewController.h
//  JhtTools
//
//  github主页: https://github.com/jinht
//  CSDN博客: http://blog.csdn.net/anticipate91
//
//  Created by Jht on 16/5/15.
//  Copyright © 2016年 靳海涛. All rights reserved.
//

#import <UIKit/UIKit.h>

/** controller父类 */
@interface JhtBaseViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UIGestureRecognizerDelegate> {
    UITableView *_baseTableView;
    NSMutableArray *_baseSourceArray;
    
    // 无网络提示的View
    UIView *_netDisconnectView;
}

/* view的frame */
/** 屏幕的宽度 */
#define FrameW [UIScreen mainScreen].bounds.size.width
/** 屏幕的高度 */
#define FrameH [UIScreen mainScreen].bounds.size.height
/** 375的比例尺 */
#define WidthScale375 ([UIScreen mainScreen].bounds.size.width/375)

/** 颜色转换  例:#000000 UIColorFromRGB(0x000000) */
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]




#pragma mark - 父类封装的便捷函数
#pragma mark Navigation
/** 创建导航栏左侧自定义的返回按钮 */
- (void)bsCreateNavigationBarLeftBtn;
/** 导航栏左侧返回按钮触发事件 */
- (void)bsPopToFormerController;

/** 创建Navigationbar的TitleView */
- (void)bsCreateNavigationBarTitleViewWithLabelTitle:(NSString *)title;


@end
