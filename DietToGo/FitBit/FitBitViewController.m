//
//  FitBitViewController.m
//  DietToGo
//
//  Created by Suresh on 4/28/14.
//  Copyright (c) 2014 DietToGo. All rights reserved.
//

#import "FitBitViewController.h"
#import "JSON.h"

@interface FitBitViewController ()

@end

@implementation FitBitViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // for setting the view below 20px in iOS7.0.
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        self.edgesForExtendedLayout = UIRectEdgeLeft | UIRectEdgeRight;
#endif
    mAppDelegate = [AppDelegate appDelegateInstance];
    self.mSubTitle.text = @"Fitbit tracks your everyday steps, stairs climbed, calories burned and more.\nmotivating you throughout the day.\nFit fitness into your day with Fitbit!";
    self.mTitle.font = OpenSans_Light(24);
    self.mSubTitle.font = OpenSans_Regular(13);
    self.mTitle.textColor = RGB_A(52, 52, 51, 1);
    self.mSubTitle.textColor = RGB_A(52, 52, 51, 1);

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:TRUE];
    //for tracking
    if (mAppDelegate.mTrackPages) {
       // self.trackedViewName = @"";
        [mAppDelegate trackFlurryLogEvent:@"Device Manager"];
    }
    //end
    NSString *imgName;
    if (CURRENTDEVICEVERSION >= IOS7VERSION ) {
        imgName = @"topbar.png";
        [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = [[UIImage alloc ]init];
    }else{
        imgName = @"topbar1.png";
    }
    [mAppDelegate setNavControllerTitle:NSLocalizedString(@"FITBIT_CONNECT", nil) imageName:imgName forController:self];
    
    [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"menu.png"] title:nil target:self action:@selector(menuAction:) forController:self rightOrLeft:0];
    [self postRequestToCheckFitBitStatus];
    //[self.mWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://api.fitbit.com/oauth/authorize?oauth_token=4261092bc9124eced5bc710370083eeb"]]];
}
- (void)postRequestToCheckFitBitStatus {
    
    [mAppDelegate createLoadView];
    NSString *mRequestStr = WEBSERVICEURL;
    mRequestStr = [mRequestStr stringByAppendingFormat:@"Fitbit/Status"];
    NSURL *url1 = [NSURL URLWithString:mRequestStr];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url1
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:60.0];
    //[theRequest valueForHTTPHeaderField:body];
    [theRequest setValue:mAppDelegate.mResponseMethods_.sessionToken forHTTPHeaderField:@"SessionToken"];
    [theRequest setValue:mAppDelegate.mResponseMethods_.authToken forHTTPHeaderField:@"AuthToken"];
    [theRequest setHTTPMethod:@"GET"];
    
    NSData *response = [NSURLConnection
                        sendSynchronousRequest:theRequest
                        returningResponse:nil error:nil];
    NSString *json_string = [[NSString alloc]
                             initWithData:response encoding:NSUTF8StringEncoding];
    DLog(@"Fit Bit Status %@", json_string);
    CGFloat yPos = 320;
    CGRect lFrame;
    int fitbitState = [json_string intValue];
    if (fitbitState == 1) {
        fitbitState = 0;
    }
    switch (fitbitState) {//[json_string intValue]
        case 0:
            //Not Connected
            self.mConnectBtn.hidden = NO;
            self.hadPINBtn.hidden = NO;
            self.mSyncBtn.hidden = YES;
            self.mDisConnectBtn.hidden = YES;
            break;
        case 1:
            //Connected but not linked
            self.mConnectBtn.hidden = YES;
            self.hadPINBtn.hidden = YES;
            self.mSyncBtn.hidden = NO;
            self.mDisConnectBtn.hidden = NO;
            lFrame = self.mSyncBtn.frame;
            lFrame.origin.y = yPos;
            self.mSyncBtn.frame = lFrame;
            lFrame = self.mDisConnectBtn.frame;
            lFrame.origin.y = yPos +70;
            self.mDisConnectBtn.frame = lFrame;
            if (![[GenricUI instance] isiPhone5]) {
                [self.mScollView setContentSize:CGSizeMake(320, 700)];
            }
            break;
        case 2:
            //Connected and linked
            self.mConnectBtn.hidden = YES;
            self.hadPINBtn.hidden = YES;
            self.mSyncBtn.hidden = YES;
            self.mDisConnectBtn.hidden = NO;
            lFrame = self.mDisConnectBtn.frame;
            lFrame.origin.y = yPos;
            self.mDisConnectBtn.frame = lFrame;
            break;
        default:
            break;
    }

    [mAppDelegate removeLoadView];
}

