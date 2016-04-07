//
//  LZNavigationController.m
//  LZScaner
//
//  Created by comst on 16/4/7.
//  Copyright © 2016年 com.comst1314. All rights reserved.
//

#import "LZNavigationController.h"

@interface LZNavigationController ()

@end

@implementation LZNavigationController

+ (void)initialize{
    UINavigationBar *bar = [UINavigationBar appearance];
    [bar setTitleTextAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:20], NSForegroundColorAttributeName : [UIColor colorWithRed:0 green:112 / 255.0 blue:1 alpha:1]}];
    [bar setBackgroundImage:[UIImage imageNamed:@"tabBarImage"] forBarMetrics:UIBarMetricsDefault];
    bar.tintColor = [UIColor whiteColor];
    
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    
    [item setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14], NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateNormal];
    [item setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14], NSForegroundColorAttributeName : [UIColor lightGrayColor]} forState:UIControlStateDisabled];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}


@end
