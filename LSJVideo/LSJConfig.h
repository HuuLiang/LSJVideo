//
//  LSJConfig.h
//  LSJVideo
//
//  Created by Liang on 16/8/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#ifndef LSJConfig_h
#define LSJConfig_h

#define LSJ_CHANNEL_NO               @"QUBA_IOS_TUIGUANG9_0000001" //@"QB_MFW_IOS_TEST_0000001" //
#define LSJ_REST_APPID               @"QUBA_2023"
#define LSJ_REST_PV                  @"100"
#define LSJ_PAYMENT_PV               @"101"
#define LSJ_PACKAGE_CERTIFICATE      @"iPhone Distribution: Neijiang Fenghuang Enterprise (Group) Co., LSJd."

#define LSJ_REST_APP_VERSION     ((NSString *)([NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"]))
#define LSJ_PAYMENT_RESERVE_DATA [NSString stringWithFormat:@"%@$%@", LSJ_REST_APPID, LSJ_CHANNEL_NO]

#define LSJ_BASE_URL                    @"http://iv.zcqcmj.com"//@"http://120.24.252.114:8093"//////@"http://192.168.1.123:8094/"
#define LSJ_ACTIVATION_URL              @"/iosvideo/activat.htm"
#define LSJ_ACCESS_URL                  @"/iosvideo/userAccess.htm"
#define LSJ_SYSTEM_CONFIG_URL           @"/iosvideo/systemConfig.htm"
#define LSJ_HOME_URL                    @"/iosvideo/homePage.htm"
#define LSJ_CHANNELRANKING_URL          @"/iosvideo/channelRanking.htm"
#define LSJ_PROGRAM_URL                 @"/iosvideo/program.htm"
#define LSJ_DETAIL_URL                  @"/iosvideo/detailsg.htm"
#define LSJ_APPSPREAD_URL               @"/iosvideo/appSpreadList.htm"

#define LSJ_STATS_BASE_URL              @"http://stats.iqu8.cn"//@"http://120.24.252.114"//
#define LSJ_STATS_CPC_URL               @"/stats/cpcs.service"
#define LSJ_STATS_TAB_URL               @"/stats/tabStat.service"
#define LSJ_STATS_PAY_URL               @"/stats/payRes.service"


#define LSJ_PAYMENT_CONFIG_URL           @"http://pay.zcqcmj.com/paycenter/payConfig.json"//@"http://120.24.252.114:8084/paycenter/payConfig.json"
#define LSJ_PAYMENT_COMMIT_URL           @"http://pay.zcqcmj.com/paycenter/qubaPr.json"//@"http://120.24.252.114:8084/paycenter/qubaPr.json"
#define LSJ_STANDBY_PAYMENT_CONFIG_URL  @"http://appcdn.mqu8.com/static/iosvideo/payConfig_%@.json"

#define LSJ_UPLOAD_SCOPE                @"mfw-photo"
#define LSJ_UPLOAD_SECRET_KEY           @"K9cjaa7iip6LxVT9zo45p7DiVxEIo158NTUfJ7dq"
#define LSJ_UPLOAD_ACCESS_KEY           @"02q5Mhx6Tfb525_sdU_VJV6po2MhZHwdgyNthI-U"

#define LSJ_DEFAULSJ_PHOTOSERVER_URL     @"http://7xpobi.com2.z0.glb.qiniucdn.com"

#define LSJ_PROTOCOL_URL                @"http://iv.ihuiyx.com/iosvideo/av-agreement.html"

#define LSJ_KSCRASH_APP_ID              @""

#define LSJ_DB_VERSION                  (1)

#define LSJ_UMENG_APP_ID                @"5790992ce0f55a0da9003033"

#endif /* LSJConfig_h */