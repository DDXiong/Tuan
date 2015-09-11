//
//  DealViewController.m
//  TUAN
//
//  Created by Tarena on 15/1/3.
//  Copyright (c) 2015年 Tarena. All rights reserved.
//

#import "DealsTableViewController.h"
#import "DianpingApi.h"
#import "Deal.h"
#import "DealTableViewCell.h"
#import "MHTabBarController/MHTabBarController.h"
#import "TRFirstViewController.h"
#import "TRSecondViewController.h"
#import "TRThirdViewController.h"

#import "WebViewController.h"


@interface DealsTableViewController ()<MHTabBarControllerDelegate>

@property(strong,nonatomic)NSMutableArray * deals;
@property (nonatomic, strong)MHTabBarController *tbc;
@property (nonatomic, strong)NSMutableDictionary *params;
@property (nonatomic)int currentPage;
@end

@implementation DealsTableViewController
- (void)subViewController:(UIViewController *)subViewController SelectedCell:(NSString *) selectedText{
    
    if ([subViewController.title isEqualToString:@"全部分类"]) {
        [self.params setObject:selectedText forKey:@"category"];
        
        
    }else if([subViewController.title isEqualToString:@"全部地区"]){
            [self.params setObject:selectedText forKey:@"region"];
    }else{//排序
        int sortType = 1;
        if ([selectedText isEqualToString:@"价格低优先"]) {
            sortType = 2;
        }else if ([selectedText isEqualToString:@"价格高优先"]) {
            sortType = 3;
        }else if ([selectedText isEqualToString:@"购买人数多优先"]) {
            sortType = 4;
        }
        [self.params setObject:@(sortType) forKey:@"sort"];
        
    }
    [DianpingApi requestDealsWithParams:self.params AndCallback:^(id obj) {
        self.deals = obj;
        [self.tableView reloadData];
    }];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.params = [NSMutableDictionary dictionary];
    self.currentPage = 1;
    [self.params setObject:@(self.currentPage) forKey:@"page"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getDeals];
    
    [self createTabBar];
}

-(void)createTabBar{
    //如果创建过 就不再创建了
    if (self.tbc) {
        return;
    }
    self.tbc = [[MHTabBarController alloc]init];
    self.tbc.delegate = self;
    TRFirstViewController *first = [[TRFirstViewController alloc]init];
    first.title = @"全部分类";
    TRSecondViewController *second = [[TRSecondViewController alloc]init];
    second.title = @"全部地区";
    TRThirdViewController *third = [[TRThirdViewController alloc]init];
    third.title = @"智能排序";
    
    self.tbc.viewControllers = @[first,second,third];
    //    因为当前是tableViewController 需要添加到    俯视图navi里面
    
    self.tableView.tableHeaderView = self.tbc.view;
    //让内容显示在bar下面
    self.tableView.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    
}


#pragma mark - 设置状态栏

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

#pragma mark - 请求团购信息

-(void)getDeals{

    [DianpingApi requestDealsWithParams:@{} AndCallback:^(id obj) {
        self.deals = obj;
        [self.tableView reloadData];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.deals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * identifier = @"DealCell";
    DealTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"DealTableViewCell" owner:self options:nil] lastObject];
    }
    cell.deal = self.deals[indexPath.row];
    
//    判断显示的是最后一行
    if (indexPath.row == self.deals.count-1) {
        [self.params setObject:@(++self.currentPage) forKey:@"page"];
        [DianpingApi requestDealsWithParams:self.params AndCallback:^(id obj) {
            [self.deals addObjectsFromArray:obj];
            [self.tableView reloadData];
        }];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WebViewController *webView = [[WebViewController alloc] init];
    webView.urlString = ((Deal *)[self.deals objectAtIndex:indexPath.row]).deal_h5_url;
    webView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webView animated:YES];
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
