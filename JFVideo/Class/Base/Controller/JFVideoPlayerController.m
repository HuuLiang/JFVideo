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
    [self.view addSubview:_videoPlayer];
    {
        [_videoPlayer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }

    [_videoPlayer startToPlay];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
