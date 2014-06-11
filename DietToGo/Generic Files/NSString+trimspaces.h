//
//  NSString+trimspaces.h
//  ServeItUp
//
//  Created by EHEandme on 6/20/13.
//  Copyright (c) 2013 valuelabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (trimspaces)
- (NSString *) stringByTrimmingWhiteSpace;
-(NSString*)encodeToHTMLText:(NSString*)mText;
-(NSString*)decodeToHTMLText:(NSString*)mText;

/*
 *Method to remove the leading Zeros from the given string
 *@param Instring is the actual string
 */
- (NSString *) removeLeadingZeros:(NSString *)Instring;

/*
 *Method to remove the ending Zeros from the given string
 *@param Instring is the actual string
 */
- (NSString *) removeTrailingZeros:(NSString *)Instring;

/*
 *Method to remove the last character from the given string
 *@param Instring is the actual string
 */
- (NSString*) removeLastCharacterOfString:(NSString*) InString;
@end
