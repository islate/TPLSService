# Installtion

## 1. install with cocoapods
```bash
vi Podfile
```
```text
platform :ios, '8.0'

source 'https://github.com/islate/SlateSpecs.git'
source 'https://github.com/CocoaPods/Specs.git'

target 'your_target_name' do
    pod 'TPLSService'
end
```
```bash
pod install
```

## 2. edit info.plist
### 2.1 LSApplicationQueriesSchemes
```plist
    <key>LSApplicationQueriesSchemes</key>
	<array>
		<string>wechat</string>
		<string>weixin</string>
		<string>sinaweibohd</string>
		<string>sinaweibo</string>
		<string>sinaweibosso</string>
		<string>weibosdk</string>
		<string>weibosdk2.5</string>
		<string>mqqapi</string>
		<string>mqq</string>
		<string>mqqOpensdkSSoLogin</string>
		<string>mqqconnect</string>
		<string>mqqopensdkdataline</string>
		<string>mqqopensdkgrouptribeshare</string>
		<string>mqqopensdkfriend</string>
		<string>mqqopensdkapi</string>
		<string>mqqopensdkapiV2</string>
		<string>mqqopensdkapiV3</string>
		<string>mqzoneopensdk</string>
		<string>wtloginmqq</string>
		<string>wtloginmqq2</string>
		<string>mqqwpa</string>
		<string>mqzone</string>
		<string>mqzonev2</string>
		<string>mqzoneshare</string>
		<string>wtloginqzone</string>
		<string>mqzonewx</string>
		<string>mqzoneopensdkapiV2</string>
		<string>mqzoneopensdkapi19</string>
		<string>mqzoneopensdkapi</string>
		<string>mqzoneopensdk</string>
	</array>
```
### 2.2 CFBundleURLTypes
Replace {WeChatAppId} {WeiboAppId} {QQAppId} with real value.
```plist
	<key>CFBundleURLTypes</key>
	<array>
		<dict>
			<key>CFBundleTypeRole</key>
			<string>Editor</string>
			<key>CFBundleURLName</key>
			<string>wechat</string>
			<key>CFBundleURLSchemes</key>
			<array>
				<string>{WeChatAppId}</string>
			</array>
		</dict>
		<dict>
			<key>CFBundleTypeRole</key>
			<string>Editor</string>
			<key>CFBundleURLName</key>
			<string>weibo</string>
			<key>CFBundleURLSchemes</key>
			<array>
				<string>sinaweibosso.{WeiboAppId}</string>
			</array>
		</dict>
		<dict>
			<key>CFBundleTypeRole</key>
			<string>Editor</string>
			<key>CFBundleURLName</key>
			<string>tencent</string>
			<key>CFBundleURLSchemes</key>
			<array>
				<string>tencent{QQAppId}</string>
			</array>
		</dict>
		<dict>
			<key>CFBundleTypeRole</key>
			<string>Editor</string>
			<key>CFBundleURLName</key>
			<string>tencentApiIdentifier</string>
			<key>CFBundleURLSchemes</key>
			<array>
				<string>tencent{QQAppId}.content</string>
			</array>
		</dict>
	</array>
```
### 2.3 NSAppTransportSecurity
```plist
	<key>NSAppTransportSecurity</key>
	<dict>
		<key>NSAllowsArbitraryLoadsInWebContent</key>
		<true/>
		<key>NSExceptionDomains</key>
		<dict>
			<key>qq.com</key>
			<dict>
				<key>NSTemporaryExceptionAllowsInsecureHTTPLoads</key>
				<true/>
				<key>NSTemporaryExceptionMinimumTLSVersion</key>
				<string>TLSv1.0</string>
				<key>NSIncludesSubdomains</key>
				<true/>
			</dict>
			<key>weibo.com</key>
			<dict>
				<key>NSTemporaryExceptionAllowsInsecureHTTPLoads</key>
				<true/>
				<key>NSTemporaryExceptionMinimumTLSVersion</key>
				<string>TLSv1.0</string>
				<key>NSIncludesSubdomains</key>
				<true/>
			</dict>
			<key>qzone.com</key>
			<dict>
				<key>NSTemporaryExceptionAllowsInsecureHTTPLoads</key>
				<true/>
				<key>NSTemporaryExceptionMinimumTLSVersion</key>
				<string>TLSv1.0</string>
				<key>NSIncludesSubdomains</key>
				<true/>
			</dict>
			<key>weibo.cn</key>
			<dict>
				<key>NSTemporaryExceptionAllowsInsecureHTTPLoads</key>
				<true/>
				<key>NSTemporaryExceptionMinimumTLSVersion</key>
				<string>TLSv1.0</string>
				<key>NSIncludesSubdomains</key>
				<true/>
			</dict>
		</dict>
		<key>NSAllowsArbitraryLoadsInMedia</key>
		<true/>
	</dict>
```

## 3. Setup AppDelegate.m
```objc
#import "TPLSService.h"

...

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
```

# Usage

## 1. login
```objc
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
```

## 2. share
```objc
    [[TPLSService sharedService] weiboShareWithContent:@"test content" image:nil url:nil shareBlock:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"weibo share success!");
        }
        else {
            NSLog(@"weibo share error:%@", error);
        }
    } editable:YES];
```