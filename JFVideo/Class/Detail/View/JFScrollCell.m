//
//  JFScrollCell.m
//  JFVideo
//
//  Created by Liang on 16/6/24.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFScrollCell.h"

@interface JFScrollCell ()
{
    UIImageView *_bgImgV;
}
@end

@implementation JFScrollCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _bgImgV = [[UIImageView alloc] init];
        [self addSubview:_bgImgV];
        
        {
            [_bgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
        }
    }
    return self;
}

@end
