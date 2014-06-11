//
//  NetworkMonitor.m
//  Castrol
//
//  Created by EHEandme on 12/13/10.
//  Copyright 2010 valuelabs. All rights reserved.
//

#import "NetworkMonitor.h"
static NetworkMonitor *g_NetworkMonitorInstance=nil;

@implementation NetworkMonitor


+(NetworkMonitor*)instance{
	
	@synchronized (self){
		if (nil==g_NetworkMonitorInstance) {
			g_NetworkMonitorInstance=[[NetworkMonitor alloc]init];
			
		}
		return g_NetworkMonitorInstance;
	}
	return nil;
}

+(void)deallocInstance{
	
	g_NetworkMonitorInstance=nil;
	
}

-(void)initNetworkInstance{
	
	m_AppDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
	//handling of the wi-fi connectivity and network connectivity
	m_InternetReach = [Reachability reachabilityForInternetConnection];
	[m_InternetReach startNotifier];
    m_WifiReach = [Reachability reachabilityForLocalWiFi];
	[m_WifiReach startNotifier];

}

//TODO: Alert Message for network is to be verified
-(BOOL)isNetworkAvailable{
	m_AppDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];

	NetworkStatus wifiStatus =[m_WifiReach currentReachabilityStatus];
	NetworkStatus internetStatus =[m_InternetReach currentReachabilityStatus];
	if(wifiStatus == ReachableViaWiFi || internetStatus == ReachableViaWiFi || 
		internetStatus == ReachableViaWWAN || internetStatus == ReachableAny){
		return YES;
	}else {
		return NO;
	}

}

-(void)displayNetworkMonitorAlert
{
    m_AppDelegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];

	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@" Please check your network connection."
						   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil,nil];
	[alert show];
    [m_AppDelegate removeLoadView];
}

- (void) SetReachibilityStates:(BOOL)isInternetUnReachable:(BOOL)isWiFiUnReachable
{	
	
	if( isInternetUnReachable == YES && isWiFiUnReachable == NO )
	{
		
		blnInternetUnReachable = TRUE;
	}
	
	if( isWiFiUnReachable == YES && isInternetUnReachable == NO )
	{
		
		blnWifiUnReachable = TRUE;
	}
	
	//Reset states for wifireachibility and iunternetreachability
	if(isWiFiUnReachable == TRUE && isInternetUnReachable == TRUE )
	{
		//Reset states
		blnWifiUnReachable =  FALSE;
		blnInternetUnReachable = FALSE;
	//	[self ShowGPSUnAvailbleMessage];
	}
}

//Called by Reachability whenever status changes.
- (void) reachabilityChanged: (NSNotification* )note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
	NetworkStatus netStatus =[curReach currentReachabilityStatus];	
	if(curReach == m_InternetReach  )
	{	
		if(netStatus != NotReachable )
		{		
			_bIsOnlineMode = TRUE;
			
			return;
		}
		else 
		{
			if( [m_WifiReach currentReachabilityStatus] == ReachableViaWiFi )
			{
				return;
			}
			
			
			[self SetReachibilityStates:YES:NO];	
			
		}
	}		
	if(curReach == m_WifiReach)
	{			
		if(netStatus !=NotReachable )
		{	
			_bIsOnlineMode = TRUE;
    		return;
		}
		else
		{	
			if([m_InternetReach currentReachabilityStatus] == ReachableViaWiFi)
			{
			    return;
			}
			
			[self SetReachibilityStates:NO:YES];	
		}
	}	
}

@end
