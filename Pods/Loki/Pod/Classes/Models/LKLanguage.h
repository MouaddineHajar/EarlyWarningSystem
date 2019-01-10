//
//  LKLanguage.h
//
//  Created by Vlad Gorbenko on 4/21/15.
//  Copyright (c) 2015 Vlad Gorbenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LKLanguage : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *title;

@property (nonatomic) NSLocaleLanguageDirection direction;

- (instancetype)initWithName:(NSString*)name code:(NSString*)code;
- (instancetype)initWithName:(NSString*)name code:(NSString*)code title:(NSString *)title;

@end
