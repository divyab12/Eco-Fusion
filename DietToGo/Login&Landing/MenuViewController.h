//
//  MenuViewController.h
//  EHEandme
//
//  Created by Divya Reddy on 23/10/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppDelegate;

@interface MenuViewController : UIViewController{
    AppDelegate *mAppDelegate;

}
@property(nonatomic, retain) NSString *selecteModule;
@property (weak, nonatomic) IBOutlet UITableView *mTableview;
@property(nonatomic, retain) NSMutableArray *headerTitleArr;
@property (weak, nonatomic) IBOutlet UIImageView *mBgImgView;
@property (nonatomic, retain)  NSMutableArray *imagearray;

@end
