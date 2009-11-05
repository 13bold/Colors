//
//  CController.h
//  Colors
//
//  Created by Matt Patenaude on 7/19/09.
//  Copyright 2009 Matt Patenaude. All rights reserved.
//

#import <Cocoa/Cocoa.h>


// Forward declarations
@class CPatternController;

// Pasteboard functions
void CCopyStringToPasteboard(NSString *toCopy);

@interface CController : NSObject {
	IBOutlet NSWindow *mainWindow;
	IBOutlet NSWindow *prefsWindow;
	
	IBOutlet NSWindow *colorInputSheet;
	IBOutlet NSTextField *colorInputField;
	
	IBOutlet NSColorWell *colorWell;
	IBOutlet NSPopUpButton *patternSelector;
	IBOutlet CPatternController *patternController;
}

// Interface methods
- (void)composeInterface;
- (IBAction)displayPreferences:(id)sender;
- (void)populatePatternSelector;

// Methods
- (IBAction)grabColorForScreen:(id)sender;
- (IBAction)copyColorToPasteboard:(id)sender;
- (IBAction)inputNewColor:(id)sender;
- (IBAction)saveNewColor:(id)sender;
- (IBAction)cancelNewColor:(id)sender;
- (void)didEndSheet:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo;

// Color panel delegate methods
- (void)changeColor:(id)sender;

@end

// Hack to enable magnifier access
@interface _NSMagnifier : NSObject {}
+ (id)sharedMagnifier;
- (void)trackMagnifierForPanel:(id)fp8;
@end
