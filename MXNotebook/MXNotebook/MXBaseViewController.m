
//
//  MXBaseViewController.m
//  MXNotebook
//
//  Created by yellow on 2017/8/8.
//  Copyright © 2017年 yellow. All rights reserved.
//

#import "MXBaseViewController.h"
#import "MXPushAnimation.h"
#import "MXPopAnimation.h"

@interface MXBaseViewController ()<UINavigationControllerDelegate>
@property (strong, nonatomic) UILabel *titleLabel;
@end

@implementation MXBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.layer.cornerRadius = 5;
    self.view.layer.masksToBounds = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupCustomNavBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
    if (self.barStyle.length > 0) {
        if ([self.barStyle isEqualToString:@"Default"]) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        } else if ([self.barStyle isEqualToString:@"Light"]) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        }
    } else {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.delegate = nil;
}

- (void)setupCustomNavBar {
    self.navigationController.navigationBarHidden = YES;
    if (!self.hideNavBar) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIDevice deviceWidth], [UIDevice navHeight])];
        view.backgroundColor = ThemeColor;
        view.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        view.layer.shadowRadius = 1;
        [self.view addSubview:view];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, [UIDevice navHeight]-0.5, [UIDevice deviceWidth], 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:line];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, [UIDevice statusBarHeight], [UIDevice deviceWidth]-200, 44)];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont systemFontOfSize:17];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [view addSubview:self.titleLabel];
        
        if (![self isKindOfClass:NSClassFromString(@"MXHomePageViewController")]) {
            UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
            backButton.frame = CGRectMake(0, [UIDevice statusBarHeight], 44, 44);
            [backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
            [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:backButton];
        }
    }
}

- (void)setNavTitle:(NSString *)navTitle {
    _navTitle = navTitle;
    self.titleLabel.text = navTitle;
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if (operation == UINavigationControllerOperationPush) {
        return [MXPushAnimation new];
    } else if (operation == UINavigationControllerOperationPop) {
        return [MXPopAnimation new];
    }
    return nil;
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
