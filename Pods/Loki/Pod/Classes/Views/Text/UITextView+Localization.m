//
//  UITextView+Localization.m
//
//
//  Created by Vlad Gorbenko on 5/25/15.
//  Copyright (c) 2015 Vlad Gorbenko. All rights reserved.
//

#import "UITextView+Localization.h"

#import "LKManager.h"

#import "UIView+Localization.h"

@import ObjectiveC.runtime;

@implementation UITextView (Localization)

#pragma mark - Accessors

- (NSString *)localizationKey {
    return objc_getAssociatedObject(self, @selector(localizationKey));
}

- (void)setLocalizationKey:(NSString *)localizationKey {
    objc_setAssociatedObject(self, @selector(localizationKey), localizationKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (localizationKey) {
        self.text = LKLocalizedString(localizationKey, nil);
    }
}


- (void)startSettings{
    self.localizationKey = self.text;
    self.controlDirection = NSLocaleLanguageDirectionLeftToRight;
    [self localize];
}

#pragma mark - Localization

- (void)localize{
    if (self.isLocalized) {
        if ([LKManager sharedInstance].currentLanguage.direction != self.controlDirection) {
            self.controlDirection = [LKManager sharedInstance].currentLanguage.direction;
            [self flipAlignment];
        }
        
        if (self.localizationKey) {
            self.text = LKLocalizedString(self.localizationKey, nil);
        }
    }
}

- (void)flipAlignment{
        switch ([self textAlignment]){
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
