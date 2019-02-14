//
//  HTTPModel.h
//  FindingMe
//
//  Created by pfjhetg on 2016/12/13.
//  Copyright © 2016年 3VOnline Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "AFAppDotNetAPIClient.h"
//重连次数
#define maxCont 10
//请求错误
#define NET_ERROR_MSG @"网络不给力"

//Singleton
// .h
#define singleton_interface(className) + (instancetype)shared##className;


@interface HTTPModel : NSObject

singleton_interface(HTTPModel)

//POST
+ (void)POST:(NSString *)URLString
  parameters:(id)parameters
    progress:(void (^)(NSProgress *))progress
     success:( void (^)(NSURLSessionDataTask *task, id  responseObject))success
     failure:( void (^)(NSURLSessionDataTask *  task, NSError *error))failure;

//GET
+ (void)GET:(NSString *)URLString
 parameters:(id)parameters
   progress:(void (^)(NSProgress *))progress
    success:( void (^)(NSURLSessionDataTask *task, id  responseObject))success
    failure:( void (^)(NSURLSessionDataTask *  task, NSError *error))failure;

//GET单次（链接失败不重新链接)
+ (void)SINGERGET:(NSString *)URLString
      parameters:(id)parameters
        progress:(void (^)(NSProgress *))progress
         success:(void (^)(NSURLSessionDataTask *, id))success
         failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;

//取消所有请求
+ (void)clearAllRequt;


+(void)telLogin:(nullable NSString *)apiId
         mobile:(nullable NSString *)mobile
       password:(nullable NSString *)password
     appVersion:(nullable NSString *)appVersion
     sysVersion:(nullable NSString *)sysVersion
     deviceType:(nullable NSString *)deviceType
       deviceId:(nullable NSString *)deviceId
        sysType:(nullable NSString *)sysType
       callback:(nullable void (^)(NSInteger status, id _Nullable responseObject, NSString* _Nullable msg))callback;
+(void)getHomeRooms:(nullable NSString *)apiId
           pageSize:(nullable NSString *)pageSize
          pageIndex:(nullable NSString *)pageIndex
           callback:(nullable void (^)(NSInteger status, id _Nullable responseObject, NSString* _Nullable msg))callback;
+(void)getUserMessage:(nullable NSString *)apiId
            someoneId:(nullable NSString *)someoneId
             callback:(nullable void (^)(NSInteger status, id _Nullable responseObject, NSString* _Nullable msg))callback;


@end
