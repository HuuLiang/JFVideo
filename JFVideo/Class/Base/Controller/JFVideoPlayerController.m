//
//  JFVideoPlayerController.m
//  JFVideo
//
//  Created by Liang on 16/6/25.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFVideoPlayerController.h"
#import "JFVideoPlayer.h"

@interface JFVideoPlayerController ()
{
    JFVideoPlayer *_videoPlayer;
    UIButton *_closeButton;
}
@end

@implementation JFVideoPlayerController

- (instancetype)initWithVideo:(NSString *)videoUrl {
    self = [self init];
    if (self) {
        _videoUrl = videoUrl;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    _videoPlayer = [[JFVideoPlayer alloc] initWithVideoURL:[NSURL URLWithString:_videoUrl]];
    @weakify(self);
    _videoPlayer.endPlayAction = ^(id sender) {
        @strongify(self);
        [self dismissAndPopPayment];
    };
    [self.view addSubview:_videoPlayer];
    {
        [_videoPlayer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }

    [_videoPlayer startToPlay];
    
    _closeButton = [[UIButton alloc] init];
    [_closeButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [self.view addSubview:_closeButton];
    {
        [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(15);
            make.top.equalTo(self.view).offset(30);
        }];
    }
    
    [_closeButton bk_addEventHandler:^(id sender) {
        @strongify(self);
        [self->_videoPlayer pause];
        
        [self dismissAndPopPayment];
        [self dismissViewControllerAnimated:YES completion:nil];
    } forControlEvents:UIControlEventTouchUpInside];
}


- (void)dismissAndPopPayment {
    if ([JFUtil isVip]) {
        return;
    }
    [self payWithInfo:self.baseModel];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

@end
