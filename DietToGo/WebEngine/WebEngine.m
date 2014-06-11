	//
	//  WebEngine.m
	//	HPAC
	//  Copyright 2011 EHEandme. All rights reserved.
	//

#import "WebEngine.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "JSON.h"
#import "UtilitiesLibrary.h"
#import "GenricUI.h"
#import "NSDataAdditions.h"

@implementation WebEngine

@synthesize mWebMethodName_;
@synthesize mStatusCode;

- (id)init
{
    if (self = [super init])
    {
			// Initialization code here
        _pAppDelegate = [AppDelegate appDelegateInstance];
    }
    
    return self;

}

- (void)makeRequestWithUrlForUploadPhoto:(NSString *)mReqStr_ 
                                withData:(NSData*)imageData
                           withAuthToken:(NSString*)mAuthToken_
                        withSessionToken:(NSString*)mToken_
{
   
    NSURL *url = [NSURL URLWithString:mReqStr_];
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];// requestWithURL:url];
    //   [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[theRequest setHTTPMethod:@"POST"]; //@"PUT"
    [theRequest addValue:@"image/jpg" forHTTPHeaderField:@"Content-Type"];
    [theRequest setValue:[NSString stringWithFormat:@"%d",[imageData length]] forHTTPHeaderField:@"Content-Length"];
    [theRequest setValue:mToken_ forHTTPHeaderField:@"SessionToken"];
    [theRequest setValue:mAuthToken_ forHTTPHeaderField:@"AuthToken"];
    
    [theRequest setValue:@"inline; filename=ImageName.jpg" forHTTPHeaderField:@"Content-Disposition"];
    [theRequest setHTTPBody:imageData];
   
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];

	if( theConnection )
	{
		if(webData != nil)
		{
			webData = nil;
		}
		
		webData = [NSMutableData data];
	}
	else
	{
        [UtilitiesLibrary showAlertViewWithTitle:@"":@"theConnection is NULL"];
	}
    
}

//Delete with Header body..
- (void)makeDELETEwithHeaderBodyRequestWithUrl:(NSString*)mReqStr_
                                      withBody:(NSString*)body 
                                         Token:(NSString*)mToken_
{
   // mReqStr_ = [mReqStr_ stringByAppendingFormat:@"?%@",body];
    NSURL *url1 = [NSURL URLWithString:mReqStr_];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url1
															  cachePolicy:NSURLRequestUseProtocolCachePolicy
														  timeoutInterval:60.0];
   
    NSData *bodyData = [body dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *bodyLength = [NSString stringWithFormat:@"%d", [bodyData length]];
    [theRequest setValue:bodyLength forHTTPHeaderField:@"Content-Length"];
   //[theRequest addValue:@"1000965" forHTTPHeaderField:@"userID"];
   // [theRequest addValue:@"100201" forHTTPHeaderField:@"ListId"];
    [theRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
   [theRequest setHTTPBody:bodyData];
    
   // [theRequest addValue:bodyData forHTTPHeaderField:<#(NSString *)#>];
    
    [theRequest setValue:mToken_ forHTTPHeaderField:@"token"];
    [theRequest setHTTPMethod:@"DELETE"];
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	
	if( theConnection )
	{
		if(webData != nil)
		{
			webData = nil;
		}
		
		webData = [NSMutableData data];
	}
	else
	{
        [UtilitiesLibrary showAlertViewWithTitle:@"":@"theConnection is NULL"];
	}
}
- (void)makeDELETERequestWithUrl:(NSString*)mReqStr_
                   withAuthToken:(NSString*)mAuthToken_
                withSessionToken:(NSString*)mToken_
{
    // mReqStr_ = [mReqStr_ stringByAppendingFormat:@"?%@",body];
    NSURL *url1 = [NSURL URLWithString:mReqStr_];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url1
															  cachePolicy:NSURLRequestUseProtocolCachePolicy
														  timeoutInterval:60.0];
    
    //NSData *bodyData = [body dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
   // NSString *bodyLength = [NSString stringWithFormat:@"%d", [bodyData length]];
    //[theRequest setValue:bodyLength forHTTPHeaderField:@"Content-Length"];
    //[theRequest addValue:@"1000965" forHTTPHeaderField:@"userID"];
    // [theRequest addValue:@"100201" forHTTPHeaderField:@"ListId"];
    [theRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //[theRequest setHTTPBody:bodyData];
    
    // [theRequest addValue:bodyData forHTTPHeaderField:<#(NSString *)#>];
    
    [theRequest setValue:mToken_ forHTTPHeaderField:@"SessionToken"];
    [theRequest setValue:mAuthToken_ forHTTPHeaderField:@"AuthToken"];
    [theRequest setHTTPMethod:@"DELETE"];
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	
	if( theConnection )
	{
		if(webData != nil)
		{
			webData = nil;
		}
		
		webData = [NSMutableData data];
	}
	else
	{
        [UtilitiesLibrary showAlertViewWithTitle:@"":@"theConnection is NULL"];
	}
}
//Get with Header Body..
- (void)makeGETwithHeaderBodyRequestWithUrl:(NSString*)mReqStr_
                              withAuthToken:(NSString*)mAuthToken_
                           withSessionToken:(NSString*)mToken_
{
    
    NSURL *url1 = [NSURL URLWithString:mReqStr_];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url1
															  cachePolicy:NSURLRequestUseProtocolCachePolicy
														  timeoutInterval:60.0];
    //[theRequest valueForHTTPHeaderField:body];
   [theRequest setValue:mToken_ forHTTPHeaderField:@"SessionToken"];
    [theRequest setValue:mAuthToken_ forHTTPHeaderField:@"AuthToken"];
    [theRequest setHTTPMethod:@"GET"];
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	
	if( theConnection )
	{
		if(webData != nil)
		{
			webData = nil;
		}
		
		webData = [NSMutableData data];
	}
	else
	{
        [UtilitiesLibrary showAlertViewWithTitle:@"":@"theConnection is NULL"];
	}
}

