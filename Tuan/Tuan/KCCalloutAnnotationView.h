//
//  KCCalloutAnnotationView.h
//  Tuan
//
//  Created by tarena500 on 15/9/9.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "KCCalloutAnnotation.h"

@interface KCCalloutAnnotationView : MKAnnotationView
@property (nonatomic ) KCCalloutAnnotation *annotation;

#pragma mark 从缓存取出标注视图
+(instancetype)calloutViewWithMapView:(MKMapView *)mapView;
@end
