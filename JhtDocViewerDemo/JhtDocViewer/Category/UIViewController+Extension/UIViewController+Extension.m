//
//  UIViewController+Extension.m
//  JhtTools
//
//  Created by Jht on 16/6/1.
//  Copyright © 2016年 靳海涛. All rights reserved.
//

#import "UIViewController+Extension.h"
#import "MBProgressHUD.h"

#define IS_IPHONE_5 ( fabs( ( double )[[ UIScreen mainScreen ] bounds].size.height - ( double )568 ) < DBL_EPSILON )
// jht 添加颜色转换  例:#000000 UIColorFromRGB(0x000000) */
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@implementation UIViewController (Extension)

#pragma mark - 提示框
/** 常用的提示框 */
- (void)JhtShowHint:(NSString *)hint {
    // 判断是否有文字
    if (hint.length == 0) {
        return;
    }
    //显示提示信息
    MBProgressHUD *hud = [self createAMBProgressHUD];
    hud.label.text = hint;
    [hud hideAnimated:YES afterDelay:1.5];
}

/** 可以设置停留时间&&Y轴偏移量的提示框 */
- (void)JhtShowHint:(NSString *)hint withDelay:(NSTimeInterval)delay withOffsetY:(float)offsetY {
    // 判断是否有文字
    if (hint.length == 0) {
        return;
    }
    //显示提示信息
    MBProgressHUD *hud = [self createAMBProgressHUD];
    hud.label.text = hint;
    hud.offset = CGPointMake(hud.offset.x, hud.offset.y + offsetY);
    [hud hideAnimated:YES afterDelay:delay];
}

/** 创建MBProgressHUD */
- (MBProgressHUD *)createAMBProgressHUD {
    UIView *view = [[UIApplication sharedApplication].delegate window];
    for (NSInteger i = 0; i < view.subviews.count; i ++) {
        if ([view.subviews[i] isKindOfClass:[MBProgressHUD class]] && view.subviews[i].tag == 111) {
            return nil;
        }
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.tag = 111;
    hud.userInteractionEnabled = NO;
    // 设置背景框的颜色
    hud.bezelView.backgroundColor = UIColorFromRGB(0x131E2F);
    hud.bezelView.alpha = 0.8;
    // 设置字的颜色
    hud.contentColor = [UIColor whiteColor];
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.margin = 10.f;
    hud.offset = CGPointMake(hud.offset.x, IS_IPHONE_5?200.f:150.f);
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}



@end
