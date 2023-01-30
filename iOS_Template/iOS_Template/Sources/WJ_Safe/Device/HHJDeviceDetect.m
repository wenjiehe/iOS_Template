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
#import <sys/stat.h>
#import <stdlib.h>
#import <UIKit/UIKit.h>

typedef int (*ptrace_ptr_t)(int _request, pid_t _pid, caddr_t _addr, int _data);
#if !defined(PT_DENY_ATTACH)
#define PT_DENY_ATTACH 31
#endif

@implementation HHJDeviceDetect

__attribute__ ((constructor)) static void ok(){
    if (!(TARGET_IPHONE_SIMULATOR == 1 && TARGET_OS_IPHONE == 1)){
        if(fopen("/var/lib", "rb") != NULL){
            exit(0);
        }
    }
}

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
                                    @"/private/var/stash",
                                    @"/APPlications/Cydia.app",
                                    @"/APPlications/limera1n.app",
                                    @"/APPlications/greenpois0n.app",
                                    @"/APPlications/blackra1n.app",
                                    @"/APPlications/blacksn0w.app",
                                    @"/APPlications/redsn0w.app",
                                    @"/APPlications/Absinthe.app",
                                    @"/etc/ssh/sshd_config",
                                    @"/usr/libexec/ssh-keysign",
                                    @"/bin/sh"
                                    ];
    for (NSString *jailbreakFilePath in jailbreakFilePaths)
    {
        if ([[NSFileManager defaultManager] fileExistsAtPath:jailbreakFilePath])
        {
            return YES;
        }
    }
    
    //判断是否可以打开越狱后url
    NSURL *url = [NSURL URLWithString:@"cydia://"];
    if ([UIApplication.sharedApplication canOpenURL:url] == true){
        return YES;
    }
    
    //可能存在hook了NSFileManager方法，此处用底层C stat去检测
    // /Library/MobileSubstrate/MobileSubstrate.dylib 最重要的越狱文件，几乎所有的越狱机都会安装MobileSubstrate
    // /Applications/Cydia.app /var/lib/cydia/ 绝大多数越狱机都会安装
    struct stat stat_info;
    if (0 == stat("/Library/MobileSubstrate/MobileSubstrate.dylib", &stat_info)){
        return YES;
    }
    if (0 == stat("/Applications/Cydia.app", &stat_info)){
        return YES;
    }
    if (0 == stat("/var/lib/cydia/", &stat_info)){
        return YES;
    }
    if (0 == stat("/var/cache/apt", &stat_info)){
        return YES;
    }
    if (0 == stat("/var/lib/apt", &stat_info)){
        return YES;
    }
    if (0 == stat("/etc/apt", &stat_info)){
        return YES;
    }
    if (0 == stat("/bin/bash", &stat_info)){
        return YES;
    }
    if (0 == stat("/bin/sh", &stat_info)){
        return YES;
    }
    if (0 == stat("/usr/sbin/sshd/", &stat_info)){
        return YES;
    }
    if (0 == stat("/usr/libexec/ssh-keysign", &stat_info)){
        return YES;
    }
    if (0 == stat("/etc/ssh/sshd_config", &stat_info)){
        return YES;
    }

    //可能存在stat也被hook了，可以看stat是不是出自系统库，有没有被攻击者换掉
    //这种情况出现的可能性很小
    int ret;
    Dl_info dylib_info;
    int (*func_stat)(const char *, struct stat *) = stat;
    if ((ret = dladdr(&func_stat, &dylib_info))){
        if (strcmp(dylib_info.dli_fname, "/usr/lib/system/libsystem_kernel.dylib")){ //不相等，肯定被攻击了，相等为0
            return YES;
        }
    }
    
    //列出所有已链接的动态库
    //通常情况下，会包含越狱机的输出结果会包含字符串: Library/MobileSubstrate/MobileSubstrate.dylib
    uint32_t count = _dyld_image_count();
    for (uint32_t i = 0; i < count; ++i) {
        NSString *name = [[NSString alloc] initWithUTF8String:_dyld_get_image_name(i)];
        if ([name containsString:@"Library/MobileSubstrate/MobileSubstrate.dylib"]){
            return YES;
        }
    }
    
    // 根据能否获取到所有应用来判断是否越狱，已越狱的设备可以读取 未越狱的设备不可以
    // 读取系统所有的应用名称
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"User/Applications/"])
    {
        return YES;
    }
    
    // 读取环境变量
    //如果攻击者给MobileSubstrate改名。但是原理都是通过DYLD_INSERT_LIBRARIES注入动态库
    //那么可以检测当前程序运行的环境变量
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
