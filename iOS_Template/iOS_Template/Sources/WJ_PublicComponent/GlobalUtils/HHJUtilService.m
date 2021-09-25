//
//  HHJUtilService.m
//  iOS_Template
//
//  Created by 贺文杰 on 2021/9/20.
//

#import "HHJUtilService.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <sys/sockio.h>
#import <sys/ioctl.h>

#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <sys/utsname.h>
#import "AFNetworkReachabilityManager.h"
#import "HHJGlobalConstant.h"

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"


@implementation HHJUtilService

+ (NSString *)getIPAddressIPv4:(BOOL)preferIPv4
{
#if TARGET_IPHONE_SIMULATOR  //模拟器
    return @"0.0.0.0";
#elif TARGET_OS_IPHONE
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_CELLULAR @"/" IP_ADDR_IPv4,IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv4,  IOS_CELLULAR @"/" IP_ADDR_IPv4 ] :
    @[ IOS_CELLULAR @"/" IP_ADDR_IPv6,IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv6,  IOS_CELLULAR @"/" IP_ADDR_IPv6 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
    HHJLog(@"addresses: %@", addresses);
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         if(address) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
#endif
}

+ (NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}

// 获取运营商
+ (NSString *)carrierName
{
    // 网络类型
    CTCarrier *carrier = [[[CTTelephonyNetworkInfo alloc] init] subscriberCellularProvider];
    return carrier.carrierName;
}
// 获取系统版本
+ (NSString *)OSVersion
{
    return [UIDevice currentDevice].systemVersion;
}

