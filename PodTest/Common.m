//
//  Common.m
//  DidiTravel
//
//  Created by Apple_yjh on 15-4-10.
//  Copyright (c) 2015年 yjh. All rights reserved.
//

#import "Common.h"
#import <sys/utsname.h>
#import <Security/Security.h>
//获取idfa
#import <AdSupport/ASIdentifierManager.h>
@implementation Common

+(NSString *)getFileToDocuments:(NSString *)url
{
    NSString *resultFilePath = @"";
    
    
    
    NSString *destFilePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[url substringFromIndex:7] ] ; // 去除域名，组合成本地文件PATH
    NSString *destFolderPath = [destFilePath stringByDeletingLastPathComponent];
    
    // 判断路径文件夹是否存在不存在则创建
    if (! [[NSFileManager defaultManager] fileExistsAtPath:destFolderPath]) {
        
        [[NSFileManager defaultManager] createDirectoryAtPath:destFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    // 判断该文件是否已经下载过
    if ([[NSFileManager defaultManager] fileExistsAtPath:destFilePath]) {
        resultFilePath = destFilePath;
        return destFilePath;
    }
    else
    {
        return nil;
    }
    
    
}


+ (BOOL)strNilOrEmpty:(NSString *)string
{
    if ([string isKindOfClass:[NSString class]])
    {
        if (string.length > 0)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    else
    {
        return YES;
    }
}

// 弹出系统警告框
+ (UIAlertView *)showAlert:(NSString *)title message:(NSString *)msg {
    NSString *strAlertOK = @"确定";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:strAlertOK
                                          otherButtonTitles:nil];
    [alert show];
    return alert;
}
+ (UIAlertView * )showNetWorkAlert :(id)deleagte message:(NSString *)message tag:(int)tag

{
    NSString *strAlertOK = @"确定";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:message
                                                   delegate:deleagte
                                          cancelButtonTitle:strAlertOK
                                          otherButtonTitles:nil];
    alert.tag = tag;
    [alert show];
    return alert;
}
+ (NSString *)strTrim:(NSString *)string{
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];//去掉两端的空格
}

#pragma mark -
#pragma mark 清除web缓存

+ (void)clearWebCache{
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>= 6.0)
    {
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
    }
}

#pragma mark -
#pragma mark 验证邮箱是否合法
+ (BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+(NSString*)getChineseCalendarWithDate:(NSDate *)date
{
    //定义农历数据:
    NSArray *chineseYears = [NSArray arrayWithObjects:
                             @"甲子", @"乙丑", @"丙寅", @"丁卯", @"戊辰", @"己巳", @"庚午", @"辛未", @"壬申", @"癸酉",
                             @"甲戌", @"乙亥", @"丙子", @"丁丑", @"戊寅", @"己卯", @"庚辰", @"辛己", @"壬午", @"癸未",
                             @"甲申", @"乙酉", @"丙戌", @"丁亥", @"戊子", @"己丑", @"庚寅", @"辛卯", @"壬辰", @"癸巳",
                             @"甲午", @"乙未", @"丙申", @"丁酉", @"戊戌", @"己亥", @"庚子", @"辛丑", @"壬寅", @"癸丑",
                             @"甲辰", @"乙巳", @"丙午", @"丁未", @"戊申", @"己酉", @"庚戌", @"辛亥", @"壬子", @"癸丑",
                             @"甲寅", @"乙卯", @"丙辰", @"丁巳", @"戊午", @"己未", @"庚申", @"辛酉", @"壬戌", @"癸亥", nil];
    NSArray *chineseMonths=[NSArray arrayWithObjects:
                            @"正月", @"二月", @"三月", @"四月", @"五月", @"六月",
                            @"七月", @"八月", @"九月", @"十月", @"冬月", @"腊月", nil];
    NSArray *chineseDays=[NSArray arrayWithObjects:
                          @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
                          @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",
                          @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",  nil];
    
    NSCalendar* localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSChineseCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:date];
    
    NSString *y_str = [chineseYears objectAtIndex:localeComp.year-1];
    NSString *m_str = [chineseMonths objectAtIndex:localeComp.month-1];
    NSString *d_str = [chineseDays objectAtIndex:localeComp.day-1];
    NSString *chineseCal_str =[NSString stringWithFormat: @"农历:%@%@%@",y_str,m_str,d_str];// @"%@_%@_%@",y_str,m_str,d_str
    return chineseCal_str;
}

+ (NSDate*)getNSDateByString:(NSString*)string formate:(NSString*)formate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formate];
    NSDate *date = [formatter dateFromString:string];
    return date;
}

