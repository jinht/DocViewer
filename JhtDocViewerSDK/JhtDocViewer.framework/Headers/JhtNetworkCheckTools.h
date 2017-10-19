//
//  JhtNetworkCheckTools.h
//  JhtTools
//
//  GitHub主页: https://github.com/jinht
//  CSDN博客: http://blog.csdn.net/anticipate91
//
//  Created by Jht on 16/5/19.
//  Copyright © 2016年 JhtTools. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "JhtNetWorkStatus.h"
#import "JhtNetworkCheckToolsProtocol.h"

/** 网络状态变化通知Key */
extern const NSString *KNCTNetworkStatusChangedNotKey;

/** 网络监听类 */
@interface JhtNetworkCheckTools : NSObject

#pragma mark - Public Method
#pragma mark Check
/** 获取当前网络状态：枚举 */
+ (JhtNetWorkStatus)currentNetWork_Status;
/** 获取当前网络状态：字符串 */
+ (NSString *)currentNetWork_StatusString;


#pragma mark start/stop
/** 开始网络监听
 *	listener：监听对象，可为nil
 */
+ (void)startMonitoringWithListener:(id<JhtNetworkCheckToolsProtocol>)listener;
/** 停止网络监听
 *  listener：监听对象，可为nil
 */
+ (void)stopMonitoringWithListener:(id<JhtNetworkCheckToolsProtocol>)listener;


#pragma mark Judge
/** 是否有网络 */
+ (BOOL)isNetworkEnable;
/** 是否为WIFI */
+ (BOOL)isWIFI;
/** 是否处于高速网络环境：3G/4G/WIFI */
+ (BOOL)isHighSpeedNetwork;


@end
