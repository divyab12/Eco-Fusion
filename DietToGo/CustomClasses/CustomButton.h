//
//  CustomButton.h
//  EHEandme
//
//  Created by Divya Reddy on 29/10/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomButton : UIButton{
    BOOL isChecked;
	NSString *name;
    NSString *totalScore;
    NSString *CurrentScore;
}
@property(nonatomic,readwrite)BOOL isChecked;
@property(nonatomic,retain)NSString *name;
//@property(nonatomic,retain)	CustomTextField *mTextField;
@property(nonatomic,retain) NSString *totalScore;
@property(nonatomic,retain) NSString *CurrentScore;
//for log meals
@property(nonatomic,retain)NSString *mSelectedRow;
@property(nonatomic,retain)NSString *mSelectedSection;
@end