+ (NSString*)getDateStringByFormateString:(NSString*)formateString date:(NSDate*)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formateString];
    NSString *strDate = [formatter stringFromDate:date];
    return strDate;
}

+ (NSInteger)getYearFromDate:(NSDate*)fromDate{
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyy"];
    NSInteger ym = [[dateFormater stringFromDate:fromDate] intValue];
    return ym;
}

+ (NSString *)getYearStrFromDate:(NSDate*)fromDate
{
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyy"];
    return [dateFormater stringFromDate:fromDate] ;
}

+(NSInteger)getMonthFromDate:(NSDate*)fromDate{
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"MM"];
    NSInteger ym = [[dateFormater stringFromDate:fromDate] intValue];
    return ym;
}

+(NSString *)getTimestamp:(NSDate *)date
{
    NSString *timeString = @"";
    if([date isKindOfClass:[NSDate class]])
    {
      timeString = [NSString stringWithFormat:@"%ld",(long)[date timeIntervalSince1970]];
    }
    return timeString;
}
//获取当前时间戳返回long类型
+(long long)getTimestampLong
{
    NSLog(@"%l",[[NSDate date] timeIntervalSince1970]*100);
    
    return (long long)[[NSDate date] timeIntervalSince1970]*100;
}
+(NSString*)getMonthChat:(NSDate *)date
{
    
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"MM"];
    NSInteger mm = [[dateFormater stringFromDate:date] intValue];
    NSString *tempMonth= @"";
    switch (mm) {
        case 1:
            tempMonth = @"JAN";
            break;
        case 2:
            tempMonth = @"FEB";
            break;
        case 3:
            tempMonth = @"MAY";
            break;
        case 4:
            tempMonth = @"APR";
            break;
        case 5:
            tempMonth = @"MAR";
            break;
        case 6:
            tempMonth = @"JUN";
            break;
        case 7:
            tempMonth = @"JUL";
            break;
        case 8:
            tempMonth = @"AUG";
            break;
        case 9:
            tempMonth = @"SEP";
            break;
        case 10:
            tempMonth = @"OCT";
            break;
        case 11:
            tempMonth = @"NOV";
            break;
        case 12:
            tempMonth = @"DEC";
            break;
    }
    [dateFormater setDateFormat:@"dd"];
    tempMonth = [tempMonth stringByAppendingString:[NSString stringWithFormat:@" %ld",[[dateFormater stringFromDate:date] integerValue]]];
    return tempMonth;
}

+(NSString *)timestampToDate:(NSString *)interval
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[interval doubleValue]];
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString * dateString= [dateFormater stringFromDate:date];
    return dateString;
}
+(NSString *)timestampToDateHaoMiao:(NSString *)interval
{
    NSString * haoMiao = [interval substringWithRange:NSMakeRange(interval.length-3, 3)];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[interval doubleValue]/1000];
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString * dateString= [[dateFormater stringFromDate:date] stringByAppendingString:[NSString stringWithFormat:@".%@",haoMiao]];
    return dateString;
}
//图片缩放到指定大小尺寸
+(UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size
{
    
    CGSize imgsize =size;
    
    UIGraphicsBeginImageContext(imgsize);
    [img drawInRect:CGRectMake(0, 0, imgsize.width, imgsize.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

//根据当前的经纬判断当前的位置信息
+(NSString *)getLoctionWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude
{
    __block NSString *locationName = @"";

    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray * placemarks, NSError * error)
     {
         if (placemarks.count > 0)
         {
             CLPlacemark *plmark = [placemarks objectAtIndex:0];
             NSString *country = plmark.country;
             NSString *city = plmark.locality;
             locationName = [NSString stringWithFormat:@"%@%@",country,city];
         }
     }];
    return locationName;
}


+ (BOOL) isValidString:(id)input
{
    if (!input) {
        return NO;
    }
    if(input==nil)
    {
        return NO;
    }
    if([input isKindOfClass:[NSNull class]] )
    {
        return NO;
    }
    if ((NSNull *)input == [NSNull null]) {
        return NO;
    }
    if (![input isKindOfClass:[NSString class]]) {
        return NO;
    }
    if (!input &&[input isEqualToString:@""]) {
        return NO;
    }
    return YES;
}

+ (BOOL) isValidDictionary:(id)input
{
    if (!input) {
        return NO;
    }
    if ((NSNull *)input == [NSNull null]) {
        return NO;
    }
    if (![input isKindOfClass:[NSDictionary class]]) {
        return NO;
    }
    if ([input count] <= 0) {
        return NO;
    }
    return YES;
}

+ (BOOL) isValidArray:(id)input
{
    if (!input) {
        return NO;
    }
    if ((NSNull *)input == [NSNull null]) {
        return NO;
    }
    if (![input isKindOfClass:[NSArray class]]) {
        return NO;
    }
    if ([input count] <= 0) {
        return NO;
    }
    return YES;
}



//1 ping++  2 h5  wx
+(NSString *)getWxPayType
{
    NSUserDefaults * wxPayTypeDefaults = [NSUserDefaults standardUserDefaults];
    return [wxPayTypeDefaults objectForKey:@"wxPayType"];
}
//获取当前用户关注的用户的id列表
+(NSMutableArray *)getGuanZhuIdList
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray * guanZhuList = [defaults objectForKey:@"userGuanZhuList"];
    if (guanZhuList==nil) {
        
        guanZhuList = [NSMutableArray array];
    }
    return guanZhuList;
}
+(void)uploadGuanZhuIdList:(NSMutableArray *)guanZhuList
{
    
    if ([guanZhuList isKindOfClass:[NSArray class]]&&guanZhuList!=nil) {
        
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[Common removeNullFromArray:guanZhuList] forKey:@"userGuanZhuList"];
        [defaults synchronize];

    }

}
//较验用户名
+ (BOOL)validateUserName:(NSString*)number {
    BOOL res = YES;
    if(![Common isValidString:number])
        return NO;
    
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}
//较验电话号码
+(BOOL)validateNumber:(NSString*)number {
    BOOL res = YES;
    if(![Common isValidString:number])
        return NO;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}
