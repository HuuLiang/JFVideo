//
//  JFWebViewController.h
//  JFVideo
//
//  Created by Liang on 16/6/23.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFBaseViewController.h"

@interface JFWebViewController : JFBaseViewController
@property (nonatomic) NSURL *url;
- (instancetype)initWithURL:(NSURL *)url;
@end
