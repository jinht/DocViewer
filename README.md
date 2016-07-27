# JhtDocViewerDemo

## Contents
#### 文档查看器（Word&amp;&amp;Excel&amp;&amp;PDF&amp;&amp;Rft || Network&amp;&amp;Local || self&amp;&amp;other App）<br>
#### 文件共享 (Network&amp;&amp;Local) <br>
## needed to pay attention.
#### 1. 如果我们在iOS9下直接进行HTTP请求是会收到如下错误提示：
App Transport Security has blocked a cleartext HTTP (http://) resource load since it is insecure. Temporary exceptions can be configured via your app's Info.plist file.<br>
系统会告诉我们不能直接使用HTTP进行请求，需要在Info.plist新增一段用于控制ATS的配置：<br>
```oc
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```
也即：<br>
![image](https://raw.githubusercontent.com/jinht/JhtDocViewer/master/JhtDocViewerImages/1.png)


#### 2. 如果想要在其他应用中打开，应该在info.plist 中添加<br>
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
![image](https://raw.githubusercontent.com/jinht/JhtDocViewer/master/JhtDocViewerImages/2.png)
#### 4. 在第三方调用我们的APP后，会调用如下方法<br>
```oc
- (BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<NSString *,id> *)options {
    if (options) {
         NSString *str = [NSString stringWithFormat:@"\n发送请求的应用程序的 Bundle ID：%@\n\n文件的NSURL：%@", options[UIApplicationOpenURLOptionsSourceApplicationKey], url];        
    }
    return YES;
}
```
#### 5. 添加库文件<br>
     WebKit.framework<br>
#### 6. 需要导入的三方库：<br>
     a. AFNetworking3.0x<br>
     b. MBProgressHUD <br>
## how to use JhtDocViewerDemo.
（1）DocListViewController 是文档列表；<br>
     tableView的数据源是 一个装有model的数组，model根据属性fileAbsolutePath（本地绝对路径），判断是否用下载；<br>
     ![image](https://raw.githubusercontent.com/jinht/JhtDocViewer/master/JhtDocViewerImages/3.png)<br>
（2）JhtLoadDocViewController 是文档详情，<br>
      a.如果不需要下载，通过webView直接显示；<br>
      ![image](https://raw.githubusercontent.com/jinht/JhtDocViewer/master/JhtDocViewerImages/6.png)<br>
      b.需要下载，则通过JhtDownloadRequest函数中的类方法进行下载，暂停等操作；（注意：JhtFileModel属性：fileSize， 应写成这种式“KB,MB,GB,Bytes”，为了计算手机剩余内存，关系是否能下载成功）<br>
      ![image](https://raw.githubusercontent.com/jinht/JhtDocViewer/master/JhtDocViewerImages/5.png)<br>
      c.资源共享;<br>
        ”JhtDocViewerDemo“ 文件用”其他应用“打开<br>
        ![image](https://raw.githubusercontent.com/jinht/JhtDocViewer/master/JhtDocViewerImages/4.png)<br>
      “其他应用”文件 用 “JhtDocViewerDemo”打开<br>
      ![image](https://raw.githubusercontent.com/jinht/JhtDocViewer/master/JhtDocViewerImages/7.png)<br>
## Hope
* If you find bug when used，Hope you can Issues me，Thank you or try to download the latest code of this framework to see the BUG has been fixed or not
* If you find the function is not enough when used，Hope you can Issues me，I very much to add more useful function to this framework ，Thank you !