//较验钱数
+(BOOL)validateMoneyNumber:(NSString*)number {
    BOOL res = YES;
    if(![Common isValidString:number])
        return NO;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}
//较验钱数
+(BOOL)validateMoneyNumberWithPoint:(NSString*)number {
    BOOL res = YES;
    if(![Common isValidString:number])
        return NO;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
    int i = 0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}

+(CGSize)setSize:(NSString *)message withCGSize:(CGSize)cgsize  withFontSize:(float)fontSize
{

    
    CGSize  size = [message boundingRectWithSize:cgsize  options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]} context:nil].size;
    return size;
}



//+(UIImage *)generateImageForGalleryWithImage:(UIImage *)image
//{
//    UIImageView *tmpImageView = [[UIImageView alloc] initWithImage:image];
//    tmpImageView.frame                  = CGRectMake(0.0f, 0.0f, image.size.width, image.size.width);
//    tmpImageView.layer.borderColor      = [UIColor whiteColor].CGColor;
//    tmpImageView.layer.borderWidth      = 0.0;
//    tmpImageView.layer.shouldRasterize  = YES;
//    
//    UIImage *tmpImage   = [UIImage imageFromView:tmpImageView];
//    
//    return [tmpImage transparentBorderImage:1.0f];
//}
+(int)getAgeByBirthdayStr:(NSString *)birth
{
    int age = 0;

    if(birth!=nil&&birth.length>0)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyyMMdd"];
        //生日
        NSDate *birthDay = [dateFormatter dateFromString:birth];
        //当前时间
        NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
        NSDate *currentDate = [dateFormatter dateFromString:currentDateStr];
        NSLog(@"currentDate %@ birthDay %@",currentDateStr,birth);
        NSTimeInterval time=[currentDate timeIntervalSinceDate:birthDay];
        age = ((int)time)/(3600*24*365);
    }
    return age;
}
+(NSString *)getobjectForKey:(id)object
{
    NSString *temp = @"";
    if(object  && ![object isEqual:[NSNull class]] &&![object isEqual:[NSNull null]])
    {
        temp = object;
    }
    return temp;
}

+(NSString *)integerToString:(CGFloat)tfloat
{
    return [NSString stringWithFormat:@"%ld",(NSInteger)tfloat];
}

