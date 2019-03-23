//
//  MXHomePageViewController.m
//  MXNotebook
//
//  Created by yellow on 2017/8/1.
//  Copyright © 2017年 yellow. All rights reserved.
//

#import "MXHomePageViewController.h"
#import "MXTopic.h"
#import "MXCollectionViewCell.h"
#import "MXTopicListViewController.h"
#import "MXRealmManager.h"
#import "MXAlert.h"
#import "MXPaper.h"

#define BottomButtonHeight 45
#define BottomButtonBaseViewHeight 60

@interface MXHomePageViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, MXCollectionViewCellDelegate>
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray <MXTopic*>*dataSource;
@property (strong, nonatomic) NSMutableArray <UIColor*>*colorArray;
@property (assign, nonatomic) BOOL readyForDelete;
@property (strong, nonatomic) UIButton *bottomButton;
@property (strong, nonatomic) UILongPressGestureRecognizer *longPressGes;
@end

@implementation MXHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self layoutView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //根据添加日期，由近及远排序
    self.dataSource = [self fetchAllTopic];
    [self.collectionView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)initData {
    NSLog(@"数据库地址：%@",[RLMRealm defaultRealm].configuration.fileURL);
    
    //self.colorArray = [NSMutableArray new];
    
    /*for (NSInteger i = 0; i < self.dataSource.count; i++) {
        [self.colorArray addObject:[UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:0.6]];
    }*/
    
    [self addObserver:self forKeyPath:@"readyForDelete" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)layoutView {
    self.navTitle = @"记账本";
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.bottomButton];
}

- (void)refreshData {
    self.dataSource = [self fetchAllTopic];
    [self.collectionView reloadData];
}

