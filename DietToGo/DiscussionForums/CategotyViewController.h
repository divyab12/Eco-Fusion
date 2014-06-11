//
//  CategotyViewController.h
//  DietToGo
//
//  Created by Suresh on 4/14/14.
//  Copyright (c) 2014 DietToGo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
#import "EnterUserName.h"
@class AppDelegate;

@interface CategotyViewController : GAITrackedViewController {
    AppDelegate *mAppDelegate;
}
@property (strong, nonatomic) IBOutlet UITableView *mTableView;
@property (strong, nonatomic) EnterUserName *mEnterUserName;

@end
