//
//  TPLSService.m
//  TPLSSDK
//
//  Third Party Login & Share Service SDK
//
//  Created by YIZE LIN on 2017/8/12.
//  Copyright © 2017年 islate. All rights reserved.
//

#import "TPLSService.h"

#import "WeiboWrapper.h"
#import "WeChatWrapper.h"
#import "TencentWrapper.h"
#import <AVOSCloud/AVOSCloud.h>

@interface TPLSService ()
@property (nonatomic, strong) NSString *signatureName;
@property (nonatomic, strong) NSString *applicationName;
@end

@implementation TPLSService

+ (instancetype)sharedService
{
    static id sharedInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [self new];
    });
    return sharedInstance;
}

#pragma mark - set appid appkey

- (void)setWeiboAppKey:(NSString *)appKey weiboAppSecret:(NSString *)secret weiboRedirectUrl:(NSString *)redirectUrl
{
    [[WeiboWrapper sharedWrapper] setWeiboAppKey:appKey weiboAppSecret:secret weiboRedirectUrl:redirectUrl];
}
- (void)setWechatAppId:(NSString *)appId secret:(NSString *)secret
{
    [[WeChatWrapper sharedWrapper] setWeixinAppId:appId secret:secret];

}
- (void)setQQAppId:(NSString *)appId
{
    [[TencentWrapper sharedWrapper] setAppId:appId];
}
- (void)setAVOSCloudAppId:(NSString *)applicationId clientKey:(NSString *)clientKey signatureName:(NSString * _Nonnull)signatureName applicationName:(NSString * _Nonnull)applicationName
{
    [AVOSCloud setApplicationId:applicationId clientKey:clientKey];
    self.signatureName = signatureName;
    self.applicationName = applicationName;
}

#pragma mark - handle sso

- (BOOL)openURL:(NSURL *)url
{
    if ([[WeChatWrapper sharedWrapper] canHandleURL:url]) {
        return [[WeChatWrapper sharedWrapper] handleOpenURL:url];
    }
    else if ([[WeiboWrapper sharedWrapper] isWeiboSSOURL:url]) {
        return [[WeiboWrapper sharedWrapper] weiboSSOHandleOpenURL:url];
    }
    else if ([[TencentWrapper sharedWrapper] canHandleOpenURL:url]) {
        return [[TencentWrapper sharedWrapper] handleOpenURL:url];
    }
    return NO;
}

- (void)applicationDidBecomeActive
{
    [[WeiboWrapper sharedWrapper] applicationDidBecomeActive];
}

#pragma mark - weibo

- (void)weiboLogin:(void(^_Nonnull)(BOOL success, NSError * _Nullable error, NSString * _Nullable uid, NSString * _Nullable accessToken, NSString * _Nullable nickname, NSString * _Nullable avatarUrl, NSString * _Nullable rawInfo))loginBlock
{
    [[WeiboWrapper sharedWrapper] weiboLogout];
    [[WeiboWrapper sharedWrapper] weiboProfile:^(BOOL success, NSString *weiboUid, NSString * accessToken, NSString *weiboNickname, NSString *weiboAvatarUrl, NSString *userAddingInfo) {
        if (loginBlock) {
            NSError *error = nil;
            if (!success) {
                error = [WeiboWrapper sharedWrapper].lastError;
            }
            loginBlock(success, error, weiboUid, accessToken, weiboNickname, weiboAvatarUrl, userAddingInfo);
        }
    }];
}
- (void)weiboShareWithContent:(NSString *_Nonnull)content
                        image:(UIImage * _Nullable )image
                          url:(NSURL * _Nullable )url
                   shareBlock:(void(^_Nonnull)(BOOL success, NSError * _Nullable error))shareBlock
                     editable:(BOOL)editable
{
    [[WeiboWrapper sharedWrapper] weiboShareWithContent:content image:image url:url shareBlock:^(BOOL success) {
        if (success) {
            shareBlock(YES, nil);
        }
        else {
            shareBlock(NO, [WeiboWrapper sharedWrapper].lastError);
        }
    } editable:editable];
}

