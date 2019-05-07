//
//  JGRollingTableVerticalController.m
//  JGRollingVertical
//
//  Created by 郭军 on 2019/5/6.
//  Copyright © 2019 ZYWL. All rights reserved.
//

#import "JGRollingTableVerticalController.h"
#import "JGRollingTableVerticalOneController.h"
#import "JGRollTableVerticalCell.h"

@interface JGRollingTableVerticalController ()  <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;

/** 所有内容 */
@property (nonatomic, weak) UIScrollView *contentView;


/** 标题 */
@property (nonatomic, strong) NSArray *TitlesArrM;

@end

static NSString * const JGRollTableVerticalCellId = @"JGRollTableVerticalCellId";


@implementation JGRollingTableVerticalController

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SJHeight, 100, kDeviceHight - SJHeight) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[JGRollTableVerticalCell class] forCellReuseIdentifier:JGRollTableVerticalCellId];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}



- (NSArray *)TitlesArrM {
    if (!_TitlesArrM) {
        _TitlesArrM = @[ @"全部", @"大学", @"中学", @"小学"];
    }
    return _TitlesArrM;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"tableView - 纵向切换";
    
    // 初始化子控制器
    [self setupChildVces];
    
     [self.view addSubview:self.tableView];
    
    // 底部的scrollView
    [self setupContentView];
    
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];

    
}



/**
 * 初始化子控制器
 */
- (void)setupChildVces {
    
    
    for (int i = 0; i < self.TitlesArrM.count; i++) {
        JGRollingTableVerticalOneController *VC = [[JGRollingTableVerticalOneController alloc] init];
        [self addChildViewController:VC];
    }
}



/**
 * 底部的scrollView
 */
- (void)setupContentView
{
    // 不要自动调整inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *contentView = [[UIScrollView alloc] init];
    //CGRectMake(0, 0, kDeviceWidth, kDeviceHight)
    contentView.frame = CGRectMake(self.tableView.width, SJHeight , kDeviceWidth - self.tableView.width, kDeviceHight - SJHeight);
    contentView.delegate = self;
    contentView.pagingEnabled = YES;
    [self.view insertSubview:contentView atIndex:0];
    contentView.contentSize = CGSizeMake(0, contentView.height * self.childViewControllers.count);
    self.contentView = contentView;
    
    // 添加第一个控制器的view
    [self scrollViewDidEndScrollingAnimation:contentView];
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 当前的索引
    NSInteger index = scrollView.contentOffset.y / scrollView.height;
    
    // 取出子控制器
    UIViewController *vc = self.childViewControllers[index];
    
    // 取出子控制器
    //    UITableViewController *vc = self.childViewControllers[index];
    vc.view.x = 0;
    vc.view.y = scrollView.contentOffset.y; // 设置控制器view的y值为0(默认是20)
    vc.view.height = scrollView.height; // 设置控制器view的height值为整个屏幕的高度(默认是比屏幕高度少个20)
    vc.view.width = scrollView.width;
    // 设置内边距
    //    CGFloat bottom = self.tabBarController.tabBar.height;
    //    CGFloat top = CGRectGetMaxY(self.titlesView.frame);
    //
    //    vc1.tableView.contentInset = UIEdgeInsetsMake(top, 0, IphoneXTH, 0);
    // 设置滚动条的内边距
    //    vc1.tableView.scrollIndicatorInsets = vc1.tableView.contentInset;
    [scrollView addSubview:vc.view];
    
    //    [scrollView addSubview:vc.view];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    // 点击按钮
    NSInteger index = scrollView.contentOffset.y / scrollView.height;

    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}




#pragma mark - UITableViewDataSource -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.TitlesArrM.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JGRollTableVerticalCell *cell = [tableView dequeueReusableCellWithIdentifier:JGRollTableVerticalCellId forIndexPath:indexPath];
    cell.TitleLbl.text = [self.TitlesArrM objectAtIndex:indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 滚动
    CGPoint offset = self.contentView.contentOffset;
    offset.y = indexPath.row * self.contentView.height;
    [self.contentView setContentOffset:offset animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50.0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
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
