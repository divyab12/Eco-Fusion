//
//  AccountManegerViewController.m
//  DietToGo
//
//  Created by Suresh on 5/6/14.
//  Copyright (c) 2014 DietToGo. All rights reserved.
//

#import "AccountManegerViewController.h"

@interface AccountManegerViewController ()

@end

@implementation AccountManegerViewController
@synthesize currentIndex;

-(id)initWithNibName:(NSString *)nibNameOrNil WithIndex:(int)lIndex{
    
    currentIndex = lIndex;
    return [self initWithNibName:nibNameOrNil bundle:nil];
}

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
    // for setting the view below 20px in iOS7.0.
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        self.edgesForExtendedLayout = UIRectEdgeLeft | UIRectEdgeRight;
#endif
    mAppDelegate = [AppDelegate appDelegateInstance];
    NSLog(@"currentIndex %d",currentIndex);
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:TRUE];
   
    NSString *imgName = @""; NSString *trackName = @"";
    if (CURRENTDEVICEVERSION >= IOS7VERSION ) {
        imgName = @"topbar.png";
        [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = [[UIImage alloc ]init];
    }else{
        imgName = @"topbar1.png";
    }
    switch (currentIndex) {
        case 1:
            [mAppDelegate setNavControllerTitle:NSLocalizedString(@"ACCOUNTMANAGEMENT", nil) imageName:imgName forController:self];
            [self.mWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:AccountManagerURL]]];
            trackName = NSLocalizedString(@"ACCOUNTMANAGEMENT", nil);
            break;
        case 2:
            [mAppDelegate setNavControllerTitle:NSLocalizedString(@"MENUMANAGEMT", nil) imageName:imgName forController:self];
            [self.mWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:MenuManagerURL]]];
            trackName = NSLocalizedString(@"MENUMANAGEMT", nil);
            break;
        case 3:
            [mAppDelegate setNavControllerTitle:NSLocalizedString(@"PLANHOLDS", nil) imageName:imgName forController:self];
            [self.mWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:PlanHoldsURL]]];
            trackName = NSLocalizedString(@"PLANHOLDS", nil);
            break;
        case 4:
            [mAppDelegate setNavControllerTitle:NSLocalizedString(@"SUPPORTREQUEST", nil) imageName:imgName forController:self];
            [self.mWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:SupportRequestURL]]];
            trackName = NSLocalizedString(@"SUPPORTREQUEST", nil);
            break;
        default:
            break;
    }
    
    if (mAppDelegate.mTrackPages) {
        [mAppDelegate trackFlurryLogEvent:trackName];
    }
    [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"menu.png"] title:nil target:self action:@selector(menuAction:) forController:self rightOrLeft:0];
}
- (void)menuAction:(id)sender {
    [mAppDelegate showLeftSideMenu:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
