//
//  CPatternController.h
//  Colors
//
//  Created by Matt Patenaude on 7/19/09.
//  Copyright 2009 Matt Patenaude. All rights reserved.
//

#import <Cocoa/Cocoa.h>


// Forward declarations
@class CController;

// Tag/edit conversion functions
NSInteger CTagForPatternFormat(NSString *theFormat);
NSString *CPatternFormatForTag(NSInteger theTag);

@interface CPatternController : NSObject {
	IBOutlet CController *appController;
	
	IBOutlet NSWindow *prefsWindow;
	IBOutlet NSWindow *patternEditSheet;
	
	IBOutlet NSTableView *patternList;
	NSMutableArray *patterns;
	
	// edit sheet outlets
	IBOutlet NSTextField *descriptionField;
	IBOutlet NSTextField *patternField;
	IBOutlet NSPopUpButton *redComponentField;
	IBOutlet NSPopUpButton *blueComponentField;
	IBOutlet NSPopUpButton *greenComponentField;
	IBOutlet NSPopUpButton *hueComponentField;
	IBOutlet NSPopUpButton *saturationComponentField;
	IBOutlet NSPopUpButton *lightnessComponentField;
	IBOutlet NSPopUpButton *alphaComponentField;
	
	NSInteger editingRow;
}

// Properties
- (NSArray *)patterns;

// Editing methods
- (IBAction)addPattern:(id)sender;
- (IBAction)removePattern:(id)sender;
- (IBAction)editPattern:(id)sender;

- (IBAction)saveSettings:(id)sender;
- (IBAction)cancelEdit:(id)sender;
- (void)savePatternList;
- (void)didEndSheet:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo;

// Table data source methods
- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView;
- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex;

// Table view delegate methods
- (void)tableView:(NSTableView *)aTableView willDisplayCell:(id)aCell forTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex;

@end
