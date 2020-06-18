//
//  DeviceInfoUtils.m
//  Example-JSB
//
//  Created by sue on 2020/5/11.
//  Copyright © 2020 sharlockk. All rights reserved.
//

#import "DeviceInfoUtils.h"
// 获取设备Model
#import "sys/utsname.h"
// 获取IDFA
#import<AdSupport/AdSupport.h>

// 获取ip
#include <ifaddrs.h>
#include <sys/socket.h> // Per msqr
#import <sys/ioctl.h>
#include <net/if.h>
#import <arpa/inet.h>
#import <UIKit/UIKit.h>
//震动
#import <AudioToolbox/AudioToolbox.h>

@implementation DeviceInfoUtils
/// 获取DeviceId
+ (NSString *)getDeviceId {
    NSString *deviceId;
    // 获取 IDFA
    if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
        deviceId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    }
    // 无IDFA 时 获取IDFV
    if (!deviceId) {
        deviceId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    }
    
    return deviceId?:@"";
}

/// 获取deviceModel
+ (NSString *)getDeviceModel {
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine
                                               encoding:NSUTF8StringEncoding];
    return deviceModel;
}

+ (NSString *)getNetWorkInfo {
    
    return [self getDeviceIPAddresses];
}


// 获取ip
+ (NSString *)getDeviceIPAddresses {
    
    int sockfd = socket(AF_INET, SOCK_DGRAM, 0);
    
    NSMutableArray *ips = [NSMutableArray array];
    
    int BUFFERSIZE = 4096;
    
    struct ifconf ifc;
    
    char buffer[BUFFERSIZE], *ptr, lastname[IFNAMSIZ], *cptr;
    
    struct ifreq *ifr, ifrcopy;
    
    ifc.ifc_len = BUFFERSIZE;
    ifc.ifc_buf = buffer;
    
    if (ioctl(sockfd, SIOCGIFCONF, &ifc) >= 0){
        
        for (ptr = buffer; ptr < buffer + ifc.ifc_len; ){
            
            ifr = (struct ifreq *)ptr;
            int len = sizeof(struct sockaddr);
            
            if (ifr->ifr_addr.sa_len > len) {
                len = ifr->ifr_addr.sa_len;
            }
            
            ptr += sizeof(ifr->ifr_name) + len;
            if (ifr->ifr_addr.sa_family != AF_INET) continue;
            if ((cptr = (char *)strchr(ifr->ifr_name, ':')) != NULL) *cptr = 0;
            if (strncmp(lastname, ifr->ifr_name, IFNAMSIZ) == 0) continue;
            
            memcpy(lastname, ifr->ifr_name, IFNAMSIZ);
            ifrcopy = *ifr;
            ioctl(sockfd, SIOCGIFFLAGS, &ifrcopy);
            
            if ((ifrcopy.ifr_flags & IFF_UP) == 0) continue;
            
            NSString *ip = [NSString  stringWithFormat:@"%s", inet_ntoa(((struct sockaddr_in *)&ifr->ifr_addr)->sin_addr)];
            [ips addObject:ip];
        }
    }
    
    close(sockfd);
    NSString *deviceIP = @"";
    
    for (int i=0; i < ips.count; i++) {
        if (ips.count > 0) {
            deviceIP = [NSString stringWithFormat:@"%@",ips.lastObject];
        }
    }
    return deviceIP;
}
/// 关闭键盘
+ (void)closeInputKeyboard {
    
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder)
                                               to:nil
                                             from:nil
                                         forEvent:nil];

}
/// 震动
+ (void)vibrate {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}
/// 打电话
+ (void)callPhone:(NSString *)phoneString {
    
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@／：；（）¥「」＂、[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+'\""];
    NSString *trimmedString = [phoneString stringByTrimmingCharactersInSet:set];
    NSRange range = [trimmedString rangeOfString:@"－"];
    if(range.location != NSNotFound)
        trimmedString = [trimmedString stringByReplacingCharactersInRange:range withString:@"-"];
    NSURL *telephoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",trimmedString]];
    [[UIApplication sharedApplication] openURL:telephoneURL options:@{UIApplicationOpenURLOptionsSourceApplicationKey:@YES} completionHandler:nil];
    
}

/// 发短信
+ (void)sendMsg:(NSString *)phoneString {
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@／：；（）¥「」＂、[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+'\""];
    NSString *trimmedString = [phoneString stringByTrimmingCharactersInSet:set];
    NSRange range = [trimmedString rangeOfString:@"－"];
    if(range.location != NSNotFound)
        trimmedString = [trimmedString stringByReplacingCharactersInRange:range withString:@"-"];
    NSURL *telephoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"sms://%@",trimmedString]];
    [[UIApplication sharedApplication] openURL:telephoneURL options:@{UIApplicationOpenURLOptionsSourceApplicationKey:@YES} completionHandler:nil];
    
}
@end
