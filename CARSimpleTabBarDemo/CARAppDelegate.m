//
//  CARAppDelegate.m
//  CARSimpleTabBarDemo
//
//  Created by Yamazaki Mitsuyoshi on 12/17/13.
//  Copyright (c) 2013 CrayonApps inc. All rights reserved.
//

#import "CARAppDelegate.h"

#import "CARSimpleTabBarController.h"

@implementation CARAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
	CARSimpleTabBarController *demoViewController = [[CARSimpleTabBarController alloc] initWithBarPosition:CARSimpleTabBarPositionTop height:27.0f];
	
//	UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0.0f, 6.0f, 0.0f, 6.0f);
//	
//	UIImage *selectedImage = [UIImage imageNamed:@"tab_selected"];
//	selectedImage = [selectedImage resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeTile];
//	
//	UIImage *nomalImage = [UIImage imageNamed:@"tab_nomal"];
//	nomalImage = [nomalImage resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeTile];
//	demoViewController.tabBar.selectedItemImage = selectedImage;
//	demoViewController.tabBar.nomalItemImage = nomalImage;
	
	demoViewController.tabBar.selectedItemColor = [UIColor colorWithRed:0.26f green:0.99f blue:0.58f alpha:1.0f];
	demoViewController.tabBar.nomalItemColor = [UIColor colorWithWhite:0.12f alpha:1.0f];
	demoViewController.tabBar.selectedTextColor = [UIColor whiteColor];
	demoViewController.tabBar.nomalTextColor = [UIColor whiteColor];
	demoViewController.tabBar.titleTextAttributes = @{
													  NSFontAttributeName: [UIFont boldSystemFontOfSize:19.0f],
													  };
	
	NSInteger count = 3;
	NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:count];
	for (NSInteger i = 0; i < count; i++) {
		NSString *title = [NSString stringWithFormat:@"%03d", i];
		UIViewController *controller = [[UIViewController alloc] init];
		CGRect frame = controller.view.bounds;
		frame.size.height = 40.0f;
		UILabel *label = [[UILabel alloc] initWithFrame:frame];
		label.font = [UIFont boldSystemFontOfSize:32.0f];
		label.textAlignment = NSTextAlignmentCenter;
		label.text = [@"VIEW " stringByAppendingString:title];
		[controller.view addSubview:label];
		label.center = controller.view.center;
		
		controller.simpleTabBarItem = [[CARSimpleTabBarItem alloc] initWithTitle:title image:nil selectedImage:nil];
		[viewControllers addObject:controller];
	}
	
	demoViewController.viewControllers = viewControllers;
	demoViewController.view.backgroundColor = [UIColor whiteColor];
	
	self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:demoViewController];
	
	[self.window makeKeyAndVisible];
	
	return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
