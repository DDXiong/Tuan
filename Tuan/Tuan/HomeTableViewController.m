//
//  HomeTableViewController.m
//  SELECT
//
//  Created by Tarena on 14/12/25.
//  Copyright (c) 2014年 tarena. All rights reserved.
//
#define TOPIC_COLOR_ORANGE [UIColor colorWithRed:247.0/255 green:135.0/255 blue:74.0/255 alpha:1.0]
#import "BusinessTableViewController.h"
#import "HomeTableViewController.h"
#import "BusinessTableViewCell.h"


@interface HomeTableViewController ()
@property(strong,nonatomic)NSMutableArray * businesses;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (nonatomic, strong)NSMutableDictionary *params;
@property (nonatomic)int currentPage;
@end

@implementation HomeTableViewController

- (void)viewDidLoad {
    self.params = [NSMutableDictionary dictionary];
  
    self.currentPage = 1;
    [self.params setObject:@(self.currentPage) forKey:@"page"];
    [self.params setObject:@(20) forKey:@"limit"];
    [super viewDidLoad];
    //初始化
    [self initHeaderView];
 
    //添加监听 当用户点击自动以headerView礼里面的分类按钮的时候响应
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(clickedCategory:) name:@"clickedCategory" object:nil];

}

-(void)clickedCategory:(NSNotification*)notif{
    
    //在这个位置跳转页面显示所点击的分类内容
    NSString *category = [notif.userInfo objectForKey:@"category"];
    [self performSegueWithIdentifier:@"businessvc" sender:category];
}
#pragma mark -请求商户信息
-(void)getBusinesses{
    
    
    [DianpingApi requestBusinessWithParams:self.params AndCallback:^(id obj) {
        self.businesses = obj;
        [self.tableView reloadData];
    }];
}

-(void)initUI{
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.bounds.size.width, 20)];
    [self.navigationController.navigationBar addSubview:statusBarView];
    statusBarView.backgroundColor = TOPIC_COLOR_ORANGE;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = TOPIC_COLOR_ORANGE;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //设置界面
    [self initUI];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
  
    NSString *cityName= [ud objectForKey:@"cityName"];
    if (!cityName) {
        cityName = @"北京";
        [ud setObject:cityName forKey:@"cityName"];
        [ud synchronize];
    }
    self.cityLabel.text = cityName;
    //获取数据
    [self getBusinesses];
    self.tabBarController.tabBar.hidden = NO;
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

#pragma mark - 初始化tableheaderview
-(void)initHeaderView{
    self.headerView = self.tableView.tableHeaderView;
    self.headerView.frame = CGRectMake(0, 0, 320, 200);
  

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.businesses.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * cells = @"BusinessTableViewCell";
    BusinessTableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:cells ];
    if(!cell){
//        自定义xib的View时 在代码需要创建该View必须用到下面的方法
        cell = [[[NSBundle mainBundle]loadNibNamed:@"BusinessTableViewCell" owner:self options:nil]lastObject];
    }
    BusinessInfo * business = self.businesses[indexPath.row];
    cell.business = business;
    
    
    if (self.businesses.count-1==indexPath.row) {
        
        [self.params setObject:@(++self.currentPage) forKey:@"page"];
        [DianpingApi requestBusinessWithParams:self.params AndCallback:^(id obj) {
            [self.businesses addObjectsFromArray:obj];
            [self.tableView reloadData];
        }];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 90;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString * str = @"猜你喜欢";
    
    return str;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BusinessInfo *bi = self.businesses[indexPath.row];
    
    WebViewController *webView = [[WebViewController alloc] init];
    webView.urlString = bi.business_url;
    
    webView.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:webView animated:YES];
    webView.hidesBottomBarWhenPushed = NO;
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"businessvc"]) {
        BusinessTableViewController *vc = segue.destinationViewController;
        vc.category = sender;
    }

}

@end
