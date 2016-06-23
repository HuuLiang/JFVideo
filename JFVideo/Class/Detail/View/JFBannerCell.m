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
        [self addSubview:_view];
        
        UIImageView *_icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detail_play_icon"]];
        [_view addSubview:_icon];
        
        {
            [_bgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.equalTo(self);
                make.height.mas_equalTo(SCREEN_WIDTH *0.6);
            }];
        }
        
    }
    return self;
}

@end
