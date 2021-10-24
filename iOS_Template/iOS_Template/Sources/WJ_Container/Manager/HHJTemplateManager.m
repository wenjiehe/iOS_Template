//
//  HHJTemplateManager.m
//  iOS_Template
//
//  Created by 贺文杰 on 2021/10/24.
//

#import "HHJTemplateManager.h"

@interface HHJTemplateManager ()

@property(nonatomic,strong)NSDictionary *templeDic;

@end

@implementation HHJTemplateManager

+ (instancetype)shareInstance
{
    static HHJTemplateManager * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HHJTemplateManager alloc] init];
    });
    
    return instance;
}

- (NSDictionary *)templeDic{
    if (!_templeDic) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"HHJPublicTemplate" ofType:@"plist"];
        _templeDic = [NSDictionary dictionaryWithContentsOfFile:path];
    }
    return _templeDic;
}

/// 获取styleType对应的类名
/// @param styleType 风格ID
- (NSString *)getTemplateWithStyleType:(NSString *)styleType{
    NSString *class = nil;
    NSDictionary *dic = self.templeDic[styleType];
    if (dic) {
        class = dic[@"classView"];
    }
    return class;
}

@end
