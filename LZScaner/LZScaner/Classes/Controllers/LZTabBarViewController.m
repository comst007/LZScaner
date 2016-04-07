//
//  LZTabBarViewController.m
//  LZScaner
//
//  Created by comst on 16/4/5.
//  Copyright © 2016年 com.comst1314. All rights reserved.
//

#import "LZTabBarViewController.h"

@interface LZTabBarViewController ()

@end

@implementation LZTabBarViewController


+ (void)initialize{
    
    UITabBar *tabBar =  [UITabBar appearance];
    [tabBar setBackgroundImage:[UIImage imageNamed:@"tabBarImage"]];
    
    
    UITabBarItem *itemAppearance = [UITabBarItem appearance];
    UIColor *textColorSelected = [UIColor colorWithRed:0 green:122 / 255.0 blue:255 / 255.0 alpha:1];
    
    NSDictionary *normalAttr = @{
                                 NSFontAttributeName :[UIFont systemFontOfSize:12],
                                 NSForegroundColorAttributeName : [UIColor whiteColor]
                                 };
    
    NSDictionary *selectAttr = @{
                                 NSFontAttributeName : [UIFont systemFontOfSize:12],
                                 NSForegroundColorAttributeName : textColorSelected
                                 };
    
    
    [itemAppearance setTitleTextAttributes:normalAttr forState:UIControlStateNormal];
    [itemAppearance setTitleTextAttributes:selectAttr forState:UIControlStateSelected];
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
