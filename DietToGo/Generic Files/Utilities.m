//
//  Utilities.m
//  ServeItUp
//
//  Created by Value Labs on 03/06/13.
//  Copyright (c) 2013 valuelabs. All rights reserved.
//

#import "Utilities.h"
#import "NSDataAdditions.h"


@implementation Utilities
+(NSString*) getSubstringForGivenString:(NSString*)strTotalString :(NSString*)strStartValue :(NSString*)strEndValue
{
	NSRange range1 = [strTotalString rangeOfString:strStartValue];
	NSRange range2 = [strTotalString rangeOfString:strEndValue];
	
	if(range1.location != NSNotFound && range2.location != NSNotFound)
	{
		NSRange range = NSMakeRange(range1.location,range2.location+range2.length-range1.location);
		return [strTotalString substringWithRange:range];
	}
	
	return @"";
}

+(BOOL)isASubString:(NSString*)strSubStr :(NSString*)aSource{
	
	NSRange range = [aSource rangeOfString:strSubStr];
	if(range.length == 0)
	{
		return NO;
	}
	return YES;	
}

+(NSString *)getStringFromImage:(UIImage *)image
{
    if(image){
        
        // CGSize size = CGSizeMake(320, 240);
        //UIImage *scalledImg = [self imageWithImage:image scaledToSize:size];
        
        NSData *dataObj = UIImagePNGRepresentation(image);
        return [dataObj base64Encoding];
        
    } else {
        
        return @"";
        
    }
}
+(UIImage *)getImageFromString:(NSString *)beforeStringImage;
{
    NSData *dataObj = [NSData dataWithBase64EncodedString:beforeStringImage];
    
    UIImage *beforeImage = [UIImage imageWithData:dataObj];
    
    return beforeImage;
}
+ (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

UIImage *UIImageResize(UIImage *image, CGSize targetSize)
{
    UIGraphicsBeginImageContext(targetSize);
    CGContextRef bitmapContext = UIGraphicsGetCurrentContext();
    
    CGContextScaleCTM(bitmapContext, 1, -1);
    CGContextDrawImage(bitmapContext, (CGRect) { .origin.y = -targetSize.height, .size = targetSize }, image.CGImage);
    
    UIImage *results = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return results;
}


+ (void)addInputViewForKeyBoard:(UITextView*)mTxtView
                          Class:(UIViewController*)mViewController
{
    UIToolbar  *mToolBar_;
    mToolBar_= [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, mViewController.view.bounds.size.width, 44)];
    //[mToolBar_ setBarStyle:UIBarStyleBlack];
    //[mToolBar_ setTranslucent:YES];
    [mToolBar_ setBackgroundColor:BLACK_COLOR];
    [mToolBar_ setTintColor:[UIColor colorWithRed:97.0/255.0 green:97.0/255.0 blue:97.0/255.0 alpha:0.1]];
    
    UIBarButtonItem *lflexibleButtonItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:    UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *lCancelButtonItem=[[UIBarButtonItem alloc] initWithTitle:@" Clear " style:UIBarButtonItemStyleDone target:mViewController action:@selector(cancel_Event)];
    
    lCancelButtonItem.tag=1;
    
    UIBarButtonItem *lDoneBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" Done " style:UIBarButtonItemStyleDone target:mViewController action:@selector(done_Event)];
    lDoneBarButtonItem.tag=2;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        lDoneBarButtonItem.tintColor = GRAY_COLOR;
        lCancelButtonItem.tintColor = GRAY_COLOR;
    }
    [mToolBar_ setItems:[NSArray arrayWithObjects:lflexibleButtonItem,lCancelButtonItem,lDoneBarButtonItem,nil]];
    mTxtView.inputAccessoryView=mToolBar_;
}
+ (void)addInputViewForKeyBoardForTextFld:(UITextField*)mTxtView
                          Class:(UIViewController*)mViewController
{
    UIToolbar  *mToolBar_;
    mToolBar_= [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, mViewController.view.bounds.size.width, 44)];
    //[mToolBar_ setBarStyle:UIBarStyleBlack];
    //[mToolBar_ setTranslucent:YES];
     [mToolBar_ setBackgroundColor:BLACK_COLOR];
    [mToolBar_ setTintColor:[UIColor colorWithRed:97.0/255.0 green:97.0/255.0 blue:97.0/255.0 alpha:0.1]];
    
    UIBarButtonItem *lflexibleButtonItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:    UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *lCancelButtonItem=[[UIBarButtonItem alloc] initWithTitle:@" Clear " style:UIBarButtonItemStyleDone target:mViewController action:@selector(cancelTxtFld_Event)];
    
    lCancelButtonItem.tag=1;
    
    UIBarButtonItem *lDoneBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" Done " style:UIBarButtonItemStyleDone target:mViewController action:@selector(doneTxtFld_Event)];
    lDoneBarButtonItem.tag=2;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        lDoneBarButtonItem.tintColor = GRAY_COLOR;
        lCancelButtonItem.tintColor = GRAY_COLOR;
    }

    [mToolBar_ setItems:[NSArray arrayWithObjects:lflexibleButtonItem,lCancelButtonItem,lDoneBarButtonItem,nil]];
    mTxtView.inputAccessoryView=mToolBar_;

}
+ (BOOL)isEmailValid:(NSString*)mEmail
{
     BOOL flag = FALSE;
    if(![mEmail isEqualToString:@""])
    {
        NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
        //Valid email address
        if ([emailTest evaluateWithObject:mEmail] == YES) 
        {
            flag = TRUE;
        }
        else
        {
            flag = FALSE;
        }
    }
    else{
    flag = FALSE;
    }
            
    return flag;
}
+ (BOOL)isPasswordValid:(NSString*)mPassword{
     BOOL flag = FALSE;
    NSString *test = mPassword;
    int j=0,k=0,l=0;
    for(int i = 0; i < [test length]; i++){
        if([test characterAtIndex:i] >=48 && [test characterAtIndex:i] <=57){
            
            j++;
        }
        else if([test characterAtIndex:i] >=65 && [test characterAtIndex:i] <=90){
            
            k++;
        }
        else if([test characterAtIndex:i] >=97 && [test characterAtIndex:i] <=122){
            
            l++;
        }
    }
    if (j==0||k==0||l==0||(test.length<8))
    {
        flag = TRUE;
    }
    else{
    flag = FALSE;
    }

    return flag;
}
+ (BOOL)isPasswordMatches:(NSString*)mPassword:(NSString *)mConfirmPassword{
  BOOL flag = FALSE;
    if ([mPassword isEqualToString:mConfirmPassword]) {
        flag = TRUE;
    }
    else{
     flag = FALSE;
    }
    return flag;
}
+ (BOOL)isZipcodeValid:(NSString*)mZipCode{
    BOOL flag = FALSE;
    if ([mZipCode length]<5 || [mZipCode length]>5) {
        flag = FALSE;
    }
    else{
        flag = TRUE;
    }
    return flag;
}
+ (BOOL)isUserNameStringValid:(NSString*)mString{
    NSString *str=mString;
    BOOL ToShowAlert=FALSE;
    for (int j=0; j<[str length];j++)
    {
        
        NSString *temp=[NSString stringWithFormat:@"%c",[str characterAtIndex:j]];
        if ([temp isEqualToString:@" "] && !ToShowAlert)
        {
            ToShowAlert=FALSE;
        }
        else
        {
            ToShowAlert=TRUE;
            
        }
        
    }
    if ([str length]<6) {
        ToShowAlert=FALSE;
    }
    if (!ToShowAlert){
        
    }
    else{
    }
    return ToShowAlert;
}

