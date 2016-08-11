//
//  QJPayWithBaiduPay.h
//  QJPayWithBaiduPay
//
//  Created by 赵建国 on 16/6/6.
//  Copyright © 2016年 QianEn payment technology co., LTD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QJPayWithBaiduPay : NSObject

+ (void)QJCallBaiDuWithParms:(NSString *)orderInfo andParams:(NSDictionary *)params  andRootViewController:(UIViewController *)rootVC response:(void(^)(int statusCode,NSString*payDesc))responseBlock;

@end
