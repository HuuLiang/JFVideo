//
//  JFConfig.h
//  JFVideo
//
//  Created by Liang on 16/6/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#ifndef JFConfig_h
#define JFConfig_h

#define JF_CHANNEL_NO               @"IOS_DONGJING_01" //@"QB_MFW_IOS_TEST_0000001" //
#define JF_REST_APPID               @"QUBA_2023"
#define JF_REST_PV                  @"102"
#define JF_PAYMENT_PV               @"105"
#define JF_PACKAGE_CERTIFICATE      @"iPhone Distribution: Neijiang Fenghuang Enterprise (Group) Co., JFd."

#define JF_REST_APP_VERSION     ((NSString *)([NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"]))
#define JF_PAYMENT_RESERVE_DATA [NSString stringWithFormat:@"%@$%@", JF_REST_APPID, JF_CHANNEL_NO]

#define JF_BASE_URL                    @"http://iv.zcqcmj.com"//@"http://120.24.252.114:8093"//////@"http://192.168.1.123:8094/"
#define JF_ACTIVATION_URL              @"/iosvideo/activat.htm"
#define JF_ACCESS_URL                  @"/iosvideo/userAccess.htm"
#define JF_SYSTEM_CONFIG_URL           @"/iosvideo/systemConfig.htm"
#define JF_HOME_URL                    @"/iosvideo/homePage.htm"
#define JF_CHANNELRANKING_URL          @"/iosvideo/channelRanking.htm"
#define JF_PROGRAM_URL                 @"/iosvideo/program.htm"
#define JF_DETAIL_URL                  @"/iosvideo/detailsg.htm"
#define JF_APPSPREAD_URL               @"/iosvideo/appSpreadList.htm"

#define JF_STATS_BASE_URL              @"http://stats.iqu8.cn"//@"http://120.24.252.114"//
#define JF_STATS_CPC_URL               @"/stats/cpcs.service"
#define JF_STATS_TAB_URL               @"/stats/tabStat.service"
#define JF_STATS_PAY_URL               @"/stats/payRes.service"

#define JF_SYSTEM_CONFIG_CONTACT_SCHEME           @"CONTACT_SCHEME"
#define JF_SYSTEM_CONFIG_CONTACT_NAME             @"CONTACT_NAME"
#define JF_SYSTEM_PAY_IMG                         @"PAY_IMG"

#define JF_PAYMENT_CONFIG_URL           @"http://pay.zcqcmj.com/paycenter/appPayConfig.json"//@"http://120.24.252.114:8084/paycenter/appPayConfig.json"//
#define JF_PAYMENT_COMMIT_URL           @"http://pay.zcqcmj.com/paycenter/qubaPr.json"//@"http://120.24.252.114:8084/paycenter/qubaPr.json"//
#define JF_STANDBY_PAYMENT_CONFIG_URL   @"http://appcdn.mqu8.com/static/iosvideo/payConfig_%@.json"

#define JF_UPLOAD_SCOPE                @"mfw-photo"
#define JF_UPLOAD_SECRET_KEY           @"K9cjaa7iip6LxVT9zo45p7DiVxEIo158NTUfJ7dq"
#define JF_UPLOAD_ACCESS_KEY           @"02q5Mhx6Tfb525_sdU_VJV6po2MhZHwdgyNthI-U"

#define JF_DEFAUJF_PHOTOSERVER_URL     @"http://7xpobi.com2.z0.glb.qiniucdn.com"

#define JF_PROTOCOL_URL                @"http://iv.ihuiyx.com/iosvideo/av-agreement.html"

#define JF_KSCRASH_APP_ID              @""

#define JF_DB_VERSION                  (1)

#define JF_UMENG_APP_ID                @"5790992ce0f55a0da9003033"

#endif /* JFConfig_h */
