//
//  MXTopicListViewController.m
//  MXNotebook
//
//  Created by msxf on 2017/8/1.
//  Copyright © 2017年 yellow. All rights reserved.
//

#import "MXTopicListViewController.h"
#import "MXTopic.h"
#import "MXPaper.h"
#import "PaperListTableViewCell.h"
#import "MXPaperDetailViewController.h"
#import "MXRealmManager.h"
#import "MXPaperListBottomView.h"
#import "MXAlert.h"

@interface MXTopicListViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) MXPaperListBottomView *bottomView;
@property (strong, nonatomic) RLMResults <MXPaper*>*dataSource;
@property (strong, nonatomic) RLMNotificationToken *token;
@property (assign, nonatomic) BOOL popMark;
@property (strong, nonatomic) UIView *tableViewBackgroundView;
@property (assign, nonatomic) BOOL readyForDelete;
@property (assign, nonatomic) BOOL appearFromAddPaper;
@property (assign, nonatomic) BOOL appearFromUpdatePaper;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;
@end

@implementation MXTopicListViewController

- (instancetype)init {
    if (self = [super init]) {
        self.hideNavBar = YES;
        self.barStyle = @"Default";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self layoutView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.appearFromAddPaper) {
        self.dataSource = [self.topic.papers sortedResultsUsingKeyPath:@"date" ascending:NO];
        [self.tableView reloadData];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.appearFromAddPaper) {
        self.dataSource = [self.topic.papers sortedResultsUsingKeyPath:@"date" ascending:NO];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.375 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        self.appearFromAddPaper = NO;
    }
    if (self.appearFromUpdatePaper) {
        PaperListTableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.selectedIndexPath];
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            cell.layer.transform = CATransform3DMakeScale(0.9, 0.9, 1);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                cell.layer.transform = CATransform3DMakeScale(1.0, 1.0, 1);
            } completion:^(BOOL finished) {
                cell.layer.transform = CATransform3DIdentity;
                [self.tableView reloadRowsAtIndexPaths:@[self.selectedIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                self.appearFromUpdatePaper = NO;
            }];
        }];
    }
}

- (void)initData {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addPaperNoti) name:@"NewPaper" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpdatePaperNoti) name:@"UpdatePaper" object:nil];
}

- (void)layoutView {
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
}

- (void)addPaperNoti {
    self.appearFromAddPaper = YES;
}

- (void)UpdatePaperNoti {
    self.appearFromUpdatePaper = YES;
}

#pragma mark - 操作按钮事件
- (void)edit {
    self.readyForDelete = !self.readyForDelete;
    [self.tableView reloadData];
}

- (void)total {
    CGFloat totalPrice = 0;
    for (MXPaper *paper in self.dataSource) {
        totalPrice += paper.amount;
    }
    
    NSArray <PaperListTableViewCell*>*cells = [self.tableView visibleCells];
    CGFloat offsetY = [self.tableView indexPathForCell:cells[0]].row * 90;
    CGFloat leftCellHeight = self.tableView.contentOffset.y - offsetY;
    for (PaperListTableViewCell *cell in cells) {
        [UIView animateWithDuration:0.375 delay:0 usingSpringWithDamping:1 initialSpringVelocity:25 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            cell.layer.position = CGPointMake(self.tableView.center.x, self.tableView.center.y + offsetY + leftCellHeight);
            cell.layer.transform = CATransform3DMakeScale(0.7, 0.7, 1);
        } completion:^(BOOL finished) {
            if (cell == [cells firstObject]) {
                MXAlert *alert = [MXAlert alertWithTitle:@"哈哈" buttonTitles:@[@"知道了"] action:^(NSInteger index, NSString * _Nullable text) {
                    [self.bottomView animationTotalButton];
                    for (PaperListTableViewCell *cell in cells) {
                        /*[UIView animateWithDuration:0.375 animations:^{
                         cell.layer.position = cell.layerPoint;
                         cell.layer.transform = CATransform3DIdentity;
                         } completion:^(BOOL finished) {
                         
                         }];*/
                        [UIView animateWithDuration:0.375 delay:0 usingSpringWithDamping:1 initialSpringVelocity:25 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            cell.layer.position = cell.layerPoint;
                            cell.layer.transform = CATransform3DIdentity;
                        } completion:^(BOOL finished) {
                            
                        }];
                    }
                }];
                alert.type = MXBlur;
                [alert addTitle:^(UILabel * _Nullable label) {
                    label.textColor = RgbColor(250, 44, 100);
                    label.font = [UIFont boldSystemFontOfSize:20];
                    label.text = [NSString stringWithFormat:@"¥%.2f",totalPrice];
                }];
                [alert show];
            }
        }];