+(NSString *)getReadableDateFromTimestamp:(NSString *)stamp
{
    NSString *_timestamp;
    
    NSTimeInterval createdAt = [stamp doubleValue];
    
    // Calculate distance time string
    time_t now;
    time(&now);
    
    int distance = (int)difftime(now, createdAt);  // createdAt
    if (distance < 0) distance = 0;
    
    if (distance < 30) {
        _timestamp = @"刚刚";
    }
    else if (distance < 60) {
        _timestamp = [NSString stringWithFormat:@"%d%@", distance, (distance == 1) ? @"秒前" : @"秒前"];
    }
    else if (distance < 60 * 60) {
        distance = distance / 60;
        _timestamp = [NSString stringWithFormat:@"%d%@", distance, (distance == 1) ? @"分钟前" : @"分钟前"];
    }
    else if (distance < 60 * 60 * 24) {
        distance = distance / 60 / 60;
        _timestamp = [NSString stringWithFormat:@"%d%@", distance, (distance == 1) ? @"小时前" : @"小时前"];
    }
    else if (distance < 60 * 60 * 24 * 7) {
        distance = ((distance / 60 / 60 / 24) + ((distance % (60 * 60 * 24))>0?1:0));
        if (distance == 1) {
            _timestamp = @"昨天";
        } else if (distance == 2) {
            _timestamp = @"前天";
        } else {
            _timestamp = [NSString stringWithFormat:@"%d%@", distance, (distance == 1) ? @"天前" : @"天前"];
        }
    }
    else if (distance < 60 * 60 * 24 * 7 * 4) {
        distance = distance / 60 / 60 / 24 / 7;
        _timestamp = [NSString stringWithFormat:@"%d%@", distance, (distance == 1) ? @"周前" : @"周前"];
    }
    else {
        static NSDateFormatter *dateFormatter = nil;
        if (dateFormatter == nil) {
            [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yy-MM-dd"];
        }
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:createdAt];
        _timestamp = [dateFormatter stringFromDate:date];
    }
    
    return _timestamp;
}
+(NSString *)getNewReadableDateFromTimestamp:(NSString *)stamp
{
    NSString *_timestamp;
    
    NSTimeInterval createdAt = [stamp doubleValue];
    
    // Calculate distance time string
    time_t now;
    time(&now);
    
    int distance = (int)difftime(now, createdAt);  // createdAt
    if (distance < 0) distance = 0;
    
    if (distance < 30) {
        _timestamp = @"刚刚";
    }
    else if (distance < 60) {
        _timestamp = [NSString stringWithFormat:@"%d%@", distance, (distance == 1) ? @"秒前" : @"秒前"];
    }
    else if (distance < 60 * 60) {
        distance = distance / 60;
        _timestamp = [NSString stringWithFormat:@"%d%@", distance, (distance == 1) ? @"分钟前" : @"分钟前"];
    }
    else if (distance < 60 * 60 * 24) {
        distance = distance / 60 / 60;
        _timestamp = [NSString stringWithFormat:@"%d%@", distance, (distance == 1) ? @"小时前" : @"小时前"];
    }
    else {
        static NSDateFormatter *dateFormatter = nil;
        if (dateFormatter == nil) {
            [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MM-dd"];
        }
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:createdAt];
        _timestamp = [dateFormatter stringFromDate:date];
    }
    
    return _timestamp;
}


+(void)showNetworkIndicator
{
    UIApplication* app=[UIApplication sharedApplication];
    app.networkActivityIndicatorVisible=YES;
}

+(void)hideNetworkIndicator
{
    UIApplication* app=[UIApplication sharedApplication];
    app.networkActivityIndicatorVisible=NO;
}


+(NSString*)uuid
{
    NSString *chars=@"abcdefghijklmnopgrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    assert(chars.length==62);
    int len=chars.length;
    NSMutableString* result=[[NSMutableString alloc] init];
    for(int i=0;i<24;i++){
        int p=arc4random_uniform(len);
        NSRange range=NSMakeRange(p, 1);
        [result appendString:[chars substringWithRange:range]];
    }
    return result;
}

#pragma mark - time

+(int64_t)int64OfStr:(NSString*)str
{
    return [str longLongValue];
}

+(NSString*)strOfInt64:(int64_t)num
{
    return [[NSNumber numberWithLongLong:num] stringValue];
}

//发布时间与当前时间的间隔
+ (NSString *)intervalSinceNow: (NSDate *) theDate
{
    
    NSTimeInterval late=[theDate timeIntervalSince1970]*1;
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"NO";
    
    NSTimeInterval cha=now-late;
    if (cha/60>2)
    {
    
        timeString=@"YES";
        
    }
    return timeString;
}
//创建时间与当前时间的间隔
+(int)getTimeDistanceSinceNow:(NSString *)timeStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMMddHHmmss"];
    NSDate * sinceDate = [dateFormatter dateFromString:timeStr];
    
    NSTimeInterval late=[sinceDate timeIntervalSince1970]*1;
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    
    NSTimeInterval cha=now-late;
    
    return (int)cha;
}

