//
//  JhtBaseViewController.m
//  JhtTools
//
//  Created by Jht on 16/5/15.
//  Copyright © 2016年 靳海涛. All rights reserved.
//

#import "JhtBaseViewController.h"
#import "MBProgressHUD.h"

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
    navigationBarTitleLabel.textColor = UIColorFromRGB(0x55AABB);;
    self.navigationItem.titleView = navigationBarTitleLabel;
}

/** 创建导航栏右侧自定义的返回按钮(图标+文字) */
- (void)bsCreateNavigationBarRightBtnWithRightImage:(UIImage *)RImage WithRightLabelText:(NSString *)RLText {
    // 图标
    UIImageView *img = [[UIImageView alloc]initWithImage:RImage];
    CGFloat imgWidth = CGRectGetWidth(img.frame);
    CGFloat imgHeight = CGRectGetHeight(img.frame);
    img.frame = CGRectMake(0, 0, imgWidth, imgHeight);
    // 显示字的label
    UILabel *lable = [[UILabel alloc] init];
    lable.textColor = [UIColor colorWithRed:0.49f green:0.49f blue:0.49f alpha:1.00f];
    lable.font = [UIFont systemFontOfSize:15];
    lable.text = RLText;
    [lable sizeToFit];
    lable.frame = CGRectMake(CGRectGetMaxX(img.frame) + 4, img.frame.origin.y - 2, lable.frame.size.width, lable.frame.size.height);
    
    // 承接两个控件的背景
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, img.frame.size.width + lable.frame.size.width + 5, img.frame.size.height)];
    [backView addSubview:img];
    [backView addSubview:lable];
    UITapGestureRecognizer *rightItemTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bsRightItemTapGes:)];
    [backView addGestureRecognizer:rightItemTap];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backView];
    self.navigationItem.rightBarButtonItem = item;
}
/** 导航栏右侧按钮点击触发事件(图标+文字~子类可以重写) */
- (void)bsRightItemTapGes:(UITapGestureRecognizer *)ges {
    NSLog(@"图标+文字 右侧按钮被点击");
}

/** 创建导航栏右侧侧自定义的按钮(仅文字) */
- (void)bsCreateNavigationBarRightBtnWithLabelText:(NSString *)RLText {
    UILabel *lable = [[UILabel alloc] init];
    lable.textColor = [UIColor whiteColor];
    lable.userInteractionEnabled = YES;
    lable.font = [UIFont systemFontOfSize:16];
    lable.text = RLText;
    [lable sizeToFit];
    
    // 添加手势
    UITapGestureRecognizer *rightItemTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bsRightItemNoImageTapGes:)];
    [lable addGestureRecognizer:rightItemTap];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:lable];
    self.navigationItem.rightBarButtonItem = item;
}
/** 默认导航栏右侧按钮点击触发事件(无图标~子类可以重写) */
- (void)bsRightItemNoImageTapGes:(UITapGestureRecognizer *)ges {
    NSLog(@"仅文字 右侧按钮被点击");
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

#pragma mark 《正在加载》的View
/** 打开 《正在加载》的View */
- (void)bsShowLoadingView {
    __weak UIView *superView = self.view;
    [MBProgressHUD showHUDAddedTo:superView animated:YES];
    
    // 启动系统状态栏加载动画
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
/** 关闭 《正在加载》的View */
- (void)bsStopLoadingView {
    __weak UIView *superView = self.view;
    [MBProgressHUD hideHUDForView:superView animated:YES];
    
    // 关闭系统状态栏加载动画
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}



#pragma mark - tableViewDelegate...
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
