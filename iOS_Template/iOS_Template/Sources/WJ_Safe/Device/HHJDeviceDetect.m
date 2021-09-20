//
//  HHJDeviceDetect.m
//  iOS_Template
//
//  Created by 贺文杰 on 2021/9/20.
//

#import "HHJDeviceDetect.h"
#import <mach-o/dyld.h>
// 阻止 gdb/lldb 调试
// 调用 ptrace 设置参数 PT_DENY_ATTACH，如果有调试器依附，则会产生错误并退出
#import <dlfcn.h>
#import <sys/types.h>

typedef int (*ptrace_ptr_t)(int _request, pid_t _pid, caddr_t _addr, int _data);
#if !defined(PT_DENY_ATTACH)
#define PT_DENY_ATTACH 31
#endif

@implementation HHJDeviceDetect

/// 检测设备越狱状态
+ (BOOL)checkDeviceJailBreakState{
#if TARGET_IPHONE_SIMULATOR  //模拟器
    return NO;
#elif TARGET_OS_IPHONE
    // 常见越狱文件
    NSArray *jailbreakFilePaths = @[
                                    @"/Applications/Cydia.app",
                                    @"/Library/MobileSubstrate/MobileSubstrate.dylib",
                                    @"/bin/bash",
                                    @"/usr/sbin/sshd",
                                    @"/etc/apt",
                                    @"/private/var/lib/apt/",
                                    @"/private/var/lib/cydia",
                                    @"/private/var/stash"
                                    ];
    for (NSString *jailbreakFilePath in jailbreakFilePaths)
    {
        if ([[NSFileManager defaultManager] fileExistsAtPath:jailbreakFilePath])
        {
            return YES;
        }
    }
    
    // 读取系统所有的应用名称
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"User/Applications/"])
    {
        return YES;
    }
    
    // 读取环境变量
    char *env = getenv("DYLD_INSERT_LIBRARIES");
    if(env)
    {
        return YES;
    }
    
    return NO;
#endif
}

/// 判断当前设备是否是模拟器
+ (BOOL)isSimulator{
    BOOL isSimulator = NO;
    #if TARGET_IPHONE_SIMULATOR  //模拟器
        isSimulator = YES;
    #endif
    return isSimulator;
}

/// 判断是否被动态库注入
+ (BOOL)isDynamicLBInjected{
    int count = _dyld_image_count();//获取加载image的数量
    if (count > 0) {
        for (int i = 0; i < count; i++) {//遍历所有的image_name。判断是否有DynamicLibraries
            const char * dyld = _dyld_get_image_name(i);
            if (strstr(dyld, "DynamicLibraries")) {
                return YES;
            }
        }
    }
    
    //检测环境变量是否有DYLD_INSERT_LIBRARIES
    char* env = getenv("DYLD_INSERT_LIBRARIES");
    if(env){
        return YES;
    }
    return NO;
}

/// 防止动态调试，如果动态调试则退出调试
void disable_gdb_debug(){
#ifndef DEBUG
    // 非 DEBUG 模式下禁止调试
    void *handle = dlopen(0, RTLD_GLOBAL | RTLD_NOW);
    ptrace_ptr_t ptrace_ptr = dlsym(handle, "ptrace");
    ptrace_ptr(PT_DENY_ATTACH, 0, 0, 0);
    dlclose(handle);
#endif
}


@end
