//
//  Casper_Imaging_for_Mac_OS_10.h
//  Casper Imaging for Mac OS 10
//
//  Created by Jon Pierce-Ruhland on 7/7/11.
//  Copyright 2011 JAMF Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Automator/AMBundleAction.h>
#import <SecurityFoundation/SFAuthorization.h>

@interface Casper_Imaging_for_Mac_OS_10 : AMBundleAction {
@private
    
    BOOL configAutoLogin;
    BOOL allowInvalidCert;
    BOOL createPrefsFile;
    BOOL launchImagingAtLogin;
    BOOL validAppAddress;
    BOOL db;
    
    NSString* casperImagingApp;
    NSString* jssAddress;
    NSString* MOUNTED_DISK_IMAGE;
    NSString* RESOURCES_LOCATION;
    NSString* adminPassword;
    
    NSFileManager* _fileManager;
}

@property BOOL configAutoLogin;
@property BOOL allowInvalidCert;
@property BOOL createPrefsFile;
@property BOOL launchImagingAtLogin;
@property BOOL validAppAddress;
@property BOOL db;

@property (nonatomic, retain) NSString* casperImagingApp;
@property (nonatomic, retain) NSString* jssAddress;
@property (nonatomic, retain) NSString* adminPassword;

//@property void chooseFiles;

- (id)runWithInput:(id)input fromAction:(AMAction *)anAction error:(NSDictionary **)errorInfo;

- (void)setMountedDiskImage:(id)input;

- (NSString*)cleanedJSSURL:(NSString*)addressToParse;

- (NSString*)safeString:(NSString*)source;

- (NSString*) strFromBool:(BOOL)input;

- (void)copy:(NSString*)sourceFile to:(NSString*)destFile;

- (void)chmod:(NSString*)filename with:(NSString*)number;

- (BOOL)chown:(NSString*)filename with:(NSString*)number;

- (BOOL)mkdir:(NSString*)dir;

- (BOOL)runAuthenticated:(NSString*)command;

- (void)unmountDiskImage;

- (void)removeMountedDirectory;

- (BOOL)defaultsWrite:(NSString*)stringToWrite;

- (void)printParams;

- (void)log:(NSString*)str;

- (void)log:(NSString*)str1 and:(NSString*)str2;

- (void)log:(NSString*)str overrideDebug:(BOOL)override;

- (void)chooseFiles;

- (void)reportError:(NSString *)message inDictionary:(NSDictionary *)errorInfo;

@end
