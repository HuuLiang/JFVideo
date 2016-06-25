//
//  JFCommentCell.m
//  JFVideo
//
//  Created by Liang on 16/6/25.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFCommentCell.h"

@interface JFCommentCell ()
{
    UIImageView *_userImgV;
    UILabel *_userNameLabel;
    UILabel *_timeLabel;
    UILabel *_commentDetailLabel;
}
@end

@implementation JFCommentCell

- (instancetype)initWithHeight:(CGFloat)height
{
    self = [super init];
    if (self) {
        
        _userImgV = [[UIImageView alloc] init];
        _userImgV.layer.cornerRadius = 19.5;
        _userImgV.layer.masksToBounds = YES;
        [self addSubview:_userImgV];
        
        _userNameLabel = [[UILabel alloc] init];
        _userNameLabel.textColor = [[UIColor colorWithHexString:@"#ffffff"] colorWithAlphaComponent:0.54];;
        _userNameLabel.textAlignment = NSTextAlignmentCenter;
        _userNameLabel.font = [UIFont systemFontOfSize:13.];
        [self addSubview:_userNameLabel];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [[UIColor colorWithHexString:@"#ffffff"] colorWithAlphaComponent:0.54];;
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.font = [UIFont systemFontOfSize:13.];
        [self addSubview:_timeLabel];
        
        _commentDetailLabel = [[UILabel alloc] init];
        _commentDetailLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        _commentDetailLabel.font = [UIFont systemFontOfSize:16.];
        [self addSubview:_commentDetailLabel];
        
        {
            [_userImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).offset(10);
                make.left.equalTo(self).offset(10);
                make.size.mas_equalTo(CGSizeMake(39, 39));
            }];
            
            [_userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(_userImgV.mas_centerY);
                make.left.equalTo(_userImgV.mas_right).offset(10);
                make.height.mas_equalTo(18);
            }];
            
            [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(_userImgV.mas_centerY);
                make.right.equalTo(self).offset(-10);
                make.height.mas_equalTo(18);
            }];
            
            [_commentDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_userImgV.mas_bottom).offset(10);
                make.left.equalTo(_userImgV.mas_right).offset(10);
                make.left.mas_equalTo(height);
            }];
            
        }
        
    }
    return self;
}

@end
