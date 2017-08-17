//
//  JhtBaseViewController.m
//  JhtTools
//
//  github主页: https://github.com/jinht
//  CSDN博客: http://blog.csdn.net/anticipate91
//
//  Created by Jht on 16/5/15.
//  Copyright © 2016年 JhtDocViewerDemo. All rights reserved.
//

#import "JhtBaseViewController.h"

@implementation JhtBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = NO;
    
    // 实例化数据源数组
    _baseSourceArray = [[NSMutableArray alloc] init];
    
    // 创建父类的UI界面
    [self bsCreateGrowthBaseUI];
    
    // 右滑返回
    [self bsToRightSlidePop];
}



#pragma mark - UI
/** 创建父类的UI界面 */
- (void)bsCreateGrowthBaseUI {
    _baseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, FrameW, FrameH) style:UITableViewStylePlain];
    _baseTableView.dataSource = self;
    _baseTableView.delegate = self;
    _baseTableView.scrollsToTop = YES;
    _baseTableView.showsVerticalScrollIndicator = NO;
    _baseTableView.showsHorizontalScrollIndicator = NO;
    _baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_baseTableView];
}



#pragma mark - 父类封装的便捷函数
#pragma mark Navigation
/** 创建导航栏左侧自定义的返回按钮 */
- (void)bsCreateNavigationBarLeftBtn {
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    NSString *leftBtnImagePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"JhtDocViewerImages.bundle/nav-back"];
    UIImage *leftBtnImage = [UIImage imageWithContentsOfFile:leftBtnImagePath];
    [leftBtn setImage:leftBtnImage forState:UIControlStateNormal];
    [leftBtn sizeToFit];
    
    [leftBtn addTarget:self action:@selector(bsPopToFormerController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftBar;
}
/** 默认导航栏左侧返回按钮触发事件(子类可以重写) */
- (void)bsPopToFormerController {
    [self.navigationController popViewControllerAnimated:YES];
}

/** 创建Navigationbar的TitleView */
- (void)bsCreateNavigationBarTitleViewWithLabelTitle:(NSString *)title {
    UILabel *navigationBarTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 44, 80)];
    navigationBarTitleLabel.text = title;
    navigationBarTitleLabel.font = [UIFont boldSystemFontOfSize:18];
    navigationBarTitleLabel.textAlignment = NSTextAlignmentCenter;
    navigationBarTitleLabel.textColor = UIColorFromRGB(0x55AABB);
    self.navigationItem.titleView = navigationBarTitleLabel;
}



#pragma mark - 工具方法
#pragma mark 右滑返回
/** 右滑返回 */
- (void)bsToRightSlidePop {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
}



#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 去除选中之后的效果
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
