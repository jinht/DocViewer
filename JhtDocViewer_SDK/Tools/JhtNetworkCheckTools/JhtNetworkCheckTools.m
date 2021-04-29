//
//  JhtNetworkCheckTools.m
//  JhtTools
//
//  GitHub主页: https://github.com/jinht
//  CSDN博客: http://blog.csdn.net/anticipate91
//
//  Created by Jht on 16/5/19.
//  Copyright © 2016年 JhtTools. All rights reserved.
//

#import "JhtNetworkCheckTools.h"
#import "Reachability.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

/** 网络状态变化通知Key */
NSString *const KNCTNetworkStatusChangedNotKey = @"KNCTNetworkStatusChangedNotKey";

@interface JhtNetworkCheckTools ()
/** 是否正在监听 */
@property (nonatomic, assign) BOOL isMonitoring;

/** 2G数组 */
@property (nonatomic, strong) NSArray *network2GArray;
/** 3G数组 */
@property (nonatomic, strong) NSArray *network3GArray;
/** 4G数组 */
@property (nonatomic, strong) NSArray *network4GArray;
/** 网络状态中文数组 */
@property (nonatomic, strong) NSArray *networkStatusStringArray;

@property (nonatomic, strong) Reachability *reachability;
/** 电话网络信息 */
@property (nonatomic, strong) CTTelephonyNetworkInfo *telephonyNetworkInfo;
/** 目前的无线接入 */
@property (nonatomic, copy) NSString *currentRaioAccess;

@end


@implementation JhtNetworkCheckTools

#pragma mark - Init
+ (void)initialize {
    JhtNetworkCheckTools *status = [JhtNetworkCheckTools sharedInstance];
    status.telephonyNetworkInfo =  [[CTTelephonyNetworkInfo alloc] init];
}


#pragma mark - Public Method
#pragma mark Check
+ (JhtNetWorkStatus)currentNetWork_Status {
    JhtNetworkCheckTools *status = [JhtNetworkCheckTools sharedInstance];
    
    return [status nctChectStatusWithRadioAccessTechnology];
}

+ (NSString *)currentNetWork_StatusString {
    JhtNetworkCheckTools *status = [JhtNetworkCheckTools sharedInstance];
    
    return status.networkStatusStringArray[[self currentNetWork_Status]];
}

#pragma mark start/stop
+ (void)startMonitoringWithListener:(id<JhtNetworkCheckToolsProtocol>)listener {
    JhtNetworkCheckTools *status = [JhtNetworkCheckTools sharedInstance];
    if (status.isMonitoring) {
        NSLog(@"网络监听已开启，请勿重复开启");
        
        [self stopMonitoringWithListener:(id<JhtNetworkCheckToolsProtocol>)listener];
    }
    
    // 注册监听
    [[NSNotificationCenter defaultCenter] addObserver:status selector:@selector(nctNetWorkStatusChanged:) name:kReachabilityChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:status selector:@selector(nctNetWorkStatusChanged:) name:CTRadioAccessTechnologyDidChangeNotification object:nil];
    
    [status.reachability startNotifier];
    
    // 标记正在监听中
    status.isMonitoring = YES;
}

+ (void)stopMonitoringWithListener:(id<JhtNetworkCheckToolsProtocol>)listener {
    JhtNetworkCheckTools *status = [JhtNetworkCheckTools sharedInstance];
    
    if (!status.isMonitoring) {
        NSLog(@"网络监听已关闭，请勿重复关闭");
        return;
    }
    
    // 注销监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [status.reachability stopNotifier];
    
    // 标记 未 正在监听中
    status.isMonitoring = NO;
}

#pragma mark Judge
+ (BOOL)isNetworkEnable {
    JhtNetWorkStatus networkStatus = [self currentNetWork_Status];
    
    return (networkStatus != NetWorkStatus_Unkhow) && (networkStatus != NetWorkStatus_None);
}

+ (BOOL)isWIFI {
    return [self currentNetWork_Status] == NetWorkStatus_WIFI;
}

