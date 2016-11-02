//
//  JhtLoadDocViewController.h
//  JhtTools
//
//  github主页: https://github.com/jinht
//  CSDN博客: http://blog.csdn.net/anticipate91
//
//  Created by Jht on 16/7/10.
//  Copyright © 2016年 靳海涛. All rights reserved.
//

#import "JhtBaseViewController.h"
@class JhtFileModel;

/** 加载文本类 */
@interface JhtLoadDocViewController : JhtBaseViewController
/** 标题 */
@property (nonatomic, copy) NSString *titleStr;

/** 用于下载的model */
@property (nonatomic, strong) JhtFileModel *currentFileModel;


@end