//        
//        [UIView animateWithDuration:0.375 animations:^{
//            cell.layer.position = CGPointMake(self.tableView.center.x, self.tableView.center.y + offsetY + leftCellHeight);
//            cell.layer.transform = CATransform3DMakeScale(0.7, 0.7, 1);
//        } completion:^(BOOL finished) {
//            if (cell == [cells firstObject]) {
//                MXAlert *alert = [MXAlert alertWithTitle:@"哈哈" buttonTitles:@[@"知道了"] action:^(NSInteger index, NSString * _Nullable text) {
//                    [self.bottomView animationTotalButton];
//                    for (PaperListTableViewCell *cell in cells) {
//                        /*[UIView animateWithDuration:0.375 animations:^{
//                            cell.layer.position = cell.layerPoint;
//                            cell.layer.transform = CATransform3DIdentity;
//                        } completion:^(BOOL finished) {
//                            
//                        }];*/
//                        [UIView animateWithDuration:0.375 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:25 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                            cell.layer.position = cell.layerPoint;
//                            cell.layer.transform = CATransform3DIdentity;
//                        } completion:^(BOOL finished) {
//                            
//                        }];
//                    }
//                }];
//                alert.type = MXBlur;
//                [alert addTitle:^(UILabel * _Nullable label) {
//                    label.textColor = RgbColor(250, 44, 100);
//                    label.font = [UIFont boldSystemFontOfSize:20];
//                    label.text = [NSString stringWithFormat:@"¥%.2f",totalPrice];
//                }];
//                [alert show];
//            }
//        }];
    }
}

- (void)addPaper {
    MXPaperDetailViewController *vc = [[MXPaperDetailViewController alloc]init];
    vc.type = PaperAdd;
    vc.topic = self.topic;
    vc.hideNavBar = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        if (scrollView.contentOffset.y < -100) {
            self.popMark = YES;
        }
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (self.popMark) {
        [self backAction];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PaperListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    MXPaper *paper = [self.dataSource objectAtIndex:indexPath.row];
    [cell setTopic:self.topic Paper:paper];
    cell.showDeleteAnimation = self.readyForDelete;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.readyForDelete) {
        MXAlert *alert = [MXAlert alertWithTitle:@"确定删除吗？" buttonTitles:@[@"取消", @"确定"] action:^(NSInteger index, NSString * _Nullable text) {
            if (index == 1) {
                [MXRealmManager remove:^(RLMRealm *realm) {
                    [realm deleteObject:self.dataSource[indexPath.row]];
                }];
                [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationBottom];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.375 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }
        }];
        [alert addTitle:^(UILabel * _Nullable label) {
            label.textColor = RgbColor(250, 44, 100);
            label.font = [UIFont systemFontOfSize:20];
            label.text = @"确定删除吗?";
        }];
        [alert show];
        return;
    }
    self.selectedIndexPath = indexPath;
    MXPaperDetailViewController *vc = [[MXPaperDetailViewController alloc]init];
    vc.paper = self.dataSource[indexPath.row];
    vc.topic = self.topic;
    vc.hideNavBar = YES;
    vc.type = PaperUpdate;
    [self.navigationController pushViewController:vc animated:YES];
}

- (MXPaperListBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[MXPaperListBottomView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-60, SCREEN_WIDTH, 60) action:^(NSInteger index) {
            NSLog(@"index: %ld", index);
            if (index == 0) {
                [self edit];
            } else if (index == 1) {
                [self total];
            } else if (index == 2) {
                [self addPaper];
            }
        }];
        _bottomView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _bottomView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT-20-60) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundView = self.tableViewBackgroundView;
        [_tableView registerNib:[UINib nibWithNibName:@"PaperListTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

- (UIView *)tableViewBackgroundView {
    if (!_tableViewBackgroundView) {
        _tableViewBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.backgroundView.bounds.size.width, self.tableView.backgroundView.bounds.size.height)];
        UILabel *label = [[UILabel alloc]init];
        label.backgroundColor = self.topic.topicColor;
        label.text = @"下拉V";
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:13];
        label.layer.cornerRadius = 5;
        label.layer.masksToBounds = YES;
        [_tableViewBackgroundView addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_tableViewBackgroundView);
            make.top.equalTo(_tableViewBackgroundView).offset(20);
            make.width.equalTo(@(20));
        }];
    }
    return _tableViewBackgroundView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
