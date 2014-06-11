//
//  AddNewPrivateFoodController.h
//  EHEandme
//
//  Created by Suresh on 2/18/14.
//  Copyright (c) 2014 EHEandme. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AddNewPrivateFoodController : UIViewController<UITextFieldDelegate> {
    /**
     * AppDelegate instance variable creation
     */
    AppDelegate *mAppDelegate_;

}
@property (strong, nonatomic) IBOutlet UITableView *mTableView;
@property(nonatomic,retain) NSMutableArray *mCategoryArr;
@property(nonatomic,retain) NSMutableArray *mSuffixArr;
@property(nonatomic,retain) NSMutableArray *mSaveArr;
@property(nonatomic,retain) UITextField *mActiveTxtFld;

@end
