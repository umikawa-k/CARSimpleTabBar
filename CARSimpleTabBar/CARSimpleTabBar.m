//
//  CARSimpleTabBar.m
//  CARSimpleTabBarDemo
//
//  Created by Yamazaki Mitsuyoshi on 12/18/13.
//  Copyright (c) 2013 CrayonApps inc. All rights reserved.
//

#import "CARSimpleTabBar.h"

@interface CARSimpleTabBar () {
	
//	NSMutableDictionary *_dividerImages;
	NSArray *_itemImageViews;
//	NSMutableDictionary *_dividerImageViews;
}

+ (NSDictionary *)attributeSetters;

//- (NSString *)dividerKeyForLeftTabItemState:(UIControlState)leftState rightTabItemState:(UIControlState)rightState;
//- (UIImage *)dividerImageForRightItemIndex:(NSInteger)index;
//- (void)replaceDividerImageViewForRightItemIndex:(NSInteger)index;

/*! itemの入れ替え時に呼ばれる。selectedIndexが変更されるのみのときはsetSelectedIndex:
 */
- (void)layoutItems;

- (void)itemDidSelect:(UITapGestureRecognizer *)gestureRecognizer;

@end

@implementation CARSimpleTabBar

@synthesize items = _items;
@synthesize selectedIndex = _selectedIndex;
@synthesize titleTextAttributes = _titleTextAttributes;
@synthesize nomalItemImage = _nomalItemImage;
@synthesize selectedItemImage = _selectedItemImage;
@synthesize nomalItemColor = _nomalItemColor;
@synthesize selectedItemColor = _selectedItemColor;
@synthesize nomalTextColor = _nomalTextColor;
@synthesize selectedTextColor = _selectedTextColor;
@dynamic selectedItem;

#pragma mark - Accessor
+ (NSDictionary *)attributeSetters {
	return @{
			NSFontAttributeName: NSStringFromSelector(@selector(setFont:)),
//			NSForegroundColorAttributeName: NSStringFromSelector(@selector(setTextColor:)),
			 };
}

+ (NSArray *)supportedTextAttributes {
	return [self attributeSetters].allKeys;
}

- (void)setFrame:(CGRect)frame {
	[super setFrame:frame];
	[self layoutItems];
}

//- (NSString *)dividerKeyForLeftTabItemState:(UIControlState)leftState rightTabItemState:(UIControlState)rightState {
//	return [NSString stringWithFormat:@"%d:%d", leftState, rightState];
//}
//
//- (UIImage *)dividerImageForRightItemIndex:(NSInteger)index {
//	
//	UIControlState leftState = UIControlStateNormal;
//	UIControlState rightState = UIControlStateNormal;
//	
//	if (self.selectedIndex == index - 1) {
//		leftState = UIControlStateSelected;
//	}
//	if (self.selectedIndex == index) {
//		rightState = UIControlStateSelected;
//	}
//	if (index == 0) {
//		leftState = UIControlStateDisabled;
//	}
//	if (index == self.items.count) {
//		rightState = UIControlStateDisabled;
//	}
//	
//	NSString *key = [self dividerKeyForLeftTabItemState:leftState rightTabItemState:rightState];
//	return _dividerImages[key];
//}
//
//- (void)replaceDividerImageViewForRightItemIndex:(NSInteger)index {
//	
//	UIImage *dividerImage = [self dividerImageForRightItemIndex:index];
//	if (dividerImage == nil) {
//		return;
//	}
//	
//	UIImageView *imageView = _itemImageViews[index];
//	
//	CGRect dividerFrame = imageView.bounds;
//	dividerFrame.size.width = (imageView.frame.size.height * dividerImage.size.width) / dividerImage.size.height;
//	dividerFrame.origin.x = imageView.frame.origin.x - (dividerFrame.size.width / 2.0f);
//	
//	UIImageView *dividerImageView = [[UIImageView alloc] initWithFrame:dividerFrame];
//	dividerImageView.image = dividerImage;
//	dividerImageView.contentMode = UIViewContentModeScaleAspectFill;
//	dividerImageView.autoresizingMask = UIViewAutoresizingNone;
//	dividerImageView.userInteractionEnabled = NO;
//	dividerImageView.clipsToBounds = YES;
//	dividerImageView.backgroundColor = [UIColor clearColor];
//	
//	[self addSubview:dividerImageView];
//	
//	NSNumber *dividerKey = [NSNumber numberWithInteger:index];
//	_dividerImageViews[dividerKey] = dividerImageView;
//}
//
//- (void)setDividerImage:(UIImage *)dividerImage forLeftTabItemState:(UIControlState)leftState rightTabItemState:(UIControlState)rightState {
//	
//	if (dividerImage == nil) {
//		return;
//	}
//	
//	NSString *key = [self dividerKeyForLeftTabItemState:leftState rightTabItemState:rightState];
//	_dividerImages[key] = dividerImage;
//	[self layoutItems];
//}
//
//- (UIImage *)dividerImageForLeftTabItemState:(UIControlState)leftState rightTabItemState:(UIControlState)rightState {
//	
//	NSString *key = [self dividerKeyForLeftTabItemState:leftState rightTabItemState:rightState];
//	return _dividerImages[key];
//}

