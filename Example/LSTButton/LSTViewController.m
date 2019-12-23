//
//  LSTViewController.m
//  LSTButton
//
//  Created by 490790096@qq.com on 09/24/2019.
//  Copyright (c) 2019 490790096@qq.com. All rights reserved.
//

#import "LSTViewController.h"
#import <LSTButton.h>
#import <Masonry.h>
#import <UIColor+LSTColor.h>
#import <UIView+LSTView.h>
#import "UIView+GLDragBlast.h"
#import "LSTBadgeView.h"

@interface LSTViewController ()

/** <#.....#> */
@property (nonatomic,strong) UIButton *testBtn;

@end

@implementation LSTViewController

#pragma mark - ***** Controller Life Cycle 控制器生命周期 *****

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self layoutSubViewUI];
    
    
}



#pragma mark - ***** setupUI 界面布局 *****

- (void)layoutSubViewUI {
    
    
//    UIView *view = [[UIView alloc] init];
//    view.frame = CGRectMake(100, 100, 80, 40);
//    view.backgroundColor = UIColor.orangeColor;
//    [self.view addSubview:view];
//    view.viscosity = 500;
//    view.clipsToBounds =  YES;
//    view.layer.cornerRadius = 10;
//    view.layer.masksToBounds = YES;
//    [view showBadgeWithHandleBlock:^(id sender) {
//
//    }];
    
//    return;
    
    LSTButton *topBtn = [[LSTButton alloc] init];
    topBtn.titleLabel.font.lineHeight;
    topBtn.imageType = LSTButtonImageTypeTop;
    topBtn.imageSize = CGSizeMake(30,30);
    topBtn.imageTextSpacing = 0;
    topBtn.badgeValue = @"88";
    topBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    topBtn.backgroundColor = [UIColor orangeColor];
    topBtn.frame = CGRectMake(self.view.size.width*0.5-50, 100, 100, 100);
    [topBtn setTitle:@"我是文字" forState:UIControlStateNormal];
    [topBtn setImage:[UIImage imageNamed:@"collected"] forState:UIControlStateNormal];
    topBtn.titleLabel.backgroundColor = [UIColor redColor];
    topBtn.imageView.backgroundColor  = [UIColor yellowColor];
    [self.view addSubview:topBtn];
    
    topBtn.dragBlast = YES;
    [topBtn blastCompletion:^(BOOL finished) {
        
    }];
    
//    [topBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.view).offset(100);
//        make.centerX.equalTo(self.view);
//        make.width.mas_equalTo(30);
//        make.height.mas_equalTo(100);
//    }];
    
    
//    return;
    
    LSTButton *leftBtn = [[LSTButton alloc] init];
    leftBtn.imageType = LSTButtonImageTypeLeft;
    leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    leftBtn.imageSize = CGSizeMake(30, 30);
    leftBtn.imageTextSpacing = 10;
    leftBtn.badgeValue = @"66";
    leftBtn.backgroundColor = [UIColor orangeColor];
    [leftBtn setTitle:@"我是文字" forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"collected"] forState:UIControlStateNormal];
    leftBtn.titleLabel.backgroundColor = [UIColor redColor];
    leftBtn.imageView.backgroundColor  = [UIColor yellowColor];
    [self.view addSubview:leftBtn];
    
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topBtn.mas_bottom).offset(30);
        make.centerX.equalTo(topBtn).offset(-100);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(50);
    }];
    
    LSTButton *rightBtn = [[LSTButton alloc] init];
    rightBtn.imageType = LSTButtonImageTypeRight;
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    rightBtn.badgeValue = @"11";
    rightBtn.backgroundColor = [UIColor orangeColor];
    [rightBtn setTitle:@"我是文字" forState:UIControlStateNormal];
    [rightBtn setImage:[UIImage imageNamed:@"collected"] forState:UIControlStateNormal];
    rightBtn.titleLabel.backgroundColor = [UIColor redColor];
    rightBtn.imageView.backgroundColor  = [UIColor yellowColor];
    [self.view addSubview:rightBtn];
    
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topBtn.mas_bottom).offset(30);
        make.centerX.equalTo(topBtn).offset(100);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(50);
    }];
    
    
    LSTButton *bottomBtn = [[LSTButton alloc] init];
    bottomBtn.imageType = LSTButtonImageTypeRight;
    bottomBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    bottomBtn.badgeValue = @"99+";
    bottomBtn.badgeOriginX = 10;
    bottomBtn.backgroundColor = [UIColor orangeColor];
    [bottomBtn setTitle:@"我是文字" forState:UIControlStateNormal];
    [bottomBtn setImage:[UIImage imageNamed:@"collected"] forState:UIControlStateNormal];
    bottomBtn.titleLabel.backgroundColor = [UIColor redColor];
    bottomBtn.imageView.backgroundColor  = [UIColor yellowColor];
    [self.view addSubview:bottomBtn];
    [bottomBtn showBadgeView];
    
    [bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(leftBtn.mas_bottom).offset(30);
        make.centerX.equalTo(topBtn);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(50);
    }];
    
    
    
    
    
    
    LSTButton *testBtn = [[LSTButton alloc] init];
    [testBtn setImage:[UIImage imageNamed:@"collected"] forState:UIControlStateNormal];
    [testBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [testBtn setTitleColor:UIColor.whiteColor forState:UIControlStateHighlighted];
    testBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    testBtn.imageType = LSTButtonImageTypeTop;
    
    testBtn.backgroundColor = UIColor.orangeColor;
    
    
    [self.view addSubview:testBtn];
    [testBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    
    
    self.testBtn = testBtn;
    
    
    
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
//    [self.testBtn setTitle:@"" forState:UIControlStateNormal];
//    [self.testBtn setImage:[UIImage imageNamed:@"collected"] forState:UIControlStateNormal];
    
    [self.testBtn setNeedsLayout];
}

#pragma mark - ***** Data Request 数据请求 *****


#pragma mark - ***** Other 其他 *****

#pragma mark - ***** Lazy Loading 懒加载 *****


@end
