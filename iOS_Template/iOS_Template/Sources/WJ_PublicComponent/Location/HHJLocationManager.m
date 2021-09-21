//
//  HHJLocationManager.m
//  iOS_Template
//
//  Created by 贺文杰 on 2021/9/20.
//

#import "HHJLocationManager.h"
#import "FixedCoordinatesUtil.h"

@interface HHJLocationManager ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *clLocationManager;
@property (nonatomic, assign, getter=isLocating) BOOL locating;
@property (nonatomic, copy) void (^completion)(NSDictionary *locationInfo);

@end

@implementation HHJLocationManager

+ (instancetype)sharedInstance{
    static HHJLocationManager *Instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Instance = [[HHJLocationManager alloc] init];
    });
    return Instance;

}

/// 是否支持定位服务
+ (BOOL)isLocationServicesEnabled{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    BOOL enabled = !(![CLLocationManager locationServicesEnabled] || kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status);
    return enabled;
}

/// 获取定位信息
/// @param completion 回调
- (void)startUpdatingLocationWithCompletion:(void(^)(NSDictionary *locationInfo))completion{
    self.completion = completion;

    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
    {
        [self.clLocationManager requestWhenInUseAuthorization];
    }else {
        [self.clLocationManager startUpdatingLocation];
    }
}

#pragma mark -- CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations API_AVAILABLE(ios(6.0), macos(10.9)){
    [manager stopUpdatingLocation];

    CLLocation *location = locations.firstObject;

    self.locating = location ? YES : NO;

    if (!location)
    {
        // 获取不到定位信息
        if (self.completion)
        {
            self.completion(nil);
        }
    }

    NSMutableDictionary *locationInfo = [NSMutableDictionary dictionary];
    CLLocationCoordinate2D coordinate ={location.coordinate.latitude,location.coordinate.longitude};
    if ([FixedCoordinatesUtil isLocationInChina:coordinate]) {
        coordinate =[FixedCoordinatesUtil transformFromWGSToGCJ:coordinate];
    }
    locationInfo[@"latitude"] = @(coordinate.latitude); // 纬度
    locationInfo[@"longitude"] = @(coordinate.longitude); // 经度
    // 强制 成 简体中文
    NSMutableArray *userDefaultLanguages = [[NSUserDefaults standardUserDefaults]
                                            objectForKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"zh-hans",nil]
                                              forKey:@"AppleLanguages"];
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    typeof(self) __weak weakSelf = self;

    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        typeof(weakSelf) __strong strongSelf = weakSelf;
        
        if (placemarks.count == 0)
        {
            if (strongSelf.completion)
            {
                strongSelf.completion(nil);
            }
            return;
        }

        CLPlacemark *placemark = placemarks.firstObject;
        NSMutableString *fullAddress = [NSMutableString string];

        NSString *country = placemark.country;
        if (country.length > 0)
        {
            // 国家
            locationInfo[@"country"] = country;
            [fullAddress appendString:country];
        }

        NSString *administrativeArea = placemark.administrativeArea;
        if (administrativeArea.length > 0)
        {
            // 省份
            locationInfo[@"administrativeArea"] = administrativeArea;
            [fullAddress appendFormat:@"%@", administrativeArea];
        }

        NSString *locality = placemark.locality;
        if (locality.length > 0)
        {
            // 城市
            locationInfo[@"locality"] = locality;
            [fullAddress appendFormat:@"%@", locality];
        }

        NSString *subLocality = placemark.subLocality;
        if (subLocality.length > 0)
        {
            // 区
            locationInfo[@"subLocality"] = subLocality;
            [fullAddress appendFormat:@"%@", subLocality];
        }

        NSString *thoroughfare = placemark.thoroughfare;
        NSString *name = placemark.name;
        if (thoroughfare.length > 0)
        {
            // 街
            locationInfo[@"thoroughfare"] = thoroughfare;
            [fullAddress appendFormat:@"%@", thoroughfare];
        }
        else if (name.length > 0)
        {
            // 街
            locationInfo[@"thoroughfare"] = name;
            [fullAddress appendFormat:@"%@", name];
        }

        // 详细地址
        locationInfo[@"fullAddress"] = fullAddress;
        // 还原Device 的语言
        [[NSUserDefaults standardUserDefaults] setObject:userDefaultLanguages forKey:@"AppleLanguages"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if (strongSelf.completion)
        {
            strongSelf.completion(locationInfo);
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    [manager stopUpdatingLocation];

    // 获取不到定位信息
    if (self.completion)
    {
        self.completion(nil);
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status API_DEPRECATED_WITH_REPLACEMENT("-locationManagerDidChangeAuthorization:", ios(4.2, 14.0), macos(10.7, 11.0), watchos(1.0, 7.0), tvos(9.0, 14.0)){
    if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status)
    {
        // 授权不通过
        if (self.completion)
        {
            self.completion(nil);
        }
    }else {
        [self.clLocationManager startUpdatingLocation];
    }
}

/*
 *  locationManagerDidChangeAuthorization:
 *
 *  Discussion:
 *    Invoked when either the authorizationStatus or
 *    accuracyAuthorization properties change
 */
- (void)locationManagerDidChangeAuthorization:(CLLocationManager *)manager API_AVAILABLE(ios(14.0), macos(11.0), watchos(7.0), tvos(14.0)){
    if ([CLLocationManager locationServicesEnabled]) {
        [self.clLocationManager startUpdatingLocation];
    }else{
        // 授权不通过
        if (self.completion)
        {
            self.completion(nil);
        }
    }
}

#pragma mark - Getter

- (CLLocationManager *)clLocationManager
{
    if (!_clLocationManager)
    {
        _clLocationManager = [[CLLocationManager alloc]init];
        _clLocationManager.delegate = self;
        _clLocationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        _clLocationManager.distanceFilter = 500.0;
    }

    return _clLocationManager;
}

@end
