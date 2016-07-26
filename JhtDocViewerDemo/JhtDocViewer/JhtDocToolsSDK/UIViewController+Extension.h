//
//  UIViewController+Extension.h
//  JhtTools
//
//  Created by Jht on 16/6/1.
//  Copyright © 2016年 靳海涛. All rights reserved.
//

#import <UIKit/UIKit.h>

/** UIViewController的扩展 */
@interface UIViewController (Extension)

#pragma mark - 提示框
/** 常用的提示框 */
- (void)JhtShowHint:(NSString *)hint;

/** 可以设置停留时间&&Y轴偏移量的提示框 */
- (void)JhtShowHint:(NSString *)hint withDelay:(NSTimeInterval)delay withOffsetY:(float)offsetY;


@end
