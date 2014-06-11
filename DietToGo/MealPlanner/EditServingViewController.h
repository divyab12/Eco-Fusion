//
//  EditServingViewController.h
//  EHEandme
//
//  Created by Suresh on 2/20/14.
//  Copyright (c) 2014 EHEandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddNewPrivateFoodController.h"

@interface EditServingViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate> {
    /**
     * AppDelegate instance variable creation
     */
    AppDelegate *mAppDelegate_;
}
@property (strong, nonatomic) IBOutlet UILabel *mInformationForLbl;

@property (strong, nonatomic) IBOutlet UIPickerView *mPickerView;
@property (strong, nonatomic) IBOutlet UILabel *mServingLbl;
@property(nonatomic,retain) NSMutableArray *mCategoryArr;
@property(nonatomic,retain) NSMutableArray *mQuantityArr;
@property(nonatomic,retain) NSMutableArray *mIncreamentArr;
@property(nonatomic,retain) NSMutableDictionary *mEditServingInfo;
@property (strong, nonatomic) IBOutlet UILabel *mLineLbl;

-(void)displayPicker;

@end
