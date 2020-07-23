//
//  LSTImgTextLayoutVC.m
//  LSTButton_Example
//
//  Created by LoSenTrad on 2019/12/30.
//  Copyright © 2019 490790096@qq.com. All rights reserved.
//

#import "LSTImgTextLayoutVC.h"
//#import "LSTButton.h"
#import <Masonry.h>
#import <UIColor+LSTColor.h>
#import <UIView+LSTView.h>
#import "UIView+GLDragBlast.h"
#import "LSTBadgeView.h"
#import <Masonry.h>
#import "LSTButton.h"

@interface LSTImgTextLayoutVC () <UITextFieldDelegate>

/** <#.....#> */
@property (nonatomic,strong) UIButton *testBtn;
/** <#.....#> */
@property (nonatomic,strong) LSTButton *btnView;
@property (weak, nonatomic) IBOutlet UITextField *textTF;


@end

@implementation LSTImgTextLayoutVC

#pragma mark - ***** Controller Life Cycle 控制器生命周期 *****

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self layoutSubViewUI];
    
    self.textTF.delegate = self;

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldTextDidChangeOneCI:)
                                                name:UITextFieldTextDidChangeNotification
                                              object:self.textTF];



}



#pragma mark - ***** setupUI 界面布局 *****

- (void)layoutSubViewUI {
    
    
    LSTButton *btn  = [[LSTButton alloc] init];
    self.btnView = btn;
    self.btnView.backgroundColor = UIColor.orangeColor;
    self.btnView.image = [UIImage imageNamed:@"123"];
    self.btnView.title = @"LSTButton";
    self.btnView.imageType = LSTButtonImageTypeLeft;
    [self.view addSubview:self.btnView];
    self.btnView.imageSize = CGSizeMake(30, 30);
    [self.btnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(120, 50));
    }];
//    self.btnView.layer.cornerRadius = 25;
//    self.btnView.layer.masksToBounds = YES;
    
//    [self.btnView lst_addEventTouchUpInsideBlock:^(id sender) {
//        NSLog(@"点击了按钮");
//    }];
    
    [self.btnView lst_addClickEventBlock:^(id sender) {
        NSLog(@"点击了按钮");
    }];
}


#pragma mark - ***** Data Request 数据请求 *****


#pragma mark - ***** Other 其他 *****


- (IBAction)toWide:(UIButton *)sender {
    
    [self.btnView mas_remakeConstraints:^(MASConstraintMaker *make) {
          make.center.equalTo(self.view);
          make.size.mas_equalTo(CGSizeMake(self.btnView.width+10, self.btnView.height));
      }];
   
}
- (IBAction)toShort:(UIButton *)sender {
    
     [self.btnView mas_remakeConstraints:^(MASConstraintMaker *make) {
         make.center.equalTo(self.view);
         make.size.mas_equalTo(CGSizeMake(self.btnView.width-10, self.btnView.height));
     }];
}
- (IBAction)toHigh:(UIButton *)sender {
    
     [self.btnView mas_remakeConstraints:^(MASConstraintMaker *make) {
         make.center.equalTo(self.view);
         make.size.mas_equalTo(CGSizeMake(self.btnView.width, self.btnView.height+10));
     }];
}
- (IBAction)toLow:(UIButton *)sender {
    
     [self.btnView mas_remakeConstraints:^(MASConstraintMaker *make) {
         make.center.equalTo(self.view);
         make.size.mas_equalTo(CGSizeMake(self.btnView.width, self.btnView.height-10));
     }];
}


- (IBAction)topImage:(UIButton *)sender {
     self.btnView.imageType = LSTButtonImageTypeTop;
    
}
- (IBAction)bottomImage:(UIButton *)sender {
     self.btnView.imageType = LSTButtonImageTypeBottom;
}
- (IBAction)leftImage:(UIButton *)sender {
     self.btnView.imageType = LSTButtonImageTypeLeft;
}
- (IBAction)rightImage:(UIButton *)sender {
     self.btnView.imageType = LSTButtonImageTypeRight;
}

- (IBAction)singleImage:(UIButton *)sender {
    self.btnView.title = @"";
}

- (IBAction)singleText:(UIButton *)sender {
    self.btnView.image = nil;
}

- (IBAction)imageText:(UIButton *)sender {
    self.btnView.image = [UIImage imageNamed:@"123"];
    self.btnView.title = @"LSTButton";
}

- (IBAction)defaultBtn:(UIButton *)sender {
    
    self.btnView.image = [UIImage imageNamed:@"123"];
    self.btnView.title = @"LSTButton";
    self.btnView.imageType = LSTButtonImageTypeLeft;
    self.btnView.imageSize = CGSizeMake(30, 30);
    [self.btnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(120, 50));
    }];
}


-(void)textFieldTextDidChangeOneCI:(NSNotification *)notification {
    UITextField *textfield=[notification object];
    self.btnView.title = textfield.text;
}


#pragma mark - ***** Lazy Loading 懒加载 *****


@end