//获取当前时间与星期
+(NSDictionary *)getNowDateAndWeek
{
    NSArray * arrWeek=[NSArray arrayWithObjects:@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六", nil];
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSWeekdayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:date];
    int week = [comps weekday];
    NSString * year= [NSString stringWithFormat:@"%d",(int)[comps year]];
    NSString * month = [NSString stringWithFormat:@"%d",(int)[comps month]];
    NSString * day = [NSString stringWithFormat:@"%d",(int)[comps day]];
    NSDictionary * dic = [[NSDictionary alloc] initWithObjectsAndKeys:year,@"year",month,@"month",day,@"day",[arrWeek objectAtIndex:week-1],@"week", nil];
    return dic;
}
+(NSString *)getWeekFromDate:(NSDate*)date
{
    NSArray * arrWeek=[NSArray arrayWithObjects:@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSWeekdayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:date];
    int week = [comps weekday];
    NSString * year= [NSString stringWithFormat:@"%d",(int)[comps year]];
    NSString * month = [NSString stringWithFormat:@"%d",(int)[comps month]];
    NSString * day = [NSString stringWithFormat:@"%d",(int)[comps day]];
    NSString * str = [arrWeek objectAtIndex:week-1];
    return str;
    
    
}
+ (NSString*)getDayFromDate:(NSDate *)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] ;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSWeekdayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:date];
    NSString * day = [NSString stringWithFormat:@"%d",(int)[comps day]];
    return day;
}
+ (NSString*)getDeviceType
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *device = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return device;
}
//获取图片格式
+(NSString *)contentTypeForImageData:(NSData *)data {
    
    uint8_t c;
    
    [data getBytes:&c length:1];
    
    switch (c) {
            
        case 0xFF:
            
            return @"jpeg";
            
        case 0x89:
            
            return @"png";
            
        case 0x47:
            
            return @"gif";
            
        case 0x49:
            
        case 0x4D:
            
            return @"tiff";
            
        case 0x52:
            
            if ([data length] < 12) {
                
                return nil;
                
            }
            
            NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            
            if(testString!=nil && ![testString isKindOfClass:[NSNull class]])
            {
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                
                return @"webp";
                
            }
            }
            
            return nil;
            
    }
    
    return nil;
    
}
+(void)shakeAnimationForView:(UIView *) view
{
    // 获取到当前的View
    
    CALayer *viewLayer = view.layer;
    
    // 获取当前View的位置
    
    CGPoint position = viewLayer.position;
    
    // 移动的两个终点位置
    
    CGPoint x = CGPointMake(position.x + 15, position.y);
    
    CGPoint y = CGPointMake(position.x - 15, position.y);
    
    // 设置动画
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    
    // 设置运动形式
    
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    
    // 设置开始位置
    
    [animation setFromValue:[NSValue valueWithCGPoint:x]];
    
    // 设置结束位置
    
    [animation setToValue:[NSValue valueWithCGPoint:y]];
    
    // 设置自动反转
    
    [animation setAutoreverses:YES];
    
    // 设置时间
    
    [animation setDuration:.06];
    
    // 设置次数
    
    [animation setRepeatCount:5];
    
    // 添加上动画
    
    [viewLayer addAnimation:animation forKey:nil];
    
    
    
}
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
+(NSString *)getDeviceUUID;
{
    NSString *identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];
    NSLog(@"%@",identifierForVendor);
    return identifierForVendor;
}
+(NSString *)getBenZhouYiShiJian:(NSString *)whichDay
{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit|NSDayCalendarUnit
                                         fromDate:now];
    
    // 得到星期几
    // 1(星期天) 2(星期二) 3(星期三) 4(星期四) 5(星期五) 6(星期六) 7(星期天)
    NSInteger weekDay = [comp weekday];
    // 得到几号
    NSInteger day = [comp day];
    
    NSLog(@"weekDay:%ld   day:%ld",weekDay,day);
    
    // 计算当前日期和这周的星期一和星期天差的天数
    long firstDiff,lastDiff;
    if (weekDay == 1) {
        firstDiff = 1;
        lastDiff = 0;
    }else{
        firstDiff = [calendar firstWeekday] - weekDay;
        lastDiff = 9 - weekDay;
    }
    
    NSLog(@"firstDiff:%ld   lastDiff:%ld",firstDiff,lastDiff);
    
    // 在当前日期(去掉了时分秒)基础上加上差的天数
    NSDateComponents *firstDayComp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
    [firstDayComp setDay:day + firstDiff];
    NSDate *firstDayOfWeek= [calendar dateFromComponents:firstDayComp];
    
    NSDateComponents *lastDayComp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
    [lastDayComp setDay:day + lastDiff];
    NSDate *lastDayOfWeek= [calendar dateFromComponents:lastDayComp];
    
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSLog(@"星期一开始 %@",[formater stringFromDate:firstDayOfWeek]);
    NSLog(@"当前 %@",[formater stringFromDate:now]);
    NSLog(@"星期天结束 %@",[formater stringFromDate:lastDayOfWeek]);
    
    
    if ([@"zhouYi" isEqualToString:whichDay]) {
        
        return [formater stringFromDate:firstDayOfWeek];
        
    }
    else if([@"jinTian" isEqualToString:whichDay])
    {
        return [formater stringFromDate:now];
    }
    else
    {
        [formater setDateFormat:@"yyyy-MM-dd "];
        [formater stringFromDate:now];
        
        NSString * nowStr = [formater stringFromDate:now];
        
        return [nowStr stringByAppendingString:@"00:00:00"];
    }
    
}
+(NSString *)convertToJsonData:(NSDictionary *)dict