//This is for other GET methods
- (void)makeGETRequestWithUrl:(NSString*)mReqStr_
{
    
    NSURL *url1 = [NSURL URLWithString:mReqStr_];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url1 
															  cachePolicy:NSURLRequestUseProtocolCachePolicy 
														  timeoutInterval:60.0];
    [theRequest setHTTPMethod:@"GET"];
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	
	if( theConnection )
	{
		if(webData != nil)
		{
			webData = nil;
		}
		
		webData = [NSMutableData data];
	}
	else
	{
          [UtilitiesLibrary showAlertViewWithTitle:@"":@"theConnection is NULL"];
	}
}

// make a POST Request
- (void)makePOSTRequestWithUrl:(NSString *)mReqStr_ 
                      withBody:(NSString*)body {
    
    NSURL *url = [NSURL URLWithString:mReqStr_];
    NSData *bodyData = [body dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *bodyLength = [NSString stringWithFormat:@"%d", [bodyData length]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:bodyLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:bodyData];

    
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	if( theConnection )
	{
		if(webData != nil)
		{
			webData = nil;
		}
		
		webData = [NSMutableData data];
	}
	else
	{
        [UtilitiesLibrary showAlertViewWithTitle:@"":@"theConnection is NULL"];
	}

    
}
- (void)makePOSTRequestWithUrl:(NSString *)mReqStr_
                      withBody:(NSString*)body
                 withAuthToken:(NSString*)mAuthToken
              withSessionToken:(NSString*)mSessionToken {
    
    NSURL *url = [NSURL URLWithString:mReqStr_];
    NSData *bodyData = [body dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *bodyLength = [NSString stringWithFormat:@"%d", [bodyData length]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:bodyLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:bodyData];
    
    [request setValue:mSessionToken forHTTPHeaderField:@"SessionToken"];
    [request setValue:mAuthToken forHTTPHeaderField:@"AuthToken"];
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	if( theConnection )
	{
		if(webData != nil)
		{
			webData = nil;
		}
		
		webData = [NSMutableData data];
	}
	else
	{
        [UtilitiesLibrary showAlertViewWithTitle:@"":@"theConnection is NULL"];
	}

    
}
- (void)makePOSTRequestWithUrlandReqData:(NSString *)mReqStr_
                      withData:(NSData*)bodyData
                 withAuthToken:(NSString*)mAuthToken
              withSessionToken:(NSString*)mSessionToken {
    NSURL *url = [NSURL URLWithString:mReqStr_];
    
    NSString *bodyLength = [NSString stringWithFormat:@"%d", [bodyData length]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:bodyLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:bodyData];
    
    [request setValue:mSessionToken forHTTPHeaderField:@"SessionToken"];
    [request setValue:mAuthToken forHTTPHeaderField:@"AuthToken"];
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	if( theConnection )
	{
		if(webData != nil)
		{
			webData = nil;
		}
		
		webData = [NSMutableData data];
	}
	else
	{
        [UtilitiesLibrary showAlertViewWithTitle:@"":@"theConnection is NULL"];
	}

}
- (void)makePOSTRequestWithUrl:(NSString *)mReqStr_
                 withAuthToken:(NSString*)mAuthToken
              withSessionToken:(NSString*)mSessionToken
{
    NSURL *url = [NSURL URLWithString:mReqStr_];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:mSessionToken forHTTPHeaderField:@"SessionToken"];
    [request setValue:mAuthToken forHTTPHeaderField:@"AuthToken"];
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	if( theConnection )
	{
		if(webData != nil)
		{
			webData = nil;
		}
		
		webData = [NSMutableData data];
	}
	else
	{
        [UtilitiesLibrary showAlertViewWithTitle:@"":@"theConnection is NULL"];
	}
    

}
- (void)makePUTwithHeaderBodyRequestWithUrl:(NSString*)mReqStr_
                                   withBody:(NSString*)body
                              withAuthToken:(NSString*)mAuthToken_
                           withSessionToken:(NSString*)mToken_
{
    NSURL *url1 = [NSURL URLWithString:mReqStr_];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url1
															  cachePolicy:NSURLRequestUseProtocolCachePolicy
														  timeoutInterval:60.0];
    
    NSData *bodyData = [body dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *bodyLength = [NSString stringWithFormat:@"%d", [bodyData length]];
    [theRequest setValue:bodyLength forHTTPHeaderField:@"Content-Length"];
    //[theRequest addValue:@"1000965" forHTTPHeaderField:@"userID"];
    // [theRequest addValue:@"100201" forHTTPHeaderField:@"ListId"];
    [theRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [theRequest setHTTPBody:bodyData];
    
    [theRequest setValue:mToken_ forHTTPHeaderField:@"SessionToken"];
    [theRequest setValue:mAuthToken_ forHTTPHeaderField:@"AuthToken"];
    [theRequest setHTTPMethod:@"PUT"];
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	
	if( theConnection )
	{
		if(webData != nil)
		{
			webData = nil;
		}
		
		webData = [NSMutableData data];
	}
	else
	{
        [UtilitiesLibrary showAlertViewWithTitle:@"":@"theConnection is NULL"];
	}

}

- (void)makePUTRequestWithUrl:(NSString*)mReqStr_
                withAuthToken:(NSString*)mAuthToken_
             withSessionToken:(NSString*)mToken_;

{
    NSURL *url1 = [NSURL URLWithString:mReqStr_];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url1
															  cachePolicy:NSURLRequestUseProtocolCachePolicy
														  timeoutInterval:60.0];
    
    [theRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    
    [theRequest setValue:mToken_ forHTTPHeaderField:@"SessionToken"];
    [theRequest setValue:mAuthToken_ forHTTPHeaderField:@"AuthToken"];
    [theRequest setHTTPMethod:@"PUT"];
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	
	if( theConnection )
	{
		if(webData != nil)
		{
			webData = nil;
		}
		
		webData = [NSMutableData data];
	}
	else
	{
        [UtilitiesLibrary showAlertViewWithTitle:@"":@"theConnection is NULL"];
	}
    
}




#pragma mark Connection Delegate methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{   
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    
    if([httpResponse statusCode] ==200){
        [webData setLength: 0];
        self.mStatusCode = WebDAVOKStatusCode;
    }
    else if([httpResponse statusCode] == 204)
    {
//        if ([mShowLogs isEqualToString:@"TRUE"]) 
            NSLog(@"--------> response code %d <----------",[httpResponse statusCode]);
            [self setMStatusCode:WebDAVNoContentStatusCode];

    }else if([httpResponse statusCode] == 500){
          NSLog(@"--------> response code %d <----------",[httpResponse statusCode]);
        [UtilitiesLibrary showAlertViewWithTitle:@"Alert" :@"Oops! There seem to be an issue, please try again later."];

    }
    else {
        //        if ([mShowLogs isEqualToString:@"TRUE"]) 
        NSLog(@"--------> response code %d <----------",[httpResponse statusCode]);
    }
}

#pragma mark NSURLConnection Delegate methods  
#pragma mark did receive data
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[webData appendData:data];
    
    
}