- (void)setItems:(NSArray *)items {
	_items = items.copy;
	[self layoutItems];
}

- (void)setSelectedItem:(CARSimpleTabBarItem *)selectedItem {
	
	if ([self.items containsObject:selectedItem] == NO) {
		return;
	}
	self.selectedIndex = [self.items indexOfObject:selectedItem];
}

- (CARSimpleTabBarItem *)selectedItem {
	return self.items[self.selectedIndex];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
	
	if (selectedIndex >= self.items.count) {
		return;
	}
	
	NSInteger previousIndex = self.selectedIndex;
	_selectedIndex = selectedIndex;
	
	UIImageView *deselectedImageView = _itemImageViews[previousIndex];
	CARSimpleTabBarItem *deselectedItem = self.items[previousIndex];
	deselectedImageView.image = (deselectedItem.image != nil) ? deselectedItem.image : self.nomalItemImage;
	deselectedImageView.backgroundColor = (deselectedItem.color != nil) ? deselectedItem.color : self.nomalItemColor;
	
	UIImageView *selectedImageView = _itemImageViews[self.selectedIndex];
	CARSimpleTabBarItem *selectedItem = self.items[self.selectedIndex];
	selectedImageView.image = (selectedItem.selectedImage != nil) ? selectedItem.selectedImage : self.selectedItemImage;
	selectedImageView.backgroundColor = (selectedItem.selectedColor != nil) ? selectedItem.selectedColor : self.selectedItemColor;
	
	UILabel *deselectedLabel = deselectedImageView.subviews[0];	//FixMe:
	deselectedLabel.textColor = self.nomalTextColor;
	
	if (self.selectedTextColor) {
		UILabel *selectedLabel = selectedImageView.subviews[0];	//FixMe:
		selectedLabel.textColor = self.selectedTextColor;
	}
	
//	NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
//	[indexSet addIndex:previousIndex];
//	[indexSet addIndex:previousIndex + 1];
//	[indexSet addIndex:self.selectedIndex];
//	[indexSet addIndex:self.selectedIndex + 1];
//	
//	[indexSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
//		[self replaceDividerImageViewForRightItemIndex:idx];
//	}];
	
	[self.delegate tabBar:self didSelectItem:self.selectedItem];
}

- (void)setTitleTextAttributes:(NSDictionary *)titleTextAttributes {
	
	_titleTextAttributes = titleTextAttributes.copy;
	
	NSDictionary *attributeSetters = [self.class attributeSetters];
	NSArray *supportedTextAttributes = [self.class supportedTextAttributes];
	
	for (UIImageView *imageView in _itemImageViews) {
		UILabel *label = imageView.subviews[0];	// あとでなんとかする
		
		for (NSString *key in self.titleTextAttributes.allKeys) {
			if ([supportedTextAttributes containsObject:key] == NO) {
				[NSException raise:NSInvalidArgumentException format:@"Currently %@ is not supported sorry", key];
			}
			
			SEL setter = NSSelectorFromString(attributeSetters[key]);
			id value = self.titleTextAttributes[key];
			[label performSelector:setter withObject:value];
		}
	}
}

- (void)setNomalItemImage:(UIImage *)nomalItemImage {
	_nomalItemImage = nomalItemImage;
	
	for (NSInteger index = 0; index < self.items.count; index++) {
		UIImageView *imageView = _itemImageViews[index];
		CARSimpleTabBarItem *item = self.items[index];
		
		if (index != self.selectedIndex) {
			imageView.image = (item.image != nil) ? item.image : self.nomalItemImage;
		}
	}
}

- (void)setSelectedItemImage:(UIImage *)selectedItemImage {
	_selectedItemImage = selectedItemImage;
	
	for (NSInteger index = 0; index < self.items.count; index++) {
		UIImageView *imageView = _itemImageViews[index];
		CARSimpleTabBarItem *item = self.items[index];
		
		if (index == self.selectedIndex) {
			imageView.image = (item.selectedImage != nil) ? item.selectedImage : self.selectedItemImage;
		}
	}
}

- (void)setNomalItemColor:(UIColor *)nomalItemColor {
	_nomalItemColor = nomalItemColor;
	
	for (NSInteger index = 0; index < self.items.count; index++) {
		UIImageView *imageView = _itemImageViews[index];
		CARSimpleTabBarItem *item = self.items[index];
		
		if (index != self.selectedIndex) {
			imageView.backgroundColor = (item.color != nil) ? item.color : self.nomalItemColor;
		}
	}
}

