//
//  BasicAnimationVCViewController.m
//  ViewEffectsDemo
//
//  Created by zhongxiuhao on 2020/8/7.
//  Copyright © 2020 zhongxiuhao. All rights reserved.
//

#import "BasicAnimationVC.h"

#import "Masonry.h"

@interface BasicAnimationVC ()

@property (nonatomic, strong) UIView    *containerView;

@property (nonatomic, strong) UIButton  *colorChangeBtn;

@end

@implementation BasicAnimationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
//    [self initSubViews];
//    [self addFingerGesture];
}

- (void)initSubViews {
    [self.view addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.colorChangeBtn];
    [_colorChangeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
        make.height.mas_equalTo(20);
    }];
}

- (void)addFingerGesture {
    // 添加左边缘滑动手势，返回前一个VC;
    UIScreenEdgePanGestureRecognizer *leftGes = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(backToPreVC)];
    leftGes.edges = UIRectEdgeLeft;
    [self.containerView addGestureRecognizer:leftGes];
}

- (void)viewColorChangdeAni {
    UIView *aniView = [UIView new];
    aniView.backgroundColor = [UIColor blackColor];
    [self.containerView addSubview:aniView];
    
    [aniView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(100, 100));
    }];
    
    [UIView animateWithDuration:1.0 delay:3 options:0 animations:^{
        aniView.backgroundColor = [UIColor redColor];
    } completion:^(BOOL finished){
        // TODO: show a toase animation complete;
    }];
}

- (void)backToPreVC {
    if (![self.navigationController popViewControllerAnimated:YES]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark subViews gettring
- (UIView *)containerView {
    if (!_containerView) {
        UIView *containerView = [[UIView alloc] initWithFrame:self.view.frame];
        _containerView = containerView;
    }
    
    return _containerView;
}

- (UIButton *)colorChangeBtn {
    if (!_colorChangeBtn) {
        UIButton *colorChangeBtn = [UIButton new];
        [colorChangeBtn setBackgroundColor:[UIColor redColor]];
        [colorChangeBtn setTitle:@"改变颜色" forState:UIControlStateNormal];
        [colorChangeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [colorChangeBtn addTarget:self action:@selector(viewColorChangdeAni) forControlEvents:UIControlEventTouchUpInside];
        _colorChangeBtn = colorChangeBtn;
    }
    
    return _colorChangeBtn;
}

@end
