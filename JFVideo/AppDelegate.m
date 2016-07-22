//
//  AppDelegate.m
//  JFVideo
//
//  Created by Liang on 16/6/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "AppDelegate.h"
#import "JFActivateModel.h"
#import "JFUserAccessModel.h"
#import "JFSystemConfigModel.h"
#import "JFHomeViewController.h"
#import "JFChannelListViewController.h"
#import "JFHotViewController.h"
#import "JFMineViewController.h"
#import "JFPaymentManager.h"
#import "MobClick.h"
#import "JFLaunchView.h"


@interface AppDelegate () <UITabBarControllerDelegate>
{
    UITabBarController *_tabBarController;
}

@end

@implementation AppDelegate

- (UIWindow *)window {
    if (_window) {
        return _window;
    }
    
    _window                              = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor              = [UIColor whiteColor];
    
    JFHomeViewController *homeVC        = [[JFHomeViewController alloc] init];
    homeVC.title                         = @"首页";
    UINavigationController *homeNav      = [[UINavigationController alloc] initWithRootViewController:homeVC];
    homeNav.tabBarItem                   = [[UITabBarItem alloc] initWithTitle:homeVC.title
                                                                         image:[UIImage imageNamed:@"tabbar_home_normal"]
                                                                 selectedImage:[UIImage imageNamed:@"tabbar_home_selected"]];

    
    JFChannelListViewController *channelVC = [[JFChannelListViewController alloc] init];
    channelVC.title                     = @"女优特辑";
    UINavigationController *channelNav  = [[UINavigationController alloc] initWithRootViewController:channelVC];
    channelNav.tabBarItem               = [[UITabBarItem alloc] initWithTitle:channelVC.title
                                                                        image:[UIImage imageNamed:@"tabbar_channel_normal"]
                                                                selectedImage:[UIImage imageNamed:@"tabbar_channel_selected"]];
    
    JFHotViewController *hotVC = [[JFHotViewController alloc] init];
    hotVC.title                          = @"热搜";
    UINavigationController * hotNav      = [[UINavigationController alloc] initWithRootViewController:hotVC];
    hotNav.tabBarItem                    = [[UITabBarItem alloc] initWithTitle:hotVC.title
                                                                         image:[UIImage imageNamed:@"tabbar_hot_normal"]
                                                                 selectedImage:[UIImage imageNamed:@"tabbar_hot_selected"]];
    
    JFMineViewController *mineVC        = [[JFMineViewController alloc] init];
    mineVC.title                         = @"私密区";
    UINavigationController *mineNav      = [[UINavigationController alloc] initWithRootViewController:mineVC];
    mineNav.tabBarItem                   = [[UITabBarItem alloc] initWithTitle:mineVC.title
                                                                         image:[UIImage imageNamed:@"tabbar_mine_normal"]
                                                                 selectedImage:[UIImage imageNamed:@"tabbar_mine_selected"]];
    
    UITabBarController *tabBarController    = [[UITabBarController alloc] init];
    tabBarController.viewControllers        = @[homeNav,channelNav,hotNav,mineNav];
    tabBarController.tabBar.translucent = NO;
    _window.rootViewController              = tabBarController;
    return _window;
}

