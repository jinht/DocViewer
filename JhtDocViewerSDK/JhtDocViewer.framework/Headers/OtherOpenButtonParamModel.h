//
//  OtherOpenButtonParamModel.h
//  JhtDocViewerDemo
//
//  GitHub主页: https://github.com/jinht
//  CSDN博客: http://blog.csdn.net/anticipate91
//
//  Created by Jht on 2017/8/16.
//  Copyright © 2017年 JhtDocViewer. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 《用其他应用打开按钮》配置Model */
@interface OtherOpenButtonParamModel : NSObject

#pragma mark - property
#pragma mark optional
/** btnFrame 
 *	default：CGRectMake(0, CGRectGetHeight(self.frame) - 45, CGRectGetWidth(self.frame), 45)
 */
@property (nonatomic, assign) CGRect btnFrame;
/** backgroundColor 
 *	default：[UIFont systemFontOfSize:17.f]
 */
@property (nonatomic, strong) UIColor *backgroundColor;
/** btn cornerRadius */
@property (nonatomic, assign) CGFloat cornerRadius;

/** 是否隐藏btn
 *  default：NO
 */
@property (nonatomic, assign) BOOL isHiddenBtn;

/** btnTitle_Normal 
 *	default：@"用其他应用打开"
 */
@property (nonatomic, strong) NSString *title_Normal;
/** titleColor_Normal 
 *	default：[UIColor whiteColor]
 */
@property (nonatomic, strong) UIColor *titleColor_Normal;
/** btnTitle_hlighted 
 *	default：@"用其他应用打开"
 */
@property (nonatomic, strong) NSString *title_Hlighted;
/** titleColor_Normal 
 *	default：[UIColor whiteColor]
 */
@property (nonatomic, strong) UIColor *titleColor_Hlighted;

/** titleFont 
 *	default：[UIFont systemFontOfSize:17.f]
 */
@property (nonatomic, strong) UIFont *titleFont;


@end
