//
//  GenricUI.h
//  SAMWeb
//
//  Created by saikiran on 06/06/11.
//  Copyright 2011 EHEandme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

typedef enum {
	
    RIGHT_BTN=1,
    LEFT_BTN
	
}navItmBtn;


@interface GenricUI : NSObject {
    
@private
    
    /**
     * AppDelegate object creating
     */
	AppDelegate *mAppDelegate_;
    
}

/**
 * method for getting the instance of class
 */
+ (GenricUI*)instance;

/**
 * method for shutDown
 */
+ (void)shutDown;

//Button creation methods
/**
 * method for creating the navigation items to a navigationbar
 @param backGroundImage refres to the image to set for navigation bar
 @param title refers to title to set for navigation bar
 @param btnTarget refers to the instance of a class in which the method to perform when barbutton clicked is defined
 @param selector refers to the action to be performed when we click barbutton items
 @param refers to the viewcontroller name
 @param rightOrLeft refers to right/left barbutton item
 */
- (void)setNavigationItemButtonsWithBackGroundImage:(UIImage *)backGroundImage
											 title:(NSString*)title 
											target:(id)btnTarget
											action:(SEL)selector
									 forController:(id)vc 
									   rightOrLeft:(NSInteger)rlBtn;

/**
 * method for creating the button
 @param title refres to the title to set for button
 @param target refers to the instance of a class in which the method to perform when barbutton clicked is defined
 @param selector refers to the action to be performed when we click barbutton items
 @param frame refers to frame to set for button
 @param image refres to the image to set for button
 @param imagePressed refres to the image to set for button in selected state
 @param darkTextColor to set the text color of title of button
 @param font refers to the font of title of button
 */
- (UIButton *)buttonWithTitle:(NSString *)title
					   target:(id)target
					 selector:(SEL)selector
						frame:(CGRect)frame
						image:(UIImage *)image
				 imagePressed:(UIImage *)imagePressed
				darkTextColor:(UIColor*)darkTextColor
						 font:(UIFont*)font;



/**
 * method for creating the label with frame
 @param frame refers to frame to set for label
 @param title refres to the text to set for label
 @param font refers to the font of label
 @param color to set the text color of label
 */	
+ (UILabel *)labelWithFrame:(CGRect)frame title:(NSString *)title font:(UIFont*)font color:(UIColor*)color;

/**
 * method for creating the UIImageView
 @param image refres to the image to set for uiimageview
 @param frame refers to frame to set for UIImageview
 */	
- (UIImageView *)imageViewWithImage:(UIImage*)image
							  frame:(CGRect)frame;

/**
 * method for creating the UITextView
 @param frame refers to frame to set for UITextView
 @param delegate refres to the instane of delegate class
 @param secureTextEntry refers to BOOL to allow secure text entry or not
 */
- (UITextView *)textViewWithFrame:(CGRect )frame
						 delegate:(id)delegate
				  secureTextEntry:(BOOL)secureTextEntry;

/**
 * method for caluclating the height of a string
 @param text refers to string
 @param width refres to the width the text is to fit
 @param font refers to font of the control to which the string is to set
 */
- (int)dynamiclabelHeightForText:(NSString *)text :(int)width :(UIFont *)font;



/**
 * method for clearing the tableviewcell objects
 @param tableViewCell refers to UITableViewCell object
 */
- (void)resetTableViews:(UITableViewCell*)tableViewCell;
+(NSString *)getEEEEMMMMDDYYYYFormateDate:(NSDate *)localDate;
+(NSString *)getHHMMAFormateTime:(NSDate *)localDate ;
+ (CGFloat)FetchHeightForFont:(UIFont*)aFont basedOnwidth:(int)aWidth andText:(NSString *)aText;
+ (id) getSize:(NSString *)text FontName:(NSString *)f_name FontSize:(float)f_size label:(UILabel *)templbl;

+ (id) showLabelWithText:(NSString *)text Font:(UIFont *)lFont labelInstance:(UILabel *)lLabelInstance numberOfLines:(int)lNumberOfLines labelTag:(int)lLabelTag textColor:(UIColor*)lTextColor;

+ (void)showAlertWithTitle:(NSString*)alertTitle 
                   message:(NSString*)alertMessage 
              cancelButton:(NSString*)cancelButtonTitle 
                 delegates:(id)parentDelegate
             button1Titles:(NSString*)button1Title
             button2Titles:(NSString*)button2Title 
                       tag:(NSInteger)tag;
/*
 * method to check if only spaces are entered in textfield and returns Yes/No
 @param string to be checked
 */
+ (BOOL)checkForStringEntered:(NSString*)inputStr;

/*
 * method used to clear the background of uitableview in grouped tableview in ios 6
 @param Tableview instance to clear the background
 */
+ (void)clearBackGroundViewOfTableView:(UITableView*)mTableview;
- (UILabel*)createUILabelWithString:(NSString*)labelText
                               font:(UIFont*)labelFont 
                          textColor:(UIColor*)labelColor	
                              frame:(CGRect)labelFrame
                      textAlignment:(NSTextAlignment)labeltextAlignment
                    backgroundColor:(UIColor*)labelBgColor;
/*
 * method used to return whether the device is iPhone5 or not
 */
- (BOOL)isiPhone5;
/*
 * method used to set zone and locale for a dateformatter
 @param mFormatter instance
 */
+ (void)setLocaleZoneForDateFormatter:(NSDateFormatter*)mFormatter;

@end
