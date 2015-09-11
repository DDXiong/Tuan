//
//  TRFirstViewController.m
//  Day14MHTabbarController
//
//  Created by tarena on 15-1-15.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "TRFirstViewController.h"

@interface TRFirstViewController ()

@end

@implementation TRFirstViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
   
//    [self.dataDict setObject:@[@"aaa",@"bbb"] forKey:self.title];
//    
//    [self.dataDict setObject:@[@"aaa",@"bbb"] forKey:@"汽车"];
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"category" ofType:@"plist"];
    self.dataDict = [NSMutableDictionary dictionaryWithContentsOfFile:path];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
