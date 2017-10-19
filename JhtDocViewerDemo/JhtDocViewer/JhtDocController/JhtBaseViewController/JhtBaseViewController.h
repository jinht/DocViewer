//
//  JhtBaseViewController.h
//  JhtTools
//
//  GitHub主页: https://github.com/jinht
//  CSDN博客: http://blog.csdn.net/anticipate91
//
//  Created by Jht on 16/5/15.
//  Copyright © 2016年 JhtTools. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JhtDocViewer/JhtDocViewer_Define.h>

/** VC父类 */
@interface JhtBaseViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate> {
    UITableView *_baseTableView;
    NSMutableArray *_baseSourceArray;
}



#pragma mark - Navigation Tools
/** 创建导航栏左侧自定义的返回按钮 */
- (void)bsCreateNavigationBarLeftBtn;
/** 导航栏左侧返回按钮触发事件 */
- (void)bsPopToFormerController;

/** 创建Navigationbar的TitleView */
- (void)bsCreateNavigationBarTitleViewWithLabelTitle:(NSString *)title;


@end
