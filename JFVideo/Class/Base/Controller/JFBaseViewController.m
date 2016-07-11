//
//  JFBaseViewController.m
//  JFVideo
//
//  Created by Liang on 16/6/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFBaseViewController.h"
#import "JFPaymentViewController.h"
#import "JFVideoPlayerController.h"
#import <MWPhotoBrowser.h>
#import "JFDetailModel.h"

static const void* kPhotoNumberAssociatedKey = &kPhotoNumberAssociatedKey;

@interface JFBaseViewController () <MWPhotoBrowserDelegate>

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
        [self payWithInfo:model];
    } else {
        JFVideoPlayerController *videoVC = [[JFVideoPlayerController alloc] initWithVideo:videoUrlStr];
        [self.navigationController pushViewController:videoVC animated:YES];
    }
}

- (void)playPhotoUrlWithInfo:(JFBaseModel *)model urlArray:(NSArray *)urlArray index:(NSInteger)index {
    if (![JFUtil isVip]) {
        [UIAlertView bk_showAlertViewWithTitle:@"非VIP用户只能浏览小图哦" message:@"开通VIP,高清大图即刻欣赏" cancelButtonTitle:@"再考虑看看" otherButtonTitles:@[@"立即开通"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex == 1) {
                [self payWithInfo:model];
            }
        }];
    } else {
        NSMutableArray<MWPhoto *> *photos = [[NSMutableArray alloc] initWithCapacity:urlArray.count];
        [urlArray enumerateObjectsUsingBlock:^(JFDetailPhotoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:obj.url]]];
        }];
        
        MWPhotoBrowser *photoBrowser = [[MWPhotoBrowser alloc] initWithPhotos:photos];
        photoBrowser.displayActionButton = NO;
        photoBrowser.delegate = self;
        objc_setAssociatedObject(photoBrowser, kPhotoNumberAssociatedKey, @(photos.count), OBJC_ASSOCIATION_COPY_NONATOMIC);
        [photoBrowser setCurrentPhotoIndex:index];
        [self.navigationController pushViewController:photoBrowser animated:YES];
    }
}

- (void)payWithInfo:(JFBaseModel *)model {
    [[JFPaymentViewController sharedPaymentVC] popupPaymentInView:self.view.window
                                                        baseModel:model
                                            withCompletionHandler:nil];
}

@end
