//
//  CARSimpleTabBarController.h
//  CARSimpleTabBarDemo
//
//  Created by Yamazaki Mitsuyoshi on 12/18/13.
//  Copyright (c) 2013 CrayonApps inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CARSimpleTabBar.h"

@class CARSimpleTabBarController;

@protocol CARSimpleTabBarControllerDelegate <NSObject>
@optional
- (BOOL)simpleTabBarController:(CARSimpleTabBarController *)tabBarController shouldAnimateToShowViewController:(UIViewController *)newController fromViewController:(UIViewController *)oldController;
@end

@interface CARSimpleTabBarController : UIViewController <CARSimpleTabBarDelegate>

@property (nonatomic, weak) id <CARSimpleTabBarControllerDelegate> delegate;

@property (nonatomic, readonly) CARSimpleTabBar *tabBar;
@property (nonatomic, copy) NSArray *viewControllers;

@property (nonatomic) CARSimpleTabBarPositions position;
@property (nonatomic) CGFloat tabBarHeight;

@property (nonatomic, readonly) UIView *contentView;

- (id)initWithBarPosition:(CARSimpleTabBarPositions)position height:(CGFloat)barHeight;

@end

@interface UIViewController (CARSimpleTabBarController)
- (CARSimpleTabBarController *)simpleTabBarController;
@end