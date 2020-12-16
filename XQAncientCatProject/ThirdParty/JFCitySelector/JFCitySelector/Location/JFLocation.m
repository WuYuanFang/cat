//
//  JFLocation.m
//  Football
//
//  Created by 张志峰 on 16/6/7.
//  Copyright © 2016年 zhangzhifeng. All rights reserved.
//

#import "JFLocation.h"

#import <CoreLocation/CoreLocation.h>

@interface JFLocation ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation JFLocation

- (instancetype)init {
    if (self = [super init]) {
        // wxq_不需要创建就去定位
//        [self startPositioningSystem];
    }
    return self;
}

- (void)startPositioningSystem {
    if (!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
    }
    [self.locationManager startUpdatingLocation];
}

#pragma mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(locating)]) {
            [self.delegate locating];
        }
    });
    
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    
    // wxq 修改
    if (@available(iOS 11.0, *)) {
        NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"JFLocation"];
        [locale setAccessibilityLanguage:self.geoLauguage];
        [geoCoder reverseGeocodeLocation:[locations lastObject] preferredLocale:locale completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            for (CLPlacemark * placemark in placemarks) {
                NSDictionary *location = [placemark addressDictionary];
                if (self.delegate && [self.delegate respondsToSelector:@selector(currentLocation:)]) {
                    [self.delegate currentLocation:location];
                }
                break;
            }
        }];
    } else {
        [geoCoder reverseGeocodeLocation:[locations lastObject] completionHandler:^(NSArray *placemarks, NSError *error) {
            for (CLPlacemark * placemark in placemarks) {
                NSDictionary *location = [placemark addressDictionary];
                if (self.delegate && [self.delegate respondsToSelector:@selector(currentLocation:)]) {
                    [self.delegate currentLocation:location];
                }
                break;
            }
        }];
    }
    
    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if ([error code] == kCLErrorDenied) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(refuseToUsePositioningSystem:)]) {
            [self.delegate refuseToUsePositioningSystem:@"已拒绝使用定位系统"];
        }
    }
    if ([error code] == kCLErrorLocationUnknown) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(locateFailure:)]) {
                [self.delegate locateFailure:@"无法获取位置信息"];
            }
        });
    }
}

#pragma mark - get

- (NSString *)geoLauguage {
    if (!_geoLauguage) {
        // 设置为中文, 写死
        _geoLauguage = @"zh-Hans";
    }
    return _geoLauguage;
}

@end