- (void)menuAction:(id)sender {
    [mAppDelegate showLeftSideMenu:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)fitBitConnectAction:(id)sender {
    //[self postRequestToVerifyPin];
   // return;
    [mAppDelegate createLoadView];
    NSString *mRequestStr = WEBSERVICEURL;
    mRequestStr = [mRequestStr stringByAppendingFormat:@"Fitbit/ConnectURL"];
    NSURL *url1 = [NSURL URLWithString:mRequestStr];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url1
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:60.0];
    //[theRequest valueForHTTPHeaderField:body];
    [theRequest setValue:mAppDelegate.mResponseMethods_.sessionToken forHTTPHeaderField:@"SessionToken"];
    [theRequest setValue:mAppDelegate.mResponseMethods_.authToken forHTTPHeaderField:@"AuthToken"];
    [theRequest setHTTPMethod:@"GET"];
    
    NSData *response = [NSURLConnection
                        sendSynchronousRequest:theRequest
                        returningResponse:nil error:nil];
    NSString *json_string = [[NSString alloc]
                             initWithData:response encoding:NSUTF8StringEncoding];
    DLog(@"Fit Bit URL %@", json_string);
    if (![json_string isEqualToString:@""]) {
        json_string = [json_string stringByReplacingOccurrencesOfString:@"\"" withString:@""];
       //  DLog(@"Fit Bit URL %@", json_string);
        json_string = [json_string stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        json_string = [json_string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:json_string]];
    }
    [mAppDelegate removeLoadView];
}

- (IBAction)syncAction:(id)sender {
    //This is reconnect API.
    [mAppDelegate createLoadView];
    NSString *mRequestStr = WEBSERVICEURL;
    mRequestStr = [mRequestStr stringByAppendingFormat:@"Fitbit/Connect"];
    NSURL *url1 = [NSURL URLWithString:mRequestStr];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url1
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:60.0];
    //[theRequest valueForHTTPHeaderField:body];
    [theRequest setValue:mAppDelegate.mResponseMethods_.sessionToken forHTTPHeaderField:@"SessionToken"];
    [theRequest setValue:mAppDelegate.mResponseMethods_.authToken forHTTPHeaderField:@"AuthToken"];
    [theRequest setHTTPMethod:@"POST"];
    
    NSHTTPURLResponse *response;
    NSError *error;
    NSData *responseData = [NSURLConnection
                            sendSynchronousRequest:theRequest
                            returningResponse:&response error:&error];
    NSString *json_string = [[NSString alloc]
                             initWithData:responseData encoding:NSUTF8StringEncoding];
    int statusCode = [((NSHTTPURLResponse *)response) statusCode];
    DLog(@"Fit Bit connect(Re) %@ : statusCode: %d", json_string, statusCode);
    if (statusCode == 200 || statusCode == 204) {
        [self postRequestToCheckFitBitStatus];
    }
    [mAppDelegate removeLoadView];
}

- (IBAction)disConnectAction:(id)sender {
    [mAppDelegate createLoadView];
    NSString *mRequestStr = WEBSERVICEURL;
    mRequestStr = [mRequestStr stringByAppendingFormat:@"Fitbit/Connect"];
    NSURL *url1 = [NSURL URLWithString:mRequestStr];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url1
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:60.0];
    //[theRequest valueForHTTPHeaderField:body];
    [theRequest setValue:mAppDelegate.mResponseMethods_.sessionToken forHTTPHeaderField:@"SessionToken"];
    [theRequest setValue:mAppDelegate.mResponseMethods_.authToken forHTTPHeaderField:@"AuthToken"];
    [theRequest setHTTPMethod:@"DELETE"];
    
    NSHTTPURLResponse *response;
    NSError *error;
    NSData *responseData = [NSURLConnection
                        sendSynchronousRequest:theRequest
                        returningResponse:&response error:&error];
    NSString *json_string = [[NSString alloc]
                             initWithData:responseData encoding:NSUTF8StringEncoding];
    int statusCode = [((NSHTTPURLResponse *)response) statusCode];
    DLog(@"Fit Bit Disconnect %@ : statusCode: %d", json_string, statusCode);
    if (statusCode == 200 || statusCode == 204) {
        [self postRequestToCheckFitBitStatus];
    }
    [mAppDelegate removeLoadView];
}

