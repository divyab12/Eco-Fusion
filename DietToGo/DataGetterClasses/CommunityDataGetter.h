//
//  CommunityDataGetter.h
//  ServeItUp
//
//  Created by Value Labs on 27/06/13.
//  Copyright (c) 2013 valuelabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommunityDataGetter : NSObject
{
    AppDelegate *mAppDelegate_;
}
// discussion boards
@property (nonatomic, retain)NSMutableArray *mcategoriesArray;
//forums array

@property (nonatomic, retain)NSMutableArray *mForumsArray;
// threads array
@property (nonatomic, retain)NSMutableArray *mThreadsArray;
//posts array
@property (nonatomic, retain)NSMutableArray *mPostsArray;
// add new thread is
@property (nonatomic, retain)NSMutableArray *mAddNewthreadArray;

//Seleted Category, forum and thread Dict
@property (nonatomic, retain) NSString *mSelectedCategoryDict, *mSelectedForumDict, *mSelectedThreadDict;
/**
 * Method used to initialize class
 */
- (id)init;
@end
