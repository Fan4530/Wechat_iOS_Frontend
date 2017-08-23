//
//  SCTabBarController.m
//  SocialDemo
//
//  Created by Student on 8/22/17.
//  Copyright © 2017 Student. All rights reserved.
//

#import "SCTabBarController.h"

@interface SCTabBarController ()

@end

@implementation SCTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewControllers = [self viewControllerArray];
    self.selectedIndex = 0;

    // Do any additional setup after loading the view.
}

- (NSArray <UIViewController *> *)viewControllerArray
{
    UIViewController *homeController = [self homeViewController];
    UIViewController *exploreController = [self exploreViewController];
    NSArray<UIViewController *> *array = @[homeController, exploreController];
    return array;
}

- (UIViewController *)homeViewController
{
    UIViewController *homeController = [[UIViewController alloc] init];
    homeController.view.backgroundColor = [UIColor whiteColor];
    homeController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Home" image:[UIImage imageNamed:@"Events"] selectedImage:[UIImage imageNamed:@"Events_selected"]];
    homeController.tabBarItem.tag = 0;
    return homeController;
}

- (UIViewController *)exploreViewController
{
    UIViewController *exploreController = [[UIViewController alloc] init];
    exploreController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Explore" image:[UIImage imageNamed:@"Explore"] selectedImage:[UIImage imageNamed:@"Explore_selected"]];
    exploreController.tabBarItem.tag = 1;
    return exploreController;
}

@end

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

