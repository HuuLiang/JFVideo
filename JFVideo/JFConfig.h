//
//  JFConfig.h
//  JFVideo
//
//  Created by Liang on 16/6/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#ifndef JFConfig_h
#define JFConfig_h

#define JF_CHANNEL_NO               @"QB_FORUM_QUDAO_B_00000001" //@"QB_MFW_IOS_TEST_0000001" //
#define JF_REST_APPID               @"QUBA_2021"
#define JF_REST_PV                  @"100"
#define JF_PACKAGE_CERTIFICATE      @"iPhone Distribution: Neijiang Fenghuang Enterprise (Group) Co., JFd."

#define JF_REST_APP_VERSION     ((NSString *)([NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"]))
#define JF_PAYMENT_RESERVE_DATA [NSString stringWithFormat:@"%@$%@", JF_REST_APPID, JF_CHANNEL_NO]

#define JF_BASE_URL                    @"http://120.24.252.114:8096"//@"http://mfw.ihuiyx.com"////@"http://192.168.1.123:8094/"
#define JF_ACTIVATION_URL              @"/forum/activat.htm"
#define JF_ACCESS_URL                  @"/forum/userAccess.htm"
#define JF_SYSTEM_CONFIG_URL           @"/forum/systemConfig.htm"
#define JF_HOME_URL                    @"/forum/homePage.htm"
#define JF_COMMUNITY_URL               @"/forum/column.htm"
#define JF_PROGRAM_URL                 @"/forum/program.htm"
#define JF_DETAIL_URL                  @"/forum/idetails.htm"
#define JF_APPSPREAD_URL               @"/forum/iappSpreadList.htm"


#define JF_PAYMENT_CONFIG_URL           @"http://120.24.252.114:8084/paycenter/payConfig.json"//@"http://pay.iqu8.net/paycenter/payConfig.json"
#define JF_PAYMENT_COMMIT_URL           @"http://120.24.252.114:8084/paycenter/qubaPr.json"//@"http://pay.iqu8.net/paycenter/qubaPr.json"

#define JF_UPLOAD_SCOPE                @"mfw-photo"
#define JF_UPLOAD_SECRET_KEY           @"K9cjaa7iip6LxVT9zo45p7DiVxEIo158NTUfJ7dq"
#define JF_UPLOAD_ACCESS_KEY           @"02q5Mhx6Tfb525_sdU_VJV6po2MhZHwdgyNthI-U"

#define JF_DEFAUJF_PHOTOSERVER_URL     @"http://7xpobi.com2.z0.glb.qiniucdn.com"

#define JF_UMENG_APP_ID                @""
#define JF_KSCRASH_APP_ID              @""

#define JF_DB_VERSION                  (1)

#endif /* JFConfig_h */
