//
//  UIButton+Localization.m
//
//
//  Created by Vlad Gorbenko on 5/25/15.
//  Copyright (c) 2015 Vlad Gorbenko. All rights reserved.
//

#import "UIButton+Localization.h"

#import "LKManager.h"

#import "UIView+Localization.h"

@import ObjectiveC.runtime;

@implementation UIButton (Localization)

#pragma mark - Accessors

- (NSString *)localizationKeyDisabled {
    return objc_getAssociatedObject(self, @selector(localizationKeyDisabled));
}

- (void)setLocalizationKeyDisabled:(NSString *)localizationKeyDisabled {
    objc_setAssociatedObject(self, @selector(localizationKeyDisabled), localizationKeyDisabled, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (localizationKeyDisabled) {
        [self setTitle:LKLocalizedString(localizationKeyDisabled, nil) forState:UIControlStateDisabled];
    }
}

- (NSString *)localizationKeyHightlighted {
    return objc_getAssociatedObject(self, @selector(localizationKeyHightlighted));
}

- (void)setLocalizationKeyHightlighted:(NSString *)localizationKeyHightlighted {
    objc_setAssociatedObject(self, @selector(localizationKeyHightlighted), localizationKeyHightlighted, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (localizationKeyHightlighted) {
        [self setTitle:LKLocalizedString(localizationKeyHightlighted, nil) forState:UIControlStateHighlighted];
    }
}

- (NSString *)localizedTitleKey {
    return objc_getAssociatedObject(self, @selector(localizedTitleKey));
}

- (void)setLocalizedTitleKey:(NSString *)localizedTitleKey {
    objc_setAssociatedObject(self, @selector(localizedTitleKey), localizedTitleKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (localizedTitleKey) {
        [self setTitle:LKLocalizedString(localizedTitleKey, nil) forState:UIControlStateNormal];
    }
}

- (NSString *)localizationKeySelected {
    return objc_getAssociatedObject(self, @selector(localizationKeySelected));
}

- (void)setLocalizationKeySelected:(NSString *)localizationKeySelected {
    objc_setAssociatedObject(self, @selector(localizationKeySelected), localizationKeySelected, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (localizationKeySelected) {
        [self setTitle:LKLocalizedString(localizationKeySelected, nil) forState:UIControlStateSelected];
    }
}

- (BOOL)shouldNotFlipImage {
    NSNumber *number = objc_getAssociatedObject(self,@selector(shouldNotFlipImage));
    return [number boolValue];
}

- (void)setShouldNotFlipImage:(BOOL)shouldNotFlipImage {
    NSNumber *number = [NSNumber numberWithBool: shouldNotFlipImage];
    objc_setAssociatedObject(self, @selector(shouldNotFlipImage), number, OBJC_ASSOCIATION_RETAIN);
    if (self.imageView.image) {
        self.imageView.transform = CGAffineTransformIdentity;
    }
    if (self.controlDirection == NSLocaleLanguageDirectionRightToLeft && shouldNotFlipImage) {
        [self.imageView flipView];
    }
}

#pragma mark - Localization

- (void)localize{
    if (self.isLocalized) {
        // -999 - Button still be localized, but never flipped
        if (self.tag != -999) {
            if ([LKManager sharedInstance].currentLanguage.direction != self.controlDirection) {
                self.controlDirection = [LKManager sharedInstance].currentLanguage.direction;
                if (self.imageView.image == nil) {
                    [self flipAlignment];
                }else{
                    [self flipView];
                    if (self.shouldNotFlipImage) {
                        [self.imageView flipView];
                    }
                    [self.titleLabel flipView];
                    [self.titleLabel flipAlignment];
                }
            }
        }
        
        if (self.localizedTitleKey) {
            [self setTitle:LKLocalizedString(self.localizedTitleKey, nil) forState:UIControlStateNormal];
        }
        if (self.localizationKeySelected) {
            [self setTitle:LKLocalizedString(self.localizationKeySelected, nil) forState:UIControlStateSelected];
        }
        if (self.localizationKeyHightlighted) {
            [self setTitle:LKLocalizedString(self.localizationKeyHightlighted, nil) forState:UIControlStateHighlighted];
        }
        if (self.localizationKeyDisabled) {
            [self setTitle:LKLocalizedString(self.localizationKeyDisabled, nil) forState:UIControlStateDisabled];
        }
    }
}

- (void)flipAlignment{
    if (self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentLeft) {
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }else if(self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentRight) {
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
}


@end
