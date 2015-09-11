//
//  SearchTableViewController.m
//  Tuan
//
//  Created by tarena on 15-4-1.
//  Copyright (c) 2015年 tarena. All rights reserved.
//
#import "WebViewController.h"
#import "SearchTableViewController.h"
#import "DianpingApi.h"
#import "BusinessTableViewCell.h"
@interface SearchTableViewController ()<UISearchBarDelegate>
@property (nonatomic, strong)NSMutableDictionary *params;
@property (nonatomic, strong)NSArray *businesses;
@end

@implementation SearchTableViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.params = [NSMutableDictionary dictionary];
   
    UISearchBar *sb = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    sb.delegate = self;
    self.tableView.tableHeaderView = sb;
    
   

}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    UISearchBar *sb = (UISearchBar*)self.tableView.tableHeaderView;
     [sb becomeFirstResponder];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSString *keyWord = searchBar.text;
    [self.params setObject:keyWord forKey:@"keyword"];
    [searchBar resignFirstResponder];
    
    [DianpingApi requestBusinessWithParams:self.params AndCallback:^(id obj) {
       
        self.businesses = obj;
        [self.tableView reloadData];
        
    }];
    
}

- (void)didReceiveMemoryWarning
{
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
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 90;
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


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
