#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "UIViewController+Localization.h"
#import "Loki.h"
#import "LKLanguage.h"
#import "LKManager.h"
#import "NSBundle+Language.h"
#import "Swizzle.h"
#import "UIBarButtonItem+Localization.h"
#import "UIButton+Localization.h"
#import "UISegmentedControl+Localization.h"
#import "UILabel+Localization.h"
#import "UITextField+Localization.h"
#import "UITextView+Localization.h"
#import "UIView+Localization.h"

FOUNDATION_EXPORT double LokiVersionNumber;
FOUNDATION_EXPORT const unsigned char LokiVersionString[];

