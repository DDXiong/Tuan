//
//  DDURLCandle.h
//  Tuan
//
//  Created by tarena500 on 15/9/10.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDURLCandle : NSObject

+ (NSDictionary *)parseQueryString:(NSString *)query;
//签名算法如下：

//1. 对除appkey以外的所有请求参数进行字典升序排列；

//2. 将以上排序后的参数表进行字符串连接，如key1value1key2value2key3value3...keyNvalueN；

//3. 将app key作为前缀，将app secret作为后缀，对该字符串进行SHA-1计算，并转换成16进制编码；

//4. 转换为全大写形式后即获得签名串
+ (NSString *)generateDianpingUrlWithLatitude:(double)latitude longtitude:(double)longitude ;
@end
