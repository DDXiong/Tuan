//
//  TableViewController.m
//  Day15Citys
//
//  Created by tarena on 15-3-31.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "CitysTableViewController.h"
#import "pinyin.h"
@interface CitysTableViewController ()
@property (nonatomic, strong)NSMutableDictionary *cityDic;
@property (nonatomic, strong)NSArray *allKeys;
@end

@implementation CitysTableViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.cityDic = [NSMutableDictionary dictionary];
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"citys" ofType:@"plist"];
    NSArray *citys = [NSArray arrayWithContentsOfFile:path];
    
    for (NSString *cityName in citys) {
        char firstLetter = pinyinFirstLetter([cityName characterAtIndex:0]);
        NSString *key = [NSString stringWithFormat:@"%c",firstLetter];
        
        NSMutableArray *newCitys = [self.cityDic objectForKey:key];
        if (!newCitys) {
            newCitys = [NSMutableArray array];
            [self.cityDic setObject:newCitys forKey:key];
        }
        [newCitys addObject:cityName];
    }
    
    [self.cityDic writeToFile:@"/Users/tarena/Desktop/citys.plist" atomically:YES];
    
    self.allKeys = [self.cityDic.allKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return self.cityDic.allKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = self.allKeys[section];
    
    NSArray *citys = [self.cityDic objectForKey:key];
    
    return citys.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSString *key = self.allKeys[indexPath.section];
    NSArray *citys = [self.cityDic objectForKey:key];
    
    NSString *cityName = citys[indexPath.row];
    cell.textLabel.text = cityName;
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    
    return self.allKeys[section];
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    
    return self.allKeys;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *key = self.allKeys[indexPath.section];
    NSArray *citys = [self.cityDic objectForKey:key];
    
    NSString *cityName = citys[indexPath.row];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:cityName forKey:@"cityName"];
    [ud synchronize];

    [[NSNotificationCenter defaultCenter]postNotificationName:@"cityChange" object:nil userInfo:@{@"cityName": cityName}];
    
    
    [self.navigationController popViewControllerAnimated:YES];
 
    
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
