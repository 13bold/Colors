//
//  NSColor+CAdditions.h
//  Colors
//
//  Created by Matt Patenaude on 7/19/09.
//  Copyright 2009 Matt Patenaude. All rights reserved.
//

#import <Cocoa/Cocoa.h>

// Format mode constants
#define CHexSingleton @"hexSingleton"
#define CHexPair @"hexPair"
#define CShortDecimalOver1 @"dec1"
#define CFloatOver1 @"float1"
#define CIntegerOver100 @"int100"
#define CShortDecimalOver100 @"dec100"
#define CFloatOver100 @"float100"
#define CIntegerOver255 @"int255"
#define CShortDecimalOver255 @"dec255"
#define CFloatOver255 @"float255"
#define CIntegerOver360 @"int360"
#define CShortDecimalOver360 @"dec360"
#define CFloatOver360 @"float360"

// Rounding function
#define MPRound(x) ((x)>=0?(NSInteger)((x)+0.5):(NSInteger)((x)-0.5))

// Hex functions
NSString *CDecToHexPair(NSInteger decNumber);
NSString *CDecToHexSingleton(NSInteger decNumber);

// Formatting function
NSString *CFormattedComponent(CGFloat component, NSString *theFormat);

@interface NSColor (CAdditions)

// Input methods
+ (NSColor *)colorWithCSSColor:(NSString *)theString;

// Output methods
- (NSString *)redComponentWithFormat:(NSString *)theString;
- (NSString *)greenComponentWithFormat:(NSString *)theString;
- (NSString *)blueComponentWithFormat:(NSString *)theString;
- (NSString *)hueComponentWithFormat:(NSString *)theString;
- (NSString *)saturationComponentWithFormat:(NSString *)theString;
- (NSString *)lightnessComponentWithFormat:(NSString *)theString;
- (NSString *)alphaComponentWithFormat:(NSString *)theString;

- (NSString *)stringWithPattern:(NSDictionary *)thePatternDict;

@end
