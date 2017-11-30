//
//  JhtNetworkCheckToolsProtocol.h
//  JhtTools
//
//  Created by Jht on 2017/10/18.
//  Copyright © 2017年 JhtTools. All rights reserved.
//

#ifndef JhtNetworkCheckToolsProtocol_h
#define JhtNetworkCheckToolsProtocol_h

#import "JhtNetWorkStatus.h"

/** 网络监听_协议声明类 */
@protocol JhtNetworkCheckToolsProtocol <NSObject>
/** 当前网络状态 */
@property (nonatomic, assign) JhtNetWorkStatus currentStatus;

/** 网络状态变更
 *  注：注册的 listener 需要实现此方法
 */
- (void)networkChangedNot:(NSNotification *)not;

@end


#endif /* JhtNetworkCheckToolsProtocol_h */
