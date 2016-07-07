//
//  JFChannelProgramCell.m
//  JFVideo
//
//  Created by Liang on 16/7/6.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFChannelProgramCell.h"

@interface JFChannelProgramCell ()
{
    UIImageView *_bgImgv;
    UILabel *_titleLabel;
}
@end

@implementation JFChannelProgramCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#464646"];
        
        _bgImgv = [[UIImageView alloc] init];
        [self addSubview:_bgImgv];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:14.];
        [self addSubview:_titleLabel];
        {
            [_bgImgv mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.equalTo(self);
                make.height.mas_equalTo((SCREEN_WIDTH-25)/3 * 300 / 227.);
            }];
            
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_bgImgv.mas_bottom).offset(5);
                make.left.equalTo(self).offset(5);
                make.height.mas_equalTo(20);
            }];
            
        }
    }
    return self;
}

- (void)setImgUrl:(NSString *)imgUrl {
    [_bgImgv sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
}

- (void)setTitle:(NSString *)title {
    _titleLabel.text = title;
}

@end
