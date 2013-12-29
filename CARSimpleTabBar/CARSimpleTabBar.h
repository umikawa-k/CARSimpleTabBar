//
//  CARSimpleTabBar.h
//  CARSimpleTabBarDemo
//
//  Created by Yamazaki Mitsuyoshi on 12/18/13.
//  Copyright (c) 2013 CrayonApps inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CARSimpleTabBarItem.h"

typedef enum {
	CARSimpleTabBarPositionTop,
	CARSimpleTabBarPositionBottom,
}CARSimpleTabBarPositions;

@class CARSimpleTabBar;

@protocol CARSimpleTabBarDelegate <NSObject>
@required
- (void)tabBar:(CARSimpleTabBar *)tabBar didSelectItem:(CARSimpleTabBarItem *)item;
@end

@interface CARSimpleTabBar : UIView

@property (nonatomic, weak) id <CARSimpleTabBarDelegate> delegate;
@property (nonatomic, copy) NSArray *items;
@property (nonatomic, weak) CARSimpleTabBarItem *selectedItem;
@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic, copy) NSDictionary *titleTextAttributes;

@property (nonatomic, strong) UIImage *nomalItemImage UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIImage *selectedItemImage UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *nomalItemColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *selectedItemColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *nomalTextColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *selectedTextColor UI_APPEARANCE_SELECTOR;

+ (NSArray *)supportedTextAttributes;

//- (void)setDividerImage:(UIImage *)dividerImage forLeftTabItemState:(UIControlState)leftState rightTabItemState:(UIControlState)rightState;
//- (UIImage *)dividerImageForLeftTabItemState:(UIControlState)leftState rightTabItemState:(UIControlState)rightState;

@end
