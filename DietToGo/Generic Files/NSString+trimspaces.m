//
//  NSString+trimspaces.m
//  ServeItUp
//
//  Created by EHEandme on 6/20/13.
//  Copyright (c) 2013 valuelabs. All rights reserved.
//

#import "NSString+trimspaces.h"

@implementation NSString (trimspaces)
- (NSString *) stringByTrimmingWhiteSpace
{
    NSString *resultString = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return resultString;
}
-(NSString*)encodeToHTMLText:(NSString*)mText {
    
    mText = [mText stringByReplacingOccurrencesOfString:@"'" withString:@"&#39;"];
    return mText;
}
-(NSString*)decodeToHTMLText:(NSString*)mText {
    
    mText = [mText stringByReplacingOccurrencesOfString:@"&#39;" withString:@"'"];
    return mText;
}

- (NSString *) removeLeadingZeros:(NSString *)Instring
{
    NSString *str2 =Instring ;
    
    for (int index=0; index<[str2 length]; index++)
    {
        if([str2 hasPrefix:@"0"])
            str2  =[str2 substringFromIndex:1];
        else
            break;
    }
    return str2;
    
}

- (NSString *) removeTrailingZeros:(NSString *)Instring
{
    NSString *str2 =Instring ;
    int length = [str2 length];
    for (int index=length; index>0; index--)
    {
        if([str2 hasSuffix:@"0"])
            str2  =[str2 substringWithRange:NSMakeRange(0, length-1)];
        else
            break;
    }
    return str2;
    
}

-(NSString*) removeLastCharacterOfString:(NSString*) InString {
    NSString *str2 =InString ;
    int length = [str2 length];
    for (int index=length; index>0; index--)
    {
        str2  =[str2 substringWithRange:NSMakeRange(0, length-1)];
        break;
    }
    return str2;
}


@end
