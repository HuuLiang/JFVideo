//
//  polymerizationPaymentSDK.h
//  polymerizationPaymentSDK
//
//  Created by libo on 14-6-5.
//
//

#import <UIKit/UIKit.h>

@protocol BDWalletSDKLoginDelegate;

/**
 * @brief   聚合收银台支付结果类型
 */
typedef enum
{
    Pay_Success        = 0,     //支付成功
    Pay_Loading        = 1,     //支付中
    Pay_Cancel         = 2,     //支付取消
    Pay_Failure        = 3,     //支付失败
}BDWalletSDKPayStateCode;

/**
 * @brief   进入SDK返回的错误类型
 */
typedef enum {
    BDPolymerWalletSDK_Error_None              = 0,    // 无错
    BDPolymerWalletSDK_Error_Net               = 1,    // 网络异常
    BDPolymerWalletSDK_Error_InvalidDelegate   = 3,    // 传入无效Delegate
    BDPolymerWalletSDK_Error_Other             = 5,    // 其他未知错误
    BDPolymerWalletSDK_Error_Params            = 6,    // params参数错误
}BDPolymerWalletSDKErrorType;

/**
 * @brief   支付渠道类型
 */
typedef enum {
    BDPolymerWalletSDK_SelectedPayChannel_Baifubao_Card = 0,    // 百度钱包常用卡
    BDPolymerWalletSDK_SelectedPayChannel_Baifubao      = 1,    // 百度钱包
    BDPolymerWalletSDK_SelectedPayChannel_Alipay        = 2,    // 支付宝
    BDPolymerWalletSDK_SelectedPayChannel_Quickpay      = 3,    // 快钱
    BDPolymerWalletSDK_SelectedPayChannel_Unionpay      = 4,    // 银联
    BDPolymerWalletSDK_SelectedPayChannel_Wechat        = 5,    // 微信
    BDPolymerWalletSDK_SelectedPayChannel_None          = -1,   // 无
}BDPolymerWalletSDKSelectedPayChannelType;

/**
 * @brief   聚合收银台Delegate
 */
@protocol BDPolymerWalletSDKMainManagerDelegate <NSObject>

@required
/**
 * @brief   支付回调接口
 * @param   statusCode           支付结果类型
 * @param   payDescs             支付结果表述
 */
-(void)BDPolymerWalletPayResultWithCode:(BDWalletSDKPayStateCode)statusCode payDesc:(NSString*)payDescs;

@optional

/**
 * @brief   百度钱包使用 - 是否登录
 */
- (BOOL)isLogin;

/**
 * @brief   百度钱包使用 - 登录接口
 * @param
 */
- (void)loginWithDelegate:(id<BDWalletSDKLoginDelegate>)loginDelegate withController:(UIViewController*)controller;

/**
 * @brief   百度钱包使用 - 获取loginToken
 */
- (NSString *)getLoginToken;

/**
 * @brief   百度钱包使用 - 异常处理
 */
-(void)handleWalletErrorWithCode:(int)errorCode;

/**
 * @brief   百度钱包使用 - 帐号正常化回调
 */
-(void)onLoginChanaged:(NSDictionary*)dict;

/**
 * @brief   百度钱包使用 - 应用版本号
 */
- (NSString*)getAppVersion;

/**
 * @brief   百度钱包使用 - 获取手机唯一标识
 */
- (NSString *)getDeviceIdentifier;

/**
 * @brief   百度钱包使用 - 统计接口
 */
- (void)logPolymerEventId:(NSString*)eventId eventDesc:(NSString*)eventDesc;


/**
 * @brief   内嵌聚合收银台使用 - 加载内嵌收银台页面成功回调
 */
-(void)BDWalletAddViewSuccess;

/**
 * @brief   内嵌聚合收银台使用 - 加载内嵌收银台页面失败回调
 */
-(void)BDWalletAddViewFailed;

/**
 * @brief   内嵌聚合收银台使用 - 开始支付回调
 */
-(void)BDWalletBeginDoPay;

/**
 * @brief   内嵌聚合收银台使用 - 结束支付回调
 */
-(void)BDWalletEndDoPay;

/**
 * @brief   内嵌聚合收银台使用 - 内嵌收银台控件高度变化回调
 * @param   heightValue          控件高度
 */
-(void)BDWalletViewHeightChanged:(CGFloat)heightValue;

/**
 * @brief   内嵌聚合收银台使用 - 当前选中支付渠道回调
 * @param   payChannelType    支付渠道
 */
