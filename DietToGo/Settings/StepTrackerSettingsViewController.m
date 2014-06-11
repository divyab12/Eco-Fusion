//
//  StepTrackerSettingsViewController.m
//  EHEandme
//
//  Created by Divya Reddy on 06/12/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import "StepTrackerSettingsViewController.h"

@interface StepTrackerSettingsViewController ()

@end

@implementation StepTrackerSettingsViewController

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
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        self.edgesForExtendedLayout = UIRectEdgeLeft | UIRectEdgeRight;
#endif
    mAppDelegate = [AppDelegate appDelegateInstance];
    self.mLbl.font = Bariol_Regular(22);
    self.mLbl.textColor = RGB_A(136, 136, 136, 1);
    self.mLb11.textColor = BLACK_COLOR;
    self.mLb11.font = Bariol_Regular(17);

    self.mSwitch.onTintColor = RGB_A(106, 184, 51, 1);
    
    //to set the switch from userdefaults
    NSUserDefaults *lUserDefaults = [NSUserDefaults standardUserDefaults];
    if ([lUserDefaults objectForKey:Step_Tracking] == nil) {
        self.mSwitch.on = FALSE;

    }else{
        if ([lUserDefaults boolForKey:Step_Tracking]) {
            self.mSwitch.on = TRUE;

        }else{
            self.mSwitch.on = FALSE;

        }
    }
    [self.mSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:TRUE];
    //self.navigationController.navigationBarHidden = TRUE;
    //for tracking
    if (mAppDelegate.mTrackPages) {
        self.trackedViewName=@"Step Tracker Settings page";
    }
    //end
    NSString *imgName;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        imgName = @"topbar.png";
        [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = [[UIImage alloc ]init];
    }else{
        imgName = @"topbar1.png";
    }
    [mAppDelegate setNavControllerTitle:NSLocalizedString(@"STEP_TRACKER_SETTINGS", nil) imageName:imgName forController:self];
    
    [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"prev(orange).png"] title:nil target:self action:@selector(backAction:) forController:self rightOrLeft:0];
    
}
- (void)backAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:TRUE];
}
- (void)switchAction:(UISwitch*)lSwitch{
    NSLog(@"%d",lSwitch.on);
    NSUserDefaults *lUserDefaults = [NSUserDefaults standardUserDefaults];
    if (!lSwitch.isOn) {
        //false
        [lUserDefaults setBool:FALSE forKey:Step_Tracking];
        [mAppDelegate showCustomAlert:@"" Message:[NSString stringWithFormat:@"Automatic steps tracking to switched OFF successfully."]];

    }else{
        [lUserDefaults setBool:TRUE forKey:Step_Tracking];
        [mAppDelegate showCustomAlert:@"" Message:[NSString stringWithFormat:@"Automatic steps trackers is switched ON successfully."]];


    }
    [mAppDelegate automaticTrackSteps];

    [lUserDefaults synchronize];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
