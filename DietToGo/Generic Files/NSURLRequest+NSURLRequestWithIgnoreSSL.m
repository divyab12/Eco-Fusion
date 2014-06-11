//
//  NSURLRequest+NSURLRequestWithIgnoreSSL.m
//  DietToGo
//
//  Created by Suresh on 5/1/14.
//  Copyright (c) 2014 DietToGo. All rights reserved.
//

#import "NSURLRequest+NSURLRequestWithIgnoreSSL.h"

@implementation NSURLRequest (NSURLRequestWithIgnoreSSL)
+(BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host
{
    return YES;
}
@end
