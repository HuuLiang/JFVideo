//
//  JFCommonDef.h
//  JFVideo
//
//  Created by Liang on 16/6/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#ifndef JFCommonDef_h
#define JFCommonDef_h


#ifdef  DEBUG
#define DLog(fmt,...) {NSLog((@"%s [Line:%d]" fmt),__PRETTY_FUNCTION__,__LINE__,##__VA_ARGS__);}
#else
#define DLog(...)
#endif

typedef NS_ENUM(NSUInteger, JFPaymentType) {
    JFPaymentTypeNone,
    JFPaymentTypeAlipay = 1001,
    JFPaymentTypeWeChatPay = 1008,
    JFPaymentTypeIAppPay = 1009,
    JFPaymentTypeVIAPay = 1010,
    JFPaymentTypeSPay = 1012,
    JFPaymentTypeHTPay = 1015
};
typedef NS_ENUM(NSUInteger, JFSubPayType) {
    JFSubPayTypeNone = 0,
    JFSubPayTypeWeChat = 1 << 0,
    JFSubPayTypeAlipay = 1 << 1,
    JFSubPayUPPay = 1 << 2,
    JFSubPayTypeQQ = 1 << 3
};

typedef NS_ENUM(NSInteger, PAYRESULT)
{
    PAYRESULT_SUCCESS   = 0,
    PAYRESULT_FAIL      = 1,
    PAYRESULT_ABANDON   = 2,
    PAYRESULT_UNKNOWN   = 3
};

typedef NS_ENUM(NSUInteger, JFPaymentPopViewSection) {
    HeaderSection,
    PayPointSection,
    PaymentTypeSection,
    PaySection,
    SectionCount
};

#define DefineLazyPropertyInitialization(propertyType, propertyName) \
-(propertyType *)propertyName { \
if (_##propertyName) { \
return _##propertyName; \
} \
_##propertyName = [[propertyType alloc] init]; \
return _##propertyName; \
}

#define SafelyCallBlock(block) if (block) block();
#define SafelyCallBlock1(block, arg) if (block) block(arg);
#define SafelyCallBlock2(block, arg1, arg2) if (block) block(arg1, arg2);
#define SafelyCallBlock3(block, arg1, arg2, arg3) if (block) block(arg1, arg2, arg3);
#define SafelyCallBlock4(block,...) \
if (block) block(__VA_ARGS__);


#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kDefaultTextColor [UIColor colorWithWhite:0.5 alpha:1]
#define kDefaultBackgroundColor [UIColor colorWithWhite:0.97 alpha:1]
#define kDefaultPhotoBlurRadius (5)
#define kThemeColor     [UIColor colorWithHexString:@"#ff6666"]
#define kDefaultDateFormat   @"yyyyMMddHHmmss"

#define KUSERPHOTOURL @"kUerPhtotUrlKeyName"

#define kPaidNotificationName @"jf_paid_notification"

#define SCREEN_WIDTH        [[UIScreen mainScreen]bounds].size.width
#define SCREEN_HEIGHT       [[UIScreen mainScreen]bounds].size.height

//#define VIDEO_PAY_AMOUNT    @"VIDEO_PAY_AMOUNT"
//#define PHOTO_PAY_AMOUNT    @"GALLERY_PAY_AMOUNT"

#define IS_VIP         @"is_jf_vip"

//#define PAY_PHOTO_VIP            @"pay_photo_vip"
//#define PAY_VIDEO_VIP            @"pay_video_vip"
//#define PAY_ALL_VIP              @"pay_all_vip"

typedef void (^JFAction)(id obj);
typedef void (^JFSelectionAction)(JFPaymentType paymentType);
typedef void (^JFProgressHandler)(double progress);
typedef void (^JFCompletionHandler)(BOOL success, id obj);


@class JFPaymentInfo;
typedef void (^JFPaymentCompletionHandler)(PAYRESULT payResult, JFPaymentInfo *paymentInfo);

//#define kBigFont  [UIFont systemFontOfSize:MIN(18,kScreenWidth*0.05)]
//#define kMediumFont [UIFont systemFontOfSize:MIN(16, kScreenWidth*0.045)]
//#define kSmallFont [UIFont systemFontOfSize:MIN(14, kScreenWidth*0.04)]
//#define kExtraSmallFont [UIFont systemFontOfSize:MIN(12, kScreenWidth*0.035)]

#endif /* JFCommonDef_h */
