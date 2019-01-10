//
//  LKLanguage.m
//
//  Created by Vlad Gorbenko on 4/21/15.
//  Copyright (c) 2015 Vlad Gorbenko. All rights reserved.
//

#import "LKLanguage.h"

#import "LKManager.h"

@implementation LKLanguage

- (instancetype)initWithName:(NSString*)name code:(NSString*)code {
    self = [super init];
    if (self) {
        self.name = name;
        self.code = code;
        self.direction = [[LKManager rightToLeftLanguagesCodes] containsObject:code] ? NSLocaleLanguageDirectionRightToLeft : NSLocaleLanguageDirectionLeftToRight;
    }
    return self;
}

- (instancetype)initWithName:(NSString*)name code:(NSString*)code title:(NSString *)title {
    self = [self initWithName:name code:code];
    if (self) {
        self.title = title;
    }
    return self;
}

@end
