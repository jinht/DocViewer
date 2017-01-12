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
         // 根据“其他应用” 用“本应用”打开, 通过url，进入列表页
        [self pushDocListViewControllerWithUrl:url];    
    }
    return YES;
}


- (void)pushDocListViewControllerWithUrl:(NSURL *)url {
    // 根据“其他应用” 用“本应用”打开, 通过要打开的url，获得本地地址
    NSString *appfilePath = [[JhtDocFileOperations sharedInstance] findLocalPathFromAppLicationOpenUrl:url];
    // 跳转页面
    DocListViewController *doc = [[DocListViewController alloc] init];
    doc.appFilePath = appfilePath;
    [_nav pushViewController:doc animated:YES];
}
```

#### 5. 库文件<br>
	系统库：WebKit.framework
	三方库：AFNetworking3.x	
 
     
## how to use JhtDocViewer.
 
 (1) 相关参数配置
   a. JhtDocFileOperations :文件操作类 <br> 
```oc
/** 文件操作类 */
@interface JhtDocFileOperations : NSObject
/** 文件名称 */
@property (nonatomic, copy) NSString *fileName;
/** 单例 */
+ (instancetype)sharedInstance;
/** 生成本地文件完整路径 */
- (NSString *)stitchLocalFilePath;
/** 生成下载文件沙盒路径 */
- (NSString *)stitchDownloadFilePath;
/** 文件下载失败时，清除文件路径 */
- (void)removeFileWhenDownloadFileFailure;
/** 清理几天前Download/Files里面文件 */
- (void)cleanFileAfterDays:(NSInteger)day;
/** “其他应用”===>“本应用”打开，通过传递过来的url，获得本地地址 */
- (NSString *)findLocalPathFromAppLicationOpenUrl:(NSURL *)url;

/** 将本地文件 保存到内存中
 *  fileName：是以.为分割的格式       eg：哈哈哈.doc
 *  basePath：是本地路径的基地址      eg：NSHomeDirectory()
 *  localPath：本地路径中存储的文件夹  eg：Documents/JhtDoc
 */
- (void)copyLocalWithFileName:(NSString *)fileName withBasePath:(NSString *)basePath withLocalPath:(NSString *)localPath;
```
    b.JhtShowDumpingViewParamModel: 下滑提示框配置参数model<br>
    作用: 提示框中的 文字的大小，颜色，位置，背景图，是否包含警示小图标等参数<br>
    c.JhtFileModel: 下载文档的Model<br>
    作用: 文件ID,文件名,如果是本地的，绝对路径, 文件大小等参数<br>
    
(2)使用集成（以APPDelegate为例）<br>
 ```oc
 - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 开启网络监听
    [[JhtNetworkCheckTools sharedInstance] startNetworkNotifyWithPollingInterval:2.0];
    
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
        // 根据“其他应用” 用“本应用”打开, 通过url，进入列表页
        [self pushDocListViewControllerWithUrl:url];
    }
    
    return YES;
}



#pragma mark - 模拟将 本地文件 的保存到 内存中
/** 模拟将 本地文件 的保存到 内存中 （如果以后是网络就可以将网络请求下来的保存到 内存中，然后从内存中读取）*/
- (void)copyLocalFile:(NSString *)fileName {
    /** 将本地文件 保存到内存中
     *  fileName：是以.为分割的格式       eg：哈哈哈.doc
     *  basePath：是本地路径的基地址      eg：NSHomeDirectory()
     *  localPath：本地路径中存储的文件夹  eg：Documents/JhtDoc
     */
    [[JhtDocFileOperations sharedInstance] copyLocalWithFileName:fileName withBasePath:NSHomeDirectory() withLocalPath:@"Documents/JhtDoc"];
}



#pragma mark - 根据“其他应用” 用“本应用”打开, 通过url，进入列表页
- (void)pushDocListViewControllerWithUrl:(NSURL *)url {
    // 根据“其他应用” 用“本应用”打开, 通过要打开的url，获得本地地址
    NSString *appfilePath = [[JhtDocFileOperations sharedInstance] findLocalPathFromAppLicationOpenUrl:url];
    // 跳转页面
    DocListViewController *doc = [[DocListViewController alloc] init];
    doc.appFilePath = appfilePath;
    [_nav pushViewController:doc animated:YES];
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
     d.无网络弹框<br>
     <img src="https://raw.githubusercontent.com/jinht/JhtDocViewer/master/ReadMEImages/10.png" width="30%" height="20%" /> <br>
       
###Remind
* ARC
* iOS >= 8.0
* iPhone \ iPad 
       
## Hope
* If you find bug when used，Hope you can Issues me，Thank you or try to download the latest code of this framework to see the BUG has been fixed or not
* If you find the function is not enough when used，Hope you can Issues me，I very much to add more useful function to this framework ，Thank you !
