//
//  JhtDefaultManager.h
//  JhtDocViewerDemo
//
//  GitHub主页: https://github.com/jinht
//  CSDN博客: http://blog.csdn.net/anticipate91
//
//  Created by Jht on 2018/11/24.
//  Copyright © 2018 JhtDocViewerDemo. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Default Type */
typedef NS_ENUM(NSUInteger, JhtDefaultType) {
    // 文本加载 View 配置参数
    JhtDefaultType_LoadDocViewParam = 0,
    
    // 《用其他应用打开》按钮 配置参数
    JhtDefaultType_OtherOpenButtonParam
};


/** Default Manager */
@interface JhtDefaultManager : NSObject

#pragma mark - Public Method
/** 获取指定 配置 Dic */
+ (NSDictionary *)getConfigDataWithType:(JhtDefaultType)type;


@end

