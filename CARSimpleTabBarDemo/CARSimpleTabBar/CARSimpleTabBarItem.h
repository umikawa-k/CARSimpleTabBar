//
//  CARSimpleTabBarItem.h
//  CARSimpleTabBarDemo
//
//  Created by Yamazaki Mitsuyoshi on 12/18/13.
//  Copyright (c) 2013 CrayonApps inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CARSimpleTabBarItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) UIColor *selectedColor;

- (id)initWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage;	// resizable image
- (id)initWithTitle:(NSString *)title color:(UIColor *)color selectedColor:(UIColor *)selectedColor;

@end

@interface UIViewController (CARSimpleTabBarItem)

- (void)setSimpleTabBarItem:(CARSimpleTabBarItem *)tabBarItem;
- (CARSimpleTabBarItem *)simpleTabBarItem;

@end
