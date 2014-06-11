//
//  ResponseMethods.h
//  EHEandme
//
//  Created by EHEandme on 17/09/12.
//  Copyright (c) 2012 EHEandme. All rights reserved.
//


#import <Foundation/Foundation.h>

@class AppDelegate;

@interface ResponseMethods : NSObject{
    
    /**
     * AppDelegate object creating
     */   
    AppDelegate *mAppDelegate_;
@public
    /*
     * bool parameter to show alert or not for food update
     */
    BOOL mToShowEditFood;
}
@property(nonatomic,strong)NSString *mErrorStr;
@property(nonatomic,strong)NSString *userName;
@property(nonatomic,strong)NSString *authToken;
@property(nonatomic,strong)NSString *sessionToken;
@property(nonatomic,strong)NSString *userType;
@property(nonatomic,strong)NSString *coachID;
@property(nonatomic,retain) id mPrevViewOfSlider;
@property(nonatomic,retain)NSString *mIsLogMealReported;


- (void)successResponse;
/*
 * Method used to check whether the response is correct or not
 */
- (BOOL)isResponseValid;
/**
 * Method used to store logged in user details in user defaults
 * @param lUsername for the user name
 * @param lAuthToken for the user authorization token
 * @param lToken for the user session token
 * @param lUserType for the user type
 */
- (void)StoreUserDetails:(NSString*)lUsername
               AuthToken:(NSString*)lAuthToken
            SessionToken:(NSString*)lToken
                UserType:(NSString*)lUserType
                 CoachID:(NSString*)lCoachID;

@end
