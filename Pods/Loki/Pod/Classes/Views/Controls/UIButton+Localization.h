//
//  UIButton+Localization.h
//
//
//  Created by Vlad Gorbenko on 5/25/15.
//  Copyright (c) 2015 Vlad Gorbenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Localization)

@property (nonatomic, strong) IBInspectable NSString *localizedTitleKey;

@property (strong, nonatomic) IBInspectable NSString *localizationKeySelected;
@property (strong, nonatomic) IBInspectable NSString *localizationKeyHightlighted;
@property (strong, nonatomic) IBInspectable NSString *localizationKeyDisabled;
@property (readwrite, nonatomic) IBInspectable BOOL shouldNotFlipImage;

@end
