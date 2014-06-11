//
//  MessagesDataGetter.m
//  EHEandme
//
//  Created by Divya Reddy on 06/01/14.
//  Copyright (c) 2014 EHEandme. All rights reserved.
//

#import "MessagesDataGetter.h"

@implementation MessagesDataGetter
@synthesize mMessagesDetailDict_, mMessagesListDict_;
- (id)init
{
    if (self = [super init])
    {
        // Initialization code here
        mAppDelegate_ = [AppDelegate appDelegateInstance];
    }
    
    return self;
    
}
@end