// 获取设备型号
+ (NSString *)deviceName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    // iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"]) return @"iPhone";
    if ([deviceString isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"] ||
        [deviceString isEqualToString:@"iPhone3,2"] ||
        [deviceString isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"] ||
        [deviceString isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"] ||
        [deviceString isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    if ([deviceString isEqualToString:@"iPhone6,1"] ||
        [deviceString isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    if ([deviceString isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone8,4"]) return @"iPhone SE(1st generation)";
    if ([deviceString isEqualToString:@"iPhone9,1"] ||
       [deviceString isEqualToString:@"iPhone9,3"]) return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,2"] ||
        [deviceString isEqualToString:@"iPhone9,4"]) return @"iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone10,1"] ||
        [deviceString isEqualToString:@"iPhone10,4"]) return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,2"] ||
        [deviceString isEqualToString:@"iPhone10,5"]) return @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,3"] ||
        [deviceString isEqualToString:@"iPhone10,6"]) return @"iPhone X";
    if ([deviceString isEqualToString:@"iPhone11,8"]) return @"iPhone XR";
    if ([deviceString isEqualToString:@"iPhone11,2"]) return @"iPhone XS";
    if ([deviceString isEqualToString:@"iPhone11,4"] ||
        [deviceString isEqualToString:@"iPhone11,6"]) return @"iPhone XS Max";
    if ([deviceString isEqualToString:@"iPhone12,1"]) return @"iPhone 11";
    if ([deviceString isEqualToString:@"iPhone12,3"]) return @"iPhone 11 Pro";
    if ([deviceString isEqualToString:@"iPhone12,5"]) return @"iPhone 11 Pro Max";
    if ([deviceString isEqualToString:@"iPhone12,8"]) return @"iPhone SE(2nd generation)";
    if ([deviceString isEqualToString:@"iPhone13,1"]) return @"iPhone 12 mini";
    if ([deviceString isEqualToString:@"iPhone13,3"]) return @"iPhone 12";
    if ([deviceString isEqualToString:@"iPhone13,3"]) return @"iPhone 12 Pro";
    if ([deviceString isEqualToString:@"iPhone13,4"]) return @"iPhone 12 Pro Max";
    if ([deviceString isEqualToString:@"iPhone14,4"]) return @"iPhone 13 mini";
    if ([deviceString isEqualToString:@"iPhone14,5"]) return @"iPhone 13";
    if ([deviceString isEqualToString:@"iPhone14,2"]) return @"iPhone 13 Pro";
    if ([deviceString isEqualToString:@"iPhone14,3"]) return @"iPhone 13 Pro Max";

    //iPod Touch
    if ([deviceString isEqualToString:@"iPod1,1"])   return @"iPod Touch";
    if ([deviceString isEqualToString:@"iPod2,1"])   return @"iPod Touch (2nd generation)";
    if ([deviceString isEqualToString:@"iPod3,1"])   return @"iPod Touch (3rd generation)";
    if ([deviceString isEqualToString:@"iPod4,1"])   return @"iPod Touch (4th generation)";
    if ([deviceString isEqualToString:@"iPod5,1"])   return @"iPod Touch (5th generation)";
    if ([deviceString isEqualToString:@"iPod7,1"])   return @"iPod Touch (6th generation)";
    if ([deviceString isEqualToString:@"iPod9,1"])   return @"iPod Touch (7th generation)";

    //iPad
    if ([deviceString isEqualToString:@"iPad1,1"])   return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"] ||
        [deviceString isEqualToString:@"iPad2,2"] ||
        [deviceString isEqualToString:@"iPad2,3"] ||
        [deviceString isEqualToString:@"iPad2,4"])   return @"iPad2";
    if ([deviceString isEqualToString:@"iPad3,1"] ||
        [deviceString isEqualToString:@"iPad3,2"] ||
        [deviceString isEqualToString:@"iPad3,3"])   return @"iPad3";
    if ([deviceString isEqualToString:@"iPad3,4"] ||
        [deviceString isEqualToString:@"iPad3,5"] ||
        [deviceString isEqualToString:@"iPad3,6"])   return @"iPad4";
    if ([deviceString isEqualToString:@"iPad6,11"] ||
        [deviceString isEqualToString:@"iPad6,12"])   return @"iPad5";
    if ([deviceString isEqualToString:@"iPad7,5"] ||
        [deviceString isEqualToString:@"iPad7,6"])   return @"iPad 6th generation";
    if ([deviceString isEqualToString:@"iPad7,11"] ||
        [deviceString isEqualToString:@"iPad7,12"])   return @"iPad 7th generation";
    if ([deviceString isEqualToString:@"iPad11,6"] ||
        [deviceString isEqualToString:@"iPad11,7"])   return @"iPad 8th generation";
    if ([deviceString isEqualToString:@"iPad12,1"] ||
        [deviceString isEqualToString:@"iPad12,2"])   return @"iPad 9th generation";

    //iPad Air
    if ([deviceString isEqualToString:@"iPad4,1"] ||
        [deviceString isEqualToString:@"iPad4,2"] ||
        [deviceString isEqualToString:@"iPad4,3"])   return @"iPadAir";
    if ([deviceString isEqualToString:@"iPad5,3"] ||
        [deviceString isEqualToString:@"iPad5,4"])   return @"iPadAir2";
    if ([deviceString isEqualToString:@"iPad11,3"] ||
        [deviceString isEqualToString:@"iPad11,4"])   return @"iPadAir3";
    if ([deviceString isEqualToString:@"iPad13,1"] ||
        [deviceString isEqualToString:@"iPad13,2"])   return @"iPadAir4";
    
    //iPad pro
    if ([deviceString isEqualToString:@"iPad6,7"] ||
        [deviceString isEqualToString:@"iPad6,8"])   return @"iPadPro 12.9-inch"; //12.9 英寸
    if ([deviceString isEqualToString:@"iPad6,3"] ||
        [deviceString isEqualToString:@"iPad6,4"])   return @"iPadPro 9.7-inch"; //9.7 英寸
    if ([deviceString isEqualToString:@"iPad7,1"] ||
        [deviceString isEqualToString:@"iPad7,2"]) return @"iPad Pro 12.9-inch 2";
    if ([deviceString isEqualToString:@"iPad7,3"] ||
        [deviceString isEqualToString:@"iPad7,4"]) return @"iPad Pro 10.5-inch";
    if ([deviceString isEqualToString:@"iPad8,1"] ||
        [deviceString isEqualToString:@"iPad8,2"] ||
        [deviceString isEqualToString:@"iPad8,3"] ||
        [deviceString isEqualToString:@"iPad8,4"]) return @"iPad Pro 11-inch";
    if ([deviceString isEqualToString:@"iPad8,5"] ||
        [deviceString isEqualToString:@"iPad8,6"] ||
        [deviceString isEqualToString:@"iPad8,7"] ||
        [deviceString isEqualToString:@"iPad8,8"]) return @"iPad Pro 12.9-inch (3rd generation)";
    if ([deviceString isEqualToString:@"iPad8,9"] ||
        [deviceString isEqualToString:@"iPad8,10"]) return @"iPad Pro 11-inch (2nd generation)";
    if ([deviceString isEqualToString:@"iPad8,11"] ||
        [deviceString isEqualToString:@"iPad8,12"]) return @"iPad Pro 12.9-inch (4th generation)";
    if ([deviceString isEqualToString:@"iPad13,4"] ||
        [deviceString isEqualToString:@"iPad13,5"] ||
        [deviceString isEqualToString:@"iPad13,6"] ||
        [deviceString isEqualToString:@"iPad13,7"]) return @"iPad Pro 11-inch (3rd generation)";
    if ([deviceString isEqualToString:@"iPad13,8"] ||
        [deviceString isEqualToString:@"iPad13,9"] ||
        [deviceString isEqualToString:@"iPad13,10"] ||
        [deviceString isEqualToString:@"iPad13,11"]) return @"iPad Pro 12.9-inch (5th generation)";


    //iPad mini
    if ([deviceString isEqualToString:@"iPad2,5"] ||
        [deviceString isEqualToString:@"iPad2,6"] ||
        [deviceString isEqualToString:@"iPad2,7"])   return @"iPad mini";
    if ([deviceString isEqualToString:@"iPad4,4"] ||
        [deviceString isEqualToString:@"iPad4,5"] ||
        [deviceString isEqualToString:@"iPad4,6"])   return @"iPad mini 2";
    if ([deviceString isEqualToString:@"iPad4,7"] ||
        [deviceString isEqualToString:@"iPad4,8"] ||
        [deviceString isEqualToString:@"iPad4,9"])   return @"iPad mini 3";
    if ([deviceString isEqualToString:@"iPad5,1"] ||
        [deviceString isEqualToString:@"iPad5,2"])   return @"iPad mini 4";
    if ([deviceString isEqualToString:@"iPad11,1"] ||
        [deviceString isEqualToString:@"iPad11,2"])   return @"iPad mini (5th generation)";
    if ([deviceString isEqualToString:@"iPad14,1"] ||
        [deviceString isEqualToString:@"iPad14,2"])   return @"iPad mini (6th generation)";

    
    if ([deviceString isEqualToString:@"i386"])      return @"iPhoneSimulator";
    if ([deviceString isEqualToString:@"x86_64"])    return @"iPhoneSimulator";
    return @"Unknown";
}

+ (NSString *)deviceNameForHeader {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    return [NSString stringWithFormat:@"%@--%@",deviceString, [self deviceName]];
}

// 获取平台 iPhone iPad
+ (NSString *)devicePlatForm
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if ([deviceString containsString:@"iPad"])
    {
        return @"iPad";
    }
    else if ([deviceString containsString:@"iPhone"])
    {
        return @"iPhone";
    }
    return @"Unknown";
}

/// 获取设备分辨率
+ (NSString *)resolution
{
    CGRect rect_screen = [[UIScreen mainScreen] bounds];
    CGSize size_screen = rect_screen.size;
    
    CGFloat scale_screen = [UIScreen mainScreen].scale;
    
    CGFloat width = size_screen.width*scale_screen;
    CGFloat height = size_screen.height*scale_screen;
    NSString *strW = [NSString stringWithFormat:@"%f",width];
    NSString *strH = [NSString stringWithFormat:@"%f",height];
    NSString *dot = @".";
    NSRange wdrang = [strW rangeOfString:dot];
    strW = [strW substringToIndex:wdrang.location];
    NSRange hdrang = [strH rangeOfString:dot];
    strH= [strH substringToIndex:hdrang.location];
    NSString *reso = [NSString stringWithFormat:@"%@*%@",strW,strH];
    return reso;
}

+ (NSString *)getUserLanguageCode {
    
//    读取本机设置的语言列表，获取第一个语言，该方法读取的语言为：国际通用语言Code+国际通用国家地区代码，
//    所以实际上想获取语言还需将国家地区代码剔除
    NSArray  *languageList =  [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] ;// 本机设置的语言列表
    NSString *languageCode = [languageList  firstObject];// 当前设置的首选语言
    NSString *countryCode = [NSString stringWithFormat:@"-%@", [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode]];
    if (languageCode && languageCode.length > 0 && countryCode && countryCode.length > 0) {
        languageCode = [languageCode stringByReplacingOccurrencesOfString:countryCode withString:@""];
    }
    
    return languageCode;
    
}

+ (NSString *)getAppName {
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [infoDic objectForKey:@"CFBundleDisplayName"];
    if (!appName || appName.length <= 0) {
        appName = [infoDic objectForKey:@"CFBundleName"];
    }
    return appName;
}

/// 获取应用build版本号
+ (NSString *)getAppBuildVersion{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appBuildVersion = [infoDic objectForKey:@"CFBundleVersion"];
    return kCheckNil(appBuildVersion);
}

/// 获取应用版本号
+ (NSString *)getAppVersion{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    return kCheckNil(appVersion);
}

+ (CGFloat)adaptedUI:(CGFloat)original UIWidth:(CGFloat)width{
    CGRect boudle = [[UIScreen mainScreen] bounds];
    CGSize screenSize = boudle.size;
    if (width == screenSize.width * 2) {
        return original/2;
    }
    
    CGFloat scale = screenSize.width * 2/width;
    original = ceil(original * scale/2);
    
    return original;
}

/// 返回网络状态
/// @param block 回调block，status为 unknow-未知网络 NotReachable-网络不可达, 无网络 WiFi-WiFi 2G-2G网络 3G-3G网络 4G-4G网络 5G-5G网络
+ (void)getNetworkStatus:(void(^)(NSString *status))block{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring]; //开始监听

    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:{
                if (block) {
                    block(@"unknown");
                }
            }
                break;
            case AFNetworkReachabilityStatusNotReachable:{
                if (block) {
                    block(@"NotReachable");
                }
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:{
                if (block) {
                    block(@"WiFi");
                }
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:{
                //创建一个CTTelephonyNetworkInfo对象
                CTTelephonyNetworkInfo *networkStatus = [[CTTelephonyNetworkInfo alloc] init];
                NSString *str = @"4G";
                if (@available(iOS 12.0, *)) { //大于12系统版本
                    NSDictionary *dic = networkStatus.serviceCurrentRadioAccessTechnology;
                    NSString *currentStatus = @"";
                    if (dic.allKeys.count) {
                        currentStatus = [dic objectForKey:dic.allKeys[0]];
                    }
                    str = [HHJUtilService networkStatus:currentStatus];
                } else {
                    //获取当前网络描述
                    NSString *currentStatus  = networkStatus.currentRadioAccessTechnology;
                    str = [HHJUtilService networkStatus:currentStatus];
                }
                if (block) {
                    block(str);
                }
            }
            default:
                break;
        }
    }];
}

