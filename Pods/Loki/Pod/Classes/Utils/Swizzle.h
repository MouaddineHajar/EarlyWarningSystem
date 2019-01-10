//
//  Swizzle.h
//
//  Created by vlad gorbenko on 5/11/15.
//  Copyright (c) 2015 Vlad Gorbenko. All rights reserved.
//

@import Foundation;

void SwizzleMethodsFrom(Class onClass, SEL fromMethods, Class fromClass, SEL toMethod);