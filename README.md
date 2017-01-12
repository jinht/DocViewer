# JhtDocViewer

## Contents
#### 文档查看器（Word&amp;&amp;Excel&amp;&amp;PDF&amp;&amp;Rft || Network&amp;&amp;Local || self&amp;&amp;other App）<br>
#### 文件共享 (Network&amp;&amp;Local) <br>

## needed to pay attention.
#### 1. 如果我们在iOS9下直接进行HTTP请求是会收到如下错误提示：
App Transport Security has blocked a cleartext HTTP (http://) resource load since it is insecure. Temporary exceptions can be configured via your app's Info.plist file.<br>
系统会告诉我们不能直接使用HTTP进行请求，需要在Info.plist新增一段用于控制ATS的配置<br>
```oc
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```
也即：<br>
<img src="https://raw.githubusercontent.com/jinht/JhtDocViewer/master/ReadMEImages/1.png" width="80%" height="80%" />

#### 2. 如果想共享自己app的文档查看功能，需在info.plist 中添加<br>
```oc
<key>CFBundleDocumentTypes</key>
	<array>
		<dict>
			<key>CFBundleTypeIconFiles</key>
			<array>
				<string>MySmallIcon.png</string>
				<string>MyLargeIcon.png</string>
			</array>
			<key>CFBundleTypeName</key>
			<string>My File Format</string>
			<key>LSHandlerRank</key>
			<string>Owner</string>
			<key>LSItemContentTypes</key>
			<array>
				<string>com.microsoft.powerpoint.ppt</string>
				<string>public.item</string>
				<string>com.microsoft.word.doc</string>
				<string>com.adobe.pdf</string>
				<string>com.microsoft.excel.xls</string>
				<string>public.image</string>
				<string>public.content</string>
				<string>public.composite-content</string>
				<string>public.archive</string>
				<string>public.audio</string>
				<string>public.movie</string>
				<string>public.text</string>
				<string>public.data</string>
			</array>
		</dict>
	</array>
```
属性说明：<br>
CFBundleTypeName：文档的类型名称<br>
LSHandlerRank：这里指是否拥有子文档<br>

#### 3. info.plist 中，对应Localization native development region键值 加入Chinese<br>
<img src="https://raw.githubusercontent.com/jinht/JhtDocViewer/master/ReadMEImages/2.png" width="80%" height="80%" />

#### 4. 在第三方调用我们的APP后，会调用如下方法<br>
```oc
- (BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<NSString *,id> *)options {
    if (options) {
         NSString *str = [NSString stringWithFormat:@"\n发送请求的应用程序的 Bundle ID：%@\n\n文件的NSURL：%@", options[UIApplicationOpenURLOptionsSourceApplicationKey], url];        
    }
    return YES;
}
```

#### 5. 库文件<br>
	系统库：WebKit.framework <br>
	三方库：AFNetworking3.0x <br>
	 
     
## how to use JhtDocViewer.
 (1) 使用时可直接拖拽下图文件夹即可<br>
     <img src="https://raw.githubusercontent.com/jinht/JhtDocViewer/master/ReadMEImages/8.png" width="50%" height="30%" /> <br>
 (2)使用集成（以APPDelegate为例）<br>
 ```oc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 开启网络监听
    [[JhtNetworkCheckTools sharedInstance] netStartNetworkNotifyWithPollingInterval:3.0];
    
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
        //返回的url， 转换成nsstring;
        NSString *appfilePath =[[[url description] componentsSeparatedByString:@"file:///private"] lastObject];
        appfilePath = [appfilePath stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        DocListViewController *doc = [[DocListViewController alloc] init];
        doc.appFilePath = appfilePath;
        [_nav pushViewController:doc animated:YES];
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<NSString *,id> *)options {
    if (options) {
//        NSString *str = [NSString stringWithFormat:@"\n发送请求的应用程序的 Bundle ID：%@\n\n文件的NSURL：%@", options[UIApplicationOpenURLOptionsSourceApplicationKey], url];
        // 返回的url， 例如这样；
//    	@"file:///private/var/mobile/Containers/Data/Application/A2E0485F-1341-48A3-BD40-6D09CB8559F5/Documents/Inbox/2-6.pptx"
        // 返回的url， 转换成nsstring;
        NSString *appfilePath = [[[url description] componentsSeparatedByString:@"file:///private"] lastObject];
        appfilePath = [appfilePath stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"appfilePath:%@", appfilePath);
        DocListViewController *doc = [[DocListViewController alloc] init];
        doc.appFilePath = appfilePath;
        [_nav pushViewController:doc animated:YES];
    }
    return YES;
}    
```
（3）DocListViewController 是文档列表<br>
     &ensp;&ensp;&ensp;&ensp;tableView的数据源是 一个装有model的数组，model根据属性fileAbsolutePath（本地绝对路径），判断是否用下载；<br>
     <img src="https://raw.githubusercontent.com/jinht/JhtDocViewer/master/ReadMEImages/3.png" width="30%" height="20%" /> <br>
（4）JhtLoadDocViewController 是文档详情VC<br>
     &ensp;&ensp;&ensp;&ensp;a.如果不需要下载，通过webView直接显示<br>
     <img src="https://raw.githubusercontent.com/jinht/JhtDocViewer/master/ReadMEImages/6.png" width="30%" height="20%" /> <br>
      b.需要下载，则通过JhtDownloadRequest函数中的类方法进行下载，暂停等操作（注意：JhtFileModel属性：fileSize，        应写成这种式“KB,MB,GB,Bytes”，为了计算手机剩余内存，关系是否能下载成功）<br>
     <img src="https://raw.githubusercontent.com/jinht/JhtDocViewer/master/ReadMEImages/5.png" width="30%" height="20%" /> <br>
     c.资源共享<br>
       ”JhtDocViewer“ 文件用”其他应用“打开<br>  
       <img src="https://raw.githubusercontent.com/jinht/JhtDocViewer/master/ReadMEImages/4.png" width="30%" height="20%" /> <br>
       “其他应用”文件 用 “JhtDocViewer”打开<br>
       <img src="https://raw.githubusercontent.com/jinht/JhtDocViewer/master/ReadMEImages/9.png" width="30%" height="20%" />&emsp;&emsp;
       <img src="https://raw.githubusercontent.com/jinht/JhtDocViewer/master/ReadMEImages/7.png" width="30%" height="20%" /> <br>
     d.设置清除缓存文件时间<br>
```oc
#pragma mark 几天天后清理Download/Files里面文件
- (void)ldCleanFileAfterDays:(NSInteger)day {
    NSString *filePath = [self ldGetDownloadFilePath];
    NSString *path = @"";
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDirectoryEnumerator *directoryEnumerator = [fileManager enumeratorAtPath:filePath];
    while ((path = [directoryEnumerator nextObject]) != nil) {
        NSString *subFilePath = [filePath stringByAppendingPathComponent:path];
        
        // 遍历文件属性
        NSError *error = nil;
       	NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:subFilePath error:&error];
       	if (fileAttributes != nil) {
            NSDate *fileCreateDate = [fileAttributes objectForKey:NSFileCreationDate];
            if (fileCreateDate) {
               	NSDate *date2 = [NSDate date];
           	NSTimeInterval aTimer = [date2 timeIntervalSinceDate:fileCreateDate];
         
                // 如果文件创建时间间隔大于day天，则删除
                if (aTimer > day*24*60*60) {
                    if([fileManager fileExistsAtPath:subFilePath]) {
                    	// 如果存在
                      	[fileManager removeItemAtPath:subFilePath error:nil];
                    }
                }
            }
        }
    }
}
```
       
       
###Remind
* ARC
* iOS >= 8.0
* iPhone \ iPad 
       
## Hope
* If you find bug when used，Hope you can Issues me，Thank you or try to download the latest code of this framework to see the BUG has been fixed or not
* If you find the function is not enough when used，Hope you can Issues me，I very much to add more useful function to this framework ，Thank you !