+ (BOOL)isHighSpeedNetwork {
    JhtNetWorkStatus networkStatus = [self currentNetWork_Status];
    return networkStatus == NetWorkStatus_3G || networkStatus == NetWorkStatus_4G || networkStatus == NetWorkStatus_WIFI;
}


#pragma mark - Private Method
/** 单例获取自身对象 */
static JhtNetworkCheckTools *jhtNetworkCheck = nil;
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        jhtNetworkCheck = [[self alloc] init];
    });
    
    return jhtNetworkCheck;
}

/** 查询网络连接状态 */
- (JhtNetWorkStatus)nctChectStatusWithRadioAccessTechnology {
    JhtNetWorkStatus status = (JhtNetWorkStatus)[self.reachability currentReachabilityStatus];
    
    NSString *technology = self.currentRaioAccess;
    if ((status == ReachableViaWWAN) && (technology != nil)) {
        if ([self.network2GArray containsObject:technology]) {
            status = NetWorkStatus_2G;
        } else if ([self.network3GArray containsObject:technology]) {
            status = NetWorkStatus_3G;
        } else if ([self.network4GArray containsObject:technology]) {
            status = NetWorkStatus_4G;
        }
    }
    
    return status;
}

/** 网络状态发生变化 */
- (void)nctNetWorkStatusChanged:(NSNotification *)notification {
    // 发送通知
    if (notification.name == CTRadioAccessTechnologyDidChangeNotification &&
        notification.object != nil) {
        self.currentRaioAccess = self.telephonyNetworkInfo.currentRadioAccessTechnology;
    }
    
    // 再次发出通知
    NSDictionary *userInfo = @{@"currentStatus_Enum" : @([JhtNetworkCheckTools currentNetWork_Status]),
                               @"currentStatus_String" : [JhtNetworkCheckTools currentNetWork_StatusString]
                               };
    [[NSNotificationCenter defaultCenter] postNotificationName:KNCTNetworkStatusChangedNotKey object:self userInfo:userInfo];
}


#pragma mark - Getter
- (NSArray *)network2GArray {
    if (!_network2GArray) {
        _network2GArray = @[CTRadioAccessTechnologyEdge,
                            CTRadioAccessTechnologyGPRS];
    }
    
    return _network2GArray;
}

- (NSArray *)network3GArray {
    if (!_network3GArray) {
        _network3GArray = @[CTRadioAccessTechnologyHSDPA,
                            CTRadioAccessTechnologyWCDMA,
                            CTRadioAccessTechnologyHSUPA,
                            CTRadioAccessTechnologyCDMA1x,
                            CTRadioAccessTechnologyCDMAEVDORev0,
                            CTRadioAccessTechnologyCDMAEVDORevA,
                            CTRadioAccessTechnologyCDMAEVDORevB,
                            CTRadioAccessTechnologyeHRPD];
    }
    
    return _network3GArray;
}

- (NSArray *)network4GArray {
    if (!_network4GArray) {
        _network4GArray = @[CTRadioAccessTechnologyLTE];
    }
    
    return _network4GArray;
}

- (NSArray *)networkStatusStringArray {
    if (!_networkStatusStringArray) {
        _networkStatusStringArray = @[@"无网络", @"WIFI", @"蜂窝网络", @"2G", @"3G", @"4G", @"未知网络"];
    }
    
    return _networkStatusStringArray;
}

- (Reachability *)reachability {
    if (!_reachability) {
        _reachability = [Reachability reachabilityForInternetConnection];
    }
    
    return _reachability;
}

- (CTTelephonyNetworkInfo *)telephonyNetworkInfo {
    if (!_telephonyNetworkInfo) {
        _telephonyNetworkInfo = [[CTTelephonyNetworkInfo alloc] init];
    }
    
    return _telephonyNetworkInfo;
}

- (NSString *)currentRaioAccess {
    if (!_currentRaioAccess) {
        _currentRaioAccess = self.telephonyNetworkInfo.currentRadioAccessTechnology;
    }
    
    return _currentRaioAccess;
}


@end
