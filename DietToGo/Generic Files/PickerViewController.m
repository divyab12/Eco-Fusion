//
//  PickerViewController.m
//  EHEandme
//
//  Created by EHEandme on 9/20/12.
//  Copyright (c) 2012 EHEandme. All rights reserved.
//

#import "PickerViewController.h"
#import "FoodDetailsViewController.h"
#define KAnimationValue 150
#define KScreenHeight 460
#define kPickerHeight 240
#define kTabbarHeight 44

@implementation PickerViewController
@synthesize mViewPicker_;
@synthesize mPickerViewDelegate_;
@synthesize mSelectedTextField_ ;
@synthesize mRowValueintheComponent;
@synthesize mTextDisplayedlb;
- (id)initWithFrame:(CGRect)frame
{
    mAppDelegate = [AppDelegate appDelegateInstance];

    
	self = [super initWithFrame:CGRectMake(0,0, 320,mAppDelegate.window.frame.size.height)];
    if (self) {
        [self setBackgroundColor: [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]];
        [self setUserInteractionEnabled:YES];
        
        
        CGFloat lXCoord=0,lYCoord=KScreenHeight-kPickerHeight-kTabbarHeight-10,lWidth=320,lHeight=kPickerHeight+kTabbarHeight+10;
        mFrame_=CGRectMake(lXCoord, lYCoord, lWidth, lHeight);
        
        
        
        UIView *mPickerView_ = [[UIView alloc] initWithFrame:CGRectMake(0, mAppDelegate.window.frame.size.height-200-44-10, 320,260)] ;
        mPickerView_.backgroundColor=[UIColor whiteColor];
        [mPickerView_ setUserInteractionEnabled:YES];
        [self addSubview:mPickerView_];
        
        mViewPicker_ = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, lWidth,kPickerHeight)] ;
        mViewPicker_.delegate=self;
        mViewPicker_.dataSource=self;
		[mPickerView_ addSubview:mViewPicker_];
        
        
        UIToolbar *lToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(lXCoord, 0, lWidth, kTabbarHeight)];
        [lToolBar setBackgroundColor:BLACK_COLOR];
		[lToolBar setTintColor:[UIColor colorWithRed:97.0/255.0 green:97.0/255.0 blue:97.0/255.0 alpha:0.1]];
        [mPickerView_ addSubview:lToolBar];
        
		
        UIBarButtonItem *lCancelButtonItem=[[UIBarButtonItem alloc]initWithTitle:@" Cancel " style:UIBarButtonItemStyleDone
                                                                                        target:self 
                                                                                        action:@selector(evt_DateEvent:)];
        lCancelButtonItem.tag=1;
        UIBarButtonItem *lDoneBarButtonItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:    UIBarButtonSystemItemDone
                                                                                         target:self
                                                                                         action:@selector(evt_DateEvent:)];
        lDoneBarButtonItem.tag=2;
         if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
             lDoneBarButtonItem.tintColor = GRAY_COLOR;
             lCancelButtonItem.tintColor = GRAY_COLOR;
         }

        [lToolBar setItems:[NSArray arrayWithObjects:lCancelButtonItem,lDoneBarButtonItem,nil]];
        
        //
        mTextDisplayedlb = [[UILabel alloc] initWithFrame:CGRectMake(0, 5,160, 40)];
        mTextDisplayedlb.numberOfLines=0;
        mTextDisplayedlb.lineBreakMode=LINE_BREAK_WORD_WRAP;
        mTextDisplayedlb.tag=3;
        mTextDisplayedlb.backgroundColor = [UIColor clearColor];
        mTextDisplayedlb.textColor = [UIColor whiteColor];
        mTextDisplayedlb.font = Bariol_Regular(17);

        // add your text here, using NSDateFormatter for example
        mTextDisplayedlb.text = @""; 
        
        // create the bar button item where we specify the label as a view to use to init with     
        UIBarButtonItem *lTextBarButton = [[UIBarButtonItem alloc] initWithCustomView:mTextDisplayedlb];
        
        [lToolBar setItems:[NSArray arrayWithObjects:lTextBarButton,lCancelButtonItem,lDoneBarButtonItem,nil]];
       
        [[self mViewPicker_]setHidden:NO];
        [[self mViewPicker_]setShowsSelectionIndicator:YES];
     
    }
    return self;
}
- (void)evt_DateEvent:(id)sender {
	
    BOOL lIsDone=YES;
    if (1==[sender tag]) {
        lIsDone=NO;
    }
    NSMutableArray *lArr=[[NSMutableArray alloc] init] ;
    for(int i=0;i<[mRowValueintheComponent count];i++){
        [lArr addObject:[[mRowValueintheComponent objectAtIndex:i] objectAtIndex:[mViewPicker_ selectedRowInComponent:i]]];
    }
    
    [mPickerViewDelegate_ pickerViewController:self didPickComp:lArr isDone:lIsDone];
}
#pragma mark UIPickerDelegate methods

//  *************** tell the picker how many rows are available for a given component ************
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [[self.mRowValueintheComponent objectAtIndex:component] count];
    
}

// ************************* tell the picker how many components it will have ******************
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView 
{
    return mNoofComponents;
}

// ************* tell the picker the title for a given component ****************
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
	
    return [[self.mRowValueintheComponent objectAtIndex:component] objectAtIndex:row];
    
}
//  *************** customize row in a picker in a component ************

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel* label = (UILabel*)view;
    if (view == nil){
        label= [[UILabel alloc] initWithFrame:CGRectMake(20, 2, 140, 40)] ;
        label.textAlignment = UITextAlignmentCenter;
        if ([self.mRowValueintheComponent  count] == 1) {
            label.frame = CGRectMake(0, 2, 280, 40);
        }
        
    }
    label.font = Bariol_Bold(17);

   // label.font =[UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
    label.numberOfLines = 0;
    label.lineBreakMode = LINE_BREAK_WORD_WRAP;
    label.textColor = BLACK_COLOR;
    label.backgroundColor = CLEAR_COLOR;
   label.text = [[self.mRowValueintheComponent objectAtIndex:component] objectAtIndex:row];
    CGSize size =  [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(label.frame.size.width, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
    if (size.height > label.frame.size.height) {
        label.numberOfLines = 2;
        label.lineBreakMode = UILineBreakModeTailTruncation;
    }

    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if([mPickerViewDelegate_ isKindOfClass:[FoodDetailsViewController class]]){
        
        [mPickerViewDelegate_ didChangeTheRowIncomponet:self picker:pickerView didSelectRow:row inComponent:component];
        
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/




@end