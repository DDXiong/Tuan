//
//  DDURLCandle.m
//  Tuan
//
//  Created by tarena500 on 15/9/10.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "DDURLCandle.h"
#import <CommonCrypto/CommonDigest.h>
@implementation DDURLCandle
#define DIANPING_APP_KEY @"989370501"
#define DIANPING_APP_Secret @"316f569225ee49c485baedc197d900f0"
+ (NSDictionary *)parseQueryString:(NSString *)query {
 
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:6];
   
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    //字符串被& 隔开，生成数组
    
    
    for (NSString *pair in pairs) {
     
        NSArray *elements = [pair componentsSeparatedByString:@"="];
      
        if ([elements count] <= 1) {
          
            return nil;
          
        }
     //http://api.dianping.com/v1/deal/find_deals?city=上海&region=黄浦区&category=电影&limit=1&page=1&appkey=[appkey]&sign=[signature]
        
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
     
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
        [dict setObject:val forKey:key];
       
    }
  
    return dict;
   
}

//签名算法如下：

//1. 对除appkey以外的所有请求参数进行字典升序排列；

//2. 将以上排序后的参数表进行字符串连接，如key1value1key2value2key3value3...keyNvalueN；

//3. 将app key作为前缀，将app secret作为后缀，对该字符串进行SHA-1计算，并转换成16进制编码；

//4. 转换为全大写形式后即获得签名串

+ (NSString *)generateDianpingUrlWithLatitude:(double)latitude longtitude:(double)longitude

{

    NSString *url = nil;
  
    NSString *appKey = DIANPING_APP_KEY;
  
    NSString *appSecret = DIANPING_APP_Secret;
 
    NSMutableString *baseUrl = [NSMutableString stringWithFormat:@"http://api.dianping.com/v1/deal/find_deals?latitude=%f&longitude=%f&sort=7",latitude, longitude];
   
    //前缀
  
    NSMutableString *signString = [NSMutableString stringWithString:appKey];
    
    //中间的key1value1key2value2key3value3...keyNvalueN

    NSURL* parsedURL = [NSURL URLWithString:[baseUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithDictionary:[self parseQueryString:[parsedURL query]]];
 
    NSArray *sortedKeys = [[paramsDic allKeys] sortedArrayUsingSelector: @selector(compare:)];
   
    for (NSString *key in sortedKeys) {
        
        [signString appendFormat:@"%@%@", key, [paramsDic objectForKey:key]];
       
    }
 
    //后缀
 
    [signString appendString:appSecret];
  
    
  
    //对该字符串进行SHA-1计算，并转换成16进制编码；
   
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
 
    NSData *stringBytes = [signString dataUsingEncoding: NSUTF8StringEncoding];
  
    if (CC_SHA1([stringBytes bytes],(CC_LONG)[stringBytes length], digest)) {
      
        NSMutableString *digestString = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH];
      
        for (int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
          
            unsigned char aChar = digest[i];
            
            [digestString appendFormat:@"%02X", aChar];
          
        }
        
        url = [[NSString alloc] initWithFormat:@"%@&appkey=%@&sign=%@", baseUrl, appKey, [digestString uppercaseString]]; //转换为全大写形式后即获得签名串
      
    }
  
    return url;
   
}
@end
