//
//  UIViewController+Localization.m
//  Pods
//
//  Created by vlad gorbenko on 12/6/15.
//
//

#import "UIViewController+Localization.h"

#import "LKManager.h"

@import ObjectiveC;

@implementation UIViewController (Localization)

#pragma mark - Accessors

- (NSString *)localizedTitleKey {
    return objc_getAssociatedObject(self, @selector(localizedTitleKey));
}

#pragma mark - Modifiers

- (void)setLocalizedTitleKey:(NSString *)localizedTitleKey {
    objc_setAssociatedObject(self, @selector(localizedTitleKey), localizedTitleKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (localizedTitleKey) {
        self.title = LKLocalizedString(localizedTitleKey, nil);
    }
}

@end
