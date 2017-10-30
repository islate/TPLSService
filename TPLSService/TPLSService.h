//
//  TPLSService.h
//  TPLSSDK
//
//  Third Party Login & Share Service SDK
//
//  Created by YIZE LIN on 2017/8/12.
//  Copyright © 2017年 islate. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPLSService : NSObject

+ (instancetype _Nonnull )sharedService;

// third party appid appkey
- (void)setWeiboAppKey:(NSString *_Nonnull)key weiboAppSecret:(NSString *_Nonnull)secret weiboRedirectUrl:(NSString *_Nonnull)redirectUrl;
- (void)setWechatAppId:(NSString *_Nonnull)appId secret:(NSString *_Nonnull)secret;
- (void)setQQAppId:(NSString *_Nonnull)appId;
- (void)setAVOSCloudAppId:(NSString *_Nonnull)applicationId clientKey:(NSString *_Nonnull)clientKey signatureName:(NSString *_Nonnull)signatureName applicationName:(NSString *_Nonnull)applicationName; // for sms code

// handle sso
- (BOOL)openURL:(NSURL *_Nonnull)url;
- (void)applicationDidBecomeActive;

// weibo
- (void)weiboLogin:(void(^_Nonnull)(BOOL success, NSError * _Nullable error, NSString * _Nullable uid, NSString * _Nullable accessToken, NSString * _Nullable nickname, NSString * _Nullable avatarUrl, NSString * _Nullable rawInfo))loginBlock;
- (void)weiboShareWithContent:(NSString *_Nonnull)content
                        image:(UIImage * _Nullable )image
                          url:(NSURL * _Nullable )url
                   shareBlock:(void(^_Nonnull)(BOOL success, NSError * _Nullable error))shareBlock
                     editable:(BOOL)editable;

// wechat
- (void)wechatLogin:(void (^_Nonnull)(BOOL success, NSError * _Nullable error, NSString * _Nullable openId, NSString * _Nullable accessToken, NSString * _Nullable unionId, NSString * _Nullable nickname, NSString * _Nullable avatarUrl, NSString * _Nullable rawInfo))loginBlock;
- (BOOL)isWechatInstalled;
- (void)wechatShareWithContent:(NSString *_Nonnull)content
                         image:(UIImage * _Nullable )image
                           url:(NSURL * _Nullable )url
                         title:(NSString *_Nonnull)title
                  imageIsThumb:(BOOL)imageIsThumb
               toFriendsCircle:(BOOL)toFriendsCircle
                    shareBlock:(void(^_Nonnull)(BOOL success, BOOL isWeixinInstalled))shareBlock;

// qq
- (void)qqLogin:(void (^_Nonnull)(BOOL success, NSError * _Nullable error, NSString * _Nullable openId, NSString * _Nullable accessToken, NSString * _Nullable nickname, NSString * _Nullable avatarUrl, NSDate * _Nullable expireDate, NSString * _Nullable rawInfo))loginBlock;
- (BOOL)isQQInstalled;
- (void)qqShareWithContent:(NSString *_Nonnull)content
                     image:(UIImage * _Nullable )image
                       url:(NSURL * _Nullable )url
                     title:(NSString *_Nonnull)title
                shareBlock:(void(^_Nonnull)(BOOL success, BOOL isQQInstalled))shareBlock;

// sms code
- (void)requestSMSCode:(NSString *_Nonnull)mobileNumber operationName:(NSString * _Nonnull )operationName callback:(void (^_Nonnull)(BOOL success, NSError * _Nullable error))callbackBlock;
- (void)verifySMSCode:(NSString *_Nonnull)code mobileNumber:(NSString *_Nonnull)mobileNumber callback:(void (^_Nonnull)(BOOL success, NSError * _Nullable error))callbackBlock;


@end
