//
//  LoadDocViewController.h
//  JhtDocViewerDemo
//
//  GitHub主页: https://github.com/jinht
//  CSDN博客: http://blog.csdn.net/anticipate91
//
//  Created by Jht on 2017/10/19.
//  Copyright © 2017年 JhtDocViewer. All rights reserved.
//

#import "JhtBaseViewController.h"
@class JhtFileModel;

/** 加载文本类 */
@interface LoadDocViewController : JhtBaseViewController

#pragma mark - property
#pragma mark required
/** 标题 */
@property (nonatomic, strong) NSString *titleStr;

/** 下载文件的model */
@property (nonatomic, strong) JhtFileModel *currentFileModel;


@end
