//
//  BusinessTableViewCell.h
//  SELECT
//
//  Created by buzz on 14/12/23.
//  Copyright (c) 2014年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusinessInfo.h"

@interface BusinessTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *s_photo;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *coupon_description;
@property (weak, nonatomic) IBOutlet UILabel *avg_price;
@property (weak, nonatomic) IBOutlet UILabel *deal_count;
@property (strong,nonatomic) BusinessInfo * business;

@end