- (NSMutableArray*)fetchAllTopic {
    RLMResults <MXTopic*>*array = [[MXTopic allObjects] sortedResultsUsingKeyPath:@"date" ascending:NO];
    NSMutableArray *mArray = [NSMutableArray new];
    for (MXTopic *topic in array) {
        topic.topicColor = [UIColor randomColorWithAlpah:0.6];
        [mArray addObject:topic];
    }
    return mArray;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MXCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"topicCell" forIndexPath:indexPath];
    cell.delegate = self;
    cell.indexPath = indexPath;
    //cell.backgroundColor = self.colorArray[indexPath.row];
    cell.showDeleteAnimation = self.readyForDelete;
    [cell setTopic:self.dataSource[indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.readyForDelete) {
        return;
    }
    MXCollectionViewCell *cell = (MXCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    [cell startAnimation:Scale Compeletion:^{
        MXTopicListViewController *vc = [[MXTopicListViewController alloc]init];
        vc.topic = self.dataSource[indexPath.row];;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSIndexPath *selectIndexPath = [self.collectionView indexPathForItemAtPoint:[self.longPressGes locationInView:self.collectionView]];
    MXCollectionViewCell *cell = (MXCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:selectIndexPath];
    MXTopic *topic = self.dataSource[sourceIndexPath.row];
    [self.dataSource removeObject:topic];
    [self.dataSource insertObject:topic atIndex:destinationIndexPath.item];
    [self.collectionView reloadData];
}

- (IBAction)moveGesAction:(UILongPressGestureRecognizer *)sender {
    switch (sender.state) {
        case UIGestureRecognizerStateBegan: {
            NSIndexPath *selectIndexPath = [self.collectionView indexPathForItemAtPoint:[sender locationInView:self.collectionView]];
            MXCollectionViewCell *cell = (MXCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:selectIndexPath];
            [self.collectionView beginInteractiveMovementForItemAtIndexPath:selectIndexPath];
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            [self.collectionView updateInteractiveMovementTargetPosition:[sender locationInView:self.collectionView]];
            break;
        }
            
        case UIGestureRecognizerStateEnded: {
            [self.collectionView endInteractiveMovement];
            break;
        }
            
        default: {
            [self.collectionView cancelInteractiveMovement];
            break;
        }
    }
}


- (IBAction)editTopic:(id)sender {
    [self.collectionView reloadData];
}

- (void)addTopic:(UIButton*)button {
    if ([button.titleLabel.text isEqualToString:@"完成"]) {
        self.readyForDelete = NO;
        return;
    }
    
    MXAlert *alert = [MXAlert alertWithTextField:@"添加账本" message:@"" buttonTitles:@[@"取消", @"添加"] action:^(NSInteger index, NSString *text) {
        NSLog(@"index: %ld",index);
        if (index == 1 && text.length > 0) {
            NSLog(@"添加：%@", text);
            MXTopic *topic = [[MXTopic alloc]init];
            topic.ID = [NSString stringWithFormat:@"%ld",[MXTopic allObjects].count+1];
            topic.name = text;
            topic.date = [NSDate date];
            topic.topicColor = [UIColor randomColorWithAlpah:0.6];
            [MXRealmManager add:^(RLMRealm *realm) {
                [realm addObject:topic];
            }];
            
            [self refreshData];
        }
    }];
    alert.type = MXBlur;
    [alert addTextField:^(MXTextField *textField) {
        textField.placeholderFont = [UIFont systemFontOfSize:15];
        textField.placeholder = @"请输入账本名称";
        textField.textColor = ThemeColor;
    }];
    [alert show];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"readyForDelete"]) {
        [self.collectionView reloadData];
        if (self.readyForDelete) {
            [UIView animateWithDuration:0.3 animations:^{
                self.bottomButton.backgroundColor = [UIColor orangeColor];
                [self.bottomButton setTitle:@"完成" forState:UIControlStateNormal];
            } completion:^(BOOL finished) {
                
            }];
        } else {
            [UIView animateWithDuration:0.3 animations:^{
                self.bottomButton.backgroundColor = ThemeColor;
                [self.bottomButton setTitle:@"添加账本" forState:UIControlStateNormal];
            } completion:^(BOOL finished) {
                
            }];
        }
    }
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        CGFloat width = floorf(([UIDevice deviceWidth] - 60) / 3.0);
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(width, width * 6 / 5.0);
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 0, 10);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, [UIDevice navHeight], [UIDevice deviceWidth], [UIDevice screenHeight] - [UIDevice navHeight] - BottomButtonBaseViewHeight) collectionViewLayout:layout];
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerNib:[UINib nibWithNibName:@"MXCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"topicCell"];
    }
    return _collectionView;
}

- (UIButton *)bottomButton {
    if (!_bottomButton) {
        _bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomButton setTitle:@"添加账本" forState:UIControlStateNormal];
        _bottomButton.backgroundColor = ThemeColor;
        _bottomButton.titleLabel.font = [UIFont systemFontOfSize:17];
        _bottomButton.frame = CGRectMake(10, [UIDevice screenHeight] - BottomButtonHeight - 10.0, [UIDevice deviceWidth]-20, BottomButtonHeight);
        _bottomButton.layer.cornerRadius = 5;
        _bottomButton.layer.masksToBounds = YES;
        [_bottomButton addTarget:self action:@selector(addTopic:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomButton;
}

#pragma mark Cell代理
- (void)cellLongPressed:(NSIndexPath *)indexPath {
    self.readyForDelete = YES;
}

- (void)cellDelete:(NSIndexPath *)indexPath {
    MXTopic *topic = self.dataSource[indexPath.row];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        [realm deleteObjects:[MXPaper objectsWhere:[NSString stringWithFormat:@"topicID = '%@'", topic.ID]]];
        [realm deleteObject:topic];
    }];
    
    
    //[MXRealmManager remove:topic];
    
    //[self.colorArray removeObjectAtIndex:indexPath.row];
    
    [self.dataSource removeObjectAtIndex:indexPath.row];
    
    if (self.dataSource.count == 0) {
        self.readyForDelete = NO;
    }
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
