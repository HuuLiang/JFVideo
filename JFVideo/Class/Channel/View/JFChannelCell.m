//
//  JFChannelCell.m
//  JFVideo
//
//  Created by Liang on 16/7/6.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFChannelCell.h"

@interface JFChannelCell ()
{
    UIImageView *_bgImgv;
    
    UIImageView *_rankImgV;
    UILabel *_rankLabel;
    
    UIImageView*_titleImgV;
    UILabel *_titleLabel;
    
    UIImageView *_hotImgv;
    UILabel *_hotLabel;
}
@end

@implementation JFChannelCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"channel_bgimg_icon"]];
        [self addSubview:imageV];
        
        _bgImgv = [[UIImageView alloc] init];
        _bgImgv.layer.cornerRadius = kScreenHeight * 8 / 1334.;
        _bgImgv.layer.masksToBounds = YES;
        [self addSubview:_bgImgv];
        
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.45];
        bgView.layer.masksToBounds = YES;
        [_bgImgv addSubview:bgView];
        
        _rankImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"channel_rank_icon"]];
        [self addSubview:_rankImgV];
        
        _rankLabel = [[UILabel alloc] init];
        _rankLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        _rankLabel.font = [UIFont systemFontOfSize:kScreenWidth * 28 / 750.];
        [self addSubview:_rankLabel];
        
        _titleImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"channel_titleimg_icon"]];
        [self addSubview:_titleImgV];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:14.];
        [_titleImgV addSubview:_titleLabel];
        
        _hotImgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"channel_hot_icon"]];
        [self addSubview:_hotImgv];
        
        _hotLabel = [[UILabel alloc] init];
        _hotLabel.textColor = [UIColor colorWithHexString:@"#d2d2d2"];
        _hotLabel.font = [UIFont systemFontOfSize:kScreenWidth * 20 / 750.];
        [self addSubview:_hotLabel];
        
        {
            [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(self);
                make.size.mas_equalTo(CGSizeMake(kScreenWidth * 360 / 750., kScreenHeight * 452 / 1334.));
            }];
            
            [_bgImgv mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
            
            [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(_bgImgv);
            }];
            
            [_rankImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(kScreenWidth * 10 / 750.);
                make.top.equalTo(self).offset(kScreenHeight * 10 / 1334.);
                make.size.mas_equalTo(CGSizeMake(kScreenWidth * 26./750, kScreenHeight * 34./1334.));
            }];
            
            [_rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_rankImgV.mas_right).offset(kScreenWidth * 10 /750.);
                make.centerY.equalTo(_rankImgV);
                make.height.mas_equalTo(kScreenHeight * 34 / 1334.);
            }];
            
            [_titleImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.bottom.equalTo(self).offset(-kScreenHeight * 60 / 1334.);
                make.size.mas_equalTo(CGSizeMake(kScreenWidth * 220./750, kScreenHeight * 71./1334.));
            }];
    
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(_titleImgV);
                make.left.equalTo(_titleImgV).offset(3);
                make.right.equalTo(_titleImgV).offset(-3);
                make.height.mas_equalTo(kScreenHeight * 60 / 1334.);
            }];
            
            [_hotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self).offset(-kScreenWidth * 10 /750.);
                make.bottom.equalTo(self).offset(-kScreenHeight * 10 / 1334.);
                make.height.mas_equalTo(kScreenHeight * 30 / 1334.);
            }];
            
            [_hotImgv mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(_hotLabel.mas_left).offset(-kScreenWidth * 10 /750.);
                make.centerY.equalTo(_hotLabel);
                make.size.mas_equalTo(CGSizeMake(kScreenWidth * 26./750, kScreenHeight * 34./1334.));
                
            }];
        }
    }
    return self;
}

- (void)updateCellWithInfo:(JFChannelColumnModel *)columnModel {
    
}

- (void)setImgUrl:(NSString *)imgUrl {
    [_bgImgv sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
}

- (void)setTitle:(NSString *)title {
    _titleLabel.text = title;
}
@end
