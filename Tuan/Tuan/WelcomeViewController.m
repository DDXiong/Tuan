//
//  WelcomeViewController.m
//  SELECT
//
//  Created by tarena on 14-12-18.
//  Copyright (c) 2014年 tarena. All rights reserved.
//
#define kDEVICE_WIDTH [[UIScreen mainScreen] bounds].size.width
#define kDEVICE_HEIGHT [[UIScreen mainScreen] bounds].size.height
#import "WelcomeViewController.h"
#import "AppDelegate.h"
@interface WelcomeViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIButton *enterBtn;
@end

@implementation WelcomeViewController

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
    [self prefersStatusBarHidden];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(kDEVICE_WIDTH * 3, kDEVICE_HEIGHT);
    self.scrollView.delegate = self;
    [self createImageData];
}
-(void)createImageData{
    for(int i = 0;i < 3 ;i++){
        UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake(kDEVICE_WIDTH * i, 0, kDEVICE_WIDTH, kDEVICE_HEIGHT)];
        imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"引导页－%d.jpg",i+1]];

        [self.scrollView addSubview:imgView];
        
        if( i==2){
            imgView.userInteractionEnabled = YES;
            //205,1002,236,70
            self.enterBtn = [[UIButton alloc]initWithFrame:CGRectMake(103,self.view.bounds.size.height-50, 118, 35)];
            
            [self.enterBtn addTarget:self action:@selector(enter) forControlEvents:UIControlEventTouchUpInside];
            [imgView addSubview:self.enterBtn];
        }
    }
}

-(void)enter{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    app.window.rootViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"tvc"];
    //第一次浏览完欢迎界面之后就不再显示了
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:YES forKey:@"isVisibled"];
    [ud synchronize];
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
    self.hvc = segue.destinationViewController;
}
*/

@end
