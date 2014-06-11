//
//  UtilitiesLibrary.h
//  UtilitiesLibrary
//
//  Created by Swathi Motaparthi on 7/17/12.
//  Copyright (c) 2012 ValueLabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 * Enum for DeviceType
 */

typedef enum{
    EIPhone,
	EIPod,
	EIPad,
	ENONE
} DeviceType;


@interface UtilitiesLibrary : NSObject {
	
}

/**
 * Method used to get the substring from a source string
 * @param total string parameter
 * @param start value of the string to get the substring
 * @param end value of the string to get the substring
 */

+ (NSString*) getSubstringForGivenString:(NSString*)strTotalString  :(NSString*)strStartValue  :(NSString*)strEndValue;

/**
 * Method used to check the string is a part of substring or not
 * @param string to check whether it is part of the source string or not
 * @param source string
 */

+ (BOOL)isASubString:(NSString*)strSubStr :(NSString*)aSource;

/**
 * Method used to check the string is integer or not
 * @param string to check whether it is integer string or not
 */

+ (BOOL)isInteger:(NSString*)ValString;

/**
 * Method used to display an alertview with a message and title
 * @param title of the alertview
 * @param message to be displayed in the alertview
 */

+(void) showAlertViewWithTitle:(NSString*)strTitle :(NSString*)strMsg;

/**
 * Method used to get the device type like iPhone, iPhone Simulator, iPad, iPad Simulator, iPod touch
 */

+(DeviceType) getDeviceType;

/**
 * Method used to identify the fault string in the web service response (.Net backend server)
 * @param string used to identify the fault message is present or not
 */

+ (BOOL)isFaultStringResponse:(NSString*)strResponse;

/**
 * Method used to get the difference between two dates
 * @param string which is from date
 * @param string which is to date
 */

+ (NSString *)dateDifferenceStringFromString:(NSString *)dateFromString
									  toDate:(NSString *)dateToString;

/**
 * Method used to get the difference of times in words
 * @param date
 */

+(NSString *)distanceOfTimeInWordsSinceDate:(NSDate *)aDate;

/**
 * Method used to get the size of the folder
 * @param path at the which the folder resides
 */

+ (unsigned long long int)folderSize:(NSString *)folderPath;

/**
 * Method used to clear the local cache
 * @param folder name which user needs to clear
 * @param specific file name which needs to be deleted
 * @param except file - All files and folders should be deleted expect this file
 */

+(BOOL)clearCache:(NSString*)docFolderName :(NSString*)fileName :(NSString*)exceptFile;

/**
 * Method used to convert the bytes into MegaBytes
 * @param size specifies bytes which needs to be converted into MB
 */

+(float)bytesToMB:(unsigned long long int)size;

/**
 * Method used to delete the HTTP cookies for the specified URL
 * @param url for which cookies needs to be deleted
 */

+ (void)deleteHTTPCookies:(NSURL*)url;

/**
 * Method used to delete the HTTP cookies for the specified URL
 * @param url for which cookies needs to be deleted
 */

+(NSString*)fileNameWithDate:(NSDate*)date;

/**
 * Method used to create the folder in the specified directory
 * @param directory where user needs to create the folder
 * @param folder name which user wants to create the folder
 */

+ (BOOL)createMyDocsDirectory:(NSString*)directory :(NSString*)folderName;

/**
 * Method used to create the folder in the specified directory
 * @param directory where user needs to create the folder
 * @param folder name which user wants to create the folder
 */

+(BOOL)saveDirectoriesToPlist:(NSMutableArray*)arrayOfElements :(NSString*)docsDirectory;

/**
 * Method used to check whether the file exists or not
 * @param directory along with file name where user needs to check the file 
 */

+(BOOL)isFileExists:(NSString*)docsDirectory;

//Commented by Swathi 19July2012
//+(NSString*)getCachedFileName:(NSString*)docsDirectory:(NSString*)urlString:(NSString*)webDavURLString;

/**
 * Method used to get the application document directory path
 */

+ (NSString *)applicationDocumentsDirectory;

/**
 * Method used to set the status bar style and status bar hidden property
 * @param is status bar hidden or not. User need to pass boolean parameter
 * @param staus bar style
 */

+(void)setStatusBar :(BOOL)isStatusBarHidden :(UIStatusBarStyle)statusBarStyle;

/**
 * Method used to scale the image
 * @param size at which the image to be scaled
 * @param image to be scaled
 */

+ (UIImage*) imageScaledToSize: (CGSize) newSize :(UIImage*)largeImage;

/**
 * Method used crop the image
 * @param image to be cropped
 * @param width of the new image
  * @param height of the new image
  * @param x position of the new image
  * @param y position of the new image
 */

+ (UIImage *)crop:(UIImage*)largeImage :(CGFloat)width :(CGFloat)height :(int)xPosition :(int)yPosition;

/**
 * Method used to get the border for the image
 * @param image for which the border to be drawn
 */

+ (UIImage*)imageWithBorderFromImage:(UIImage*)source;

/**
 * Method used to calculate the sixe of the image
 * @param new size of the image
 * @param actual image size
 */

+(CGRect)calculateSize :(CGSize) newSize :(CGSize)imageSize;

/**
 * Method used to recognize the device
 */

+(BOOL)recognizeDevice;

@end

