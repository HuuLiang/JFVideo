//
//  JFPaymentTypeCell.m
//  JFVideo
//
//  Created by Liang on 16/7/9.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFPaymentTypeCell.h"


@interface JFPaymentTypeCell ()
{
    UIImageView *_imgV;
    UILabel *_label;
}
@end

@implementation JFPaymentTypeCell

- (instancetype)initWithPaymentType:(JFPaymentType)paymentType
{
    self = [super init];
    if (self) {
        self.payType = paymentType;
        
        self.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _chooseBtn.layer.cornerRadius = 20;
        _chooseBtn.layer.masksToBounds = YES;
        [_chooseBtn setImage:[UIImage imageNamed:@"choose_normal"] forState:UIControlStateNormal];
        [_chooseBtn setImage:[UIImage imageNamed:@"choose_selected"] forState:UIControlStateSelected];
        [self addSubview:_chooseBtn];
        
        [_chooseBtn bk_addEventHandler:^(id sender) {
            _selectionAction(paymentType);
        } forControlEvents:UIControlEventTouchUpInside];
        
        NSString *imageName = @"";
        NSString *text = @"";
        if (paymentType == JFPaymentTypeAlipay) {
            imageName = @"alipay_icon";
            text = @"支付宝支付";
        }else if(paymentType == JFPaymentTypeWeChatPay){
            imageName = @"wechat_icon";
            text = @"微信支付";
        }else if (paymentType == JFPaymentTypeIAppPay){
            imageName = @"card_pay_icon";
            text = @"购卡支付";
        }
        
        _imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        [self addSubview:_imgV];
        
        _label = [[UILabel alloc] init];
        _label.text = text;//JFPaymentTypeAlipay == paymentType ? @"支付宝支付" : @"微信支付";
        _label.textColor = [UIColor colorWithHexString:@"#333333"];
        _label.font = [UIFont systemFontOfSize:14.];
        _label.backgroundColor = [UIColor clearColor];
        [self addSubview:_label];
        
        {
            [_chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.left.equalTo(self).offset(10);
                make.size.mas_equalTo(CGSizeMake(40, 40));
            }];
            
            [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.left.equalTo(_chooseBtn.mas_right).offset(5);
                make.size.mas_equalTo(CGSizeMake(25, 25));
            }];
            
            [_label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
                make.left.equalTo(_imgV.mas_right).offset(10);
                make.right.equalTo(self);
                make.height.mas_equalTo(20);
            }];
        }
    }
    return self;
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated {
    _chooseBtn.selected = selected;
}

@end
