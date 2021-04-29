//
//  JhtDownTipsDumpingView.m
//  JhtDocViewerDemo
//
//  GitHub主页: https://github.com/jinht
//  CSDN博客: http://blog.csdn.net/anticipate91
//
//  Created by Jht on 2017/1/11.
//  Copyright © 2017年 JhtDocViewer. All rights reserved.
//

#import "JhtDownTipsDumpingView.h"
#import "JhtShowDumpingViewParamModel.h"

@interface JhtDownTipsDumpingView ()

/** 阻尼动画下滑的label */
@property (nonatomic, strong) UILabel *dumpLabel;
/** 提示框model相关参数 */
@property (nonatomic, strong) JhtShowDumpingViewParamModel *paramModel;

@end


@implementation JhtDownTipsDumpingView

#pragma mark - Public Method
+ (void)showWithFView:(UIView *)view text:(NSString *)text showDumpingViewParamModel:(JhtShowDumpingViewParamModel *)model {
    CGRect frame = model.showViewFrame;
    frame.origin.y -= model.showViewFrame.size.height;
    JhtDownTipsDumpingView *dump = [[JhtDownTipsDumpingView alloc] initWithFrame:frame withFView:view withText:text withShowDumpingViewModelParam:model];
    [view addSubview:dump];
    
    // 开始动画
    [dump startDampingAnimation:0.3];
}


#pragma mark - Priavte Method
/** 初始化
 *  view: 动画 父View
 *  text: 动画展示 文字
 *  model: 提示框 相关参数model
 */
- (id)initWithFrame:(CGRect)frame withFView:(UIView *)view withText:(NSString *)text withShowDumpingViewModelParam:(JhtShowDumpingViewParamModel *)model {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.paramModel = model;
        self.backgroundColor = self.paramModel.showBackgroundColor;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5;
        
        // 设置背景图片
        if (self.paramModel.showBackgroundImageName.length) {
            UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
            [self addSubview:bgImageView];
            
            // 背景图片
            if ([self.paramModel.showBackgroundImageName isEqualToString:@"dumpView"]) {
                // buddle中默认的图
                NSString *imagePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"JhtDocViewer.bundle/images/dumpView"];
                bgImageView.image = [UIImage imageWithContentsOfFile:imagePath];
                
            } else {
                bgImageView.image = [UIImage imageNamed:self.paramModel.showBackgroundImageName];
            }
        }
        
        // 设置前面警示图标
        if (!self.paramModel.isHiddenFormerWarningIcon) {
            UIImageView *warningIcon = [[UIImageView alloc] initWithFrame:self.paramModel.formerWarningIconFrame];
            [self addSubview:warningIcon];
            // buddle中默认的图
            NSString *imagePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"JhtDocViewer.bundle/images/network_lost"];
            warningIcon.image = [UIImage imageWithContentsOfFile:imagePath];
        }
        
        // 设置文字
        self.dumpLabel.frame = self.paramModel.showLabelFrame;
        self.dumpLabel.text = text;
        [self addSubview:self.dumpLabel];
    }
    
    return self;
}

/** 开始动画阻尼动画
 *  duration: 动画时间
 */
- (void)startDampingAnimation:(NSTimeInterval)duration {
    // 弹簧弹动效果动画 Damping: 阻尼 Velocity: 速度
    CGRect frame = self.frame;
    frame.origin.y += self.paramModel.showViewFrame.size.height;
    [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveEaseIn animations:^{
        // 动画过程中
        self.frame = frame;
        
    } completion:^(BOOL finished) {
        // 停留几秒
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissWithAnimation:0.25 isAnimation:YES];
        });
    }];
}

/** 关闭阻尼动画
 *  duration: 动画时间
 *  isAnimation: 是否进行动画，NO: 直接关闭
 */
- (void)dismissWithAnimation:(NSTimeInterval)duration isAnimation:(BOOL)isAnimation {
    CGRect frame = self.frame;
    frame.origin.y -= self.paramModel.showViewFrame.size.height;
    if (isAnimation) {
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = frame;
        }completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
        
    } else {
        self.frame = frame;
        [self removeFromSuperview];
    }
}


#pragma mark - Getter
- (UILabel *)dumpLabel {
    if (!_dumpLabel) {
        // 下拉View中的显示的label
        _dumpLabel = [[UILabel alloc] init];
        
        _dumpLabel.font = self.paramModel.showTextFont;
        _dumpLabel.textColor = self.paramModel.showTextColor;
        _dumpLabel.layer.masksToBounds = YES;
        _dumpLabel.backgroundColor = [UIColor clearColor];
        _dumpLabel.textAlignment = self.paramModel.showTextAlignment;
    }
    
    return _dumpLabel;
}


@end
