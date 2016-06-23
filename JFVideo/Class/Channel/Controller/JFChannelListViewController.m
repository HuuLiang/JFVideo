//
//  JFChannelListViewController.m
//  JFVideo
//
//  Created by Liang on 16/6/23.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JFChannelListViewController.h"
#import "JFChannelViewController.h"
#import "SlideHeadView.h"
#import "JFChannelViewController.h"


@interface JFChannelListViewController ()
@property (nonatomic) NSMutableArray *dataSource;
@end

@implementation JFChannelListViewController

DefineLazyPropertyInitialization(NSMutableArray, dataSource)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    SlideHeadView *SlideVC = [[SlideHeadView alloc] init];
    [self.view addSubview:SlideVC];
    
    [self.dataSource removeAllObjects];
    
//    for (NSInteger i = 0; i < _model.columnList.count; i++) {
//        JFChannelViewController *baseVC = [[JFChannelViewController alloc] initWithColumn:_model.columnList[i]];
//        LTCommunityColumnModel *model = _model.columnList[i];
//        [_dataSource addObject:model.name];
//        [SlideVC addChildViewController:baseVC title:model.name];
//    }
//    SlideVC.titlesArr = _dataSource;
//    [SlideVC setSlideHeadView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
