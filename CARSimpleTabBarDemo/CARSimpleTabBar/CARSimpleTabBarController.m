//
//  CARSimpleTabBarController.m
//  CARSimpleTabBarDemo
//
//  Created by Yamazaki Mitsuyoshi on 12/18/13.
//  Copyright (c) 2013 CrayonApps inc. All rights reserved.
//

#import "CARSimpleTabBarController.h"
#import <QuartzCore/QuartzCore.h>

@interface CARSimpleTabBarController () {
	
	NSInteger _previousSelectedIndex;
}

- (CGRect)contentViewFrame;

- (void)layoutTabBar;

@end

@implementation CARSimpleTabBarController

@synthesize tabBar = _tabBar;
@synthesize viewControllers = _viewControllers;
@synthesize position = _position;
@synthesize contentView = _contentView;
@dynamic tabBarHeight;

#pragma mark - Accessor
- (CGRect)contentViewFrame {
	
	CGRect contentViewFrame = self.view.bounds;
	contentViewFrame.size.height -= self.tabBarHeight;
	if (self.position == CARSimpleTabBarPositionTop) {
		contentViewFrame.origin.y = self.tabBarHeight;
	}
	return contentViewFrame;
}

- (void)setViewControllers:(NSArray *)viewControllers {
	
	NSMutableArray *newItems = [NSMutableArray arrayWithCapacity:viewControllers.count];
	CGRect childViewFrame = self.contentView.bounds;
	
	for (UIViewController *controller in viewControllers) {
		[controller.view removeFromSuperview];
		[controller removeFromParentViewController];
		[controller willMoveToParentViewController:self];
		
		controller.view.frame = childViewFrame;
		
		[self addChildViewController:controller];
		[controller didMoveToParentViewController:self];
		
		if (controller.simpleTabBarItem) {
			[newItems addObject:controller.simpleTabBarItem];
		}
		else {
			[newItems addObject:[[CARSimpleTabBarItem alloc] init]];
		}
	}
	
	_viewControllers = viewControllers.copy;
	self.tabBar.items = newItems.copy;
	
	// TODO: Inherit the previous selected view
	
	//	self.selectedIndex = 0;
	//	self.tabBar.selectedIndex = 0;
}

- (void)setPosition:(CARSimpleTabBarPositions)position {
	_position = position;
	[self layoutTabBar];
}

- (void)setTabBarHeight:(CGFloat)tabBarHeight {
	
	CGRect barFrame = self.tabBar.frame;
	barFrame.size.height = tabBarHeight;
	self.tabBar.frame = barFrame;
	
	[self layoutTabBar];
}

- (CGFloat)tabBarHeight {
	return self.tabBar.frame.size.height;
}

