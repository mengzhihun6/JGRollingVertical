//
//  ViewController.m
//  JGRollingVertical
//
//  Created by 郭军 on 2019/5/6.
//  Copyright © 2019 ZYWL. All rights reserved.
//

#import "ViewController.h"
#import "JGRollingHorizontalController.h"
#import "JGRollingVerticalController.h"
#import "JGRollingTableVerticalController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;

@end

static NSString * const UITableViewCellId = @"UITableViewCellId";


@implementation ViewController

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:UITableViewCellId];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];

    
}




#pragma mark - UITableViewDataSource -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UITableViewCellId forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        
        cell.textLabel.text = @"横向切换";
    }else if (indexPath.row == 1){
        
          cell.textLabel.text = @"纵向切换";
    }else {
        
        cell.textLabel.text = @"tableView - 纵向切换";
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        
        JGRollingHorizontalController *VC = [[JGRollingHorizontalController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }else if (indexPath.row == 1){
        
        JGRollingVerticalController *VC = [[JGRollingVerticalController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }else {
        
        JGRollingTableVerticalController *VC = [[JGRollingTableVerticalController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 65.0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}





@end
