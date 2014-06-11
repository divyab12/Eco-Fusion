//
//  GenericDataBase.m
//  EHEandme
//
//  Created by Divya Reddy on 04/12/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import "GenericDataBase.h"
#import "AppDelegate.h"
#import "Constants.h"

@implementation GenericDataBase
@synthesize databasePath;
-(void)storeDataBaseIntoFile
{
    
    //DB Part
	databaseName = @"EHE.sql";
	
	// Get the path to the documents directory and append the databaseName
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
    [self setDatabasePath:[documentsDir stringByAppendingPathComponent:databaseName]];
    //    //NSLog(@"documentsDir : %@",documentsDir);
    
}
-(void) checkAndCreateDatabase{
	// Check if the SQL database has already been saved to the users phone, if not then copy it over
	BOOL success;
	
	// Create a FileManager object, we will use this to check the status
	// of the database and to copy it over if required
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	// Check if the database has already been created in the users filesystem
	success = [fileManager fileExistsAtPath:databasePath];
	
	// If the database already exists then return without doing anything
	if(success)
    {
        [self validateDB];
        return;
    }
	
	// If not then proceed to copy the database from the application to the users filesystem
	
	// Get the path to the database in the application package
	NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
	
	// Copy the database from the package to the users filesystem
	[fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
    
    [self validateDB];
    
}
-(void)validateDB
{
    //BOOL version = [self queryUserVersion:@"PRAGMA user_version;"];
    [self getAllTableNames];
    //NSLog(@" current sql version --> %d",version);
    
    [self getAllTableNames];
}
-(NSMutableArray*)getAllTableNames
{
	NSMutableArray *dataArray = [[NSMutableArray alloc]init] ;
    
    //    int fieldscount = [self getFieldsCount:tablename];
    
    sqlite3 *database;
    
	if(sqlite3_open([[self databasePath] UTF8String], &database) == SQLITE_OK) {
        
		NSString *sql = [NSString stringWithFormat:@"SELECT * FROM sqlite_master WHERE type='table'"];
		//NSString *sql = [NSString stringWithFormat:@"ALTER TABLE test55 ADD COLUMN statu4default TEXT"];
        
        const char *sqlUpdateStatement = [sql UTF8String];
        
        sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlUpdateStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
            while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                
                NSMutableDictionary * data = [[NSMutableDictionary alloc] init] ;
                
                for (int i=0; i<sqlite3_column_count(compiledStatement); i++) {
                    NSString * columnName = [NSString stringWithUTF8String:(char *)sqlite3_column_name(compiledStatement,i)];
                    NSString * fieldValue = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,i)];
                    
                    if (![[NSString stringWithFormat:@"%@",columnName] isEqualToString:@"sql"] ) {
                        [data setValue:[NSString stringWithFormat:@"%@",fieldValue] forKey:[NSString stringWithFormat:@"%@",columnName]];
                    }
                }
                
                [dataArray addObject:data];
                
            }
            sqlite3_finalize(compiledStatement);
            
		}
		
		
       	sqlite3_close(database);
    }
    
    //NSLog(@"dataArray %@",dataArray);
    
    return dataArray;
}
- (BOOL)checkTrackerOrderForDate
{
    BOOL hasData = FALSE;
    NSMutableDictionary *ltempDict=[self getTrackerOrderForDate];
    if (ltempDict.count > 0) {
        hasData = TRUE;
    }
    
    return hasData;
}
- (void)insertTrackerOrder:(NSString*)mSequence{
    [self clearTrackerOrder];
    sqlite3 *database;
	
	// Open the database from the users filessytem
	if(sqlite3_open([[self databasePath] UTF8String], &database) == SQLITE_OK) {
        NSString *sql = [NSString stringWithFormat:@"insert into TrackerOrder(Sequence, VisibleTrackers)  values ('%@', '%@');", mSequence, mSequence];
        
        //NSLog(@"sql %@", sql);
        
        const char *sqlInsertStatement;
        sqlInsertStatement = [sql UTF8String];
        
        if (sqlite3_exec(database, sqlInsertStatement, NULL, NULL, NULL) == SQLITE_OK)
        {
            
            //		//NSLog(@"successfully inserted into color table.");
        }
        else
        {
            //NSLog(@"unable to insert ActiveReviewsData with id=%@", [obj valueForKey:@"id"]);
        }
        sqlite3_close(database);
    }
    else
    {
        //NSLog(@"unable to connect to SQL database with method = 'ActiveReviewsData'");
    }


}
- (void)clearTrackerOrder{
    sqlite3 *database;
	
	// Open the database from the users filessytem
	if(sqlite3_open([[self databasePath] UTF8String], &database) == SQLITE_OK) {
        
        
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM TrackerOrder;"];
        
        const char *sqlInsertStatement;
        sqlInsertStatement = [sql UTF8String];
        
		if (sqlite3_exec(database, sqlInsertStatement, NULL, NULL, NULL) == SQLITE_OK)
		{
            
            //			//NSLog(@"successfully executed %@", sql);
		}
        else
        {
            //NSLog(@"unable to execute %@", sql);
        }
        sqlite3_close(database);
        
        
    }
    else
    {
        //NSLog(@"unable to connect SQL database with method = 'clearAllExisitingData'");
    }
}
- (NSMutableDictionary*)getTrackerOrderForDate{
    NSMutableDictionary *ltempDict=[[NSMutableDictionary alloc] init];
    sqlite3 *database;
    
	if(sqlite3_open([[self databasePath] UTF8String], &database) == SQLITE_OK) {
		
        
		NSString *sql = [NSString stringWithFormat:@"select * from TrackerOrder;" ];
		const char *sqlUpdateStatement = [sql UTF8String];
        sqlite3_stmt *compiledStatement;
        
		if(sqlite3_prepare_v2(database, sqlUpdateStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
            
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                
                //NSString *str = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,0)];
                //                //NSLog(@"GetAllColorsFromDataBase %@",str);
				[ltempDict setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,0)] forKey:@"Sequence"];
                [ltempDict setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,1)] forKey:@"VisibleTrackers"];

            }
            sqlite3_finalize(compiledStatement);
            
		}
       	sqlite3_close(database);
    }
    return ltempDict;
}
- (void)updateTrackerOrder:(NSString*)mSequence
          VisisbleTrackers:(NSString*)mVisible{
    sqlite3 *database;
	
    
	// Open the database from the users filessytem
	if(sqlite3_open([[self databasePath] UTF8String], &database) == SQLITE_OK) {
        NSString *sql = [NSString stringWithFormat:@"UPDATE TrackerOrder SET Sequence = '%@', VisibleTrackers = '%@';", mSequence, mVisible];
        
        
        
        //NSLog(@"sql %@", sql);
        const char *sqlInsertStatement;
        sqlInsertStatement = [sql UTF8String];
        
		if (sqlite3_exec(database, sqlInsertStatement, NULL, NULL, NULL) == SQLITE_OK)
		{
            
            //NSLog(@"Updated successfully in ActiveReviewsData  %@", sql);
		}
        else
        {
            //NSLog(@"unable to Updated in ActiveReviewsData  %@", sql);
        }
        sqlite3_close(database);
        
        
    }
    else
    {
        //NSLog(@"unable to connect SQL database with method = 'editDeficiencyData'");
    }
    

}
- (BOOL)checkGoalOrder{
    BOOL hasData = FALSE;
    NSMutableDictionary *ltempDict=[self getGoalOrderForDate];
    if (ltempDict.count > 0) {
        hasData = TRUE;
    }
    
    return hasData;
}
- (NSMutableDictionary*)getGoalOrderForDate{
    NSMutableDictionary *ltempDict=[[NSMutableDictionary alloc] init];
    sqlite3 *database;
    
	if(sqlite3_open([[self databasePath] UTF8String], &database) == SQLITE_OK) {
		
        
		NSString *sql = [NSString stringWithFormat:@"select * from GoalOrder;"];
		const char *sqlUpdateStatement = [sql UTF8String];
        sqlite3_stmt *compiledStatement;
        
		if(sqlite3_prepare_v2(database, sqlUpdateStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
            
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                
				[ltempDict setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,0)] forKey:@"Sequence"];
                [ltempDict setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,1)] forKey:@"VisibleGoals"];
                
            }
            sqlite3_finalize(compiledStatement);
            
		}
       	sqlite3_close(database);
    }
    return ltempDict;

}
- (void)insertGoalOrder:(NSString*)mSequence{
    [self clearGoalOrder];
    sqlite3 *database;
	
	// Open the database from the users filessytem
	if(sqlite3_open([[self databasePath] UTF8String], &database) == SQLITE_OK) {
        NSString *sql = [NSString stringWithFormat:@"insert into GoalOrder(Sequence, VisibleGoals)  values ('%@', '%@');", mSequence, mSequence];
        
        //NSLog(@"sql %@", sql);
        
        const char *sqlInsertStatement;
        sqlInsertStatement = [sql UTF8String];
        
        if (sqlite3_exec(database, sqlInsertStatement, NULL, NULL, NULL) == SQLITE_OK)
        {
            
            //		//NSLog(@"successfully inserted into color table.");
        }
        else
        {
            //NSLog(@"unable to insert ActiveReviewsData with id=%@", [obj valueForKey:@"id"]);
        }
        sqlite3_close(database);
    }
    else
    {
        //NSLog(@"unable to connect to SQL database with method = 'ActiveReviewsData'");
    }

}
- (void)clearGoalOrder{
    sqlite3 *database;
	
	// Open the database from the users filessytem
	if(sqlite3_open([[self databasePath] UTF8String], &database) == SQLITE_OK) {
        
        
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM GoalOrder;"];
        
        const char *sqlInsertStatement;
        sqlInsertStatement = [sql UTF8String];
        
		if (sqlite3_exec(database, sqlInsertStatement, NULL, NULL, NULL) == SQLITE_OK)
		{
            
            //			//NSLog(@"successfully executed %@", sql);
		}
        else
        {
            //NSLog(@"unable to execute %@", sql);
        }
        sqlite3_close(database);
        
        
    }
    else
    {
        //NSLog(@"unable to connect SQL database with method = 'clearAllExisitingData'");
    }

}
- (void)updateGoalsOrder:(NSString*)mSequence
           VisisbleGoals:(NSString*)mVisible{
    sqlite3 *database;
	
    
	// Open the database from the users filessytem
	if(sqlite3_open([[self databasePath] UTF8String], &database) == SQLITE_OK) {
        NSString *sql = [NSString stringWithFormat:@"UPDATE GoalOrder SET Sequence = '%@', VisibleGoals = '%@' ;", mSequence, mVisible];
        
        
        
        //NSLog(@"sql %@", sql);
        const char *sqlInsertStatement;
        sqlInsertStatement = [sql UTF8String];
        
		if (sqlite3_exec(database, sqlInsertStatement, NULL, NULL, NULL) == SQLITE_OK)
		{
            
            //NSLog(@"Updated successfully in ActiveReviewsData  %@", sql);
		}
        else
        {
            //NSLog(@"unable to Updated in ActiveReviewsData  %@", sql);
        }
        sqlite3_close(database);
        
        
    }
    else
    {
        //NSLog(@"unable to connect SQL database with method = 'editDeficiencyData'");
    }

    
}
#pragma mark - Water Goals
-(void)createWaterGoalsTable {
    
    sqlite3 *database;
	// Open the database from the users filessytem
	if(sqlite3_open([[self databasePath] UTF8String], &database) == SQLITE_OK) {
        NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS WaterGoal (UserId TEXT, GoalWater TEXT);"];
        NSLog(@"sql %@", sql);
        const char *sqlInsertStatement;
        sqlInsertStatement = [sql UTF8String];
        
        if (sqlite3_exec(database, sqlInsertStatement, NULL, NULL, NULL) == SQLITE_OK)
        {
            NSLog(@"successfully created WaterGoal table.");
        }
        else
        {
            NSLog(@"unable to Create %@", sql);
        }
        sqlite3_close(database);
    }
    else
    {
        //NSLog(@"unable to connect to SQL database with method = 'WaterGoal'");
    }
}
- (void)insertWaterGoals:(NSString*)mWater UserID:(NSString*)mID{
    sqlite3 *database;
	// Open the database from the users filessytem
	if(sqlite3_open([[self databasePath] UTF8String], &database) == SQLITE_OK) {
        NSString *sql = [NSString stringWithFormat:@"insert into WaterGoal(GoalWater, UserId)  values ('%@', '%@');", mWater, mID];
        NSLog(@"sql %@", sql);
        const char *sqlInsertStatement;
        sqlInsertStatement = [sql UTF8String];
        
        if (sqlite3_exec(database, sqlInsertStatement, NULL, NULL, NULL) == SQLITE_OK)
        {
            NSLog(@"successfully inserted into WaterGoal table.");
        }
        else
        {
            NSLog(@"unable to insert %@", sql);
        }
        sqlite3_close(database);
    }
    else
    {
        //NSLog(@"unable to connect to SQL database with method = 'WaterGoal'");
    }
}
- (void)updateWaterGoalFormUser:(NSString*)mWater UserId:(NSString*)mUserId {
    sqlite3 *database;
	// Open the database from the users filessytem
	if(sqlite3_open([[self databasePath] UTF8String], &database) == SQLITE_OK) {
        NSString *sql = [NSString stringWithFormat:@"UPDATE WaterGoal SET GoalWater = '%@' WHERE UserId = '%@' ;", mWater, mUserId];
        NSLog(@"sql %@", sql);
        const char *sqlInsertStatement;
        sqlInsertStatement = [sql UTF8String];
        
		if (sqlite3_exec(database, sqlInsertStatement, NULL, NULL, NULL) == SQLITE_OK)
		{
            
            NSLog(@"Updated successfully");
		}
        else
        {
            NSLog(@"unable to Updated  %@", sql);
        }
        sqlite3_close(database);
    }
    else
    {
        //NSLog(@"unable to connect SQL database with method = 'editDeficiencyData'");
    }
    
    
}
- (NSMutableDictionary*)getWaterGoalFormUser:(NSString*)mUserId {
    
    NSMutableDictionary *ltempDict=[[NSMutableDictionary alloc] init];
    sqlite3 *database;
    
	if(sqlite3_open([[self databasePath] UTF8String], &database) == SQLITE_OK) {
		
        
		NSString *sql = [NSString stringWithFormat:@"select * from WaterGoal where UserId='%@';",mUserId];
		const char *sqlUpdateStatement = [sql UTF8String];
        sqlite3_stmt *compiledStatement;
        
		if(sqlite3_prepare_v2(database, sqlUpdateStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
            
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                
				[ltempDict setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,0)] forKey:@"UserId"];
                [ltempDict setValue:[NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement,1)] forKey:@"GoalWater"];
                
            }
            sqlite3_finalize(compiledStatement);
            
		}
       	sqlite3_close(database);
    }
    return ltempDict;
    
}
@end