#pragma mark did fail with error
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	[[NSNotificationCenter defaultCenter] postNotificationName: @"ResponseFailed" object: nil];
		//[connection release];
}

#pragma mark did finish loading 
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
		//NSLog(@"ConnectionDidFinish");
	
	if([webData length]==0 )
	{
        if (self.mStatusCode == WebDAVNoContentStatusCode && ([self.mWebMethodName_ isEqualToString:UPDATEPERSONALSETTINGS] || [self.mWebMethodName_ isEqualToString:LOGOUT] || [self.mWebMethodName_ isEqualToString:ADDFOODTOFAVORITEFOODS] || [self.mWebMethodName_ isEqualToString:REMOVEFOODFROMFAVORITEFOODS] || [self.mWebMethodName_ isEqualToString:SAVEMEALPLANS] || [self.mWebMethodName_ isEqualToString:SAVEMEALPREFERENCES] || [self.mWebMethodName_ isEqualToString:SWAPMEAL]|| [self.mWebMethodName_ isEqualToString:AddWeightLog] || [self.mWebMethodName_ isEqualToString:EditWeight] || [self.mWebMethodName_ isEqualToString:DeleteWeightLog] || [self.mWebMethodName_ isEqualToString:AddMeasurementLog] || [self.mWebMethodName_ isEqualToString:EditMeasurement] || [self.mWebMethodName_ isEqualToString:DeleteMeasurementLog] || [self.mWebMethodName_ isEqualToString:AddExerciseLog] || [self.mWebMethodName_ isEqualToString:DeleteExerciseLog] || [self.mWebMethodName_ isEqualToString:AddGlucoseLog] || [self.mWebMethodName_ isEqualToString:DeleteGlucoseLog] || [self.mWebMethodName_ isEqualToString:AddJournalLog] || [self.mWebMethodName_ isEqualToString:DeleteJournalLog] || [self.mWebMethodName_ isEqualToString:AddCholesterolLog] || [self.mWebMethodName_ isEqualToString:DeleteCholesterolLog] || [self.mWebMethodName_ isEqualToString:AddBMILog] || [self.mWebMethodName_ isEqualToString:DeleteBMILog] || [self.mWebMethodName_ isEqualToString:AddGoal] || [self.mWebMethodName_ isEqualToString:DeleteGoal] || [self.mWebMethodName_ isEqualToString:AddStepLog] || [self.mWebMethodName_ isEqualToString:DeleteStepLog] || [self.mWebMethodName_ isEqualToString:AddStepLog] || [self.mWebMethodName_ isEqualToString:SaveNotifications] || [self.mWebMethodName_ isEqualToString:DeleteMessage] || [self.mWebMethodName_ isEqualToString:ArchiveMessage] || [self.mWebMethodName_ isEqualToString:ReplyMessage] || [self.mWebMethodName_ isEqualToString:SendNewMessage]))
        {
            [[NSNotificationCenter defaultCenter] postNotificationName: @"onResponse" object:self];

        }else{
            [[NSNotificationCenter defaultCenter] postNotificationName: @"onNilResponse" object: nil];

        }

	}
	else
	{
		[[NSNotificationCenter defaultCenter] postNotificationName: @"onResponse" object:self];
		
	}
}

#pragma mark didReceiveAuthenticationChallenge 
//Comment this method while installing in teh device. 09/24/2012
- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
	NSURLCredential *newCredential;
	newCredential=[NSURLCredential credentialWithUser:@"dbakkareddygari"
											 password:@"Secure*12" persistence:NSURLCredentialPersistenceNone];
	[[challenge sender] useCredential:newCredential
		   forAuthenticationChallenge:challenge];
	
}

- (void) dealloc
{
    //[theConenction release];
	webData=nil;
	
}

@end
