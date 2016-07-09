//
//  JFPaymentTypeCell.m
//  JFVideo
//
//  Created by Liang on 16/7/9.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFPaymentTypeCell.h"
#import "JFPaymentButton.h"

@interface JFPaymentTypeCell ()
@property (nonatomic,retain) NSMutableArray<JFPaymentButton *> *buttons;
@end

@implementation JFPaymentTypeCell

DefineLazyPropertyInitialization(NSMutableArray, buttons)

- (void)setAvailablePaymentTypes:(NSArray *)availablePaymentTypes {
    if ([availablePaymentTypes isEqualToArray:_availablePaymentTypes]) {
        return ;
    }
    
    _availablePaymentTypes = availablePaymentTypes;
    
    [self.buttons enumerateObjectsUsingBlock:^(JFPaymentButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self.buttons removeAllObjects];
    
    [availablePaymentTypes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JFPaymentType paymentType = [obj unsignedIntegerValue];
        
        JFPaymentButton *button = [[JFPaymentButton alloc] init];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        if (paymentType == TKPaymentTypeAlipay) {
            [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#02a0e9"]] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"alipay_icon"] forState:UIControlStateNormal];
            [button setTitle:@"支付宝支付" forState:UIControlStateNormal];
        } else if (paymentType == TKPaymentTypeWeChatPay) {
            [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#05c30b"]] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"wechat_icon"] forState:UIControlStateNormal];
            [button setTitle:@"微信支付" forState:UIControlStateNormal];
        } else {
            return ;
        }
        [self.buttons addObject:button];
        [self addSubview:button];
        
        @weakify(self);
        [button bk_addEventHandler:^(id sender) {
            @strongify(self);
            SafelyCallBlock2(self.selectionAction, idx, sender);
        } forControlEvents:UIControlEventTouchUpInside];
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    const CGFloat interItemSpacing = 15;
    const CGFloat buttonWidth = self.buttons.count == 0 ? 0 : (CGRectGetWidth(self.bounds) - (self.buttons.count + 1) * interItemSpacing) / self.buttons.count;
    const CGFloat buttonHeight = CGRectGetHeight(self.bounds) * 0.6;
    const CGFloat buttonY = (CGRectGetHeight(self.bounds) - buttonHeight) / 2;
    
    __block CGRect lastFrame = CGRectZero;
    [self.buttons enumerateObjectsUsingBlock:^(JFPaymentButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.frame = CGRectMake(CGRectGetMaxX(lastFrame) + interItemSpacing, buttonY, buttonWidth, buttonHeight);
        lastFrame = obj.frame;
    }];
}

@end
