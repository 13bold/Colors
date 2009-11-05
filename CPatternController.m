//
//  CPatternController.m
//  Colors
//
//  Created by Matt Patenaude on 7/19/09.
//  Copyright 2009 Slightly Pretentious Software. All rights reserved.
//

#import "CPatternController.h"
#import "CController.h"
#import "NSColor+CAdditions.h"


// Tag/edit conversion functions
NSInteger CTagForPatternFormat(NSString *theFormat)
{
	if ([theFormat isEqualToString:CHexPair])
		return 0;
	if ([theFormat isEqualToString:CHexSingleton])
		return 1;
	if ([theFormat isEqualToString:CShortDecimalOver1])
		return 2;
	if ([theFormat isEqualToString:CFloatOver1])
		return 3;
	if ([theFormat isEqualToString:CIntegerOver100])
		return 4;
	if ([theFormat isEqualToString:CShortDecimalOver100])
		return 5;
	if ([theFormat isEqualToString:CFloatOver100])
		return 6;
	if ([theFormat isEqualToString:CIntegerOver255])
		return 7;
	if ([theFormat isEqualToString:CShortDecimalOver255])
		return 8;
	if ([theFormat isEqualToString:CFloatOver255])
		return 9;
	if ([theFormat isEqualToString:CIntegerOver360])
		return 10;
	if ([theFormat isEqualToString:CShortDecimalOver360])
		return 11;
	if ([theFormat isEqualToString:CFloatOver360])
		return 12;
	return 3;
}
NSString *CPatternFormatForTag(NSInteger theTag)
{
	switch (theTag) {
		case 0:
			return CHexPair;
			break;
		case 1:
			return CHexSingleton;
			break;
		case 2:
			return CShortDecimalOver1;
			break;
		case 4:
			return CIntegerOver100;
			break;
		case 5:
			return CShortDecimalOver100;
			break;
		case 6:
			return CFloatOver100;
			break;
		case 7:
			return CIntegerOver255;
			break;
		case 8:
			return CShortDecimalOver255;
			break;
		case 9:
			return CFloatOver255;
			break;
		case 10:
			return CIntegerOver360;
			break;
		case 11:
			return CShortDecimalOver360;
			break;
		case 12:
			return CFloatOver360;
			break;
		case 3:
		default:
			return CFloatOver1;
			break;
	}
}

@implementation CPatternController

#pragma mark Initializers
+ (void)initialize
{
	[[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithObject:[NSArray array] forKey:@"patterns"]];
}
- (id)init
{
	if (self = [super init])
	{
		patterns = [[NSMutableArray alloc] init];
		editingRow = -1;
		
		// compile the list of patterns
		NSString *defaultPatterns = [[NSBundle mainBundle] pathForResource:@"DefaultPatterns" ofType:@"plist"];
		
		if (defaultPatterns)
		{
			NSArray *defPats = [[NSArray alloc] initWithContentsOfFile:defaultPatterns];
			for (NSDictionary *pat in defPats)
			{
				NSMutableDictionary *thePattern = [pat mutableCopy];
				[thePattern setObject:[NSNumber numberWithBool:NO] forKey:@"editable"];
				[patterns addObject:thePattern];
				[thePattern release];
			}
			[defPats release];
		}
		
		[patterns addObjectsFromArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"patterns"]];
	}
	return self;
}
- (void)awakeFromNib
{
	// set the table actions
	[patternList setTarget:self];
	[patternList setDoubleAction:@selector(editPattern:)];
}

#pragma mark Deallocator
- (void)dealloc
{
	[patterns release];
	[super dealloc];
}

#pragma mark Properties
- (NSArray *)patterns
{
	return patterns;
}