{
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
    
}
//判断字符串是否为空或全是空格
+ (BOOL) isEmpty:(NSString *) str {
    
    if(!str) {
        
        return true;
        
    }else {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        
        
        if([trimedString length] == 0) {
            
            return true;
            
            
        }else {
            
            
            return false;
            
            
        }
        
    }
    
    
}
////获取视频的第一帧
//+ (UIImage*) getVideoPreViewImage:(NSURL *)path
//{
//    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:path options:nil];
//    AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
//
//    assetGen.appliesPreferredTrackTransform = YES;
//    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
//    NSError *error = nil;
//    CMTime actualTime;
//    CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
//    UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
//    CGImageRelease(image);
//    return videoImage;
//}
+(NSString *)shiJianDistanceAlsoDaYu3Days:(NSString *)timestamp distance:(int)timeDistance;
{
    
    NSTimeInterval createdAt = [timestamp doubleValue];
    
    // Calculate distance time string
    time_t now;
    time(&now);
    
    int distance = (int)difftime(now, createdAt);  // createdAt
   if (distance >= 60 * 60 * 24 * timeDistance)
   {
       return @"大于3天";
   }
    else
    {
        return @"小于3天";
    }
}
+(NSString *)shiJianDistanceAlsoDaYu5Minutes:(NSString *)timestamp distance:(int)timeDistance;
{
    
    NSTimeInterval createdAt = [timestamp doubleValue];
    
    // Calculate distance time string
    time_t now;
    time(&now);
    
    int distance = (int)difftime(now, createdAt);  // createdAt
    if (distance >= 60 * timeDistance)
    {
        return @"大于5分钟";
    }
    else
    {
        return @"小于5分钟";
    }
}
+(NSString *)getDeviceIPIpAddresses

{
    
    int sockfd =socket(AF_INET,SOCK_DGRAM, 0);
    
    
    NSMutableArray *ips = [NSMutableArray array];
    
    int BUFFERSIZE =4096;
    
    struct ifconf ifc;
    
    char buffer[BUFFERSIZE], *ptr, lastname[IFNAMSIZ], *cptr;
    
    struct ifreq *ifr, ifrcopy;
    
    ifc.ifc_len = BUFFERSIZE;
    
    ifc.ifc_buf = buffer;
    
    if (ioctl(sockfd,SIOCGIFCONF, &ifc) >= 0){
        
        for (ptr = buffer; ptr < buffer + ifc.ifc_len; ){
            
            ifr = (struct ifreq *)ptr;
            
            int len =sizeof(struct sockaddr);
            
            if (ifr->ifr_addr.sa_len > len) {
                
                len = ifr->ifr_addr.sa_len;
                
            }
            
            ptr += sizeof(ifr->ifr_name) + len;
            
            if (ifr->ifr_addr.sa_family !=AF_INET) continue;
            
            if ((cptr = (char *)strchr(ifr->ifr_name,':')) != NULL) *cptr =0;
            
            if (strncmp(lastname, ifr->ifr_name,IFNAMSIZ) == 0)continue;
            
            memcpy(lastname, ifr->ifr_name,IFNAMSIZ);
            
            ifrcopy = *ifr;
            
            ioctl(sockfd,SIOCGIFFLAGS, &ifrcopy);
            
            if ((ifrcopy.ifr_flags &IFF_UP) == 0)continue;
            
            
            
            NSString *ip = [NSString stringWithFormat:@"%s",inet_ntoa(((struct sockaddr_in *)&ifr->ifr_addr)->sin_addr)];
            
            [ips addObject:ip];
            
        }
        
    }
    
    close(sockfd);
    NSString *deviceIP =@"";
    
    for (int i=0; i < ips.count; i++)
        
    {
        
        if (ips.count >0)
            
        {
            
            deviceIP = [NSString stringWithFormat:@"%@",ips.lastObject];
            
            
            
        }
        
    }
    
    NSLog(@"deviceIP========%@",deviceIP);
    return deviceIP;
    
}
//获取ip和地理位置信息以及国家名
+(NSDictionary *)getWANIP

