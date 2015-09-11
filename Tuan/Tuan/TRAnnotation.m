//
//  TRAnnotation.m
//  TRSearchDeals
//
//  Created by tarena on 15/8/20.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "TRAnnotation.h"

@implementation TRAnnotation

//重写判定两个对象相等的逻辑
- (BOOL)isEqual:(TRAnnotation *)object {
    //判定规则：如果两个大头针的title一样，就认定两个大头针是同一个
    return [self.title isEqual:object.title];
}




@end
