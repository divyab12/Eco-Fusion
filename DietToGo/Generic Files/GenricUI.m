//
//  GenricUI.m
//  SAMWeb
//
//  Created by saikiran on 06/06/11.
//  Copyright 2013 EHEandme. All rights reserved.
//

#import "GenricUI.h"
#import "Constants.h"
#import "AppDelegate.h"

@implementation GenricUI
static GenricUI *gGenericUI = nil ;

+(GenricUI*)instance {
	
	@synchronized (self){
		if (nil==gGenericUI) {
			gGenericUI=[[GenricUI alloc]init];
			
		}
		return gGenericUI;
	}
	return nil;
}

-(id)init{
    mAppDelegate_=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    return  self;
}

+ (id)allocWithZone:(NSZone *)zone 
{
    @synchronized(self) {
        if (nil==gGenericUI ) {
            gGenericUI = [super allocWithZone:zone];
            return gGenericUI;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}


- (id)copyWithZone:(NSZone *)zone 
{ 
	return self; 
}

/*- (id)retain 
{ 
	return self; 
} 

- (id)autorelease 
{ 
	return self; 
    
}
*/

+(void)shutDown{
   // RELEASE_NIL(gGenericUI);
}
#pragma mark Button creation

- (UIButton *)buttonWithTitle:(NSString *)title
					   target:(id)target
					 selector:(SEL)selector
						frame:(CGRect)frame
						image:(UIImage *)image
				 imagePressed:(UIImage *)imagePressed
				darkTextColor:(UIColor*)darkTextColor
						 font:(UIFont*)font
{	
	
	UIButton *button = [[UIButton alloc] initWithFrame:frame];
	[button setTitle:title forState:UIControlStateNormal];	
	[button setTitleColor:darkTextColor forState:UIControlStateNormal];
	button.titleLabel.font = font;
	
	UIImage *newImage = [image stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
	[button setBackgroundImage:newImage forState:UIControlStateNormal];
	
	UIImage *newPressedImage = [imagePressed stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
	[button setBackgroundImage:newPressedImage forState:UIControlStateHighlighted];
	
	button.titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
	
	[button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
	
		// in case the parent view draws with a custom color or gradient, use a transparent color
	button.backgroundColor = CLEAR_COLOR;
	
	return button;
}


#pragma mark Navigation bar buttons
-(void)setNavigationItemButtonsWithBackGroundImage:(UIImage *)backGroundImage
											 title:(NSString*)title 
											target:(id)btnTarget
											action:(SEL)selector
									 forController:(id)vc 
									   rightOrLeft:(NSInteger)rlBtn
{
	UIViewController *lVC=(UIViewController*)vc;
	
	
	CGRect pButtonFrame = CGRectMake(0, 0, backGroundImage.size.width, backGroundImage.size.height);
	/*UIButton *pBackButton = [[self buttonWithBackGroungImage:backGroundImage
													  target:btnTarget
													selector:selector
													   frame:pButtonFrame 
													   title:@"" 
											   darkTextColor:CLEAR_COLOR 
														font:NULL]retain];*/
    UIButton *button = [[UIButton alloc] initWithFrame:pButtonFrame];
	[button setBackgroundImage:backGroundImage forState:UIControlStateNormal];
	[button setTitle:title forState:UIControlStateNormal];
    [button addTarget:btnTarget action:selector forControlEvents:UIControlEventTouchUpInside];
	button.backgroundColor = [UIColor clearColor];

	
	
	UIBarButtonItem* pBarButton = [[UIBarButtonItem alloc] initWithCustomView:button];
  
	
	if (rlBtn==RIGHT_BTN) 
    {
            
			[lVC.navigationItem setRightBarButtonItem:pBarButton]; 
    }else
    {
        [lVC.navigationItem setLeftBarButtonItem:pBarButton];    
    }
	
}

#pragma mark - For Labels 

+ (UILabel *)labelWithFrame:(CGRect)frame title:(NSString *)title font:(UIFont*)font color:(UIColor*)color
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
	label.text = title;
    label.font = font;
    label.textColor = color;
    label.backgroundColor = CLEAR_COLOR;
	
    return label;
}

#pragma mark - For ImageViews 

- (UIImageView *)imageViewWithImage:(UIImage*)image
							  frame:(CGRect)frame
{
	UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
	imageView.image = image;
	return imageView;
}


#pragma mark -TextView

- (UITextView *)textViewWithFrame:(CGRect )frame
			 delegate:(id)delegate
		  secureTextEntry:(BOOL)secureTextEntry

{
	UITextView *textView=[[UITextView alloc]initWithFrame:frame];
	textView.secureTextEntry=secureTextEntry;
    textView.delegate=delegate;
	textView.returnKeyType=UIReturnKeyDone;
	
	return textView;
	
	
	
}

-(int)dynamiclabelHeightForText:(NSString *)text :(int)width :(UIFont *)font
{
	
	CGSize maximumLabelSize = CGSizeMake(width,2500);
	
	CGSize expectedLabelSize = [text sizeWithFont:font 
								constrainedToSize:maximumLabelSize 
									lineBreakMode:LINE_BREAK_WORD_WRAP];
	
	
	return expectedLabelSize.height;
	
	
}


- (void)resetTableViews:(UITableViewCell*)tableViewCell{
	
	int testCount=0;
	//reset uiimageviews
	for (UIView *subView in [tableViewCell.contentView subviews]) {
        if ([subView isKindOfClass:[UIImageView class]]) {
            UIImageView *lImgSubView=(UIImageView*)subView;
            [lImgSubView setFrame:CGRectZero];
            [lImgSubView setImage:nil];
            lImgSubView=nil;
        }else if ([subView isKindOfClass: [UILabel class]]) {
            UILabel *lLabelSubView=(UILabel*)subView;
            [lLabelSubView setFrame:CGRectZero];
            [lLabelSubView setText:nil];
            lLabelSubView=nil;
        }
		testCount++;
	}
	//[tableViewCell setBackgroundColor:CLEAR_COLOR];
    
}
#pragma mark getUSDateFormate
+(NSString *)getEEEEMMMMDDYYYYFormateDate:(NSDate *)localDate
{
    NSDateFormatter *lDateFormat_ = [[NSDateFormatter alloc] init];
    NSTimeZone *gmtZone = [NSTimeZone systemTimeZone];
    [lDateFormat_ setTimeZone:gmtZone];
    NSLocale *enLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en-US"];
    lDateFormat_.locale = enLocale;
    [lDateFormat_ setDateFormat:@"EEEE,MMMM dd, yyyy"];
    NSString *dateString = [lDateFormat_ stringFromDate:localDate];
    return dateString;
}

+(NSString *)getHHMMAFormateTime:(NSDate *)localDate {
    NSDateFormatter *lDateFormat_ = [[NSDateFormatter alloc] init];
    NSTimeZone *gmtZone = [NSTimeZone systemTimeZone];
    [lDateFormat_ setTimeZone:gmtZone];
    NSLocale *enLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en-US"];
    lDateFormat_.locale = enLocale;
    [lDateFormat_ setDateFormat:@"hh:mm a"];
    NSString *dateString = [lDateFormat_ stringFromDate:localDate];
    return dateString; 
}

+ (CGFloat)FetchHeightForFont:(UIFont*)aFont basedOnwidth:(int)aWidth andText:(NSString *)aText
{
    
    CGFloat maxWidth = aWidth; 
	CGFloat maxHeight = 2500;
	CGSize maximumLabelSize = CGSizeMake(maxWidth,maxHeight);
	
	CGSize expectedLabelSize = [aText sizeWithFont:aFont
                                 constrainedToSize:maximumLabelSize 
                                     lineBreakMode:LINE_BREAK_WORD_WRAP];
	return expectedLabelSize.height;
    
}

+ (id) getSize:(NSString *)text FontName:(NSString *)f_name FontSize:(float)f_size label:(UILabel *)templbl
{
    templbl.numberOfLines = 0;
    [templbl setFont:[UIFont fontWithName:f_name size:f_size]];
    [templbl setLineBreakMode:LINE_BREAK_WORD_WRAP];
    
    CGSize maximumLabelSize = CGSizeMake(310,9999);
    
    CGSize expectedLabelSize = [text sizeWithFont:templbl.font
                                constrainedToSize:maximumLabelSize 
                                    lineBreakMode:templbl.lineBreakMode];
    
    CGRect newFrame = templbl.frame;
    newFrame.size.height = expectedLabelSize.height;
    templbl.frame = newFrame;
    [templbl setText:text];
    [templbl sizeToFit];
    
    return templbl;
}

+ (id) showLabelWithText:(NSString *)text Font:(UIFont *)lFont labelInstance:(UILabel *)lLabelInstance numberOfLines:(int)lNumberOfLines labelTag:(int)lLabelTag textColor:(UIColor*)lTextColor {
    lLabelInstance.numberOfLines = lNumberOfLines;
    [lLabelInstance setFont:lFont];
    [lLabelInstance setBackgroundColor:CLEAR_COLOR];
    [lLabelInstance setTextColor:lTextColor];
    [lLabelInstance setTag:lLabelTag];
    [lLabelInstance setText:text];
    /*CGSize maximumLabelSize = CGSizeMake(310,9999);

    CGSize expectedLabelSize = [text sizeWithFont:lLabelInstance.font
                                constrainedToSize:maximumLabelSize 
                                    lineBreakMode:lLabelInstance.lineBreakMode];*/
    
    /*CGRect newFrame = lLabelInstance.frame;
    newFrame.size.height = expectedLabelSize.height;
    lLabelInstance.frame = newFrame;
    
    [lLabelInstance sizeToFit];*/
    
    return lLabelInstance;
}

+ (void)showAlertWithTitle:(NSString*)alertTitle 
                  message:(NSString*)alertMessage 
             cancelButton:(NSString*)cancelButtonTitle 
                delegates:(id)parentDelegate
            button1Titles:(NSString*)button1Title
            button2Titles:(NSString*)button2Title 
                      tag:(NSInteger)tag{
    
    //TODO: Check whether the other button titles can be added dynamically by passing array as parameter..
    UIAlertView *lAlertView=[[UIAlertView alloc]initWithTitle:alertTitle message:alertMessage delegate:parentDelegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:button1Title,button2Title,nil];
	[lAlertView show];
    [lAlertView setTag:tag];
}
+ (BOOL)checkForStringEntered:(NSString*)inputStr{
    BOOL flag=FALSE;
    
    for (int j=0; j<[inputStr length];j++)
    {        
        
        NSString *temp=[NSString stringWithFormat:@"%c",[inputStr characterAtIndex:j]];
        if ([temp isEqualToString:@" "] && !flag)
        {
            flag=FALSE;
        }
        else
        {
            flag=TRUE;
            
        }
        
    }
    return flag;
}
/**
 *Code for TableView BackgroundColor issue in IOS 6.0.
 */
+ (void)clearBackGroundViewOfTableView:(UITableView*)mTableview
{
    [mTableview setBackgroundView:nil];
    [mTableview setBackgroundView:[[UIView alloc] init] ];
    [mTableview setBackgroundColor:UIColor.clearColor];
}

- (UILabel*)createUILabelWithString:(NSString*)labelText
                               font:(UIFont*)labelFont 
                          textColor:(UIColor*)labelColor	
                              frame:(CGRect)labelFrame
                      textAlignment:(NSTextAlignment)labeltextAlignment
                    backgroundColor:(UIColor*)labelBgColor{
	
	UILabel *lLabel=[[UILabel alloc]initWithFrame:labelFrame] ;
	[lLabel setFont:labelFont];
	[lLabel setNumberOfLines:0];
	[lLabel setTextColor:labelColor];
	[lLabel setBackgroundColor:labelBgColor];
	[lLabel setText:labelText];
	[lLabel setTextAlignment:labeltextAlignment];
	
	//Don't forget to release the UILabel instance returned
	return lLabel  ;
}
- (BOOL)isiPhone5
{
    BOOL flag = FALSE;
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (screenSize.height > 480.0f) {
            flag = TRUE;
        } else {
            flag = FALSE;
        }
    } else {
        /*Do iPad stuff here.*/
    }
    return flag;
    
}
+ (void)setLocaleZoneForDateFormatter:(NSDateFormatter *)mFormatter
{
    NSTimeZone *gmtZone = [NSTimeZone systemTimeZone];
    [mFormatter setTimeZone:gmtZone];
    NSLocale *enLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en-US"];
    mFormatter.locale = enLocale;
    
}
@end
