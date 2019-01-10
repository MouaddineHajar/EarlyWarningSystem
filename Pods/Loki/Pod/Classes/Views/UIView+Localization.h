//
//  UIView+Localized.h
//
//
//  Created by Vlad Gorbenko on 5/25/15.
//  Copyright (c) 2015 Vlad Gorbenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Localization)

@property (nonatomic) IBInspectable BOOL isLocalized;
@property (nonatomic) NSLocaleLanguageDirection controlDirection;

/** Flip current view*/
- (void)flipView;

/** Flip Alignment for current view*/
- (void)flipAlignment;

/** Make localization for current view*/
- (void)localize;

/** Make localization for 1st level subviews*/
- (void)localizeSubviews;

@end
