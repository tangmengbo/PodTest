//
//  ViewController.m
//  PodTest
//
//  Created by 唐蒙波 on 2018/12/6.
//  Copyright © 2018年 tangmengbo. All rights reserved.
//

#import "ViewController.h"
//获取idfa
#import <AdSupport/ASIdentifierManager.h>
#import "Common.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString * deviceId;
    if ( [[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
        
        deviceId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        
    }
    else
    {
        deviceId = @"";
    }

    
    [HTTPModel telLogin:@"1810103"
                 mobile:@"15829782534"
               password:@"123456"
             appVersion:[[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"]
             sysVersion:[[UIDevice currentDevice] systemVersion]
             deviceType:[Common getDeviceType]
               deviceId:deviceId
                sysType:@"ios"
               callback:^(NSInteger status, id  _Nullable responseObject, NSString * _Nullable msg) {
                  
                   if (status==0) {
                       
                       NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
                       [defaults setObject:[Common removeNullFromDictionary:[responseObject objectForKey:@"User"]] forKey:@"USERINFO"];
                       [defaults synchronize];
                       [self getHomeRooms:[[responseObject objectForKey:@"User"] objectForKey:@"userId"]];
                       
                      
                   }
                   
               }];
    

}
-(void)getHomeRooms:(NSString *)userId
{
//    [HTTPModel getHomeRooms:@"1810401"
//                   pageSize:@"10"
//                  pageIndex:@"0"
//                   callback:^(NSInteger status, id  _Nullable responseObject, NSString * _Nullable msg) {
//
//                       if (status==0) {
//
//                       }
//                       else
//                       {
//                           NSLog(@"%@",msg);
//                       }
//                   }];
    [HTTPModel getUserMessage:@"1810108"
                    someoneId:userId
                     callback:^(NSInteger status, id  _Nullable responseObject, NSString * _Nullable msg) {
                         
                         
                     }];
}

@end
