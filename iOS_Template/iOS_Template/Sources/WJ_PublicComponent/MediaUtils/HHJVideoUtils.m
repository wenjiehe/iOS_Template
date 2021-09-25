//
//  HHJVideoUtils.m
//  iOS_Template
//
//  Created by 贺文杰 on 2021/9/25.
//

#import "HHJVideoUtils.h"
#import <AVFoundation/AVFoundation.h>
#import "HHJGlobalConstant.h"
#import <UIKit/UIKit.h>

@implementation HHJVideoUtils

/// 获取网络视频信息，建议：放在异步线程中获取，避免阻塞主线程
/// @param url 网络视频url
+ (NSDictionary *)getNetworkVideoInfo:(NSString *)url{
    url = kCheckNil(url);
    NSMutableDictionary *mtbDic = [NSMutableDictionary new];
    if (url.length > 0) {
        NSDictionary *opt = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:url] options:opt];
        NSArray *ary = [asset tracksWithMediaType:AVMediaTypeVideo];
        
        //获取视频总时长
        double second = (float)asset.duration.value / (float)asset.duration.timescale;
        [mtbDic setObject:[NSNumber numberWithDouble:second] forKey:@"second"];
        
        //获取视频大小
        NSString *videoSize = @"";
        for (AVAssetTrack *track in ary) {
            if ([track.mediaType isEqualToString:AVMediaTypeVideo]) {
                if (track.totalSampleDataLength >= 1024 * 1024) { //是否大于1M
                    videoSize = [NSString stringWithFormat:@"%.2lldM", track.totalSampleDataLength / (1024 * 1024)];
                }else{
                    videoSize = [NSString stringWithFormat:@"%.2lldKB", track.totalSampleDataLength / 1024];
                }
            }
        }
        [mtbDic setObject:videoSize forKey:@"videoSize"];
        
        //每秒传输帧数
        double fps = ary.count > 0 ? ((AVAssetTrack *)ary[0]).nominalFrameRate : 0;
        [mtbDic setObject:[NSNumber numberWithDouble:fps] forKey:@"fps"];
        
        //获取每一帧对应的图片
        AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
        imageGenerator.appliesPreferredTrackTransform = YES;
        NSMutableArray *mtbAry = [NSMutableArray new];
        for (NSInteger i = 0; i <= second * fps; i++) {
            //CMTimeMakeWithSeconds(a,b) a-当前时间 b 每秒钟多少帧
            [mtbAry addObject:[NSValue valueWithCMTime:CMTimeMakeWithSeconds(i / fps, fps)]];
        }
        imageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
        imageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
        [imageGenerator generateCGImagesAsynchronouslyForTimes:mtbAry completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
            if (!error) {
                //获取图片
                UIImage *img = [UIImage imageWithCGImage:image];
                NSLog(@"img = %@, result = %ld", img, result);
            }else{
                NSLog(@"error = %@", error);
            }
        }];
        
    }else{
        HHJLog(@"传入的网络视频url为空");
    }
    return mtbDic;
}

@end
