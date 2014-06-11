//
//  TIMERUIApplication.h
//  EHEandme
//
//  Created by Suresh on 3/4/14.
//  Copyright (c) 2014 EHEandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

//the length of time before your application "times out". This number actually represents seconds, so we'll have to multiple it by 60 in the .m file
#define kApplicationTimeoutInMinutes 20
#define kMaxIdleTimeSeconds 60.0

//the notification your AppDelegate needs to watch for in order to know that it has indeed "timed out"
#define kApplicationDidTimeoutNotification @"AppTimeOut"

@interface TIMERUIApplication : UIApplication
{
    NSTimer     *myidleTimer;
}

-(void)resetIdleTimer;

@end