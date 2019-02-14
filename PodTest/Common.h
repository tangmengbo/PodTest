//
//  Common.h
//  DidiTravel
//
//  Created by Apple_yjh on 15-4-10.
//  Copyright (c) 2015年 yjh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
/*获取手机ip*/
#import <sys/socket.h>
#import <sys/sockio.h>
#import <sys/ioctl.h>
#import <net/if.h>
#import <arpa/inet.h>
/*获取手机ip*/

@interface Common : NSObject

//本地缓存数据
+(NSString *)getFileToDocuments:(NSString *)url ;



+ (BOOL)strNilOrEmpty:(NSString *)string;
/**
 *	@brief	弹出系统警告框.
 *
 *	@param
 *
 *	@return	UIAlertView
 */

+ (UIAlertView *)showAlert:(NSString *)title message:(NSString *)msg;
+ (UIAlertView * )showNetWorkAlert :(id)deleagte message:(NSString *)message tag:(int)tag;


/**
 *	@brief	去掉string两端空格.
 *
 *	@param 	string 	源字符串.
 *
 *	@return	处理后的string.
 */
+ (NSString *)strTrim:(NSString *)string;

//邮箱验证
+ (BOOL)isValidateEmail:(NSString *)email;
/**
 *
 *
 *  @param 清理网络缓存
 *
 *
 */
+ (void)clearWebCache;

/*
 * @DO 获取指定日期的农历日期
 * @param date [指定日期]
 * @return (NSString)[指定日期的农历字符串]
 */
+(NSString*)getChineseCalendarWithDate:(NSDate *)date;

/**
 *  将指定格式的日期字符串转化为日期
 *
 *  @param string  日期字符串
 *  @param formate 日期样式
 *
 *  @return 日期
 */
+ (NSDate*)getNSDateByString:(NSString*)string formate:(NSString*)formate;
/**
 *  将指定日期转换成格式化日期字符串
 *
 *  @param formateString 格式
 *  @param date          日期
 *
 *  @return 格式化日期字符串
 */
+ (NSString*)getDateStringByFormateString:(NSString*)formateString date:(NSDate*)date;
/**
 *  从日期数据流中获取年份
 *
 *  @param fromDate 日期数据流
 *
 *  @return 年份
 */
+ (NSInteger)getYearFromDate:(NSDate*)fromDate;
+ (NSString *)getYearStrFromDate:(NSDate*)fromDate;

+(NSString*)getMonthChat:(NSDate *)date;
/**
 *  从日期数据流中获取月份
 *
 *  @param fromDate 日期数据流
 *
 *  @return 月份
 */
+(NSInteger)getMonthFromDate:(NSDate*)fromDate;
//获取当前时间戳
+(NSString *)getTimestamp:(NSDate *)date;
//获取当前时间戳返回long类型  毫秒
+(long long)getTimestampLong;

+(NSString *)timestampToDate:(NSString *)interval;

+(NSString *)timestampToDateHaoMiao:(NSString *)interval;


