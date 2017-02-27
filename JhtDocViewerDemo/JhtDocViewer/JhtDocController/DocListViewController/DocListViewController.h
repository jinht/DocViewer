//
//  DocListViewController.h
//  JhtTools
//
//  github主页: https://github.com/jinht
//  CSDN博客: http://blog.csdn.net/anticipate91
//
//  Created by Jht on 16/7/8.
//  Copyright © 2016年 靳海涛. All rights reserved.
//

#import "JhtBaseViewController.h"

/** 文件列表类 */
@interface DocListViewController : JhtBaseViewController

/** 从appDelegate里面，跳转过来，主要用于打开别的软件的共享过来的文档 */
@property (nonatomic, strong) NSString *appFilePath;


@end
