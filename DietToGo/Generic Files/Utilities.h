//
//  Utilities.h
//  ServeItUp
//
//  Created by Value Labs on 03/06/13.
//  Copyright (c) 2013 valuelabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
@interface Utilities : NSObject
{
    
}
/**
 * method used to get a string in between two strings
 * @param total string
 * @param starting string
 * @param ending string
 */
+ (NSString*) getSubstringForGivenString:(NSString*)strTotalString :(NSString*)                           strStartValue :(NSString*)strEndValue;
/**
 * method used to check whether a string in sub string of other
 * @param sub string
 * @param total string
 */
+(BOOL)isASubString:(NSString*)strSubStr :(NSString*)aSource;



/**
 * method used to get the encoded string for an image
 * @param image
 */
+(NSString *)getStringFromImage:(UIImage *)image;

/**
 * method used to get the image from the encoded string
 * @param encoded string of a image
 */
+(UIImage *)getImageFromString:(NSString *)beforeStringImage;

/**
 * method used to scale an image
 * @param image
 * @param size of the image
 */
+ (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;

+ (BOOL)isEmailValid:(NSString*)mEmail;
+ (BOOL)isPasswordValid:(NSString*)mPassword;
+ (BOOL)isPasswordMatches:(NSString*)mPassword :(NSString *)mConfirmPassword;
+ (BOOL)isZipcodeValid:(NSString*)mZipCode;
+ (BOOL)isStringValid:(NSString*)mString;
+ (BOOL)isUserNameStringValid:(NSString*)mString;

/*
 * Method used to add toolbar with cancel and done buttons for a textview
 * @param mTxtView for textview instance
 * @param mViewController for class reference
 */
+ (void)addInputViewForKeyBoard:(UITextView*)mTxtView
                          Class:(UIViewController*)mViewController;
+ (void)addInputViewForKeyBoardForTextFld:(UITextField*)mTxtView
                          Class:(UIViewController*)mViewController;
/*
 * Method used to crop the larger image
 * @param largeImage for large image
 */
+ (UIImage *)crop:(UIImage*)largeImage;

/*
 * Method used to return the time interval from the given date
 * @param mPiostedTime for the time received from server
 */
+ (NSString*)returnTheTimeDifferenceString:(NSString*)mPostedTime;

UIImage *UIImageResize(UIImage *image, CGSize targetSize);
@end
