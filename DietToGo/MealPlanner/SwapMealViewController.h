//
//  SwapMealViewController.h
//  EHEandme
//
//  Created by Divya Reddy on 29/10/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
@class AppDelegate;

@interface SwapMealViewController : GAITrackedViewController{
    /**
     * AppDelegate instance variable creation
     */
    AppDelegate *mAppDelegate_;
}
@property(nonatomic,retain)NSMutableDictionary *mNoofRowsInSectionArray_;


@property (weak, nonatomic) IBOutlet UITableView *mtableview;

@end
