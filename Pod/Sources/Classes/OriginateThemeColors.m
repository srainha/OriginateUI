//
//  OriginateThemeColors.m
//  OriginateUI
//
//  Created by Philip Kluz on 7/6/15.
//  Copyright (c) 2015 Originate. All rights reserved.
//

#import "OriginateThemeColors.h"

NSString * const OUIColorPrimaryKey = @"primary";
NSString * const OUIColorSecondaryKey = @"secondary";
NSString * const OUIColorSuccessKey = @"success";
NSString * const OUIColorWarningKey = @"warning";
NSString * const OUIColorErrorKey = @"error";

@interface OriginateThemeColors ()

#pragma mark - Properties
@property (nonatomic, strong, readwrite) NSDictionary *definition;

@end

@implementation OriginateThemeColors

#pragma mark - OriginateThemeColors

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if (self) {
        _definition = dictionary;
    }
    
    return self;
}

- (UIColor *)primaryColor
{
    if (!_primaryColor) {
        _primaryColor = [[self class] colorForKey:OUIColorPrimaryKey
                                           source:self.definition
                                         fallback:[UIColor hex:0x00A0D8]];
    }
    
    return _primaryColor;
}

- (UIColor *)secondaryColor
{
    if (!_secondaryColor) {
        _secondaryColor = [[self class] colorForKey:OUIColorSecondaryKey
                                             source:self.definition
                                           fallback:[UIColor hex:0xFCD92B]];
    }
    
    return _secondaryColor;
}

- (UIColor *)successColor
{
    if (!_successColor) {
        _successColor = [[self class] colorForKey:OUIColorSuccessKey
                                           source:self.definition
                                         fallback:[UIColor hex:0x95BE22]];
    }
    
    return _successColor;
}

- (UIColor *)warningColor
{
    if (!_warningColor) {
        _warningColor = [[self class] colorForKey:OUIColorWarningKey
                                                 source:self.definition
                                               fallback:[UIColor hex:0xFFA500]];
    }
    
    return _warningColor;
}

- (UIColor *)errorColor
{
    if (!_errorColor) {
        _errorColor = [[self class] colorForKey:OUIColorErrorKey
                                         source:self.definition
                                       fallback:[UIColor hex:0xFD1111]];
    }
    
    return _errorColor;
}

+ (UIColor *)colorForKey:(NSString *)key
                  source:(NSDictionary *)definition
                fallback:(UIColor *)fallback
{
    NSString *colorValue = definition[key];
    
    if ([colorValue length] == 0) {
        return fallback;
    }
    
    UIColor *color = [UIColor colorWithHexString:colorValue];
    
    return color ?: fallback;
}

@end