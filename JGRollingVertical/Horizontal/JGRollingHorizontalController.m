//
//  JGRollingHorizontalController.m
//  JGRollingVertical
//
//  Created by 郭军 on 2019/5/6.
//  Copyright © 2019 ZYWL. All rights reserved.
//

#import "JGRollingHorizontalController.h"
#import "JGRollHorizontalOneController.h"

@interface JGRollingHorizontalController () <UIScrollViewDelegate>

/** 标签栏底部的指示器 */
@property (nonatomic, weak) UIView *indicatorView;
/** 当前选中的按钮 */
@property (nonatomic, weak) UIButton *selectedButton;
/** 顶部的所有标签 */
@property (nonatomic, weak) UIView *titlesView;
/** 底部的所有内容 */
@property (nonatomic, weak) UIScrollView *contentView;

/** 标题 */
@property (nonatomic, strong) NSArray *TitlesArrM;

@end

@implementation JGRollingHorizontalController

- (NSArray *)TitlesArrM {
    if (!_TitlesArrM) {
        _TitlesArrM = @[ @"全部", @"大学", @"中学", @"小学"];
    }
    return _TitlesArrM;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"横向切换";
    
    // 初始化子控制器
    [self setupChildVces];
    
    // 设置顶部的标签栏
    [self setupTitlesView];
    
    // 底部的scrollView
    [self setupContentView];
    
}



/**
 * 初始化子控制器
 */
- (void)setupChildVces {
    
    
    for (int i = 0; i < self.TitlesArrM.count; i++) {
        JGRollHorizontalOneController *VC = [[JGRollHorizontalOneController alloc] init];
        [self addChildViewController:VC];
    }
}

/**
 * 设置顶部的标签栏
 */
- (void)setupTitlesView
{
    // 标签栏整体
    UIView *titlesView = [[UIView alloc] initWithFrame:CGRectMake(0, SJHeight, kDeviceWidth, 44)];
    titlesView.backgroundColor = [UIColor whiteColor];
    //    titlesView.width = self.view.width;
    //    titlesView.height = 44;
    [self.view addSubview:titlesView];
    self.titlesView = titlesView;
    
    // 底部的指示器
    UIView *indicatorView = [[UIView alloc] init];
    indicatorView.backgroundColor = [UIColor redColor];
    indicatorView.height = 2;
    indicatorView.tag = -1;
    indicatorView.y = titlesView.height - indicatorView.height;
    self.indicatorView = indicatorView;
    
    // 内部的子标签
    NSArray *titles = self.TitlesArrM;
    CGFloat width = titlesView.width / titles.count;
    CGFloat height = titlesView.height;
    for (NSInteger i = 0; i < titles.count; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i*width, 0, width, height)];
        button.tag = i;
        [button setTitle:titles[i] forState:UIControlStateNormal];
        //        [button layoutIfNeeded]; // 强制布局(强制更新子控件的frame)
        [button setTitleColor:JG333Color forState:UIControlStateNormal];
        [button setTitleColor:JGMainColor forState:UIControlStateSelected];
        button.titleLabel.font = JGFont(15);
        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [titlesView addSubview:button];
        
        if (i != titles.count) { //分割线
            
            UIView *Line = [[UIView alloc] initWithFrame:CGRectMake(width - 0.5, 12, 0.5, 20)];
            Line.backgroundColor = JGLineColor;
            [button addSubview:Line];
        }
        
        
        // 默认点击了第一个按钮
        if (i == 0) {
            //            button.enabled = NO;
            self.selectedButton = button;
            button.selected = YES;
            // 让按钮内部的label根据文字内容来计算尺寸
            [button.titleLabel sizeToFit];
            self.indicatorView.width = button.titleLabel.width + 25;
            self.indicatorView.centerX = button.centerX;
        }
    }
    
    [titlesView addSubview:indicatorView];
}

- (void)titleClick:(UIButton *)button
{
    // 控制按钮状态
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
    
    // 动画
    [UIView animateWithDuration:0.15 animations:^{
        self.indicatorView.width = button.titleLabel.width + 25;
        self.indicatorView.centerX = button.centerX;
    }];
    
    // 滚动
    CGPoint offset = self.contentView.contentOffset;
    offset.x = button.tag * self.contentView.width;
    [self.contentView setContentOffset:offset animated:YES];
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
    CGFloat Y = SJHeight + self.titlesView.height;
    contentView.frame = CGRectMake(0, Y , kDeviceWidth, kDeviceHight - Y);
    contentView.delegate = self;
    contentView.pagingEnabled = YES;
    [self.view insertSubview:contentView atIndex:0];
    contentView.contentSize = CGSizeMake(contentView.width * self.childViewControllers.count, 0);
    self.contentView = contentView;
    
    // 添加第一个控制器的view
    [self scrollViewDidEndScrollingAnimation:contentView];
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 当前的索引
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    
    // 取出子控制器
    UIViewController *vc = self.childViewControllers[index];
    
    // 取出子控制器
//    UITableViewController *vc = self.childViewControllers[index];
    vc.view.x = scrollView.contentOffset.x;
    vc.view.y = 0; // 设置控制器view的y值为0(默认是20)
    vc.view.height = scrollView.height; // 设置控制器view的height值为整个屏幕的高度(默认是比屏幕高度少个20)
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
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    [self titleClick:self.titlesView.subviews[index]];
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