#pragma mark Editing methods
- (IBAction)addPattern:(id)sender
{
	editingRow = -1;
	
	[descriptionField setStringValue:@""];
	[patternField setStringValue:@""];
	[redComponentField selectItemWithTag:CTagForPatternFormat(CHexPair)];
	[greenComponentField selectItemWithTag:CTagForPatternFormat(CHexPair)];
	[blueComponentField selectItemWithTag:CTagForPatternFormat(CHexPair)];
	[hueComponentField selectItemWithTag:CTagForPatternFormat(CShortDecimalOver360)];
	[saturationComponentField selectItemWithTag:CTagForPatternFormat(CShortDecimalOver100)];
	[lightnessComponentField selectItemWithTag:CTagForPatternFormat(CShortDecimalOver100)];
	[alphaComponentField selectItemWithTag:CTagForPatternFormat(CShortDecimalOver1)];
	
	[NSApp beginSheet:patternEditSheet modalForWindow:prefsWindow modalDelegate:self didEndSelector:@selector(didEndSheet:returnCode:contextInfo:) contextInfo:nil];
	[patternEditSheet makeFirstResponder:descriptionField];
}
- (IBAction)removePattern:(id)sender
{
	NSInteger selection = [patternList selectedRow];
	if (selection > -1)
	{
		NSDictionary *pattern = [patterns objectAtIndex:selection];
		if (![[pattern objectForKey:@"editable"] boolValue])
			return;
		
		[patterns removeObjectAtIndex:selection];
	}
	[self savePatternList];
}
- (IBAction)editPattern:(id)sender
{
	NSInteger selection = [patternList selectedRow];
	if (selection > -1)
	{
		editingRow = selection;
		
		NSDictionary *pattern = [patterns objectAtIndex:selection];
		if (![[pattern objectForKey:@"editable"] boolValue])
			return;
		
		// open edit sheet
		[descriptionField setStringValue:[pattern objectForKey:@"description"]];
		[patternField setStringValue:[pattern objectForKey:@"pattern"]];
		[redComponentField selectItemWithTag:CTagForPatternFormat([pattern objectForKey:@"redFormat"])];
		[greenComponentField selectItemWithTag:CTagForPatternFormat([pattern objectForKey:@"greenFormat"])];
		[blueComponentField selectItemWithTag:CTagForPatternFormat([pattern objectForKey:@"blueFormat"])];
		[hueComponentField selectItemWithTag:CTagForPatternFormat([pattern objectForKey:@"hueFormat"])];
		[saturationComponentField selectItemWithTag:CTagForPatternFormat([pattern objectForKey:@"saturationFormat"])];
		[lightnessComponentField selectItemWithTag:CTagForPatternFormat([pattern objectForKey:@"lightnessFormat"])];
		[alphaComponentField selectItemWithTag:CTagForPatternFormat([pattern objectForKey:@"alphaFormat"])];
		
		[NSApp beginSheet:patternEditSheet modalForWindow:prefsWindow modalDelegate:self didEndSelector:@selector(didEndSheet:returnCode:contextInfo:) contextInfo:nil];
		[patternEditSheet makeFirstResponder:descriptionField];
	}
}

- (IBAction)saveSettings:(id)sender
{
	NSMutableDictionary *theItem = [NSMutableDictionary dictionary];
	
	[theItem setObject:[descriptionField stringValue] forKey:@"description"];
	[theItem setObject:[patternField stringValue] forKey:@"pattern"];
	[theItem setObject:CPatternFormatForTag([[redComponentField selectedItem] tag]) forKey:@"redFormat"];
	[theItem setObject:CPatternFormatForTag([[greenComponentField selectedItem] tag]) forKey:@"greenFormat"];
	[theItem setObject:CPatternFormatForTag([[blueComponentField selectedItem] tag]) forKey:@"blueFormat"];
	[theItem setObject:CPatternFormatForTag([[hueComponentField selectedItem] tag]) forKey:@"hueFormat"];
	[theItem setObject:CPatternFormatForTag([[saturationComponentField selectedItem] tag]) forKey:@"saturationFormat"];
	[theItem setObject:CPatternFormatForTag([[lightnessComponentField selectedItem] tag]) forKey:@"lightnessFormat"];
	[theItem setObject:CPatternFormatForTag([[alphaComponentField selectedItem] tag]) forKey:@"alphaFormat"];
	[theItem setObject:[NSNumber numberWithBool:YES] forKey:@"editable"];
	
	if (editingRow > -1)
		[patterns replaceObjectAtIndex:editingRow withObject:theItem];
	else
		[patterns addObject:theItem];
	
	[NSApp endSheet:patternEditSheet];
}
- (IBAction)cancelEdit:(id)sender
{
	[NSApp endSheet:patternEditSheet];
}
- (void)savePatternList
{
	[patternList reloadData];
	[appController populatePatternSelector];
	
	NSMutableArray *patternTemp = [[NSMutableArray alloc] init];
	for (NSDictionary *pattern in patterns)
	{
		if ([[pattern objectForKey:@"editable"] boolValue])
			[patternTemp addObject:pattern];
	}
	
	[[NSUserDefaults standardUserDefaults] setObject:patternTemp forKey:@"patterns"];
	[patternTemp release];
}
- (void)didEndSheet:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo
{
	editingRow = -1;
	[self savePatternList];
    [sheet orderOut:self];
}

#pragma mark Table data source methods
- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
	return [patterns count];
}
- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
	return [[patterns objectAtIndex:rowIndex] objectForKey:@"description"];
}

#pragma mark Table view delegate methods
- (void)tableView:(NSTableView *)aTableView willDisplayCell:(id)aCell forTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
	return [aCell setEnabled:[[[patterns objectAtIndex:rowIndex] objectForKey:@"editable"] boolValue]];
}

@end
