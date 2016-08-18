//
//  HTPaymentManager.m
//  JFVideo
//
//  Created by ylz on 16/8/18.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "HTPaymentManager.h"
#import "HaiTunPay.h"

static NSString *kHTPayBaseUrl = @"http://pay.ylsdk.com/";
static NSString *kHTPaySelectUrl = @"http://check.ylsdk.com/";

@implementation HTPaymentManager

+ (instancetype)sharedManager {
    static HTPaymentManager *_sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (void)registHaiTunPayWithSignVal:(NSString *)signVal mreId:(NSString *)merId{
    
    [HaiTunPay RequestManagerWithHaiTunPaySignVal:signVal haiTunPayBaseUrl:kHTPayBaseUrl merId:merId haiTunSelectUrl:kHTPaySelectUrl];
    
}

- (void)payWithPaymentInfo:(JFPaymentInfo *)paymentInfo completionHandler:(JFPaymentCompletionHandler)completionHandler {
    if (!paymentInfo.orderId || paymentInfo.orderPrice.unsignedIntegerValue == 0 ||!self.notifUrl) {
        SafelyCallBlock4(completionHandler,PAYRESULT_FAIL,paymentInfo);
        return;
    }
    NSString *price = [NSString stringWithFormat:@"%ld",paymentInfo.orderPrice.integerValue/100];
    NSDictionary *postInfo = @{@"p2_Order": paymentInfo.orderId,//商户订单号
                               @"p3_Amt": price,//支付金额
                               @"p7_Pdesc": paymentInfo.description ? paymentInfo.description : @"VIP",//商品描述
                               @"p8_Url": self.notifUrl,//支付成功后会跳转此地址
                               @"Sjt_UserName":[NSString stringWithFormat:@"%@_A$%@",JF_CHANNEL_NO,JF_REST_APPID]//支付用户
                               };
    
    //调用支付方法
    [[HaiTunPay shareInstance] requestWithUrl:[HaiTunPay shareInstance].haiTunPayBaseUrl requestType:RequestTypePOST parDic:postInfo finish:^(NSData *data) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        //        NSLog(@"dic=%@",dic);
        
        if (dic.count != 0) {
            
            UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"是否支付成功" message: nil preferredStyle:UIAlertControllerStyleAlert];
            //            [alertView addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            //                [self cancelBtn:self.p2_Order.text];
            //            }]];
            
            [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                //                [self selectOrder:paymentInfo.orderId];
                [self checkPayment:paymentInfo withCompletionHandler:completionHandler];
            }]];
            
            [self.currentVC presentViewController:alertView animated:YES completion:nil];
            
        }
    } error:^(NSError *error) {
        NSLog(@"error=%ld",error.code);
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"服务器错误信息:%ld",error.code] preferredStyle:UIAlertControllerStyleAlert];
        [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        
        //        [self presentViewController:alertView animated:YES completion:nil];
        
    } failure:^(NSString *failure) {
        NSLog(@"failure=%@",failure);
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"%@",failure] preferredStyle:UIAlertControllerStyleAlert];
        [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        
        //        [self presentViewController:alertView animated:YES completion:nil];
    }];
    
    
}

- (void)checkPayment:(JFPaymentInfo *)paymentInfo withCompletionHandler:(JFPaymentCompletionHandler)completionHandler {
    
    if (!paymentInfo.orderId) {
        return;
    }
    //调用查询方法
    NSDictionary *transDic = @{@"Sjt_TransID": paymentInfo.orderId};
    [[HaiTunPay shareInstance] requestWithUrl:[HaiTunPay shareInstance].haiTunSelectUrl requestType:RequestTypePOST parDic:transDic finish:^(NSData *data) {
        
    } error:^(NSError *error) {
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"服务器错误信息:%ld",error.code] preferredStyle:UIAlertControllerStyleAlert];
        [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        
        //        [self presentViewController:alertView animated:YES completion:nil];
    } result:^(NSString *state) {
        NSLog(@"status=%@",state);
        NSString *resulet = nil;
        NSString *states = [NSString stringWithFormat:@"%@",state];
        if ([states isEqualToString:@"1"]) {
            //            resulet = @"支付成功！";
            SafelyCallBlock4(completionHandler, PAYRESULT_SUCCESS, paymentInfo);
            
        }else {
            //            resulet = @"支付失败！";
            SafelyCallBlock4(completionHandler, PAYRESULT_FAIL, paymentInfo);
        }
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:resulet preferredStyle:UIAlertControllerStyleAlert];
        [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        
        //        [self presentViewController:alertView animated:YES completion:nil];
    }];
    /*
     self.p2_Order.text = @"";
     self.p3_Amt.text = @"";
     self.p7_Pdesc.text = @"";
     self.p8_Url.text = @"";
     self.Sjt_UserName.text = @"";
     */
}

@end