+ (NSString *)networkStatus:(NSString *)currentStatus{
    NSString *str = @"4G";
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyGPRS"]){
        //GPRS网络
        str = @"2G";
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyEdge"]){
        //2.75G的EDGE网络
        str = @"2G";
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyWCDMA"]){
        //3G WCDMA网络
        str = @"3G";
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSDPA"]){
        //3.5G网络
        str = @"3G";
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSUPA"]){
        //3.5G网络
        str = @"3G";
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMA1x"]){
        //CDMA2G网络
        str = @"2G";
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORev0"]){
        //CDMA的EVDORev0(应该算3G吧?)
        str = @"3G";
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevA"]){
        //CDMA的EVDORevA(应该也算3G吧?)
        str = @"3G";
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevB"]){
        //CDMA的EVDORev0(应该还是算3G吧?)
        str = @"3G";
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyeHRPD"]){
        //eHRPD网络
        str = @"3G";
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyLTE"]){
        //LTE4G网络
        str = @"4G";
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyNR"]) {
        //新无线(5G)
        str = @"5G";
    }
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyNRNSA"]) {
        //5G NR的非独立组网（NSA）模式
        str = @"5G";
    }
    return str;
}

/// 获取mac地址
+ (NSString *)macaddress
{
    
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    HHJLog(@"outString:%@", outstring);
    
    free(buf);
    
    return [outstring uppercaseString];
}

+ (NSDictionary *)getDeviceInfo
{
    NSMutableDictionary *clinfo = [NSMutableDictionary dictionary];
#if  TARGET_IPHONE_SIMULATOR
#else
    [clinfo setObject:[self carrierName] forKey:@"carrierName"];
    [clinfo setObject:[self macaddress] forKey:@"macaddress"];
#endif
    [clinfo setObject:[self OSVersion] forKey:@"OSVersion"];
    [clinfo setObject:[self deviceName] forKey:@"deviceName"];
    [self getNetworkStatus:^(NSString * _Nonnull status) {
        [clinfo setObject:status forKey:@"networkStatus"];
    }];
    [clinfo setObject:[self getIPAddressIPv4:YES] forKey:@"IPAddress"];
    NSDictionary *info = [[NSDictionary alloc] initWithDictionary:clinfo];
    return info;
}


@end