- (void)setupCommonStyles {
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithHexString:@"#efefef"]];
    [[UITabBar appearance] setTintColor:[UIColor colorWithHexString:@"#ec5382"]];
    [[UITabBar appearance] setBarStyle:UIBarStyleDefault];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:11.],
                                                        NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#b0b0b0"]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:11.],
                                                        NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#e51c23"]} forState:UIControlStateSelected];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithHexString:@"#212121"]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18.],
                                                           NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [UIViewController aspect_hookSelector:@selector(viewDidLoad)
                              withOptions:AspectPositionAfter
                               usingBlock:^(id<AspectInfo> aspectInfo){
                                   UIViewController *thisVC = [aspectInfo instance];
                                   thisVC.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:@"返回" style:UIBarButtonItemStylePlain handler:nil];
                                   thisVC.navigationController.navigationBar.translucent = NO;
                               } error:nil];
    
    [UITabBarController aspect_hookSelector:@selector(shouldAutorotate)
                                withOptions:AspectPositionInstead
                                 usingBlock:^(id<AspectInfo> aspectInfo){
                                     UITabBarController *thisTabBarVC = [aspectInfo instance];
                                     UIViewController *selectedVC = thisTabBarVC.selectedViewController;
                                     
                                     BOOL autoRotate = NO;
                                     if ([selectedVC isKindOfClass:[UINavigationController class]]) {
                                         autoRotate = [((UINavigationController *)selectedVC).topViewController shouldAutorotate];
                                     } else {
                                         autoRotate = [selectedVC shouldAutorotate];
                                     }
                                     [[aspectInfo originalInvocation] setReturnValue:&autoRotate];
                                 } error:nil];
    
    [UITabBarController aspect_hookSelector:@selector(supportedInterfaceOrientations)
                                withOptions:AspectPositionInstead
                                 usingBlock:^(id<AspectInfo> aspectInfo){
                                     UITabBarController *thisTabBarVC = [aspectInfo instance];
                                     UIViewController *selectedVC = thisTabBarVC.selectedViewController;
                                     
                                     NSUInteger result = 0;
                                     if ([selectedVC isKindOfClass:[UINavigationController class]]) {
                                         result = [((UINavigationController *)selectedVC).topViewController supportedInterfaceOrientations];
                                     } else {
                                         result = [selectedVC supportedInterfaceOrientations];
                                     }
                                     [[aspectInfo originalInvocation] setReturnValue:&result];
                                 } error:nil];
    
    [UIViewController aspect_hookSelector:@selector(hidesBottomBarWhenPushed)
                              withOptions:AspectPositionInstead
                               usingBlock:^(id<AspectInfo> aspectInfo)
     {
         UIViewController *thisVC = [aspectInfo instance];
         BOOL hidesBottomBar = NO;
         if (thisVC.navigationController.viewControllers.count > 1) {
             hidesBottomBar = YES;
         }
         [[aspectInfo originalInvocation] setReturnValue:&hidesBottomBar];
     } error:nil];
    
    [UINavigationController aspect_hookSelector:@selector(preferredStatusBarStyle)
                                    withOptions:AspectPositionInstead
                                     usingBlock:^(id<AspectInfo> aspectInfo){
                                         UIStatusBarStyle statusBarStyle = UIStatusBarStyleLightContent;
                                         [[aspectInfo originalInvocation] setReturnValue:&statusBarStyle];
                                     } error:nil];
    
    [UIViewController aspect_hookSelector:@selector(preferredStatusBarStyle)
                              withOptions:AspectPositionInstead
                               usingBlock:^(id<AspectInfo> aspectInfo){
                                   UIStatusBarStyle statusBarStyle = UIStatusBarStyleLightContent;
                                   [[aspectInfo originalInvocation] setReturnValue:&statusBarStyle];
                               } error:nil];
    
    [UIScrollView aspect_hookSelector:@selector(showsVerticalScrollIndicator)
                          withOptions:AspectPositionInstead
                           usingBlock:^(id<AspectInfo> aspectInfo)
     {
         BOOL bShow = NO;
         [[aspectInfo originalInvocation] setReturnValue:&bShow];
     } error:nil];
    
    
}


- (void)setupMobStatistics {
#ifdef DEBUG
    [MobClick setLogEnabled:YES];
#endif
    NSString *bundleVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    if (bundleVersion) {
        [MobClick setAppVersion:bundleVersion];
    }
    [MobClick startWithAppkey:JF_UMENG_APP_ID reportPolicy:BATCH channelId:JF_CHANNEL_NO];
    
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [JFUtil accumateLaunchSeq];
    [self setupCommonStyles];
    
    //paymentInfo
    [[JFPaymentManager sharedManager] setup];
     [self setupMobStatistics];
    
    [self.window makeKeyAndVisible];
    
    JFLaunchView *launchView = [[JFLaunchView alloc] init];
    [launchView show];
    
    if (![JFUtil isRegistered]) {
        [[JFActivateModel sharedModel] activateWithCompletionHandler:^(BOOL success, NSString *userId) {
            [JFUtil setRegisteredWithUserId:userId];
        }];
    } else {
        [[JFUserAccessModel sharedModel] requestUserAccess];
    }
    
    [[JFSystemConfigModel sharedModel] fetchSystemConfigWithCompletionHandler:^(BOOL success) {
        if (success) {
            //获取系统配置成功
        }
    }];
    

    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    [[JFPaymentManager sharedManager] handleOpenUrl:url];
    return YES;
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    [[JFPaymentManager sharedManager] handleOpenUrl:url];
    return YES;
}

@end
