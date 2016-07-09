//
//  JFBaseViewController.m
//  JFVideo
//
//  Created by Liang on 16/6/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFBaseViewController.h"
#import "JFPaymentViewController.h"

@interface JFBaseViewController ()

@end

@implementation JFBaseViewController

- (instancetype)initWithTitle:(NSString *)title {
    self = [self init];
    if (self) {
        self.title = title;
    }
    return self;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)playVideoWithInfo:(JFBaseModel *)model videoUrl:(NSString *)videoUrlStr {
    if (![JFUtil isVip]) {
        [self payWithInfo:nil];
    } else {
        
    }
}

- (void)payWithInfo:(JFBaseModel *)model {
    [[JFPaymentViewController sharedPaymentVC] popupPaymentInView:self.view.window
                                                        baseModel:model
                                            withCompletionHandler:nil];
}

@end
