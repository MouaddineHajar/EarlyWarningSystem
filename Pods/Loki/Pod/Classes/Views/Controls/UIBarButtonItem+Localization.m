//
//  UIBarButtonItem+Localization.m
//  Pods
//
//  Created by Alex Zdorovets on 12/23/15.
//
//

#import "UIBarButtonItem+Localization.h"

#import "LKManager.h"

@import ObjectiveC.runtime;

@implementation UIBarButtonItem (Localization)

#pragma mark - Accessors

- (NSString *)localizedTitleKey {
    return objc_getAssociatedObject(self, @selector(localizedTitleKey));
}

- (void)setLocalizedTitleKey:(NSString *)localizedTitleKey {
    objc_setAssociatedObject(self, @selector(localizedTitleKey), localizedTitleKey, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (localizedTitleKey) {
        self.title = LKLocalizedString(localizedTitleKey, nil);
    }
}

@end
