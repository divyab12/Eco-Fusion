//
//  DatePickerController.m
//  GSPSurveyor
//
//  Created by EHEandme on 6/14/11.
//  Copyright 2013 EHEandme Inc. All rights reserved.
//

#import "DatePickerController.h"
#define Select_Date @"Select Date"
#define KAnimationValue 150
#define KScreenHeight 460
#define kPickerHeight 200
#define kTabbarHeight 44
@implementation DatePickerController

@synthesize mDatePicker_;
@synthesize mDatePickerDelegate_;
@synthesize mSelectedTextField_;
@synthesize mTextDisplayedlb;
@synthesize mToolBar_;
@synthesize mPickerView_;
- (id)initWithFrame:(CGRect)frame {
    
    mAppDelegate = [AppDelegate appDelegateInstance];
    
    
	self = [super initWithFrame:CGRectMake(0,0, 320,mAppDelegate.window.frame.size.height)];
    if (self) {
        [self setBackgroundColor: [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
        [self setUserInteractionEnabled:YES];
        CGFloat lXCoord=0,lYCoord=KScreenHeight-kPickerHeight-kTabbarHeight-10,lWidth=320,lHeight=kPickerHeight+kTabbarHeight+10;
        mFrame_=CGRectMake(lXCoord, lYCoord, lWidth, lHeight);
        
//        mPickerView_ = [[UIView alloc] initWithFrame:mFrame_];
        
        
        mPickerView_ = [[UIView alloc] initWithFrame:CGRectMake(0, mAppDelegate.window.frame.size.height-200-44-10, 320,220)] ;
        mPickerView_.backgroundColor=[UIColor whiteColor];
        [mPickerView_ setUserInteractionEnabled:YES];
        [self addSubview:mPickerView_];
        mDatePicker_ = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, lWidth,kPickerHeight)] ;
        mDatePicker_.datePickerMode = UIDatePickerModeDate;
		[mPickerView_ addSubview:mDatePicker_];
        
        
        mToolBar_=[[UIToolbar alloc]initWithFrame:CGRectMake(lXCoord, 0, lWidth, kTabbarHeight)];
        mToolBar_.tag=10;
        [mToolBar_ setBackgroundColor:BLACK_COLOR];
		[mToolBar_ setTintColor:[UIColor colorWithRed:97.0/255.0 green:97.0/255.0 blue:97.0/255.0 alpha:0.1]];
        [mPickerView_ addSubview:mToolBar_];
        
       /* UIBarButtonItem *lflexibleButtonItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:    UIBarButtonSystemItemFlexibleSpace
                                                                                         target:self
                                                                                         action:nil];
        */
        
       mTextDisplayedlb = [[UILabel alloc] initWithFrame:CGRectMake(10, 5,160, 40)];
        mTextDisplayedlb.numberOfLines=0;
        mTextDisplayedlb.lineBreakMode=LINE_BREAK_WORD_WRAP;
        mTextDisplayedlb.tag=3;
        mTextDisplayedlb.backgroundColor = [UIColor clearColor];
        mTextDisplayedlb.textColor = [UIColor whiteColor];
        mTextDisplayedlb.font = Bariol_Regular(17);
        // add your text here, using NSDateFormatter for example
        mTextDisplayedlb.text = Select_Date; 
        
        // create the bar button item where we specify the label as a view to use to init with     
        UIBarButtonItem *lTextBarButton = [[UIBarButtonItem alloc] initWithCustomView:mTextDisplayedlb];
        
        UIBarButtonItem *lCancelButtonItem=[[UIBarButtonItem alloc]initWithTitle:@" Cancel " style:UIBarButtonItemStyleDone
                                                                                        target:self 
                                                                                        action:@selector(evt_DateEvent:)];
        lCancelButtonItem.tag=1;
  
        UIBarButtonItem *lDoneBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" Done " style:UIBarButtonItemStyleDone target:self action:@selector(evt_DateEvent:)];
        lDoneBarButtonItem.tag=2;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
            lDoneBarButtonItem.tintColor = GRAY_COLOR;
            lCancelButtonItem.tintColor = GRAY_COLOR;
        }

        [mToolBar_ setItems:[NSArray arrayWithObjects:lTextBarButton,lCancelButtonItem,lDoneBarButtonItem,nil]];
    }
    return self;
}

- (void)evt_DateEvent:(id)sender {
	
    BOOL lIsDone=YES;
    if (1==[sender tag]) {
        lIsDone=NO;
    }
    [mDatePickerDelegate_ datePickerController:self didPickDate:mDatePicker_.date isDone:lIsDone];
}
- (void)showAnimation {
    
    CGFloat lXCoord=0,lYCoord=KScreenHeight-kPickerHeight-kTabbarHeight-10,lWidth=320,lHeight=kPickerHeight+kTabbarHeight+10;
    mFrame_=CGRectMake(lXCoord, lYCoord+KAnimationValue, lWidth, lHeight);
    self.mPickerView_.frame=mFrame_;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:0.5];
        mFrame_=CGRectMake(lXCoord, lYCoord, lWidth, lHeight);
        self.mPickerView_.frame=mFrame_;
        [UIView commitAnimations];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/



@end
