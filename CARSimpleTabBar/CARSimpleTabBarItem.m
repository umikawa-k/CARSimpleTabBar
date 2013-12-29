//
//  CARSimpleTabBarItem.m
//  CARSimpleTabBarDemo
//
//  Created by Yamazaki Mitsuyoshi on 12/18/13.
//  Copyright (c) 2013 CrayonApps inc. All rights reserved.
//

#import "CARSimpleTabBarItem.h"

@implementation CARSimpleTabBarItem

- (id)initWithTitle:(NSString *)givenTitle image:(UIImage *)givenImage selectedImage:(UIImage *)givenSelectedImage {
	
	self = [super init];
	if (self) {
		self.title = givenTitle;
		self.image = givenImage;
		self.selectedImage = givenSelectedImage;
	}
	return self;
}

- (id)initWithTitle:(NSString *)givenTitle color:(UIColor *)givenColor selectedColor:(UIColor *)givenSelectedColor {
	
	self = [super init];
	if (self) {
		self.title = givenTitle;
		self.color = givenColor;
		self.selectedColor = givenSelectedColor;
	}
	return self;
}

@end

@implementation UIViewController (CARSimpleTabBarItem)

- (void)setSimpleTabBarItem:(CARSimpleTabBarItem *)tabBarItem {
	self.tabBarItem = (id)tabBarItem;
}

- (CARSimpleTabBarItem *)simpleTabBarItem {
	if ([self.tabBarItem isKindOfClass:[CARSimpleTabBarItem class]]) {
		return (CARSimpleTabBarItem *)self.tabBarItem;
	}
	return nil;
}

@end