{
    
    //通过淘宝的服务来定位WAN的IP，否则获取路由IP没什么用
    NSUserDefaults * getIpParameterDefaults = [NSUserDefaults standardUserDefaults];
    NSString * ipPathStr = [getIpParameterDefaults objectForKey:@"getIpParameterDefaultsKey"];
    
    NSURL *ipURL =  [NSURL URLWithString:ipPathStr];
    NSData *data = [NSData dataWithContentsOfURL:ipURL];
    NSDictionary *ipDic;
    if(data)
    {
        ipDic  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    }
    NSDictionary * dic = [ipDic objectForKey:@"data"];
    
    
    return dic;

    
}
+(NSDictionary *)deviceWANIPAdress{
    
  
        NSError *error;
        
        NSUserDefaults * getIpParameterDefaults = [NSUserDefaults standardUserDefaults];
        NSString * ipPathStr = [getIpParameterDefaults objectForKey:@"getIpParameterDefaultsKey"];
        
        NSURL *ipURL = [NSURL URLWithString:ipPathStr]; //  http://pv.sohu.com/cityjson?ie=utf-8
        
        NSMutableString *ip = [NSMutableString stringWithContentsOfURL:ipURL encoding:NSUTF8StringEncoding error:&error];
        
        //判断返回字符串是否为所需数据
        
        if ([ip hasPrefix:@"var returnCitySN = "]) {
            
            //对字符串进行处理，然后进行json解析
            
            //删除字符串多余字符串
            
            NSRange range = NSMakeRange(0, 19);
            
            [ip deleteCharactersInRange:range];
            
            NSString * nowIp =[ip substringToIndex:ip.length-1];
            
            //将字符串转换成二进制进行Json解析
            
            NSData * data = [nowIp dataUsingEncoding:NSUTF8StringEncoding];
            
            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            return dict;
            
        }
    
    return nil;
    
}

+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}
//判断手机号码格式是否正确
+ (BOOL)valiMobile:(NSString *)mobile
{
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (mobile.length != 11)
    {
        return NO;
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        }else{
            return NO;
        }
    }
}

// 删除Dictionary中的NSNull
+ (NSMutableDictionary *)removeNullFromDictionary:(NSDictionary *)dic
{
    NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
    for (NSString *strKey in dic.allKeys) {
        NSValue *value = dic[strKey];
        // 删除NSDictionary中的NSNull，再保存进字典
        if ([value isKindOfClass:NSDictionary.class]) {
            mdic[strKey] = [self removeNullFromDictionary:(NSDictionary *)value];
        }
        // 删除NSArray中的NSNull，再保存进字典
        else if ([value isKindOfClass:NSArray.class]) {
            mdic[strKey] = [Common removeNullFromArray:(NSArray *)value];
        }
        // 剩余的非NSNull类型的数据保存进字典
        else if (![value isKindOfClass:NSNull.class]) {
            mdic[strKey] = dic[strKey];
        }
    }
    return mdic;
}
// 删除NSArray中的NSNull
+ (NSMutableArray *)removeNullFromArray:(NSArray *)arr
{
    NSMutableArray *marr = [NSMutableArray array];
    for (int i = 0; i < arr.count; i++) {
        NSValue *value = arr[i];
        // 删除NSDictionary中的NSNull，再添加进数组
        if ([value isKindOfClass:NSDictionary.class]) {
            [marr addObject:[Common removeNullFromDictionary:(NSDictionary *)value]];
        }
        // 删除NSArray中的NSNull，再添加进数组
        else if ([value isKindOfClass:NSArray.class]) {
            [marr addObject:[self removeNullFromArray:(NSArray *)value]];
        }
        // 剩余的非NSNull类型的数据添加进数组
        else if (![value isKindOfClass:NSNull.class]) {
            [marr addObject:value];
        }
    }
    return marr;
    
}
//截取图片
+(UIImage*)image:(UIImage *)imageI scaleToSize:(CGSize)size{
    /*
     UIGraphicsBeginImageContextWithOptions(CGSize size, BOOL opaque, CGFloat scale)
     CGSize size：指定将来创建出来的bitmap的大小
     BOOL opaque：设置透明YES代表透明，NO代表不透明
     CGFloat scale：代表缩放,0代表不缩放
     创建出来的bitmap就对应一个UIImage对象
     */
    UIGraphicsBeginImageContextWithOptions(size, NO, 1.0); //此处将画布放大两倍，这样在retina屏截取时不会影响像素
    
    [imageI drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;
}
+(UIImage *)imageFromImage:(UIImage *)imageI inRect:(CGRect)rect{
    
    CGImageRef sourceImageRef = [imageI CGImage];
    
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    return newImage;
}
////获取根据文字自适应高度的lable
//+(UILabel *)getLableByContenMessage:(NSString *)contenStr textFont:(float)textFont lineSpacing:(float )lineSpacing lableFrame:(CGRect)lableFrame
//{
//    UILabel * describleLable = [[UILabel alloc] initWithFrame:CGRectMake(lableFrame.origin.x, lableFrame.origin.y, lableFrame.size.width, 0)];
//    describleLable.backgroundColor = [UIColor clearColor];
//    describleLable.font = [UIFont systemFontOfSize:textFont];
//    describleLable.numberOfLines = 0;
//    
//    //lable中要显示的文字
//    NSString * describle =contenStr;
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:describle];
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    //调整行间距
//    [paragraphStyle setLineSpacing:lineSpacing];
//    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [describle length])];
//    if ([contenStr containsString:@"香芋倡导绿色、文明的社交环境，涉及政治、色情、低俗、暴力及未成年人等违法不良信息将被封号。共建文明社区，从你我做起。"])
//    {
//        describleLable.textColor = UIColorFromRGB(0xFFCF00);
//
//        [attributedString addAttribute:NSForegroundColorAttributeName
//                                 value:[UIColor redColor]
//                                 range:NSMakeRange(0, 7)];
//        
//    }
//    describleLable.attributedText = attributedString;
//    //设置自适应
//    [describleLable sizeToFit];
//    
//
//    return describleLable;
//}

