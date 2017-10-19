//
//  JhtNetWorkStatus.h
//  JhtTools
//
//  GitHub主页: https://github.com/jinht
//  CSDN博客: http://blog.csdn.net/anticipate91
//
//  Created by Jht on 2017/10/18.
//  Copyright © 2017年 JhtTools. All rights reserved.
//

#ifndef JhtNetWorkStatus_h
#define JhtNetWorkStatus_h

/** 网络监听_网络状态声明类 */

/** 网络状态 */
typedef NS_ENUM(NSUInteger, JhtNetWorkStatus) {
    // 无网络
    NetWorkStatus_None = 0,
    
    // WIFI
    NetWorkStatus_WIFI,
    
    // 蜂窝网络
    NetWorkStatus_2G,
    NetWorkStatus_3G,
    NetWorkStatus_4G,
    
    // 未知网络
    NetWorkStatus_Unkhow
};


#endif /* JhtNetWorkStatus_h */
