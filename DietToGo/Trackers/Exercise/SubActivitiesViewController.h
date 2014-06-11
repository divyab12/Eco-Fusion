//
//  SubActivitiesViewController.h
//  EHEandme
//
//  Created by Divya Reddy on 19/11/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
@class AppDelegate;

@interface SubActivitiesViewController : GAITrackedViewController{
    /**
     * creating the instanse for app delegate
     */
    AppDelegate *mAppDelegate_;
    /**
     * Array to store search results
     */
    NSMutableArray *mSearchArray_;

}
@property(nonatomic,retain)NSString *mNavTitleStr;
@property(nonatomic,retain)NSMutableArray *mExercisesArray;
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;
@property (retain, nonatomic) IBOutlet UISearchDisplayController *searchDisplayController;
@property (retain, nonatomic) IBOutlet UITableView *mTableView_;

/*
 * method used to search the contents of tableview based on text entered in searchbar
 * @param searchtext for the text enterted in searchnar
 * @param scope refers to the array where to search the test
 */
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope ;

@end
