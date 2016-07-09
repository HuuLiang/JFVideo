    //
//  JFPaymentButton.m
//  JFVideo
//
//  Created by Liang on 16/7/9.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFPaymentButton.h"

@implementation JFPaymentButton

- (instancetype)init {
    self = [super init];
    if (self) {
        self.layer.masksToBounds = YES;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.numberOfLines = 2;
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    const CGFloat height = CGRectGetHeight(contentRect) * 0.8;
    return CGRectMake(5, (contentRect.size.height - height)/2, height, height);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    CGRect imageRect = [self imageRectForContentRect:contentRect];
    const CGFloat height = imageRect.size.height;
    const CGFloat x = CGRectGetMaxX(imageRect);
    return CGRectMake(x, (contentRect.size.height - height)/2, contentRect.size.width-x-5, height);
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.layer.cornerRadius = CGRectGetHeight(self.bounds)/2;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:MIN(CGRectGetWidth(self.bounds) * 0.11,20)];
}


@end
