//
//  JhtDefaultManager.m
//  JhtDocViewerDemo
//
//  GitHub主页: https://github.com/jinht
//  CSDN博客: http://blog.csdn.net/anticipate91
//
//  Created by Jht on 2018/11/24.
//  Copyright © 2018 JhtDocViewerDemo. All rights reserved.
//

#import "JhtDefaultManager.h"

@implementation JhtDefaultManager

#pragma mark - Public Method
/** 获取指定 配置 Dic */
+ (NSDictionary *)getConfigDataWithType:(JhtDefaultType)type {
    NSString *key = [NSString stringWithFormat:@"item %ld", (long)type];
    NSDictionary *dic = [JhtDefaultManager getBundleResourcePlist:@"JhtDocViewer_Default"];
    
    return dic[key];
}


#pragma mark - Private Method
/** 获取指定 plist Dic */
+ (NSMutableDictionary *)getBundleResourcePlist:(NSString *)name {
    if (name.length) {
        NSString *bundlePath = [self getBundlePath];
        NSString *plistPath = [bundlePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", name]];
        NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        return data ? : [NSMutableDictionary dictionary];
    }
    
    return nil;
}

/** 获取Bundle path */
+ (NSString *)getBundlePath {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"JhtDocViewer" ofType:@"bundle"];
    
    return path;
}


@end
