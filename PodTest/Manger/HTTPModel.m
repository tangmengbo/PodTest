//
//  HTTPModel.m
//  FindingMe
//
//  Created by pfjhetg on 2016/12/13.
//  Copyright © 2016年 3VOnline Inc. All rights reserved.
//

#import "HTTPModel.h"
#import "AppDelegate.h"
#define HTTP_REQUESTURL    @"http://api.xy.51findme.com:19303/"


#define WEAKSELF __weak typeof(self) weakSelf = self;


// 最后一句不要斜线
#define singleton_implementation(className) \
static className *_instace; \
\
+ (id)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instace = [super allocWithZone:zone]; \
}); \
\
return _instace; \
} \
\
+ (instancetype)shared##className \
{ \
if (_instace == nil) { \
_instace = [[className alloc] init]; \
} \
\
return _instace; \
}



@implementation HTTPModel
singleton_implementation(HTTPModel)

# pragma - mark 封装请求

+(NSDictionary *)getParams
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary * userInfo = [defaults objectForKey:@"USERINFO"];
    
    return userInfo;
}

+(NSString *)getRandom
{
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyyMMddHHmmss"];
    NSString * dateStr =  [dateFormater stringFromDate:[NSDate date]] ;//获取年月日字符串
    
    int num = (arc4random() % 100);
    NSString * numStr = [NSString stringWithFormat:@"%.2d", num]; //获取六位的随机数
    return [dateStr stringByAppendingString:numStr];
}

+ (void)POST:(NSString *)URLString
  parameters:(id)parameters
    progress:(void (^)(NSProgress *))progress
     success:(void (^)(NSURLSessionDataTask *, id))success
     failure:(void (^)(NSURLSessionDataTask *, NSError *))failure{
    WEAKSELF
    
    AFAppDotNetAPIClient * apiClient =   [AFAppDotNetAPIClient sharedClient];
    
    apiClient.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [apiClient.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
     [apiClient.requestSerializer setValue:[self getRandom] forHTTPHeaderField:@"random"];
    
    NSDictionary * userInfo = [self getParams];
    if ([userInfo isKindOfClass:[NSDictionary class]]) {
        [apiClient.requestSerializer setValue:[userInfo objectForKey:@"token"] forHTTPHeaderField:@"token"];
    }
 
    [apiClient POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            
            if ([@"0" isEqualToString:[responseObject objectForKey:@"respCode"]]) {
                
                success(task, responseObject);
            }
            else
            {
                NSError *error = [NSError errorWithDomain:[responseObject objectForKey:@"respMsg"]
                                                     code:[[responseObject objectForKey:@"respCode"]integerValue]
                                                 userInfo:nil];
                failure(task, error);
            }
           
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *re =(NSHTTPURLResponse *)  task.response;
        if (maxCont == 1) {
            if (failure) {
                failure(task, error);
               // [Common showToastView:NET_ERROR_MSG];
            }
        } else if (error.code == -1001 || re.statusCode == 504) {
            dispatch_after(100*NSEC_PER_MSEC, dispatch_get_main_queue(), ^{
                [weakSelf REPLYPOST:URLString  errerCount:1 parameters:parameters progress:progress success:success failure:failure];
            });
        } else {
            if (failure) {
                failure(task, error);
                // [Common showToastView:NET_ERROR_MSG];
               // [Common showToastView:NET_ERROR_MSG view:self.view];
            }
        }
    }];
}


+ (void)REPLYPOST:(NSString *)URLString
       errerCount:(int)errerCount
       parameters:(id)parameters
         progress:(void (^)(NSProgress *))progress
          success:(void (^)(NSURLSessionDataTask *, id))success
          failure:(void (^)(NSURLSessionDataTask *, NSError *))failure{
    WEAKSELF
    [[AFAppDotNetAPIClient sharedClient] POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *re =(NSHTTPURLResponse *)  task.response;
        if (error.code == -1001 || re.statusCode == 504) {
            int er = errerCount +1;
            if (er>=maxCont) {
                if (failure) {
                    failure(task, error);
                    // [Common showToastView:NET_ERROR_MSG];
                }
            } else {
                dispatch_after(100*NSEC_PER_MSEC, dispatch_get_main_queue(), ^{
                    [weakSelf REPLYPOST:URLString errerCount:er parameters:parameters progress:progress success:success failure:failure];
                });
            }
        } else {
            if (failure) {
                failure(task, error);
                 //[Common showToastView:NET_ERROR_MSG];
            }
        }
    }];
}


+ (void)GET:(NSString *)URLString
 parameters:(id)parameters
   progress:(void (^)(NSProgress *))progress
    success:(void (^)(NSURLSessionDataTask *, id))success
    failure:(void (^)(NSURLSessionDataTask *, NSError *))failure{
    WEAKSELF
    [[AFAppDotNetAPIClient sharedClient] GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *re =(NSHTTPURLResponse *)  task.response;
        if (maxCont == 1) {
            if (failure) {
                failure(task, error);
            }
        } else if (error.code == -1001 || re.statusCode == 504) {
            dispatch_after(100*NSEC_PER_MSEC, dispatch_get_main_queue(), ^{
                [weakSelf REPLYGET:URLString  errerCount:1 parameters:parameters progress:progress success:success failure:failure];
            });
        } else {
            if (failure) {
                failure(task, error);
            }
        }
    }];
}


