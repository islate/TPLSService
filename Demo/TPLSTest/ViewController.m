//
//  ViewController.m
//  TPLSTest
//
//  Created by YIZE LIN on 2017/8/12.
//  Copyright © 2017年 islate. All rights reserved.
//

#import "ViewController.h"

#import "TPLSService.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *code;

@end

@implementation ViewController

- (IBAction)weiboLogin:(id)sender {
    [[TPLSService sharedService] weiboLogin:^(BOOL success, NSError * _Nullable error, NSString * _Nullable uid, NSString * _Nullable nickname, NSString * _Nullable avatarUrl, NSString * _Nullable rawInfo) {
        if (success) {
            NSLog(@"weibo login success!");
            
            /*
             * TODO: app user login
             * 1. use weibo uid to bind with app's user.
             * 2. use weibo nickname/avatar to generate app's user profile.
             * 3. rawInfo is the original json from Weibo API.
             */
        }
        else {
            NSLog(@"weibo login error:%@", error);
        }
    }];
}
- (IBAction)weiboShare:(id)sender {
    [[TPLSService sharedService] weiboShareWithContent:@"test content" image:nil url:nil shareBlock:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"weibo share success!");
        }
        else {
            NSLog(@"weibo share error:%@", error);
        }
    } editable:YES];
}

- (IBAction)wechatLogin:(id)sender {
    [[TPLSService sharedService] wechatLogin:^(BOOL success, NSError * _Nullable error, NSString * _Nullable openId, NSString * _Nullable unionId, NSString * _Nullable nickname, NSString * _Nullable avatarUrl, NSString * _Nullable rawInfo) {
        if (success) {
            NSLog(@"wechat login success!");

            /*
             * TODO: app user login
             * 1. use wechat openId/unionId to bind with app's user.
             * 2. use wechat nickname/avatar to generate app's user profile.
             * 3. rawInfo is the original json from Wechat API.
             */
        }
        else {
            NSLog(@"wechat login error:%@", error);
        }
    }];
}
- (IBAction)wechatShare:(id)sender {
    [[TPLSService sharedService] wechatShareWithContent:@"test content" image:nil url:[NSURL URLWithString:@"https://fb.com"] title:@"test title" imageIsThumb:NO toFriendsCircle:NO shareBlock:^(BOOL success, BOOL isWeixinInstalled) {
        if (success) {
            NSLog(@"wechat share success!");
        }
        else {
            NSLog(@"wechat share error!");
        }
    }];
}

- (IBAction)qqLogin:(id)sender {
    [[TPLSService sharedService] qqLogin:^(BOOL success, NSError * _Nullable error, NSString * _Nullable openId, NSString * _Nullable accessToken, NSString * _Nullable nickname, NSString * _Nullable avatarUrl, NSDate * _Nullable expireDate, NSString * _Nullable rawInfo) {
        if (success) {
            NSLog(@"qq login success!");

            /*
             * TODO: app user login
             * 1. use qq openId to bind with app's user.
             * 2. use qq nickname/avatar to generate app's user profile.
             * 3. rawInfo is the original json from QQ API.
             */
        }
        else {
            NSLog(@"qq login error:%@", error);
        }
    }];
}
- (IBAction)qqShare:(id)sender {
    [[TPLSService sharedService] qqShareWithContent:@"test content" image:nil url:[NSURL URLWithString:@"https://fb.com"] title:@"test title" shareBlock:^(BOOL success, BOOL isQQInstalled) {
        if (success) {
            NSLog(@"qq share success!");
        }
        else {
            NSLog(@"qq share error!");
        }
    }];
}

- (IBAction)requestSMSCode:(id)sender {
    // todo: should valid the phone number

    // message template:
    // "【signatureName】您正在使用applicationName服务进行operationName，您的验证码是：123456，请在10分钟内完成验证。"
    [[TPLSService sharedService] requestSMSCode:self.phone.text operationName:@"手机登录" callback:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            NSLog(@"Request Code Success!");
        }
        else {
            NSLog(@"Request Code error:%@", error);
        }
    }];
}
- (IBAction)verifySMSCode:(id)sender {
    // todo: should valid the phone number (eleven digits starts with 1)
    // todo: should valid the code (six digits)
    
    [[TPLSService sharedService] verifySMSCode:self.code.text mobileNumber:self.phone.text callback:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            NSLog(@"Verify Code Success!");

            /*
             * TODO: app user login
             * 1. use mobile number to bind with app's user.
             */
        }
        else {
            NSLog(@"Verify Code error:%@", error);
        }
    }];
}


@end
