//
//  GenericDataBase.h
//  EHEandme
//
//  Created by Divya Reddy on 04/12/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface GenericDataBase : NSObject
{
    NSString *databaseName;
}
@property(retain,nonatomic)NSString *databasePath;
/*
 * method to store the database path in documents lib
 */
-(void)storeDataBaseIntoFile;

/*
 * method to check weather db eists at documents else create it
 */
-(void) checkAndCreateDatabase;
/*
 * method to get all the table data in the DB
 */
-(NSMutableArray*)getAllTableNames;
/*
 * method used to check whether the data is available for trackers for particular day in DB
 */
- (BOOL)checkTrackerOrderForDate;
/*
 * method used to check whether the goal data is available in DB
 */
- (BOOL)checkGoalOrder;

/*
 * method used to insert the data of trackers sequence for a day in the DB
 * @param mSequence for the order of the Trackers to be shown
 */
- (void)insertTrackerOrder:(NSString*)mSequence;
/*
 * method used to insert the data of goals sequence for a day in the DB
 * @param mSequence for the order of the goals to be shown
 */
- (void)insertGoalOrder:(NSString*)mSequence;
/*
 * method used to delete the data of trackers sequence for a day in the DB
 */
- (void)clearTrackerOrder;
/*
 * method used to delete the data of goals sequence for a day in the DB
 */
- (void)clearGoalOrder;
/*
 * method used to retrieve the data of trackers sequence for a day in the DB
 */
- (NSMutableDictionary*)getTrackerOrderForDate;
/*
 * method used to retrieve the data of goal sequence for a day in the DB
 */
- (NSMutableDictionary*)getGoalOrderForDate;

/*
 * method used to update the data of trackers sequence for a day in the DB
 * @param mSequence for the order of the Trackers to be shown
 */
- (void)updateTrackerOrder:(NSString*)mSequence
          VisisbleTrackers:(NSString*)mVisible;
/*
 * method used to update the data of goals sequence for a day in the DB
 * @param mSequence for the order of the goals to be shown
 */
- (void)updateGoalsOrder:(NSString*)mSequence
        VisisbleGoals:(NSString*)mVisible;
#pragma mark - Water Goals
-(void)createWaterGoalsTable;
- (void)insertWaterGoals:(NSString*)mWater UserID:(NSString*)mID;
- (void)updateWaterGoalFormUser:(NSString*)mWater UserId:(NSString*)mUserId;
- (NSMutableDictionary*)getWaterGoalFormUser:(NSString*)mUserId;
@end
