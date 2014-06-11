//
//  NetworkMonitor.h
//  Castrol
//
//  Created by EHEandme on 12/13/10.
//  Copyright 2010 valuelabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import "AppDelegate.h"

@class Reachability;

@class AppDelegate;

@interface NetworkMonitor : NSObject{
	//Reachability
	Reachability	*m_InternetReach;
	Reachability *m_WifiReach;
	AppDelegate *m_AppDelegate;
	BOOL _bIsOnlineMode;
	BOOL blnInternetUnReachable;
	BOOL blnWifiUnReachable;
}

+(NetworkMonitor*)instance;
+(void)deallocInstance;
-(void)displayNetworkMonitorAlert;
-(BOOL)isNetworkAvailable;
-(void)initNetworkInstance;
- (void) SetReachibilityStates:(BOOL)isInternetUnReachable :(BOOL)isWiFiUnReachable;
- (void) reachabilityChanged: (NSNotification* )note;
@end
