//
//  MapView.m
//  Tuan
//
//  Created by tarena500 on 15/9/8.
//  Copyright (c) 2015年 tarena. All rights reserved.
//

#import "MapView.h"
#import <MapKit/MapKit.h>
#import "AFNetworking.h"
#import "TRAnnotation.h"
#import "Deal.h"
#import "DPAPI.h"
#import "JsonParser.h"
#import "BusinessInfo.h"
#import "MJExtension.h"
@interface MapView ()<MKMapViewDelegate,DPRequestDelegate >
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property(nonatomic,strong)CLLocationManager*locationManager;
@property(nonatomic,strong)CLGeocoder*geocoder;
@property(nonatomic,strong)NSString*cityName;

@end

@implementation MapView

#define DIANPING_APP_KEY @"989370501"
#define DIANPING_APP_Secret @"316f569225ee49c485baedc197d900f0"
-(CLGeocoder*)geocoder{
    if (!_geocoder) {
        _geocoder=[[CLGeocoder alloc]init];
    }
    return _geocoder;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initGUI];
    //[self addAnnotation];
}

#pragma mark 添加地图控件
-(void)initGUI{

    _locationManager=[[CLLocationManager alloc]init];

        [_locationManager requestAlwaysAuthorization];
   
    
    //用户位置追踪(用户位置追踪用于标记用户当前位置，此时会调用定位服务)
    _mapView.userTrackingMode=MKUserTrackingModeFollow;
    
    //设置地图类型
    _mapView.mapType=MKMapTypeStandard;
     self.mapView.delegate = self;
    //添加大头针
   // [self addAnnotation];
}

#pragma mark --- mapView delegate
//定位到用户位置的触发方法
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    NSLog(@"00000000000");
    //1.反地理编码,获取用户所在的城市(@“city”)
    [self.geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (!error) {
            //通过获得的地标对象，获取用户所在的城市
            CLPlacemark *placemark = [placemarks lastObject];
            //placemark.addressDictionary[@"state"]
            //如果是直辖市(北京市市辖区)
            NSString *subLocality = [placemark.locality substringFromIndex:placemark.locality.length - 2];
            if ([subLocality isEqualToString:@"辖区"]) {
                NSString *tmpStr = placemark.addressDictionary[@"State"];//tmpStr:北京市
                self.cityName = [tmpStr substringToIndex:tmpStr.length - 1];
            } else {
                //非直辖市(保定市)
                self.cityName = [placemark.locality substringToIndex:placemark.locality.length - 1];
            }

            //2.发送请求(获取用户位置附近500米内的所有团购订单)
            [self mapView:self.mapView regionDidChangeAnimated:YES];
        }
    }];
  
    [self requetStatusWithmapView:mapView];
}





-(void)requetStatusWithmapView:(MKMapView *)mapView{

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //获取显示部分的地图的中心(latitude; longitude)
    params[@"city"] =@"深圳";   //self.cityName;
    params[@"latitude"] = @(mapView.region.center.latitude);
    params[@"longitude"] = @(mapView.region.center.longitude);
    params[@"radius"] = @(5000);
    DPAPI *api = [[DPAPI alloc] init];
    //发送请求
    [api requestWithURL:@"v1/deal/find_deals" params:params delegate:self];

}

//挪动地图的触发方法
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {

    [self requetStatusWithmapView:mapView];

   }

#pragma mark --- dianping delegate
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result {
    NSArray*dealArray=result[@"deals"];
    for (NSDictionary*dic in dealArray ) {
        Deal*deal=[Deal objectWithKeyValues:dic];
        NSArray*businesses=deal.businesses;
        for (NSDictionary*dicBusi in businesses) {
            BusinessInfo*business=[BusinessInfo objectWithKeyValues:dicBusi];
            TRAnnotation *annotation = [[TRAnnotation alloc] init];
            annotation.coordinate = CLLocationCoordinate2DMake(business.latitude , business.longitude );
            annotation.title = business.name;
            annotation.image=[UIImage imageNamed:@"ic_category_22@2x.png"];
            // annotation.subtitle = ;
            //设置图片
            NSLog(@"组数:%f,%f %@ ",business.latitude,business.longitude,business.name);
              annotation.image = [UIImage imageNamed:@"ic_category_22.png"];


            // 判定当前地图是否有该大头针
            if ([self.mapView.annotations containsObject:annotation]) {
                break;
            }
            
            [self.mapView addAnnotation:annotation];
   
        }
  
    }

}
#pragma mark 显示大头针时调用，注意方法中的annotation参数是即将显示的大头针对象

- (void)request:(DPRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"服务器返回失败：%@", error.userInfo);
    
}


-(void)addAnnotation{
    

        
        CLLocationCoordinate2D location1=CLLocationCoordinate2DMake(22.561922,114.169807);
        TRAnnotation *annotation=[[TRAnnotation alloc]init];
        annotation.title=@"深圳";
        annotation.subtitle=@"Kenshin Cui's Studios";
        annotation.coordinate=location1;
        annotation.image=[UIImage imageNamed:@"ic_category_22.png"];
        annotation.icon=[UIImage imageNamed:@"ic_category_22.png"];
        annotation.detail=@"CMJ Studio...";
        annotation.rate=[UIImage imageNamed:@"ic_category_22.png"];
        [_mapView addAnnotation:annotation];
        
 
    
}


#pragma mark -- MapView delegate
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {

    //判定是否是当前用户的位置
    if ([annotation isMemberOfClass:[MKUserLocation class]]) {
        return nil;
    }
//    //重用机制
    static NSString *identifier = @"anno";
    MKAnnotationView *annoView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (!annoView) {
        annoView = [[MKAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:identifier];
        //设置callout
        annoView.canShowCallout = YES;
    }
    
    TRAnnotation *anno = (TRAnnotation *)annotation;
    annoView.annotation = anno;
    annoView.image = anno.image;
    return annoView;
}


@end