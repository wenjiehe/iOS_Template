//
//  FixedCoordinatesUtil.h
//  FixedCoordinatesDemo
//
//  Created by wangyong on 15/6/10.
//  Copyright (c) 2015年 P&C Information. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

/**
 *  国内地图使用的坐标系统是GCJ-02,而iOS SDK中所用到的是国际标准的坐标系统WGS-84
 *  该Util用于修正坐标系统
 */
@interface FixedCoordinatesUtil : NSObject

//判断是否已经超出中国范围
+(BOOL)isLocationInChina:(CLLocationCoordinate2D)location;

//转GCJ-02
+(CLLocationCoordinate2D)transformFromWGSToGCJ:(CLLocationCoordinate2D)wgsLoc;

@end