- (void)setSelectedItemColor:(UIColor *)selectedItemColor {
	_selectedItemColor = selectedItemColor;
	
	for (NSInteger index = 0; index < self.items.count; index++) {
		UIImageView *imageView = _itemImageViews[index];
		CARSimpleTabBarItem *item = self.items[index];
		
		if (index == self.selectedIndex) {
			imageView.backgroundColor = (item.selectedColor != nil) ? item.selectedColor : self.selectedItemColor;
		}
	}
}

- (void)setNomalTextColor:(UIColor *)nomalTextColor {
	
	if (nomalTextColor == nil) {
		return;
	}
	
	_nomalTextColor = nomalTextColor;
	
	for (UIImageView *imageView in _itemImageViews) {
		UILabel *label = imageView.subviews[0];	// あとでなんとかする
		
		if ([_itemImageViews indexOfObject:imageView] != self.selectedIndex) {
			label.textColor = self.nomalTextColor;
		}
	}
}

- (void)setSelectedTextColor:(UIColor *)selectedTextColor {
	
	if (selectedTextColor == nil) {
		return;
	}
	
	_selectedTextColor = selectedTextColor;
	
	for (UIImageView *imageView in _itemImageViews) {
		UILabel *label = imageView.subviews[0];	// あとでなんとかする
		
		if ([_itemImageViews indexOfObject:imageView] == self.selectedIndex) {
			label.textColor = self.selectedTextColor;
		}
	}
}

#pragma mark - Lifecycle
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		
//		_dividerImages = [[NSMutableDictionary alloc] init];
		_itemImageViews = nil;
//		_dividerImageViews = [[NSMutableDictionary alloc] init];
		
		self.backgroundColor = [UIColor clearColor];
		
		_nomalTextColor = [UIColor blueColor];
		
		[self layoutItems];
    }
    return self;
}

#pragma mark - Layout
- (void)layoutItems {
	
	if (self.items == nil) {
		return;
	}
	
	if (self.items.count <= self.selectedIndex) {
		_selectedIndex = _selectedIndex % self.items.count;
	}
	
	[_itemImageViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
	_itemImageViews = nil;
	
	NSMutableArray *newImageViews = [NSMutableArray arrayWithCapacity:self.items.count];
	
//	[_dividerImageViews.allValues makeObjectsPerformSelector:@selector(removeFromSuperview)];
//	[_dividerImageViews removeAllObjects];
	
	CGRect imageFrame = self.bounds;
	imageFrame.size.width /= (CGFloat)self.items.count;
	
	for (NSInteger index = 0; index < self.items.count; index++) {
		
		CARSimpleTabBarItem *item = self.items[index];
		
		// tab item image view
		imageFrame.origin.x = imageFrame.size.width * index;
		UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageFrame];
		imageView.image = (item.image != nil) ? item.image : self.nomalItemImage;
		imageView.backgroundColor = (item.color != nil) ? item.color : self.nomalItemColor;
		imageView.contentMode = UIViewContentModeScaleToFill;
		imageView.autoresizingMask = UIViewAutoresizingNone;
		imageView.userInteractionEnabled = YES;
		imageView.clipsToBounds = YES;
		
		UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemDidSelect:)];
		[imageView addGestureRecognizer:tapGestureRecognizer];
		
		UILabel *label = [[UILabel alloc] initWithFrame:imageView.bounds];
		label.backgroundColor = [UIColor clearColor];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		label.userInteractionEnabled = NO;
		label.clipsToBounds = YES;
		label.textAlignment = NSTextAlignmentCenter;
		label.textColor = self.nomalTextColor;
		label.adjustsFontSizeToFitWidth = YES;
		label.backgroundColor = [UIColor clearColor];
		label.text = item.title;
		
		[imageView addSubview:label];
		
		[self addSubview:imageView];
		[newImageViews addObject:imageView];
	}
	
	_itemImageViews = newImageViews.copy;
	
	self.titleTextAttributes = self.titleTextAttributes;	// to reload attributes
	
	self.selectedIndex = self.selectedIndex;
	
//	for (NSInteger index = 0; index <= self.items.count; index++) {
//		[self replaceDividerImageViewForRightItemIndex:index];
//	}
}

#pragma mark - Select
- (void)itemDidSelect:(UITapGestureRecognizer *)gestureRecognizer {
	
	NSInteger itemIndex = [_itemImageViews indexOfObject:gestureRecognizer.view];
	
	if (itemIndex >= self.items.count) {
		return;
	}
	if (itemIndex == self.selectedIndex) {
		return;
	}
	
	self.selectedIndex = itemIndex;
}

@end