- (IBAction)hadPINAction:(id)sender {
    
    [mAppDelegate addTransparentViewToWindowForDisuccionForum];
    
    NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"EnterFitBitPIN" owner:self options:nil];
    self.mEnterFitBitPIN = [array objectAtIndex:0];
    
    self.mEnterFitBitPIN.mPINTxt.text = @"";
    [Utilities addInputViewForKeyBoardForTextFld:self.mEnterFitBitPIN.mPINTxt Class:self];
    [self.mEnterFitBitPIN.mPINTxt becomeFirstResponder];
    [self.mEnterFitBitPIN.mPINTxt setReturnKeyType:UIReturnKeyGo];
    self.mEnterFitBitPIN.mPINTxt.delegate = self;
    
    //[self.mEnterFitBitPIN.mContinueBtn addTarget:self action:@selector(enterPINContinueAction:) forControlEvents:UIControlEventTouchUpInside];
    [mAppDelegate.window addSubview:self.mEnterFitBitPIN];
}
// clear action
- (void)cancelTxtFld_Event
{
    self.mEnterFitBitPIN.mPINTxt.text = @"";
    [self.mEnterFitBitPIN.mPINTxt resignFirstResponder];
    [self.mEnterFitBitPIN removeFromSuperview];
    [mAppDelegate removeTransparentViewFromWindow];
}
// done action
- (void)doneTxtFld_Event
{
    [self enterPINContinueAction];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self enterPINContinueAction];
    return YES;
}
- (void)enterPINContinueAction {
    if ( [self.mEnterFitBitPIN.mPINTxt.text isEqualToString:@""]) {
        [UtilitiesLibrary showAlertViewWithTitle:NSLocalizedString(@"ALERT_TITLE", nil) :NSLocalizedString(@"FITBIT_PIN", nil)];
        return;
    }
    [self.mEnterFitBitPIN.mPINTxt resignFirstResponder];
    [self.mEnterFitBitPIN removeFromSuperview];
    [mAppDelegate removeTransparentViewFromWindow];
    [self postRequestToVerifyPin:[NSString stringWithFormat:@"=%@",self.mEnterFitBitPIN.mPINTxt.text]];
}
- (void)postRequestToVerifyPin:(NSString*)mBody {
    
    [mAppDelegate createLoadView];
    NSString *mRequestStr = WEBSERVICEURL;
    mRequestStr = [mRequestStr stringByAppendingFormat:@"Fitbit/Verify"];
    NSURL *url1 = [NSURL URLWithString:mRequestStr];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url1
                                                              cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                          timeoutInterval:60.0];
    [theRequest setValue:mAppDelegate.mResponseMethods_.sessionToken forHTTPHeaderField:@"SessionToken"];
    [theRequest setValue:mAppDelegate.mResponseMethods_.authToken forHTTPHeaderField:@"AuthToken"];
    [theRequest setHTTPMethod:@"POST"];
   // NSString *body = @"p2c1ro5nsnigt94glpthnc15cc";
    //[theRequest valueForHTTPHeaderField:body];
    
    NSData *bodyData = [mBody dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *bodyLength = [NSString stringWithFormat:@"%d", [bodyData length]];
    [theRequest setValue:bodyLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
   // [theRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [theRequest setHTTPBody:bodyData];
  
    NSData *response = [NSURLConnection 
                        sendSynchronousRequest:theRequest
                        returningResponse:nil error:nil];
    NSString *json_string = [[NSString alloc]
                             initWithData:response encoding:NSUTF8StringEncoding];
    DLog(@"Fit Bit VerifyPin %@", json_string);
    [mAppDelegate removeLoadView];
    if ([json_string isEqualToString:@"An error occurred"]) {
        [UtilitiesLibrary showAlertViewWithTitle:NSLocalizedString(@"ALERT_TITLE", nil) :NSLocalizedString(@"NO_RESPONSE", nil)];
        return;
    }else if ([json_string isEqualToString:@"Fitbit device conflict"]) {
        [UtilitiesLibrary showAlertViewWithTitle:NSLocalizedString(@"ALERT_TITLE", nil):@"Fitbit device conflict"];
    }else {
        if ([json_string boolValue]) {
            [self postRequestToCheckFitBitStatus];
        } else {
            
        }
        
    }
}
@end
