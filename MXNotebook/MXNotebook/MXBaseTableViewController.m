//
//  MXBaseTableViewController.m
//  MXNotebook
//
//  Created by yellow on 2017/8/8.
//  Copyright © 2017年 yellow. All rights reserved.
//

#import "MXBaseTableViewController.h"
#import "MXPushAnimation.h"
#import "MXPopAnimation.h"

@interface MXBaseTableViewController ()<UINavigationControllerDelegate>
@property (strong, nonatomic) UILabel *titleLabel;
@end

@implementation MXBaseTableViewController

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
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.delegate = nil;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.barStyle.length > 0) {
        if ([self.barStyle isEqualToString:@"Default"]) {
            return UIStatusBarStyleDefault;
        } else if ([self.barStyle isEqualToString:@"Light"]) {
            return UIStatusBarStyleLightContent;
        }
    }
    return [UIApplication sharedApplication].statusBarStyle;
}

- (void)setupCustomNavBar {
    self.navigationController.navigationBarHidden = YES;
    if (!self.hideNavBar) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIDevice deviceWidth], 64)];
        view.backgroundColor = ThemeColor;
        view.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        view.layer.shadowRadius = 1;
        [self.view addSubview:view];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, [UIDevice navHeight] - 0.5, [UIDevice deviceWidth], 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:line];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 20, [UIDevice deviceWidth]-200, 44)];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont systemFontOfSize:17];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [view addSubview:self.titleLabel];
        
        if (![self isKindOfClass:NSClassFromString(@"MXHomePageViewController")]) {
            UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
            backButton.frame = CGRectMake(0, 20, 44, 44);
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
