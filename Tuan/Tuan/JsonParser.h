//
//  JsonParser.h
//  Day15Tuan
//
//  Created by tarena on 15-2-27.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonParser : NSObject

+(NSArray *)parseBussinessByDic:(NSDictionary *)dic;

+(NSArray *)parseDealByDictionary:(NSDictionary *)dic;

@end
