//
//  TRThirdViewController.m
//  Day14MHTabbarController
//
//  Created by tarena on 15-1-15.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "TRThirdViewController.h"

@interface TRThirdViewController ()

@end

@implementation TRThirdViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self.dataDict setObject:@[@"默认",@"价格低优先",@"价格高优先",@"购买人数多优先"] forKey:self.title];
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
