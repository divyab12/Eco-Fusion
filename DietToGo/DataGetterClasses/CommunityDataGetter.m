//
//  CommunityDataGetter.m
//  ServeItUp
//
//  Created by Value Labs on 27/06/13.
//  Copyright (c) 2013 valuelabs. All rights reserved.
//

#import "CommunityDataGetter.h"

@implementation CommunityDataGetter
@synthesize mcategoriesArray,mForumsArray,mThreadsArray,mPostsArray,mAddNewthreadArray;
@synthesize mSelectedCategoryDict, mSelectedForumDict, mSelectedThreadDict;

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