-(void)BDWalletSelectedPayChannel:(BDPolymerWalletSDKSelectedPayChannelType)payChannelType;

@end

@interface BDPolymerWalletSDKMainManager : NSObject
{
    NSString *_alixpayAppScheme;
}

/**
 * @brief   导航条背景图片，不设置使用默认背景图 1、设置背景图片 聚合收银台presentViewController有效 2、百度钱包有效 - 聚合收银台进入
 */
@property(nonatomic,strong)UIImage *bdWalletNavBgImage;

/**
 * @brief   返回按扭，不设置使用默认返回按扭
 */
@property(nonatomic,strong)UIImage *bdWalletNavBackNormalImage;

/**
 * @brief   设置导航条Title颜色，不设置使用默认Title颜色  1、聚合收银台presentViewController有效 2、百度钱包有效- 聚合收银台进入
 */
@property (nonatomic, strong)UIColor *bdWalletNavTitleColor;

/**
 * @brief   导航导航条Title字体 设置导航导航条Title字体 如果不设置使用默认Title字体
 */
@property (nonatomic, strong)UIFont *bdWalletNavTitleFont;

/**
 * @brief   导航条背景颜色，不设置使用默认颜色
 */
@property (nonatomic, strong) UIColor *bdWalletNavColor;

/**
 * @brief   导航条左边返回按扭按下态 如果不设置会使用默认返回按扭按下态
 */
@property(nonatomic,strong)UIImage *bdWalletNavBackHighlightImage;

/**
 * @brief   导航条左边返回文字偏移量
 */
@property (nonatomic, assign)UIEdgeInsets bdWalletNavBacktitleEdgeInset;

/**
 * @brief   导航条左边返回图片偏移量
 */
@property (nonatomic, assign)UIEdgeInsets bdWalletNavBackimageEdgeInset;

/**
 * @brief   支付宝回调Scheme值
 */
@property(nonatomic,copy)NSString *alixpayAppScheme;

// 对外不可见
@property (nonatomic, weak) id<BDPolymerWalletSDKMainManagerDelegate> polymerDelegate;

/**
 * @brief   聚合收银台单例
 */
+(BDPolymerWalletSDKMainManager*)getInstance;

/**
 * @brief   聚合收银台根视图控制器
 */
@property(nonatomic, weak)UIViewController  *sdkRootController;

/**
 * @brief   聚合支付接口
 * @param     delegateT           聚合收银台委托
 * @param     params              订单信息
 */
-(BDPolymerWalletSDKErrorType)doPolymerPay:(id<BDPolymerWalletSDKMainManagerDelegate>)delegateT params:(NSDictionary*)params;

/**
 * @brief   处理第三方支付调转回来的结果
 * @param   resultDic           支付结果信息
 */
-(BOOL)handleResDic:(NSDictionary*)resultDic;

/**
 * @brief   获取内嵌控件 （每次拿都会生成新的控件，刷新调refreshEmbeddedPolymerPayView接口）
 * @param   delegateT           聚合收银台委托
 */
-(UIView*)getEmbeddedPolymerPayView:(id<BDPolymerWalletSDKMainManagerDelegate>)delegateT params:(NSDictionary*)params;

/**
 * @brief   内嵌调用支付
 * @param   delegateT           聚合收银台委托
 */
-(BDPolymerWalletSDKErrorType)doEmbeddedPolymerPay:(id<BDPolymerWalletSDKMainManagerDelegate>)delegateT;

/**
 * @brief   内嵌调用支付 - 支付时订单信息变更时调用（该订单信息需要重新签名）
 * @param   delegateT           聚合收银台委托
 */
-(BDPolymerWalletSDKErrorType)doEmbeddedPolymerPay:(id<BDPolymerWalletSDKMainManagerDelegate>)delegateT params:(NSDictionary*)params;

/**
 * @brief   刷新内嵌收银台控件
 * @param   params           订单信息
 */
-(void)refreshEmbeddedPolymerPayView:(NSDictionary*)params;

/**
 * @brief   刷新百度钱包优惠文案
 * @param     params           订单信息
 */
-(void)refreshPromotion:(NSDictionary*)params;

/**
 * @brief   直接调用第三方支付接口(暂时只支持支付宝，微信)
 * @param   params           订单信息
 */
-(BDPolymerWalletSDKErrorType)doDirectCallThirdPay:(id<BDPolymerWalletSDKMainManagerDelegate>)delegateT params:(NSDictionary*)params WithReqData:(id)reqDataParams;

@end


