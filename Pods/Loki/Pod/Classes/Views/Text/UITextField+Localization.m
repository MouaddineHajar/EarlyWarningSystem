//
//  UITextField+Localization.m
//
//
//  Created by Vlad Gorbenko on 5/25/15.
//  Copyright (c) 2015 Vlad Gorbenko. All rights reserved.
//

#import "UITextField+Localization.h"

#import "LKManager.h"

#import "UIView+Localization.h"

@import ObjectiveC.runtime;

@implementation UITextField (Localization)

#pragma mark - Accessors

- (NSString *)localizationKeyText {
    return objc_getAssociatedObject(self, @selector(localizationKeyText));
}

- (void)setLocalizationKeyText:(NSString *)localizationKeyText {
    objc_setAssociatedObject(self, @selector(localizationKeyText), localizationKeyText, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (localizationKeyText) {
        self.text = LKLocalizedString(localizationKeyText, nil);
    }
}

- (NSString *)localizationKeyPlaceholder {
    return objc_getAssociatedObject(self, @selector(localizationKeyPlaceholder));
}

- (void)setLocalizationKeyPlaceholder:(NSString *)localizationKeyPlaceholder {
    objc_setAssociatedObject(self, @selector(localizationKeyPlaceholder), localizationKeyPlaceholder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (localizationKeyPlaceholder) {
        self.placeholder = LKLocalizedString(localizationKeyPlaceholder, nil);
    }
}

#pragma mark - Localization

- (void)localize{
    if (self.isLocalized) {
        if ([LKManager sharedInstance].currentLanguage.direction != self.controlDirection) {
            self.controlDirection = [LKManager sharedInstance].currentLanguage.direction;
            [self flipAlignment];
        }
        
        if (self.localizationKeyText) {
            self.text = LKLocalizedString(self.localizationKeyText, nil);
        }
        if (self.localizationKeyPlaceholder) {
            self.placeholder = LKLocalizedString(self.localizationKeyPlaceholder, nil);
        }
    }
}

- (void)flipAlignment{
    switch (self.textAlignment){
        case NSTextAlignmentLeft:
            [self setTextAlignment:NSTextAlignmentRight];
            break;
        case NSTextAlignmentRight:
            [self setTextAlignment:NSTextAlignmentLeft];
            break;
        default:
            break;
    }
}

@end
