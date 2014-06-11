//
//  AccountManegerViewController.h
//  DietToGo
//
//  Created by Suresh on 5/6/14.
//  Copyright (c) 2014 DietToGo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountManegerViewController : UIViewController {
    AppDelegate *mAppDelegate;
}
@property int currentIndex;
@property (strong, nonatomic) IBOutlet UIWebView *mWebView;
-(id)initWithNibName:(NSString *)nibNameOrNil WithIndex:(int)lIndex;
@end
