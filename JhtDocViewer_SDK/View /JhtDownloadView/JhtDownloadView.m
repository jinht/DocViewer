
//
//  JhtDownloadView.m
//  JhtDocViewerDemo
//
//  GitHub主页: https://github.com/jinht
//  CSDN博客: http://blog.csdn.net/anticipate91
//
//  Created by Jht on 2017/1/5.
//  Copyright © 2017年 JhtDocViewer. All rights reserved.
//

#import "JhtDownloadView.h"
#import "JhtFileModel.h"
#import "JhtDefaultManager.h"
#import "JhtDownloadRequest.h"
#import "JhtDocViewer_Define.h"
#import "JhtNetworkCheckTools.h"

@interface JhtDownloadView() {
    // 点击按钮回调的block 0: 重新加载，1: 点击关闭
    clickBlock _block;
}
/** 下载文件的model */
@property (nonatomic, strong) JhtFileModel *currentFileModel;

@end


@implementation JhtDownloadView

#pragma mark - Public Method
- (id)initWithFrame:(CGRect)frame downloadingHint:(NSString *)downloadingHint lostNetHint:(NSString *)lostNetHint downloadProgressTintColor:(UIColor *)downloadProgressTintColor fileModel:(JhtFileModel *)model {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.downloadProgressTintColor = downloadProgressTintColor;
        self.downloadingHint = downloadingHint;
        self.lostNetHint = lostNetHint;
        self.currentFileModel = model;
        
        // 文件类型图片
        [self addSubview:self.iconFileImageView];
        // 文件名称
        [self addSubview:self.iconFileDescribeLabel];
        // 进度条
        [self addSubview:self.fileProgressView];
        // 关闭按钮
        [self addSubview:self.closeBtn];
        // 下载按钮
        [self addSubview:self.downloadBtn];
        // 下载进度文案label
        [self addSubview:self.downloadingStateLabel];
        
        // 初始化相关参数
        [self ldvInitParam];
    }
    
    return self;
}

- (void)clickBtnBlock:(clickBlock)block {
    _block = block;
}


#pragma mark - Private Method
/** 初始化相关参数 */
- (void)ldvInitParam {
    NSString *fileIconName = @"";
    if (self.currentFileModel.viewFileType == Type_Docx) {
        fileIconName = @"word.png";
    } else if (self.currentFileModel.viewFileType == Type_Xlsx) {
        fileIconName = @"excel.png";
    } else if (self.currentFileModel.viewFileType == Type_Pptx) {
        fileIconName = @"ppt.png";
    } else if (self.currentFileModel.viewFileType == Type_Pdf) {
        fileIconName = @"pdf.png";
    } else if (self.currentFileModel.viewFileType == Type_Txt) {
        fileIconName = @"txt.png";
    } else {
        fileIconName = @"unknow.png";
    }
    
    // 文件类型图片
    self.iconFileImageView.frame = CGRectMake((CGRectGetWidth(self.frame) - 100) / 2.f, 65.f, 100.f, 100.f);
    NSString *fileTypeImagePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"JhtDocViewer.bundle/images/%@", fileIconName]];
    self.iconFileImageView.image = [UIImage imageWithContentsOfFile:fileTypeImagePath];
    
    // 计算文件大小
    CGSize filesize = [self.currentFileModel.fileName boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.frame) - 90, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0]} context:nil].size;
    CGFloat describeHeight = filesize.height;
    
    // 文件名称
    self.iconFileDescribeLabel.frame = CGRectMake(45, CGRectGetMaxY(_iconFileImageView.frame) + 25, CGRectGetWidth(self.frame) - 90, describeHeight);
    self.iconFileDescribeLabel.text = self.currentFileModel.fileName;
    
    // 下载条
    self.fileProgressView.frame = CGRectMake(45 / 2.0, CGRectGetMaxY(self.iconFileDescribeLabel.frame) + 29, CGRectGetWidth(self.frame) - (45 / 2.0 * 2 + 5 / 2.0 + 20), 10);
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0f, 3.0f);
    // 更改进度条 高度
    _fileProgressView.transform = transform;
    
    // 关闭按钮
    self.closeBtn.frame = CGRectMake(CGRectGetMaxX(self.fileProgressView.frame), CGRectGetMaxY(self.iconFileDescribeLabel.frame) + 19, 20, 20);
    
    // 下载进度文案label
    self.downloadingStateLabel.text = self.downloadingHint;
    [self.downloadingStateLabel sizeToFit];
    self.downloadingStateLabel.frame = CGRectMake(0, CGRectGetMaxY(self.iconFileDescribeLabel.frame) + 29 + 19, CGRectGetWidth(self.frame), CGRectGetHeight(_downloadingStateLabel.frame));

    // 重试按钮
    self.downloadBtn.frame = CGRectMake((CGRectGetWidth(self.frame) - 110.f) / 2.f, CGRectGetMaxY(_downloadingStateLabel.frame) + 10, 110, 30);
    [self.downloadBtn setTitle:[NSString stringWithFormat:@"下载 %@", self.currentFileModel.fileSize] forState:UIControlStateNormal];
}


