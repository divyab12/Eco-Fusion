//
//  ForumsViewController.h
//  DietToGo
//
//  Created by Suresh on 4/14/14.
//  Copyright (c) 2014 DietToGo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppDelegate;
@interface ForumsViewController : UIViewController {
    AppDelegate *mAppDelegate;
}
@property (strong, nonatomic) IBOutlet UITableView *mTableView;

@end
