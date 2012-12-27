//
//  NSColor+CAdditions.m
//  Colors
//
//  Created by Matt Patenaude on 7/19/09.
//  Copyright 2009 Matt Patenaude. All rights reserved.
//

#import "NSColor+CAdditions.h"
#import "MPTidbits.h"

#pragma mark Hex functions
NSString *CDecToHexPair(NSInteger decNumber)
{
	if (decNumber > 255)
	{
		NSLog(@"Error: CADecToHexPair cannot accept numbers larger than 255");
		return nil;
	}
	
	NSArray *hTable = [NSArray arrayWithObjects:@"a", @"b", @"c", @"d", @"e", @"f", nil];
	
	NSString *pair = @"%@%@";
	
	NSInteger digOne = decNumber / 16;
	NSInteger digTwo = decNumber % 16;
	
	NSString *p1;
	if (digOne < 10)
		p1 = [NSString stringWithFormat:@"%d", digOne];
	else
		p1 = [hTable objectAtIndex:(digOne - 10)];
	
	NSString *p2;
	if (digTwo < 10)
		p2 = [NSString stringWithFormat:@"%d", digTwo];
	else
		p2 = [hTable objectAtIndex:(digTwo - 10)];
	
	return [NSString stringWithFormat:pair, p1, p2];
}
NSString *CDecToHexSingleton(NSInteger decNumber)
{
	if (decNumber > 255)
	{
		NSLog(@"Error: CADecToHexSingleton cannot accept numbers larger than 255");
		return nil;
	}
	
	NSArray *hTable = [NSArray arrayWithObjects:@"a", @"b", @"c", @"d", @"e", @"f", nil];
	
	NSInteger digOne = decNumber / 16;
	NSInteger digTwo = decNumber % 16;
	
	if (digOne != digTwo)
	{
		NSLog(@"Error: cannot represent %d as singleton", decNumber);
		return nil;
	}
	
	NSString *p1;
	if (digOne < 10)
		p1 = [NSString stringWithFormat:@"%d", digOne];
	else
		p1 = [hTable objectAtIndex:(digOne - 10)];
	
	return p1;
}

#pragma mark Formatting function
NSString *CFormattedComponent(CGFloat component, NSString *theFormat)
{
	if ([theFormat isEqualToString:CHexSingleton])
	{
		NSInteger dec = MPRound(component * 255.0);
		return CDecToHexSingleton(dec);
	}
	else if ([theFormat isEqualToString:CHexPair])
	{
		NSInteger dec = MPRound(component * 255.0);
		return CDecToHexPair(dec);
	}
	else if ([theFormat isEqualToString:CShortDecimalOver1])
		return [NSString stringWithFormat:@"%0.4f", component];
	else if ([theFormat isEqualToString:CIntegerOver100])
		return [NSString stringWithFormat:@"%d", MPRound(component * 100.0)];
	else if ([theFormat isEqualToString:CShortDecimalOver100])
		return [NSString stringWithFormat:@"%0.4f", (component * 100.0)];
	else if ([theFormat isEqualToString:CFloatOver100])
		return [NSString stringWithFormat:@"%f", (component * 100.0)];
	else if ([theFormat isEqualToString:CIntegerOver255])
		return [NSString stringWithFormat:@"%d", MPRound(component * 255.0)];
	else if ([theFormat isEqualToString:CShortDecimalOver255])
		return [NSString stringWithFormat:@"%0.4f", (component * 255.0)];
	else if ([theFormat isEqualToString:CFloatOver255])
		return [NSString stringWithFormat:@"%f", (component * 255.0)];
	else if ([theFormat isEqualToString:CIntegerOver360])
		return [NSString stringWithFormat:@"%d", MPRound(component * 360.0)];
	else if ([theFormat isEqualToString:CShortDecimalOver360])
		return [NSString stringWithFormat:@"%0.4f", (component * 360.0)];
	else if ([theFormat isEqualToString:CFloatOver360])
		return [NSString stringWithFormat:@"%f", (component * 360.0)];
	// else if ([theFormat isEqualToString:CFloatOver1])
	return [NSString stringWithFormat:@"%f", component];
}

@implementation NSColor (CAdditions)

