//
//  JFBannerCell.m
//  JFVideo
//
//  Created by Liang on 16/6/23.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFBannerCell.h"

@interface JFBannerCell ()
{
    UIImageView *_bgImgV;
    UIImageView *_userImgV;
    UILabel *_titleLabel;
    UILabel *_playNumLabel;
}
@end

@implementation JFBannerCell

- (instancetype)initWithHeight:(CGFloat)height
{
    self = [super init];
    if (self) {
        
        
        _bgImgV = [[UIImageView alloc] init];
        _bgImgV.backgroundColor = [UIColor redColor];
        [self addSubview:_bgImgV];
        
        UIView *_view = [[UIView alloc] init];
        _view.backgroundColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.3];
        [_bgImgV addSubview:_view];
        
        UIImageView *_icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detail_play_icon"]];
        [_view addSubview:_icon];
        
        _userImgV = [[UIImageView alloc] init];
        _userImgV.layer.cornerRadius = SCREEN_WIDTH*8/75.;
        _userImgV.layer.masksToBounds = YES;
        [self addSubview:_userImgV];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        _titleLabel.font = [UIFont systemFontOfSize:15.];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        _playNumLabel = [[UILabel alloc] init];
        _playNumLabel.textColor = [[UIColor colorWithHexString:@"#ffffff"] colorWithAlphaComponent:0/54];
        _playNumLabel.font = [UIFont systemFontOfSize:12.];
        _playNumLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_playNumLabel];
        
        
        {
            [_bgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.equalTo(self);
                make.height.mas_equalTo(SCREEN_WIDTH *0.6);
            }];
            
            [_view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(_bgImgV);
            }];
            
            [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(_view);
                make.size.mas_equalTo(CGSizeMake(40, 40));
            }];
            
            [_userImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(15);
                make.centerY.equalTo(_bgImgV.mas_bottom).offset(15);
                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH*16/75., SCREEN_WIDTH*16/75.));
            }];
            
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_bgImgV.mas_bottom).offset(15);
                make.centerX.equalTo(self);
                make.height.mas_equalTo(20);
            }];
            
            [_playNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_titleLabel.mas_bottom).offset(5);
                make.centerX.equalTo(self);
                make.height.mas_equalTo(15);
            }];
        }
        
    }
    return self;
}

- (void)setBgImgUrl:(NSString *)bgImgUrl {
    [_bgImgV sd_setImageWithURL:[NSURL URLWithString:bgImgUrl]];
    
    [_userImgV sd_setImageWithURL:[NSURL URLWithString:bgImgUrl]];
}

- (void)setTitle:(NSString *)title {
    _titleLabel.text = title;
}

- (void)setNum:(NSInteger)num {
    _playNumLabel.text = [NSString stringWithFormat:@"今日播放量:%ld",num];
}


@end
