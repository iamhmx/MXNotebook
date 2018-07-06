//
//  MXPaperDetailViewController.m
//  MXNotebook
//
//  Created by yellow on 2017/8/2.
//  Copyright © 2017年 yellow. All rights reserved.
//

#import "MXPaperDetailViewController.h"
#import "MXPaper.h"
#import "MXTopic.h"
#import "MXRealmManager.h"
#import "MXPaperDetailTableViewCell.h"
#import "MXAlert.h"
#import <objc/runtime.h>

@interface MXPaperDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,MXPaperDetailTableViewCellDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *buttonView;
@property (assign, nonatomic) BOOL popMark;
@property (strong, nonatomic) NSDate *chooseDate;
@property (strong, nonatomic) UIView *tableViewBackgroundView;
@property (copy, nonatomic)   NSString *content;
@property (copy, nonatomic)   NSString *price;
@end

@implementation MXPaperDetailViewController

- (instancetype)init {
    if (self = [super init]) {
        self.hideNavBar = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.barStyle = @"Default";
    self.content = self.paper.name;
    self.price = [NSString stringWithFormat:@"%.f",self.paper.amount];
    [self.view addSubview:self.tableView];
}

- (void)save {
    [self.view endEditing:YES];
    if (self.content.length == 0) {
        [MXAlert hud:@"请输入账单"];
        return;
    } else if (self.price.length == 0) {
        [MXAlert hud:@"请输入金额"];
        return;
    }
    if (self.type == PaperAdd) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NewPaper" object:nil];
        MXPaper *paper = [[MXPaper alloc]init];
        paper.topicID = self.topic.ID;
        paper.name = self.content;
        paper.date = self.chooseDate ? self.chooseDate : [NSDate date];
        paper.amount = [self.price floatValue];
        
        [MXRealmManager update:^(RLMRealm *realm) {
            [self.topic.papers addObject:paper];
        }];
        
        [MXAlert hud:@"添加成功"];
    } else if (self.type == PaperUpdate) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdatePaper" object:nil];
        [MXRealmManager update:^(RLMRealm *realm) {
            if (self.chooseDate) {
                self.paper.date = self.chooseDate;
            }
            self.paper.name = self.content;
            self.paper.amount = [self.price floatValue];
        }];
        [MXAlert hud:@"修改成功"];
    }
    [self.navigationController popViewControllerAnimated:YES];
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
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 220;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MXPaperDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.delegate = self;
    [cell setType:self.type Topic:self.topic andPaper:self.paper];
    return cell;
}

#pragma mark - Cell代理
- (void)textFieldFinishContent:(NSString *)content price:(NSString *)price {
    NSLog(@"content:%@, price:%@",content,price);
    self.content = content;
    self.price = price;
}

- (void)tapDateCell {
    NSLog(@"tap");
    MXAlert *alert = [MXAlert alertDatePickerWithTitle:@"请选择日期" buttonTitles:@[@"取消", @"确定"] action:^(NSInteger index, NSDate * _Nullable date) {
        self.chooseDate = date;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NewDate" object:date];
    }];
    [alert addDatePicker:^(UIDatePicker * _Nullable picker) {
        //设置当前日期
        if (!self.chooseDate) {
            picker.date = (self.type == PaperAdd ? [NSDate date] : self.paper.date);
        } else {
            picker.date = self.chooseDate;
        }
    }];
    [alert show];
}

#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT-20) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"MXPaperDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundView = self.tableViewBackgroundView;
        
        _tableView.tableFooterView = self.buttonView;
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

- (UIView *)buttonView {
    if (!_buttonView) {
        _buttonView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"保存账单" forState:UIControlStateNormal];
        button.backgroundColor = ThemeColor;
        button.titleLabel.font = [UIFont systemFontOfSize:17];
        button.layer.cornerRadius = 5;
        button.layer.masksToBounds = YES;
        [button addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
        [_buttonView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_buttonView).insets(UIEdgeInsetsMake(30, 10, 25, 10));
        }];
    }
    return _buttonView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