+ (void)REPLYGET:(NSString *)URLString  errerCount:(int)errerCount parameters:(id)parameters progress:(void (^)(NSProgress *))progress success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure{
    __weak typeof(self) _weekSelf = self;
    [[AFAppDotNetAPIClient sharedClient] GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse *re =(NSHTTPURLResponse *)  task.response;
        if (error.code == -1001 || re.statusCode == 504) {
            int er = errerCount + 1;
            if (er >= maxCont) {
                if (failure) {
                    failure(task, error);
                    // [Common showToastView:NET_ERROR_MSG];
                }
            } else {
                dispatch_after(100*NSEC_PER_MSEC, dispatch_get_main_queue(), ^{
                    [_weekSelf REPLYGET:URLString  errerCount:er parameters:parameters progress:progress success:success failure:failure];
                });
            }
        } else {
            if (failure) {
                failure(task, error);
                // [Common showToastView:NET_ERROR_MSG];
            }
        }
    }];
}


+ (void)SINGERGET:(NSString *)URLString parameters:(id)parameters progress:(void (^)(NSProgress *))progress success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure{
    [[AFAppDotNetAPIClient sharedClient] GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(task, error);
            // [Common showToastView:NET_ERROR_MSG];
        }
    }];
}


+ (void)clearAllRequt{
    [AFAppDotNetAPIClient clearAllRequest];
}


# pragma - mark http请求接口

+(void)telLogin:(nullable NSString *)apiId
         mobile:(nullable NSString *)mobile
       password:(nullable NSString *)password
     appVersion:(nullable NSString *)appVersion
     sysVersion:(nullable NSString *)sysVersion
     deviceType:(nullable NSString *)deviceType
       deviceId:(nullable NSString *)deviceId
        sysType:(nullable NSString *)sysType
       callback:(nullable void (^)(NSInteger status, id _Nullable responseObject, NSString* _Nullable msg))callback
{
    NSString *url = [NSString stringWithFormat:@"%@%@/calling/%@", HTTP_REQUESTURL,@"user",apiId];
    
    NSMutableDictionary * parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:mobile forKey:@"mobile"];
    [parameter setObject:password forKey:@"password"];
    [parameter setObject:appVersion forKey:@"appVersion"];
    [parameter setObject:sysVersion forKey:@"sysVersion"];
    [parameter setObject:deviceType forKey:@"deviceType"];
    [parameter setObject:deviceId forKey:@"deviceId"];
    [parameter setObject:sysType forKey:@"sysType"];

    
    [HTTPModel POST:url parameters:parameter progress:^(NSProgress * progress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject valueForKey:@"result"]) {
            callback([[[responseObject valueForKey:@"result"] valueForKey:@"retCode"] integerValue], [[responseObject objectForKey:@"result"] objectForKey:@"data"], [responseObject objectForKey:@"retMsg"]);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        callback(error.code, nil, error.domain);
    }];
}
+(void)getHomeRooms:(nullable NSString *)apiId
         pageSize:(nullable NSString *)pageSize
       pageIndex:(nullable NSString *)pageIndex
       callback:(nullable void (^)(NSInteger status, id _Nullable responseObject, NSString* _Nullable msg))callback
{
    NSString *url = [NSString stringWithFormat:@"%@%@/calling/%@", HTTP_REQUESTURL,@"user",apiId];
    
    NSMutableDictionary * parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:pageSize forKey:@"pageSize"];
    [parameter setObject:pageIndex forKey:@"pageIndex"];
    
    [HTTPModel POST:url parameters:parameter progress:^(NSProgress * progress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([@"0" isEqualToString:[responseObject objectForKey:@"respCode"]]) {
            
            callback([[[responseObject valueForKey:@"result"] valueForKey:@"retCode"] integerValue], [[responseObject objectForKey:@"result"] objectForKey:@"data"], [responseObject objectForKey:@"retMsg"]);
        }
        else
        {
            callback([[[responseObject valueForKey:@"result"] valueForKey:@"retCode"] integerValue], [[responseObject objectForKey:@"result"] objectForKey:@"data"], [responseObject objectForKey:@"retMsg"]);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        callback(error.code, nil, error.domain);
    }];
}
+(void)getUserMessage:(nullable NSString *)apiId
           someoneId:(nullable NSString *)someoneId
           callback:(nullable void (^)(NSInteger status, id _Nullable responseObject, NSString* _Nullable msg))callback
{
    NSString *url = [NSString stringWithFormat:@"%@%@/calling/%@", HTTP_REQUESTURL,@"user",apiId];
    
    NSMutableDictionary * parameter = [[NSMutableDictionary alloc] init];
    [parameter setObject:someoneId forKey:@"someoneId"];
    
    [HTTPModel POST:url parameters:parameter progress:^(NSProgress * progress) {
        
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([@"0" isEqualToString:[responseObject objectForKey:@"respCode"]]) {
            
            callback([[[responseObject valueForKey:@"result"] valueForKey:@"retCode"] integerValue], [[responseObject objectForKey:@"result"] objectForKey:@"data"], [responseObject objectForKey:@"retMsg"]);
        }
        else
        {
            callback([[[responseObject valueForKey:@"result"] valueForKey:@"retCode"] integerValue], [[responseObject objectForKey:@"result"] objectForKey:@"data"], [responseObject objectForKey:@"retMsg"]);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        callback(error.code, nil, error.domain);
    }];
}



@end
