#pragma mark Input methods
+ (NSColor *)colorWithCSSColor:(NSString *)theString
{
	NSMutableString *rule = [[[theString lowercaseString] mutableCopy] autorelease];
	[rule replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [rule length])];
	[rule replaceOccurrencesOfString:@"\t" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [rule length])];
	[rule replaceOccurrencesOfString:@";" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [rule length])];
	
	// rgb() and rgba() rules
	if ([rule hasPrefix:@"rgb"])
	{
		[rule replaceOccurrencesOfString:@"rgb" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [rule length])];
		[rule replaceOccurrencesOfString:@"a(" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [rule length])];
		[rule replaceOccurrencesOfString:@"(" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [rule length])];
		[rule replaceOccurrencesOfString:@")" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [rule length])];
		NSArray *components = [rule componentsSeparatedByString:@","];
		
		CGFloat comps[4] = {0.0, 0.0, 0.0, 1.0};
		
		NSUInteger i;
		for (i = 0; i < 3; i++)
		{
			NSString *part = [components objectAtIndex:i];
			if ([part rangeOfString:@"%"].location != NSNotFound)
			{
				part = [part stringByReplacingOccurrencesOfString:@"%" withString:@""];
				comps[i] = ([part floatValue] / 100.0);
			}
			else
				comps[i] = ([part floatValue] / 255.0);
		}
		
		if ([components count] > 3)
			comps[3] = [[components objectAtIndex:3] floatValue];
		
		return [NSColor colorWithCalibratedRed:comps[0] green:comps[1] blue:comps[2] alpha:comps[3]];
	}
	// hsl() and hsla() rules
	else if ([rule hasPrefix:@"hsl"])
	{
		[rule replaceOccurrencesOfString:@"hsl" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [rule length])];
		[rule replaceOccurrencesOfString:@"a(" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [rule length])];
		[rule replaceOccurrencesOfString:@"(" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [rule length])];
		[rule replaceOccurrencesOfString:@")" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [rule length])];
		NSArray *components = [rule componentsSeparatedByString:@","];
		
		CGFloat comps[4] = {0.0, 0.0, 0.0, 1.0};
		
		NSUInteger i;
		for (i = 0; i < 3; i++)
		{
			NSString *part = [components objectAtIndex:i];
			if ([part rangeOfString:@"%"].location != NSNotFound)
			{
				part = [part stringByReplacingOccurrencesOfString:@"%" withString:@""];
				comps[i] = ([part floatValue] / 100.0);
			}
			else
				comps[i] = ([part floatValue] / 360.0);
		}
		
		if ([components count] > 3)
			comps[3] = [[components objectAtIndex:3] floatValue];
		
		// HSL-to-HSV
		comps[2] *= 2.0;
		comps[1] *= (comps[2] <= 1.0) ? comps[2] : 2.0 - comps[2];
		
		return [NSColor colorWithCalibratedHue:comps[0] saturation:((2.0 * comps[1]) / (comps[2] + comps[1])) brightness:((comps[2] + comps[1]) / 2.0) alpha:comps[3]];
	}
	// #rrggbb and #rgb
	else if ([rule hasPrefix:@"#"] || ([rule length] == 6 || [rule length] == 3))
	{
		[rule replaceOccurrencesOfString:@"#" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [rule length])];
		
		CGFloat comps[4] = {0.0, 0.0, 0.0, 1.0};
		
		BOOL singletons = ([rule length] == 3);
		NSUInteger i;
		for (i = 0; i < 3; i++)
		{
			NSString *component = [rule substringWithRange:NSMakeRange(((singletons) ? i : i * 2), ((singletons) ? 1 : 2))];
			NSScanner *theScanner = [NSScanner scannerWithString:((singletons) ? [NSString stringWithFormat:@"%@%@", component, component] : component)];
			
			unsigned thePart;
			[theScanner scanHexInt:&thePart];
			
			comps[i] = (CGFloat)thePart / 255.0;
		}
		
		return [NSColor colorWithCalibratedRed:comps[0] green:comps[1] blue:comps[2] alpha:comps[3]];
	}
	
	return [NSColor blackColor];
}

