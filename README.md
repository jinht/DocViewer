# JhtDocViewerDemo

## Contents
文档查看器（Word&amp;&amp;Excel&amp;&amp;PDF&amp;&amp;Rft || Network&amp;&amp;Local || self&amp;&amp;other App）
## needed to pay attention.
1.如果我们在iOS9下直接进行HTTP请求是会收到如下错误提示：
App Transport Security has blocked a cleartext HTTP (http://) resource load since it is insecure. Temporary exceptions can be configured via your app's Info.plist file.
系统会告诉我们不能直接使用HTTP进行请求，需要在Info.plist新增一段用于控制ATS的配置：
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>




2.如果想要在其他应用中打开，应该在info.plist 中添加
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
属性说明：
CFBundleTypeName：文档的类型名称
LSHandlerRank：这里指是否拥有子文档

3.info.plist 中，对应Localization native development region键值 加入Chinese
￼

4.在第三方调用我们的APP后，会调用如下方法
- (BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<NSString *,id> *)options {
    if (options) {
         NSString *str = [NSString stringWithFormat:@"\n发送请求的应用程序的 Bundle ID：%@\n\n文件的NSURL：%@", options[UIApplicationOpenURLOptionsSourceApplicationKey], url];        
    }
    return YES;
}
5.添加库文件
￼WebKit.framework
6.需要导入的三方库：
a.AFNetworking3.0x
b.MBProgressHUD 
