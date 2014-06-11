//
//  EditLandingViewController.h
//  EHEandme
//
//  Created by Divya Reddy on 01/11/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
@interface EditLandingViewController : GAITrackedViewController{
    AppDelegate *mAppDelegate;
}
@property (strong, nonatomic) IBOutlet UILabel *mLbl1;
@property (strong, nonatomic) IBOutlet UILabel *mlbl2;
@property (strong, nonatomic) IBOutlet UILabel *mlbl3;
@property (strong, nonatomic) IBOutlet UILabel *mlbl4;
@property (strong, nonatomic) IBOutlet UILabel *mlbl5;
@property (weak, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (nonatomic,retain) NSMutableArray *mTrackersArray,*mGoalsArray;
@property (weak, nonatomic) IBOutlet UIImageView *mGoalImgView;
@property (nonatomic, retain) NSMutableArray *mTrackersImgsArray;
@property (nonatomic, retain) NSMutableDictionary *mUnHideTrackersDict;
@property (weak, nonatomic) IBOutlet UILabel *mGoalsLbl;
@property (weak, nonatomic) IBOutlet UILabel *mTrackersLbl;
@property (weak, nonatomic) IBOutlet UIImageView *mTrackersImgView;
@property (weak, nonatomic) IBOutlet UITableView *mGoalsTblView;
@property (weak, nonatomic) IBOutlet UITableView *mTrackersTblView;

- (NSString*)getTheKeyValueinDBforTracker:(NSString*)mTrackerText;
- (CGFloat)caluclateGoalsTableHeight;
@end