//截取当前屏幕内容 将以下代码粘贴复制 直接调用imageWithScreenshot方法
/**
 *  截取当前屏幕
 *
 *  @return NSData *
 */
+ (NSData *)dataWithScreenshotInPNGFormat
{
    CGSize imageSize = CGSizeZero;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation))
        imageSize = [UIScreen mainScreen].bounds.size;
    else
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft)
        {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        }
        else if (orientation == UIInterfaceOrientationLandscapeRight)
        {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
        {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        }
        else
        {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return UIImagePNGRepresentation(image);
}

/**
 *  返回截取到的图片
 *
 *  @return UIImage *
 */
+ (UIImage *)imageWithScreenshot
{
    NSData *imageData = [Common dataWithScreenshotInPNGFormat];
    return [UIImage imageWithData:imageData];
}
//图片合成
+ (UIImage *)composeImg :(UIImage *)bottomImage topImage:(UIImage *)topImage hcImageWidth:(float)hcImageWidth  hcImageHeight:(float)hcImageHeight hcFrame:(CGRect)hcFrame{
    
    //以1.png的图大小为画布创建上下文
    UIGraphicsBeginImageContext(CGSizeMake(hcImageWidth*4, hcImageHeight*4)); //*4是为了保持清晰度
    [bottomImage drawInRect:CGRectMake(0, 0, hcImageWidth*4, hcImageHeight*4)];//先把1.png 画到上下文中
    [topImage drawInRect:hcFrame];//再把小图放在上下文中
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();//从当前上下文中获得最终图片
    UIGraphicsEndImageContext();//关闭上下文
    return resultImg; 
}
//生成二维码
+(UIImage * )erweima :(NSString *)dingDanHao
{
    
    //二维码滤镜
    CIFilter *filter=[CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    //恢复滤镜的默认属性
    
    [filter setDefaults];
    
    //将字符串转换成NSData
    
    NSData *data=[dingDanHao dataUsingEncoding:NSUTF8StringEncoding];
    
    //通过KVO设置滤镜inputmessage数据
    
    [filter setValue:data forKey:@"inputMessage"];
    
    //获得滤镜输出的图像
    
    CIImage *outputImage=[filter outputImage];
    
    //将CIImage转换成UIImage,并放大显示
    
    return [Common createNonInterpolatedUIImageFormCIImage:outputImage withSize:100.0];
    
}
//改变二维码大小

+(UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    
    CGRect extent = CGRectIntegral(image.extent);
    
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 创建bitmap;
    
    size_t width = CGRectGetWidth(extent) * scale;
    
    size_t height = CGRectGetHeight(extent) * scale;
    
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    
    CGContextScaleCTM(bitmapRef, scale, scale);
    
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 保存bitmap到图片
    
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    
    CGContextRelease(bitmapRef);
    
    CGImageRelease(bitmapImage);
    
    return [UIImage imageWithCGImage:scaledImage];
    
}
    @end
