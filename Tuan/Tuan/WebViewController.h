//
//  WebViewController.h
//  TUAN
//
//  Created by Tarena on 15/1/4.
//  Copyright (c) 2015年 Tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController
@property (copy,nonatomic) NSString *urlString;
@property (strong,nonatomic) UIWebView *webView;
@end