#pragma mark - Getter
- (UIImageView *)iconFileImageView {
    if (!_iconFileImageView) {
        _iconFileImageView = [[UIImageView alloc] init];
    }
    
    return _iconFileImageView;
}

- (UILabel *)iconFileDescribeLabel {
    if (!_iconFileDescribeLabel) {
        _iconFileDescribeLabel = [[UILabel alloc] init];
        
        _iconFileDescribeLabel.textAlignment = NSTextAlignmentCenter;
        _iconFileDescribeLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        _iconFileDescribeLabel.font = [UIFont systemFontOfSize:16.f];
        _iconFileDescribeLabel.textColor = UIColorFromRGB(0x333333);
        _iconFileDescribeLabel.numberOfLines = 0;
    }
    
    return _iconFileDescribeLabel;
}

- (UILabel *)downloadingStateLabel {
    if (!_downloadingStateLabel) {
        _downloadingStateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        
        _downloadingStateLabel.text = self.downloadingHint;
        _downloadingStateLabel.font = [UIFont systemFontOfSize:14.f];
        _downloadingStateLabel.textColor = UIColorFromRGB(0x808080);
        _downloadingStateLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _downloadingStateLabel;
}

- (UIColor *)downloadProgressTintColor {
    return _downloadProgressTintColor ? _downloadProgressTintColor : UIColorFromRGB(0x61CBF5);
}

- (UIProgressView *)fileProgressView {
    if (!_fileProgressView) {
        _fileProgressView = [[UIProgressView alloc] init];
        
        [_fileProgressView setProgressViewStyle:UIProgressViewStyleDefault];
        _fileProgressView.progressTintColor = self.downloadProgressTintColor;
        _fileProgressView.layer.masksToBounds = YES;
        _fileProgressView.layer.cornerRadius = 2.f;
        _fileProgressView.hidden = YES;
    }
    
    return _fileProgressView;
}

- (UIButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        NSString *closeImagePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"JhtDocViewer.bundle/images/close"];
        UIImage *closeBtnImage = [UIImage imageWithContentsOfFile:closeImagePath];
        [_closeBtn setImage:closeBtnImage forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(ldvTwoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _closeBtn.hidden = YES;
        _closeBtn.tag = 201;
    }
    
    return _closeBtn;
}

- (UIButton *)downloadBtn {
    if (!_downloadBtn) {
        _downloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _downloadBtn.backgroundColor = UIColorFromRGB(0x61cbf5);
        [_downloadBtn setTitle:@"下载" forState:UIControlStateNormal];
        _downloadBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        [_downloadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _downloadBtn.layer.cornerRadius = 3.f;
        _downloadBtn.tag = 200;
        _downloadBtn.layer.masksToBounds = YES;
        [_downloadBtn addTarget:self action:@selector(ldvTwoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        _downloadBtn.hidden = YES;
    }
    
    return _downloadBtn;
}

- (NSString *)downloadingHint {
    if ([JhtNetworkCheckTools currentNetWork_Status] == NetWorkStatus_None) {
        return self.lostNetHint;
        
    } else {
        NSDictionary *dic = [JhtDefaultManager getConfigDataWithType:JhtDefaultType_LoadDocViewParam];
        return _downloadingHint.length > 0 ? _downloadingHint : dic[@"downloadingHint"];
    }
}

- (NSString *)lostNetHint {
    NSDictionary *dic = [JhtDefaultManager getConfigDataWithType:JhtDefaultType_LoadDocViewParam];
    return _lostNetHint.length > 0 ? _lostNetHint : dic[@"lostNetHint"];
}


#pragma mark Getter Method
/** 点击按钮触发 */
- (void)ldvTwoBtnClick:(UIButton *)btn {
    _block(btn.tag - 200);
}


@end
