//
//  UIView+Localized.m
//
//
//  Created by Vlad Gorbenko on 5/25/15.
//  Copyright (c) 2015 Vlad Gorbenko. All rights reserved.
//

#import "UIView+Localization.h"

#import "LKManager.h"

#import <objc/runtime.h>

void LKSwizzleMethodsFrom(Class onClass, SEL fromMethod, Class fromClass, SEL toMethod) {
    Method originalMethod = class_getInstanceMethod(onClass, fromMethod);
    Method swizzledMethod = class_getInstanceMethod(fromClass, toMethod);
    
    BOOL didAddMethod = class_addMethod(onClass, fromMethod, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(onClass, toMethod, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@implementation UIView (Localization)

#pragma mark - Lifecycle

+ (void)load {
#ifdef __IPHONE_9_0
    LKSwizzleMethodsFrom(self, @selector(semanticContentAttribute), self, @selector(swizzledSemanticContentAttribute));
#endif
}

#pragma mark - Accessors

- (BOOL)isLocalized {
    return [objc_getAssociatedObject(self, @selector(isLocalized)) boolValue];
}

- (void)setIsLocalized:(BOOL)isLocalized {
    objc_setAssociatedObject(self, @selector(isLocalized), @(isLocalized), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (isLocalized) {
        [self localize];
    }
}

- (NSLocaleLanguageDirection)controlDirection {
    NSLocaleLanguageDirection direction = [objc_getAssociatedObject(self, @selector(controlDirection)) integerValue];
    if (direction == NSLocaleLanguageDirectionUnknown) {
        return NSLocaleLanguageDirectionLeftToRight;
    }
    return direction;
}

- (void)setControlDirection:(NSLocaleLanguageDirection)controlDirection {
    objc_setAssociatedObject(self, @selector(controlDirection), @(controlDirection), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Localization

- (void)flipView{
    if (CGAffineTransformEqualToTransform(self.transform, CGAffineTransformIdentity)) {
        self.transform = CGAffineTransformMake(-1, 0, 0, 1, 0, 0);
    }else{
        self.transform = CGAffineTransformIdentity;
    }
}

- (void)flipAlignment{
}

- (void)localize {
    if (self.isLocalized) {
        if ([LKManager sharedInstance].currentLanguage.direction != self.controlDirection) {
            self.controlDirection = [LKManager sharedInstance].currentLanguage.direction;
            [self flipView];
            if(![[LKManager simpleViews] containsObject:self.class]) {
                for (id subview in self.subviews) {
                    [subview flipView];
                }
            }
        }
    }
}

- (void)localizeSubviews{
    for (id subView in self.subviews){
        [subView localize];
        if ([subView subviews].count > 0){
            [subView localizeSubviews];
        }
    }
}

#pragma mark - Utils

#ifdef __IPHONE_9_0
- (UISemanticContentAttribute)swizzledSemanticContentAttribute {
    return UISemanticContentAttributeForceLeftToRight;
}
#endif
@end
