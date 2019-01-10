//
//  UISegmentedControl+Localization.m
//
//
//  Created by Vlad Gorbenko on 5/25/15.
//  Copyright (c) 2015 Vlad Gorbenko. All rights reserved.
//

#import "UISegmentedControl+Localization.h"

@import ObjectiveC.runtime;

#import "Swizzle.h"

#import "LKManager.h"

#import "UIView+Localization.h"

static IMP originalSelectedIndexImplementation;
static IMP originalSetSelectedIndexImplementation;

@implementation UISegmentedControl (Localization)

- (void)setIsLocalized:(BOOL)isLocalized{
    NSMutableArray *keys = [NSMutableArray array];
    for (NSUInteger i = 0; i < self.numberOfSegments; i++) {
        [keys addObject:[self titleForSegmentAtIndex:i]];
    }
    self.localizationKeys = keys;
    [super setIsLocalized:isLocalized];
}

- (NSArray *)localizationKeys {
    return objc_getAssociatedObject(self, @selector(localizationKeys));
}

- (void)setLocalizationKeys:(NSArray *)localizationKeys {
    objc_setAssociatedObject(self, @selector(localizationKeys), localizationKeys, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalSelector = @selector(selectedSegmentIndex);
        SEL swizzledSelector = @selector(swizzleSelectedIndex);
        originalSelectedIndexImplementation = class_getMethodImplementation([self class], originalSelector);
        SwizzleMethodsFrom([self class], originalSelector, [self class], swizzledSelector);
        
        SEL originalSelectorSet = @selector(setSelectedSegmentIndex:);
        SEL swizzledSelectorSet = @selector(swizzleSetSelectedSegmentIndex:);
        originalSetSelectedIndexImplementation = class_getMethodImplementation([self class], originalSelectorSet);
        SwizzleMethodsFrom([self class], originalSelectorSet, [self class], swizzledSelectorSet);
    });
}

- (void)localize {
    if (self.isLocalized) {
        if ([LKManager sharedInstance].currentLanguage.direction != self.controlDirection) {
            NSInteger selected = self.selectedSegmentIndex;
            self.controlDirection = [LKManager sharedInstance].currentLanguage.direction;
            NSArray *keys = self.localizationKeys;
            if (self.controlDirection == NSLocaleLanguageDirectionRightToLeft) {
                keys = [[keys reverseObjectEnumerator] allObjects];
            }
            [self removeAllSegments];
            for (NSUInteger i = 0; i < keys.count; i++) {
                [self insertSegmentWithTitle:LKLocalizedString(keys[i], nil) atIndex:i animated:NO];
            }
            [self setSelectedSegmentIndex:selected];
        }else{
            for (NSUInteger i = 0; i < self.numberOfSegments; i++) {
                [self setTitle:LKLocalizedString(self.localizationKeys[i], nil) forSegmentAtIndex:i];
            }
        }
    }
}

#pragma mark - Utils

- (NSInteger)swizzleSelectedIndex {
    NSInteger selectedIndex = ((int(*)(id,SEL))originalSelectedIndexImplementation)(self, _cmd);
    if (self.controlDirection == NSLocaleLanguageDirectionRightToLeft) {
        return self.numberOfSegments - 1 - selectedIndex;
    } else {
        return selectedIndex;
    }
}

- (void)swizzleSetSelectedSegmentIndex:(NSInteger)selectedSegmentIndex{
    if (self.controlDirection == NSLocaleLanguageDirectionRightToLeft) {
        selectedSegmentIndex = self.numberOfSegments - 1 - selectedSegmentIndex;
    }
    ((void(*)(id, SEL, NSInteger))originalSetSelectedIndexImplementation)(self, _cmd, selectedSegmentIndex);
}

@end
