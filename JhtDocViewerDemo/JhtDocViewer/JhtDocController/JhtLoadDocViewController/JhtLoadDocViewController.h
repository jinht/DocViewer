//
//  JhtLoadDocViewController.h
//  JhtTools
//
//  Created by Jht on 16/7/10.
//  Copyright © 2016年 靳海涛. All rights reserved.
//

#import "JhtBaseViewController.h"
#import "JhtFileModel.h"

/** 加载文本类 */
@interface JhtLoadDocViewController : JhtBaseViewController

/** 标题 */
@property (nonatomic, copy) NSString *titleStr;

/** 用于下载的model */
@property (nonatomic, strong) JhtFileModel *currentFileModel;


@end
