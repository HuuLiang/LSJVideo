//
//  LSJConfig.h
//  LSJVideo
//
//  Created by Liang on 16/8/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#ifndef LSJConfig_h
#define LSJConfig_h

#define LSJ_CHANNEL_NO               [LSJConfiguration sharedConfig].channelNo//@"IOS_TTSEQU_0001" //@"QB_MFW_IOS_TEST_0000001" //
#define LSJ_REST_APPID               @"QUBA_2025"
#define LSJ_REST_PV                  @"193"
#define LSJ_PAYMENT_PV               @"100"
#define LSJ_PACKAGE_CERTIFICATE      @"iPhone Distribution: Beijing Huazhong Hengtai Network Technology Co., Ltd."

#define LSJ_REST_APP_VERSION     ((NSString *)([NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"]))
#define LSJ_PAYMENT_RESERVE_DATA [NSString stringWithFormat:@"%@$%@", LSJ_REST_APPID, LSJ_CHANNEL_NO]

#define LSJ_BASE_URL                    @"http://iv.zcqcmj.com"//@"http://120.24.252.114:8093"//@"http://192.168.1.123:8094/"
#define LSJ_HOME_URL                    @"/iosvideo/channelRanking.htm"
#define LSJ_WELFARE_URL                 @"/iosvideo/welfare.htm"
#define LSJ_LECHERS_URL                 @"/iosvideo/forum.htm"
#define LSJ_HOT_URL                     @"/iosvideo/hotSearch.htm"
#define LSJ_PROGRAM_URL                 @"/iosvideo/programForum.htm"
#define LSJ_COLUMN_URL                  @"/iosvideo/columnProgram.htm"
#define LSJ_COLUMN_DAY_URL              @"/iosvideo/programComment.htm"
#define LSJ_DETAIL_URL                  @"/iosvideo/detailsg.htm"
#define LSJ_WELFAREDETAIL_URL           @"/iosvideo/detailstw.htm"
#define LSJ_APPSPREAD_URL               @"/iosvideo/appSpreadList.htm"
#define LSJ_ACTIVATION_URL              @"/iosvideo/activat.htm"
#define LSJ_ACCESS_URL                  @"/iosvideo/userAccess.htm"
#define LSJ_SYSTEM_CONFIG_URL           @"/iosvideo/systemConfig.htm"

#define LSJ_APP_SPREAD_BANNER_URL       @"/iosvideo/appSpreadBanner.htm"

#define LSJ_STATS_BASE_URL              @"http://stats.iqu8.cn"//@"http://120.24.252.114"//
#define LSJ_STATS_CPC_URL               @"/stats/cpcs.service"
#define LSJ_STATS_TAB_URL               @"/stats/tabStat.service"
#define LSJ_STATS_PAY_URL               @"/stats/payRes.service"


#define LSJ_PAYMENT_CONFIG_URL           @"http://pay.zcqcmj.com/paycenter/appPayConfig.json"//@"http://120.24.252.114:8084/paycenter/appPayConfig.json"
#define LSJ_PAYMENT_COMMIT_URL           @"http://pay.zcqcmj.com/paycenter/qubaPr.json"//@"http://120.24.252.114:8084/paycenter/qubaPr.json"
#define LSJ_STANDBY_PAYMENT_CONFIG_URL  @"http://appcdn.mqu8.com/static/iosvideo/payConfig_%@.json"

#define LSJ_UPLOAD_SCOPE                @"mfw-photo"
#define LSJ_UPLOAD_SECRET_KEY           @"K9cjaa7iip6LxVT9zo45p7DiVxEIo158NTUfJ7dq"
#define LSJ_UPLOAD_ACCESS_KEY           @"02q5Mhx6Tfb525_sdU_VJV6po2MhZHwdgyNthI-U"

#define LSJ_DEFAULSJ_PHOTOSERVER_URL     @"http://7xpobi.com2.z0.glb.qiniucdn.com"

#define LSJ_PROTOCOL_URL                @"http://iv.zcqcmj.com/iosvideo/laosiji-agreement.html"
#define LSJ_STATEMENT_URL               @""

#define LSJ_KSCRASH_APP_ID              @"72d15c0abe9178a79e7ab9856edf3d26"

#define LSJ_DB_VERSION                  (1)

#define LSJ_UMENG_APP_ID                @"57ebc899e0f55a52a8002e6a"

#endif /* LSJConfig_h */