#pragma mark - Lifecycle
- (id)initWithBarPosition:(CARSimpleTabBarPositions)position height:(CGFloat)barHeight {
	
	self = [super init];
	if (self) {
		_position = position;
		
		CGRect barFrame = self.view.bounds;
		barFrame.size.height = barHeight;
		
		if (self.position == CARSimpleTabBarPositionBottom) {
			barFrame.origin.y = self.view.frame.size.height - barFrame.origin.y;
		}
		
		_tabBar = [[CARSimpleTabBar alloc] initWithFrame:barFrame];
		self.tabBar.delegate = self;
		
		[self.view addSubview:self.tabBar];
		self.contentView.frame = self.contentViewFrame;	// 必要
	}
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.edgesForExtendedLayout = UIRectEdgeNone;
	self.view.backgroundColor = [UIColor clearColor];
	
	_contentView = [[UIView alloc] initWithFrame:self.contentViewFrame];
	self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.contentView.backgroundColor = [UIColor clearColor];
	
	[self.view addSubview:self.contentView];
	
	[self layoutTabBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Appearance and Rotation Methods
#pragma mark iOS6
- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
	return YES;
}

- (BOOL)shouldAutomaticallyForwardRotationMethods {
	return YES;
}

#pragma mark iOS5
- (BOOL)automaticallyForwardAppearanceAndRotationMethodsToChildViewControllers {
	return YES;
}

#pragma mark - Layout
- (void)layoutTabBar {
	
	CGRect barFrame = self.view.bounds;
	
	if (self.position == CARSimpleTabBarPositionTop) {
		barFrame.origin.y = 0.0f;
	}
	else {
		barFrame.origin.y = self.view.frame.size.height - barFrame.origin.y;
	}
	
	self.tabBar.frame = barFrame;
	self.contentView.frame = self.contentViewFrame;
}

#pragma mark - CARSimpleTabBarDelegate
- (void)tabBar:(CARSimpleTabBar *)tabBar didSelectItem:(CARSimpleTabBarItem *)item {
	
	UIViewController *deselectedViewController = self.viewControllers[_previousSelectedIndex];
	
	if (_previousSelectedIndex == self.tabBar.selectedIndex) {
		deselectedViewController = nil;
	}
	
	UIViewController *selectedViewController = self.viewControllers[self.tabBar.selectedIndex];
	
	BOOL shouldAnimate = NO;
	if ([self.delegate respondsToSelector:@selector(simpleTabBarController:shouldAnimateToShowViewController:fromViewController:)]) {
		shouldAnimate = [self.delegate simpleTabBarController:self shouldAnimateToShowViewController:selectedViewController fromViewController:deselectedViewController];
	}
	
	[self.contentView addSubview:selectedViewController.view];
	[self.contentView bringSubviewToFront:self.tabBar];
	
	if (shouldAnimate == YES) {
		
		self.view.userInteractionEnabled = NO;
		
		CGRect selectedViewFrame = self.contentView.bounds;
		BOOL toRight = (_previousSelectedIndex < self.tabBar.selectedIndex);
		selectedViewFrame.origin.x = toRight ? self.view.frame.size.width : -self.view.frame.size.width;
		selectedViewController.view.frame = selectedViewFrame;
		
		// 重い
		//		selectedViewController.view.layer.shadowColor = [UIColor darkGrayColor].CGColor;
		//		selectedViewController.view.layer.shadowRadius = 20.0f;
		//		selectedViewController.view.layer.shadowOpacity = 0.5f;
		//		CGSize shadowOffset = CGSizeZero;
		//		shadowOffset.width = toRight ? -10.0f : +10.0f;
		//		selectedViewController.view.layer.shadowOffset = shadowOffset;
		
		selectedViewFrame.origin.x = 0.0f;
		
		NSTimeInterval duration = 0.4;
		
		[UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
			
			CGRect deselectedViewFrame = deselectedViewController.view.frame;
			deselectedViewFrame.origin.x += toRight ? deselectedViewFrame.size.width * 0.02f : deselectedViewFrame.size.width * 0.08f;
			deselectedViewFrame.origin.y += deselectedViewFrame.size.height * 0.05f;
			deselectedViewFrame.size.width *= 0.9f;
			deselectedViewFrame.size.height *= 0.9f;
			deselectedViewController.view.frame = deselectedViewFrame;
			deselectedViewController.view.alpha = 0.3f;
			
			selectedViewController.view.frame = selectedViewFrame;
			
		} completion:^(BOOL finished) {
			deselectedViewController.view.alpha = 1.0f;
			[deselectedViewController.view removeFromSuperview];
			self.view.userInteractionEnabled = YES;
		}];
	}
	else {
		[deselectedViewController.view removeFromSuperview];
	}
	
	_previousSelectedIndex = self.tabBar.selectedIndex;
}

@end


@implementation UIViewController (CARSimpleTabBarController)

- (CARSimpleTabBarController *)simpleTabBarController {
	
	for (UIViewController *viewController = self.parentViewController; viewController != nil; viewController = viewController.parentViewController) {
		if ([viewController isKindOfClass:[CARSimpleTabBarController class]]) {
			return (CARSimpleTabBarController *)viewController;
		}
	}
	
	return nil;
}

@end