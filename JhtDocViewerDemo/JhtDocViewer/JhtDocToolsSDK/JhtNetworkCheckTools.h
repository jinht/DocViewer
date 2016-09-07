//
//  JhtNetworkCheckTools.h
//  JhtTools
//
//  Created by Jht on 16/5/19.
//  Copyright © 2016年 靳海涛. All rights reserved.
//

#import <UIKit/UIKit.h>

// 网络监听返回枚举类
typedef enum {
    NETWORK_TYPE_NONE = 0,
    NETWORK_TYPE_WIFI = 1,
    NETWORK_TYPE_2G = 2,
    NETWORK_TYPE_3G = 3,
    NETWORK_TYPE_4G = 4
}NETWORK_TYPE;

/** 网络监听类 */
@interface JhtNetworkCheckTools : NSObject

/** 单例获取自身对象 */
+ (instancetype)sharedInstance;

/** 开启检查网络的监听
 *  pollingInterval：轮询检查网络状态的时间间隔
 */
- (void)netStartNetworkNotifyWithPollingInterval:(CGFloat)pollingInterval;
/** 停止检查网络的监听 */
- (void)netStopNetworkNotify;

/** 获取当前网络状态(类型) */
- (NETWORK_TYPE)netGetCurrentNetworkType;


@end
