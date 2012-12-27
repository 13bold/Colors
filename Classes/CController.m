//
//  CController.m
//  Colors
//
//  Created by Matt Patenaude on 7/19/09.
//  Copyright 2009 Matt Patenaude. All rights reserved.
//

#import "CController.h"
#import "NSColor+CAdditions.h"
#import "CPatternController.h"


#pragma mark Pasteboard functions
void CCopyStringToPasteboard(NSString *toCopy)
{
	NSPasteboard *pb = [NSPasteboard generalPasteboard];
	[pb declareTypes:[NSArray arrayWithObject:NSStringPboardType] owner:nil];
	[pb setString:toCopy forType:NSStringPboardType];
}

@implementation CController

#pragma mark Initializers
- (void)awakeFromNib
{
	[self composeInterface];
    
    mainWindow.delegate = self;
}

- (void)applicationWillFinishLaunching:(NSNotification *)aNotification
{
	[NSColor setIgnoresAlpha:NO];
    [NSColorPanel sharedColorPanel].delegate = self;
}

#pragma mark Interface methods
- (void)composeInterface
{
	[mainWindow setContentBorderThickness:21.0 forEdge:NSMinYEdge];
	[self populatePatternSelector];
}
- (IBAction)displayPreferences:(id)sender
{
	[prefsWindow makeKeyAndOrderFront:sender];
}
- (void)populatePatternSelector
{
	NSString *oldTitle = [[[patternSelector selectedItem] title] copy];
	
	NSArray *itemArray = [[patternSelector itemArray] copy];
	for (NSMenuItem *item in itemArray)
		[[patternSelector menu] removeItem:item];
	[itemArray release];
	
	NSArray *patterns = [patternController patterns];
	for (NSDictionary *pattern in patterns)
		[patternSelector addItemWithTitle:[pattern objectForKey:@"description"]];
	
	if (oldTitle)
	{
		if ([patternSelector itemWithTitle:oldTitle] != nil)
			[patternSelector selectItemWithTitle:oldTitle];
		[oldTitle release];
	}
}

#pragma mark Methods
- (IBAction)grabColorForScreen:(id)sender
{
	_NSMagnifier *mag = [_NSMagnifier sharedMagnifier];
	[mag trackMagnifierForPanel:[NSColorPanel sharedColorPanel]];
}
- (IBAction)copyColorToPasteboard:(id)sender
{
	NSInteger selection = [patternSelector indexOfSelectedItem];
	if (selection > -1)
	{
		NSArray *patterns = [patternController patterns];
		NSDictionary *thePattern = [patterns objectAtIndex:selection];
		
		NSString *output = [[colorWell color] stringWithPattern:thePattern];
		CCopyStringToPasteboard(output);
	}
}
- (IBAction)inputNewColor:(id)sender
{
	[colorInputField setStringValue:@""];
	[NSApp beginSheet:colorInputSheet modalForWindow:mainWindow modalDelegate:self didEndSelector:@selector(didEndSheet:returnCode:contextInfo:) contextInfo:nil];
	[colorInputSheet makeFirstResponder:colorInputField];
}
- (IBAction)saveNewColor:(id)sender
{
	[colorWell setColor:[NSColor colorWithCSSColor:[colorInputField stringValue]]];
	[NSApp endSheet:colorInputSheet];
}
- (IBAction)cancelNewColor:(id)sender
{
	[NSApp endSheet:colorInputSheet];
}
- (void)didEndSheet:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo
{
    [sheet orderOut:self];
}

#pragma mark Color panel delegate methods
- (void)changeColor:(id)sender
{
	[NSApp activateIgnoringOtherApps:YES];
	[colorWell setColor:[sender color]];
}

- (BOOL)windowShouldClose:(id)sender {
    if(sender == mainWindow) {
        [[NSApplication sharedApplication] hide:nil];
        return NO;
    }
    return YES;
}



@end