+ (BOOL)isStringValid:(NSString*)mString{
    NSString *str=mString;
     BOOL ToShowAlert=FALSE;
    for (int j=0; j<[str length];j++)
         { 
            
            NSString *temp=[NSString stringWithFormat:@"%c",[str characterAtIndex:j]];
            if ([temp isEqualToString:@" "] && !ToShowAlert)
                {
                     ToShowAlert=FALSE;
                    }
            else
                {
                     ToShowAlert=TRUE;
                    
                    }
            
            }
    if (!ToShowAlert){
        
        }
    else{
        }
    return ToShowAlert;
}
+ (UIImage *)crop:(UIImage*)largeImage {
    
    //image resize and crop logic
    CGFloat width = 320, height = 200;
    int xPosition = 0;
    int yPosition = 0;
    if(largeImage.size.width < 320) {
        width = largeImage.size.width;
    }
    if(largeImage.size.height < 200) {
        height = largeImage.size.height;
    }
    
    xPosition = (largeImage.size.width - width)/2;
    yPosition = (largeImage.size.height - height)/2;
    
    //for 2x images
    /*CGFloat scale = [[UIScreen mainScreen] scale];
     
     if (scale>1.0) {
     rect = CGRectMake(rect.origin.x*scale , rect.origin.y*scale, rect.size.width*scale, rect.size.height*scale);
     }*/
    
    //CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
    CGImageRef imageRef = CGImageCreateWithImageInRect([largeImage CGImage], CGRectMake(xPosition, yPosition, width, height));
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return newImage;
}
+ (NSString*)returnTheTimeDifferenceString:(NSString*)mPostedTime
{
    NSString *mStr = @"";
    if ([mPostedTime isEqualToString:@"00:00:00"]) {
        return mStr;
    }
    //to check whether number of days are added or not to the string
    NSDateFormatter *lFormatter = [[NSDateFormatter alloc]init] ;
    [lFormatter setDateFormat:@"HH:mm:ss.SSSSSSS"];
    NSDate *lDate = [lFormatter dateFromString:mPostedTime];
    if (lDate == nil) {
        int ldays=[[mPostedTime substringToIndex:[mPostedTime rangeOfString:@"."].location] intValue];
        
        //to check for days value
        if (ldays>0 && ldays<7) {
            if (ldays == 1) {
                mStr = [NSString stringWithFormat:@"%d day ago",ldays];
            }else{
                mStr = [NSString stringWithFormat:@"%d days ago",ldays];
            }
        }else if(ldays>=7 && ldays<30)
        {
            ldays = ldays/7;//weeks
            if (ldays == 1) {
                mStr = [NSString stringWithFormat:@"%d week ago",ldays];
            }else{
                mStr = [NSString stringWithFormat:@"%d weeks ago",ldays];
            }
            
        }else if(ldays>=30 && ldays<365)
        {
            ldays = ldays/30;//months
            if (ldays == 1) {
                mStr = [NSString stringWithFormat:@"%d month ago",ldays];
            }else{
                mStr = [NSString stringWithFormat:@"%d months ago",ldays];
            }
            
        }else if(ldays>=365)
        {
            ldays = ldays/365;//years
            if (ldays == 1) {
                mStr = [NSString stringWithFormat:@"%d year ago",ldays];
            }else{
                mStr = [NSString stringWithFormat:@"%d years ago",ldays];
            }
            
        }
        return mStr;
        
    }else
    {
        [lFormatter setDateFormat:@"HH"];
        int hours = [[lFormatter stringFromDate:lDate] intValue];
        [lFormatter setDateFormat:@"mm"];
        int minutes = [[lFormatter stringFromDate:lDate] intValue];
        [lFormatter setDateFormat:@"ss"];
        int seconds = [[lFormatter stringFromDate:lDate] intValue];
        
        if (hours == 0 && minutes == 0 && seconds == 0) {
            mStr = [NSString stringWithFormat:@"1 second ago"];
            
        }else if (hours == 0 && minutes == 0 && seconds>0) {
            if (seconds>1) {
                mStr = [NSString stringWithFormat:@"%d seconds ago", seconds];
            }else {
                mStr = [NSString stringWithFormat:@"%d second ago", seconds ];
            }
        }else if (hours == 0 && minutes > 0 ) {
            if (minutes>1) {
                mStr = [NSString stringWithFormat:@"%d minutes ago", minutes];
            }else {
                mStr = [NSString stringWithFormat:@"%d minute ago", minutes ];
            }
        }
        else  {
            if (hours >1) {
                mStr = [NSString stringWithFormat:@"%d hours ago", hours ];
            }else {
                mStr = [NSString stringWithFormat:@"%d hour ago", hours ];
            }
        }
        return  mStr;
    }
    
    
    return mStr;
}

@end

