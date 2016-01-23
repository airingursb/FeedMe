//
//  FeedMe-Bridging-Header.h
//  FeedMe
//
//  Created by Airing on 16/1/16.
//  Copyright © 2016年 Airing. All rights reserved.
//

#ifndef FeedMe_Bridging_Header_h
#define FeedMe_Bridging_Header_h

#import <SMS_SDK/SMS_SDK.h>


//＝＝＝＝＝＝＝＝＝＝ShareSDK头文件＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//以下是ShareSDK必须添加的依赖库：
//1、libicucore.dylib
//2、libz.dylib
//3、libstdc++.dylib
//4、JavaScriptCore.framework

//＝＝＝＝＝＝＝＝＝＝ShareSDKUI头文件，使用ShareSDK提供的UI需要导入＝＝＝＝＝
#import <ShareSDKUI/ShareSDK+SSUI.h>

//＝＝＝＝＝＝＝＝＝＝以下是各个平台SDK的头文件，根据需要继承的平台添加＝＝＝
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//以下是腾讯SDK的依赖库：
//libsqlite3.dylib

//微信SDK头文件
#import "WXApi.h"
//以下是微信SDK的依赖库：
//libsqlite3.dylib


#endif /* FeedMe_Bridging_Header_h */