//图片缩放到指定大小尺寸
+(UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;


+(NSString *)getLoctionWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude;

+ (BOOL) isValidString:(id)input;

+ (BOOL) isValidDictionary:(id)input;

+ (BOOL) isValidArray:(id)input;
+ (BOOL)validateUserName:(NSString*)number;
+ (BOOL)validateNumber:(NSString*)number;
+(BOOL)validateMoneyNumber:(NSString*)number;
+(BOOL)validateMoneyNumberWithPoint:(NSString*)number ;
+(CGSize)setSize:(NSString *)message withCGSize:(CGSize)cgsize  withFontSize:(float)fontSize;

+(int)getAgeByBirthdayStr:(NSString *)birthdayStr;

//获取当前用户id
+(NSString *)getNowUserID;
+(NSString *)getCityName;
+(NSDictionary *)getAuthentication;
+(NSString *)getRenQiAR;
+(NSString *)getSignature;
+(NSString *)getCurrentaccessid;

+(NSString *)getCurrentSex;

+(NSString *)getCurrentUserName;
+(NSString *)getBirthday;

+(NSString *)getCurrentUserAnchorType;

+(BOOL)isInreview;

+(NSString *)getCurrentAvatarpath;

+(NSString *)getVIPStatus;

+(NSString *)getRoleStatus;

+(NSString *)getWxPayType;

+(NSMutableArray *)getGuanZhuIdList;
+(void)uploadGuanZhuIdList:(NSMutableArray *)guanZhuList;

//+(UIImage *)generateImageForGalleryWithImage:(UIImage *)image;

+(NSString *)getobjectForKey:(id)object;

+(NSString *)integerToString:(CGFloat)tfloat;

+(NSString *)getReadableDateFromTimestamp:(NSString *)timestamp;

+(NSString *)getNewReadableDateFromTimestamp:(NSString *)stamp;

+(void)showNetworkIndicator;

+(void)hideNetworkIndicator;

+(NSString*)uuid;

+(int64_t)int64OfStr:(NSString*)str;

+(NSString*)strOfInt64:(int64_t)num;

+(UIButton * )showToastView:(NSString *)message view:(UIView *)view;
+ (NSString *)intervalSinceNow: (NSDate *) theDate;
//创建时间与当前时间的间隔
+(int)getTimeDistanceSinceNow:(NSString *)timeStr;
//获取当前日期与星期
+(NSDictionary *)getNowDateAndWeek;
+ (NSString*)getDayFromDate:(NSDate *)date;
+(void)saveImage:(NSString *)savePath image:(UIImage *)image;
//获取设备型号
+ (NSString*)getDeviceType;
+(NSString *)getWeekFromDate:(NSDate*)date;
+(NSString *)netWorkState;

//获取图片格式
+(NSString *)contentTypeForImageData:(NSData *)data ;
//抖动效果
+(void)shakeAnimationForView:(UIView *) view;

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

+(NSString *)getDeviceUUID;

// 获取本周一的日期
+(NSString *)getBenZhouYiShiJian:(NSString *)whichDay;
//dictionary转json字符串
+(NSString *)convertToJsonData:(NSDictionary *)dict;
//判断字符串是否为空或全是空格
+ (BOOL) isEmpty:(NSString *) str;
//获取视频第一帧图片
+ (UIImage*) getVideoPreViewImage:(NSURL *)path;
//判断时间间隔是否大于3天
+(NSString *)shiJianDistanceAlsoDaYu3Days:(NSString *)timestamp distance:(int)timeDistance;
//判断时间间隔是否大于5分钟
+(NSString *)shiJianDistanceAlsoDaYu5Minutes:(NSString *)timestamp distance:(int)timeDistance;
//获取手机ip
+(NSString *)getDeviceIPIpAddresses;

//获取ip和地理位置信息以及国家名
+(NSDictionary *)getWANIP;

+(NSDictionary *)deviceWANIPAdress;
//对图片本身进行旋转
+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation;
//判断手机号码格式是否正确
+ (BOOL)valiMobile:(NSString *)mobile;

// 删除Dictionary中的NSNull
+ (NSMutableDictionary *)removeNullFromDictionary:(NSDictionary *)dic;
// 删除NSArray中的NSNull
+ (NSMutableArray *)removeNullFromArray:(NSArray *)arr;

+(UIImage*)image:(UIImage *)imageI scaleToSize:(CGSize)size;
+(UIImage *)imageFromImage:(UIImage *)imageI inRect:(CGRect)rect;

//获取根据文字自适应高度的lable
+(UILabel *)getLableByContenMessage:(NSString *)contenStr textFont:(float)textFont lineSpacing:(float )lineSpacing lableFrame:(CGRect)lableFrame;

//截取当前屏幕
+ (UIImage *)imageWithScreenshot;

//图片合成
+ (UIImage *)composeImg :(UIImage *)bottomImage topImage:(UIImage *)topImage hcImageWidth:(float)hcImageWidth  hcImageHeight:(float)hcImageHeight hcFrame:(CGRect)hcFrame;
//生成二维码
+(UIImage * )erweima :(NSString *)dingDanHao;

@end
