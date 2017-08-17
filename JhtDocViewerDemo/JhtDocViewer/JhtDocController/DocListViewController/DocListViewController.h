//
//  DocListViewController.h
//  JhtTools
//
//  GitHub主页: https://github.com/jinht
//  CSDN博客: http://blog.csdn.net/anticipate91
//
//  Created by Jht on 16/7/8.
//  Copyright © 2016年 JhtDocViewerDemo. All rights reserved.
//

#import "JhtBaseViewController.h"

/** 文件列表类 */
@interface DocListViewController : JhtBaseViewController

/** 从appDelegate里面，跳转过来，主要用于打开其他app共享跳转过来的文档 */
@property (nonatomic, strong) NSString *appFilePath;


@end
