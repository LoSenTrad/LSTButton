//
//  LSTViewController.m
//  LSTButton
//
//  Created by 490790096@qq.com on 09/24/2019.
//  Copyright (c) 2019 490790096@qq.com. All rights reserved.
//

#import "LSTViewController.h"
//#import "LSTButton.h"
#import <Masonry.h>
#import <UIColor+LSTColor.h>
#import <UIView+LSTView.h>
#import "UIView+GLDragBlast.h"
#import "LSTBadgeView.h"
#import <Masonry.h>
#import "LSTButton.h"
#import "LSTImgTextLayoutVC.h"

@interface LSTViewController ()

@end

@implementation LSTViewController

#pragma mark - ***** Controller Life Cycle 控制器生命周期 *****

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self layoutSubViewUI];
    
    
}



#pragma mark - ***** setupUI 界面布局 *****

- (void)layoutSubViewUI {
    
    
    
}


#pragma mark - ***** Data Request 数据请求 *****


#pragma mark - ***** Other 其他 *****
/** 图文布局 */
- (IBAction)imageTextLayout:(UIButton *)sender {
    
    LSTImgTextLayoutVC *vc = [[LSTImgTextLayoutVC alloc]initWithNibName:@"LSTImgTextLayoutVC" bundle:nil];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}



#pragma mark - ***** Lazy Loading 懒加载 *****


@end
