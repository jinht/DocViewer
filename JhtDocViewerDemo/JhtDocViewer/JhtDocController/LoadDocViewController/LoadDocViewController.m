//
//  LoadDocViewController.m
//  JhtDocViewerDemo
//
//  GitHub主页: https://github.com/jinht
//  CSDN博客: http://blog.csdn.net/anticipate91
//
//  Created by Jht on 2017/10/19.
//  Copyright © 2017年 JhtDocViewer. All rights reserved.
//

#import "LoadDocViewController.h"

@implementation LoadDocViewController {
    // 文本加载 View
    JhtLoadDocView *_docView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 移除父类的tableView
    [_baseTableView removeFromSuperview];
    
    // 设置导航栏
    [self ldSetNav];
    
    // CreateUI
    [self ldCreateUI];
    
    NSLog(@"\n downloadFilesPath => %@ \n otherAppFilesPath => %@", [JhtDocFileOperations sharedInstance].downloadFilesPath, [JhtDocFileOperations sharedInstance].otherAppFilesPath);
}



#pragma mark - SetNav
/** 设置导航栏 */
- (void)ldSetNav {
    // 设置导航栏返回按钮
    [self bsCreateNavigationBarLeftBtn];
    
    // 设置导航栏标题
    [self bsCreateNavigationBarTitleViewWithLabelTitle:self.titleStr];
}



#pragma mark - UI
/** CreateUI */
- (void)ldCreateUI {
    // 文本加载 View 配置Model
    JhtLoadDocViewParamModel *loadDocViewParamModel = [[JhtLoadDocViewParamModel  alloc] init];
    // 清理？天前的文件
    loadDocViewParamModel.daysAgo = 1;
    
    // 提示框Model
    JhtShowDumpingViewParamModel *showDumpingViewParamModel = [[JhtShowDumpingViewParamModel alloc] init];
    showDumpingViewParamModel.showTextFont = [UIFont boldSystemFontOfSize:15];
    showDumpingViewParamModel.showBackgroundColor = [UIColor whiteColor];
    showDumpingViewParamModel.showBackgroundImageName = @"dumpView";
    
    // 《用其他应用打开》按钮 配置Model
    OtherOpenButtonParamModel *otherOpenButtonParamModel = [[OtherOpenButtonParamModel alloc] init];
    otherOpenButtonParamModel.titleFont = [UIFont boldSystemFontOfSize:20.0];
    otherOpenButtonParamModel.backgroundColor = [UIColor purpleColor];
//    otherOpenButtonParamModel.isHiddenBtn = YES;
    
    CGRect tempFrame = self.view.frame;
    tempFrame.size.height -= JhtSafeAreaInsetsBottom;
    _docView = [[JhtLoadDocView alloc] initWithFrame:tempFrame fileModel:self.currentFileModel showErrorViewOfFatherView:self.navigationController.view loadDocViewParamModel:loadDocViewParamModel showDumpingViewParamModel:showDumpingViewParamModel otherOpenButtonParamModel:otherOpenButtonParamModel];
    [self.view addSubview:_docView];
    
    [_docView finishedDownloadCompletionHandler:^(NSString *urlStr) {
        NSLog(@"网络下载文件成功后保存在《本地的路径》：\n%@", urlStr);
    }];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
