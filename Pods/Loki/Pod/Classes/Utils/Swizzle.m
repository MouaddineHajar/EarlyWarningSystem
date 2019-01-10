//
//  Swizzle.m
//
//  Created by vlad gorbenko on 5/11/15.
//  Copyright (c) 2015 Vlad Gorbenko. All rights reserved.
//

#import "Swizzle.h"

#import <objc/runtime.h>

void SwizzleMethodsFrom(Class onClass, SEL fromMethod, Class fromClass, SEL toMethod) {
    Method originalMethod = class_getInstanceMethod(onClass, fromMethod);
    Method swizzledMethod = class_getInstanceMethod(fromClass, toMethod);
    
    BOOL didAddMethod = class_addMethod(onClass, fromMethod, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(onClass, toMethod, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}