#pragma mark - wechat

- (void)wechatLogin:(void (^_Nonnull)(BOOL success, NSError * _Nullable error, NSString * _Nullable openId, NSString * _Nullable accessToken, NSString * _Nullable unionId, NSString * _Nullable nickname, NSString * _Nullable avatarUrl, NSString * _Nullable rawInfo))loginBlock
{
    [[WeChatWrapper sharedWrapper] login:^(BOOL success, NSError *error, NSString *openId, NSString * accessToken, NSString *unionId, NSString *nickname, NSString *avatarUrl, NSString *rawInfo) {
        if (loginBlock) {
            loginBlock(success, error, openId, accessToken, unionId, nickname, avatarUrl, rawInfo);
        }
    }];
}
- (BOOL)isWechatInstalled
{
    return [[WeChatWrapper sharedWrapper] isWeixinInstalled];
}
- (void)wechatShareWithContent:(NSString *_Nonnull)content
                         image:(UIImage * _Nullable )image
                           url:(NSURL * _Nullable )url
                         title:(NSString *_Nonnull)title
                  imageIsThumb:(BOOL)imageIsThumb
               toFriendsCircle:(BOOL)toFriendsCircle
                    shareBlock:(void(^_Nonnull)(BOOL success, BOOL isWeixinInstalled))shareBlock
{
    [[WeChatWrapper sharedWrapper] weixinShareWithContent:content url:url.absoluteString image:image title:title imageIsThumb:imageIsThumb toFriendsCircle:toFriendsCircle shareBlock:shareBlock];
}

#pragma mark - QQ

- (void)qqLogin:(void (^_Nonnull)(BOOL success, NSError * _Nullable error, NSString * _Nonnull openId, NSString * _Nonnull accessToken, NSString * _Nonnull nickname, NSString * _Nonnull avatarUrl, NSDate * _Nonnull expireDate, NSString * _Nullable rawInfo))loginBlock
{
    [[TencentWrapper sharedWrapper] qqLogout];
    [[TencentWrapper sharedWrapper] login:loginBlock];
}
- (BOOL)isQQInstalled
{
    return [[TencentWrapper sharedWrapper] isQQInstalled];
}
- (void)qqShareWithContent:(NSString *_Nonnull)content
                     image:(UIImage * _Nullable )image
                       url:(NSURL * _Nullable )url
                     title:(NSString *_Nonnull)title
                shareBlock:(void(^_Nonnull)(BOOL success, BOOL isQQInstalled))shareBlock
{
    [[TencentWrapper sharedWrapper] qqShareWithContent:content url:url.absoluteString image:image title:title shareBlock:shareBlock];
}

#pragma mark - sms code

// request sms code
- (void)requestSMSCode:(NSString *_Nonnull)mobileNumber operationName:(NSString * _Nonnull )operationName callback:(void (^_Nonnull)(BOOL success, NSError * _Nullable error))callbackBlock
{
    // message template:
    // "【signatureName】您正在使用applicationName服务进行operationName，您的验证码是：123456，请在10分钟内完成验证。"
    AVShortMessageRequestOptions *options = [[AVShortMessageRequestOptions alloc] init];
    options.TTL = 10;// 10 minutes
    options.applicationName = self.applicationName;
    options.operation = operationName;
    options.signatureName = self.signatureName;
    [AVSMS requestShortMessageForPhoneNumber:mobileNumber
                                     options:options
                                    callback:callbackBlock];
}

// verify sms code
- (void)verifySMSCode:(NSString *_Nonnull)code mobileNumber:(NSString *_Nonnull)mobileNumber callback:(void (^_Nonnull)(BOOL success, NSError * _Nullable error))callbackBlock
{
    [AVOSCloud verifySmsCode:code mobilePhoneNumber:mobileNumber callback:callbackBlock];
}

@end