#pragma mark Output methods
- (NSString *)redComponentWithFormat:(NSString *)theString
{
	return CFormattedComponent([self redComponent], theString);
}
- (NSString *)greenComponentWithFormat:(NSString *)theString
{
	return CFormattedComponent([self greenComponent], theString);
}
- (NSString *)blueComponentWithFormat:(NSString *)theString
{
	return CFormattedComponent([self blueComponent], theString);
}
- (NSString *)hueComponentWithFormat:(NSString *)theString
{
	return CFormattedComponent([self hueComponent], theString);
}
- (NSString *)saturationComponentWithFormat:(NSString *)theString
{
	// HSV-to-HSL hack
	CGFloat saturationComponent = [self saturationComponent] * [self brightnessComponent];
	CGFloat lightnessComponent = (2.0 - [self saturationComponent]) * [self brightnessComponent];
	saturationComponent /= (lightnessComponent <= 1.0) ? lightnessComponent : (2.0 - lightnessComponent);
	
	return CFormattedComponent(saturationComponent, theString);
}
- (NSString *)lightnessComponentWithFormat:(NSString *)theString
{
	// HSV-to-HSL hack
	CGFloat lightnessComponent = ((2.0 - [self saturationComponent]) * [self brightnessComponent]) / 2.0;
	
	return CFormattedComponent(lightnessComponent, theString);
}
- (NSString *)alphaComponentWithFormat:(NSString *)theString
{
	return CFormattedComponent([self alphaComponent], theString);
}

- (NSString *)stringWithPattern:(NSDictionary *)thePatternDict
{
	NSString *thePattern = [thePatternDict objectForKey:@"pattern"];
	
	NSString *redFormat = [thePatternDict objectForKey:@"redFormat"];
	NSString *greenFormat = [thePatternDict objectForKey:@"greenFormat"];
	NSString *blueFormat = [thePatternDict objectForKey:@"blueFormat"];
	
	NSString *hueFormat = [thePatternDict objectForKey:@"hueFormat"];
	NSString *saturationFormat = [thePatternDict objectForKey:@"saturationFormat"];
	NSString *lightnessFormat = [thePatternDict objectForKey:@"lightnessFormat"];
	
	NSString *alphaFormat = [thePatternDict objectForKey:@"alphaFormat"];
	
	// make a mutable string to save memory
	NSMutableString *output = [thePattern mutableCopy];
	
	// start by escaping double-percents
	[output replaceOccurrencesOfString:@"%%" withString:@"--double-percent-escaped--" options:NSLiteralSearch range:NSMakeRange(0, [output length])];
	
	// format the components
	[output replaceOccurrencesOfString:@"%r" withString:[self redComponentWithFormat:redFormat] options:NSCaseInsensitiveSearch range:NSMakeRange(0, [output length])];
	[output replaceOccurrencesOfString:@"%g" withString:[self greenComponentWithFormat:greenFormat] options:NSCaseInsensitiveSearch range:NSMakeRange(0, [output length])];
	[output replaceOccurrencesOfString:@"%b" withString:[self blueComponentWithFormat:blueFormat] options:NSCaseInsensitiveSearch range:NSMakeRange(0, [output length])];
	[output replaceOccurrencesOfString:@"%h" withString:[self hueComponentWithFormat:hueFormat] options:NSCaseInsensitiveSearch range:NSMakeRange(0, [output length])];
	[output replaceOccurrencesOfString:@"%s" withString:[self saturationComponentWithFormat:saturationFormat] options:NSCaseInsensitiveSearch range:NSMakeRange(0, [output length])];
	[output replaceOccurrencesOfString:@"%l" withString:[self lightnessComponentWithFormat:lightnessFormat] options:NSCaseInsensitiveSearch range:NSMakeRange(0, [output length])];
	[output replaceOccurrencesOfString:@"%a" withString:[self alphaComponentWithFormat:alphaFormat] options:NSCaseInsensitiveSearch range:NSMakeRange(0, [output length])];
	
	// replace removed percents
	[output replaceOccurrencesOfString:@"--double-percent-escaped--" withString:@"%" options:NSLiteralSearch range:NSMakeRange(0, [output length])];
	
	// return the results
	return [output autorelease];
}

@end
