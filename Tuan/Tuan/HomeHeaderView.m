//
//  HomeHeaderView.m
//  Day15Tuan
//
//  Created by tarena on 15-2-28.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "HomeHeaderView.h"

@implementation HomeHeaderView
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSArray * labelText = @[@"美食",@"电影",@"酒店",@"KTV",@"小吃",@"休闲娱乐",@"今日新品",@"更多"];
        for (int i = 0; i<8; i++) {
            UIButton * headerBtn = [[UIButton alloc]initWithFrame:CGRectMake(i%4*80+10, i/4*90+10, 60, 60)];
            headerBtn.tag = i;
            [headerBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"首页_1%d",i+1]] forState:UIControlStateNormal];
            [headerBtn addTarget:self action:@selector(categoryClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:headerBtn];
            
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(i%4*80+10, i/4*90+80, 60, 10)];
            label.text = labelText[i];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor lightGrayColor];
            label.font = [UIFont fontWithName:@"黑体-简" size:11];
            label.textColor = [UIColor colorWithRed:62.0/255 green:62.0/255 blue:62.0/255 alpha:1];
            [self addSubview:label];
        }
    }
    return self;
}

-(void)categoryClick:(UIButton*)btn{
    
    NSString *category = @"美食";
    switch (btn.tag) {
        case 1:
            category = @"电影";
            break;
        case 2:
            category = @"酒店";
            break;
        case 3:
            category = @"KTV";
            break;
        case 4:
            category = @"购物";
            break;
        case 5:
            category = @"休闲娱乐";
            break;
        case 6:
            category = @"旅行社";
            break;
        case 7:
            category = @"购物";
            break;
            
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"clickedCategory" object:nil userInfo:@{@"category":category}];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
