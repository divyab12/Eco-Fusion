//
//  NSURLRequest+NSURLRequestWithIgnoreSSL.h
//  DietToGo
//
//  Created by Suresh on 5/1/14.
//  Copyright (c) 2014 DietToGo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLRequest (NSURLRequestWithIgnoreSSL)
+(BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host;
@end
