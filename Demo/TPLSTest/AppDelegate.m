//
//  AppDelegate.m
//  TPLSTest
//
//  Created by YIZE LIN on 2017/8/12.
//  Copyright © 2017年 islate. All rights reserved.
//

#import "AppDelegate.h"

#import "TPLSService.h"

#define WeChatAppId @"wx7f6c1b266ced5c81"
#define WeChatSecretKey @"376a1ea004b3304f244f3873497a7539"
#define QQAppId @"101082784"
#define QQAppKey @"e67be28be1e200575b78424c06182f2b"
#define WeiboAppId @"2115890114"
#define WeiboAppKey @"b240443bdc13c127055ea4355f47268b"
#define WeiboRedirectUrl @"http://"
#define AVOSCloudAppId @"qdqNvSJYdeHKAMcxw3X4jPmF-gzGzoHsz"
#define AVOSCloudAppKey @"j4eoQ4V5f5ExzmoGeFQas4hE"
#define SMSSignatureName @"now视频"
#define SMSApplicationName @"now视频"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // set third party appid and appkey
    [[TPLSService sharedService] setAVOSCloudAppId:AVOSCloudAppId clientKey:AVOSCloudAppKey signatureName:SMSSignatureName applicationName:SMSApplicationName];
    [[TPLSService sharedService] setWeiboAppKey:WeiboAppId weiboAppSecret:WeiboAppKey weiboRedirectUrl:WeiboRedirectUrl];
    [[TPLSService sharedService] setWechatAppId:WeChatAppId secret:WeChatSecretKey];
    [[TPLSService sharedService] setQQAppId:QQAppId];
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // handle sso
    [[TPLSService sharedService] applicationDidBecomeActive];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    // handle sso url
    BOOL result = [[TPLSService sharedService] openURL:url];
    if (!result) {
        // TODO: handle other urls
    }
    return result;
}

@end
