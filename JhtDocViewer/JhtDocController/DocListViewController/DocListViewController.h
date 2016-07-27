//
//  DocListViewController.h
//  JhtTools
//
//  Created by Jht on 16/7/8.
//  Copyright © 2016年 靳海涛. All rights reserved.
//

#import "JhtBaseViewController.h"

@interface DocListViewController : JhtBaseViewController

/** 从appDelegate里面，跳转过来，主要用于打开别的软件的共享过来的文档 */
@property (nonatomic, copy) NSString *appFilePath;


@end
