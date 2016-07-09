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
    TKPaymentTypeAlipay = 1001,
    TKPaymentTypeWeChatPay = 1008,
    TKPaymentTypeIAppPay = 1009,
    TKPaymentTypeVIAPay = 1010,
    TKPaymentTypeSPay = 1012,
    TKPaymentTypeHTPay = 1015
};
typedef NS_ENUM(NSInteger, PAYRESULT)
{
    PAYRESULT_SUCCESS   = 0,
    PAYRESULT_FAIL      = 1,
    PAYRESULT_ABANDON   = 2,
    PAYRESULT_UNKNOWN   = 3
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


#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kDefaultTextColor [UIColor colorWithWhite:0.5 alpha:1]
#define kDefaultBackgroundColor [UIColor colorWithWhite:0.97 alpha:1]
#define kDefaultPhotoBlurRadius (5)
#define kThemeColor     [UIColor colorWithHexString:@"#ff6666"]
#define kDefaultDateFormat   @"yyyyMMddHHmmss"

#define KUSERPHOTOURL @"kUerPhtotUrlKeyName"



#define SCREEN_WIDTH        [[UIScreen mainScreen]bounds].size.width
#define SCREEN_HEIGHT       [[UIScreen mainScreen]bounds].size.height

//#define VIDEO_PAY_AMOUNT    @"VIDEO_PAY_AMOUNT"
//#define PHOTO_PAY_AMOUNT    @"GALLERY_PAY_AMOUNT"

#define IS_VIP         @"is_jf_vip"

//#define PAY_PHOTO_VIP            @"pay_photo_vip"
//#define PAY_VIDEO_VIP            @"pay_video_vip"
//#define PAY_ALL_VIP              @"pay_all_vip"

typedef void (^JFAction)(id obj);
typedef void (^JFSelectionAction)(NSUInteger index, id obj);
typedef void (^JFProgressHandler)(double progress);
typedef void (^JFCompletionHandler)(BOOL success, id obj);

@class JFPaymentInfo;
typedef void (^JFPaymentCompletionHandler)(PAYRESULT payResult, JFPaymentInfo *paymentInfo);

#endif /* JFCommonDef_h */
