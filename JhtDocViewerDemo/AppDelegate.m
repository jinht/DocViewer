//
//  AppDelegate.m
//  JhtDocViewerDemo
//
//  GitHub主页: https://github.com/jinht
//  CSDN博客: http://blog.csdn.net/anticipate91
//
//  Created by Jht on 16/7/24.
//  Copyright © 2016年 JhtDocViewerDemo. All rights reserved.
//

#import "AppDelegate.h"
#import "JhtNetworkCheckTools.h"
#import "JhtDocFileOperations.h"
#import "DocListViewController.h"

#define OpenFileName0 @"2.pptx"
#define OpenFileName1 @"1.xlsx"
#define OpenFileName2 @"CIImage.docx"
#define OpenFileName3 @"信鸽推送说明书.pdf"

@implementation AppDelegate {
    UINavigationController *_nav;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 开启网络监听
    [JhtNetworkCheckTools startMonitoringWithListener:nil];
    
    // 模拟将 本地文件 的保存到 内存中
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if (![def objectForKey:@"first"]) {
        // 模拟将 本地文件 的保存到 内存中
        [self copyLocalFile:OpenFileName0];
        [self copyLocalFile:OpenFileName1];
        [self copyLocalFile:OpenFileName2];
        [self copyLocalFile:OpenFileName3];
        [def setObject:@"1" forKey:@"first"];
        [def synchronize];
    }
    DocListViewController *vc = [[DocListViewController alloc] init];
    _nav = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = _nav;
    
    // 三方跳转
    if (launchOptions) {
        NSURL *url = launchOptions[UIApplicationLaunchOptionsURLKey];
        // 根据“其他应用” 用“本应用”打开，通过url，进入列表页
        [self pushDocListViewControllerWithUrl:url];
    }
    return YES;
}


#pragma mark 模拟将 本地文件 的保存到 内存中
/** 模拟将 本地文件 的保存到 内存中（如果以后是网络就可以将网络请求下来的保存到 内存中，然后从内存中读取）*/
- (void)copyLocalFile:(NSString *)fileName {
    /** 将本地文件 保存到内存中
     *  fileName: 是以.为分割的格式       eg: 哈哈哈.doc
     *  basePath: 是本地路径的基地址      eg: NSHomeDirectory()
     *  localPath: 本地路径中存储的文件夹  eg: Documents/JhtDoc
     */
    [[JhtDocFileOperations sharedInstance] copyLocalWithFileName:fileName basePath:NSHomeDirectory() localPath:@"Documents/JhtDoc"];
}



#pragma mark - ApplicationDelegate
- (BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<NSString *,id> *)options {
    if (options) {
        NSString *str = [NSString stringWithFormat:@"\n发送请求的应用程序的 Bundle ID: %@\n\n文件的NSURL: %@", options[UIApplicationOpenURLOptionsSourceApplicationKey], url];
        NSLog(@"%@", str);
        
        if (self.window && url) {
            // 根据“其他应用” 用“本应用”打开，通过url，进入列表页
            [self pushDocListViewControllerWithUrl:url];
        }
    }
    return YES;
}


#pragma mark ApplicationDelegate Method
/** 根据“其他应用” 用“本应用”打开，通过url，进入列表页 */
- (void)pushDocListViewControllerWithUrl:(NSURL *)url {
    // 根据“其他应用” 用“本应用”打开，通过要打开的url，获得本地地址
    NSString *appFilePath = [[JhtDocFileOperations sharedInstance] findLocalPathFromAppLicationOpenUrl:url];
    // 跳转页面
    DocListViewController *doc = [[DocListViewController alloc] init];
    doc.appFilePath = appFilePath;
    [_nav pushViewController:doc animated:YES];
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end

