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
#import <JhtDocViewer/JhtLoadDocView.h>
#import <JhtDocViewer/OtherOpenButtonParamModel.h>
#import <JhtDocViewer/JhtShowDumpingViewParamModel.h>

@implementation LoadDocViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 移除父类的tableView
    [_baseTableView removeFromSuperview];
    
    // 设置导航栏
    [self ldSetNav];
    
    // 创建UI界面
    [self ldCreateUI];
}


#pragma mark - setNav
/** 设置导航栏 */
- (void)ldSetNav {
    // 设置导航栏返回按钮
    [self bsCreateNavigationBarLeftBtn];
    
    // 设置导航栏标题
    [self bsCreateNavigationBarTitleViewWithLabelTitle:self.titleStr];
}



#pragma mark - UI界面
/** 创建UI界面 */
- (void)ldCreateUI {
    // 提示框Model
    JhtShowDumpingViewParamModel *showDumpingViewParamModel = [[JhtShowDumpingViewParamModel alloc] init];
    showDumpingViewParamModel.showTextFont = [UIFont boldSystemFontOfSize:15];
    showDumpingViewParamModel.showBackgroundColor = [UIColor whiteColor];
    showDumpingViewParamModel.showBackgroundImageName = @"dumpView";
    
    // 《用其他应用打开按钮》配置Model
    OtherOpenButtonParamModel *otherOpenButtonParamModel = [[OtherOpenButtonParamModel alloc] init];
    otherOpenButtonParamModel.titleFont = [UIFont boldSystemFontOfSize:20.0];
    otherOpenButtonParamModel.backgroundColor = [UIColor purpleColor];
//    otherOpenButtonParamModel.isHiddenBtn = YES;
    
    JhtLoadDocView *docView = [[JhtLoadDocView alloc] initWithFrame:self.view.frame withFileModel:self.currentFileModel withShowErrorViewOfFatherView:self.navigationController.view withLoadDocViewParamModel:nil withShowDumpingViewParamModel:showDumpingViewParamModel withOtherOpenButtonParamModel:otherOpenButtonParamModel];
    
    [self.view addSubview:docView];
    
    [docView finishedDownloadCompletionHandler:^(NSString *urlStr) {
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
