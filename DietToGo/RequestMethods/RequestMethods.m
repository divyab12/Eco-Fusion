//
//  RequestMethods.m
//  EHEandme
//
//  Created by EHEandme on 17/09/12.
//  Copyright (c) 2012 EHEandme. All rights reserved.
//

#import "RequestMethods.h"
#import "AppDelegate.h"
#import "WebEngine.h"
#import "Constants.h"
#import "ResponseMethods.h"

@implementation RequestMethods

@synthesize mViewRefrence;
- (id)init
{
    if (self = [super init])
    {
        // Initialization code here
        mAppDelegate_ = [AppDelegate appDelegateInstance];
    }
    
    return self;
    
}
- (void)postRequestForLoginWithUserID:(NSString*)mUserID
                             UserName:(NSString*)mName
                              CoachID:(NSString*)mID
{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  GETTOKENS;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"Account/%@", LOGINTEXT];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *body = [NSString stringWithFormat:@"EHEUserID=%@&UserName=%@&CoachID=%@",mUserID,mName,mID];
    [mAppDelegate_.mWebEngine_ makePOSTRequestWithUrl:mRequestURL
                                             withBody:body];

}
- (void)postRequestToValidateCookies:(NSString*)mRT
                                  SV:(NSString*)mSV
                                  CD:(NSString*)mCD{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  GETTOKENS;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"Account/Validate"];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *body = [NSString stringWithFormat:@"Cookie=%@",[self encodeToPercentEscapeString:mRT]];
    [mAppDelegate_.mWebEngine_ makePOSTRequestWithUrl:mRequestURL
                                             withBody:body];

}
//Encode a string to embed in an URL.

-(NSString*)encodeToPercentEscapeString:(NSString *)string {
    
    return (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)string,NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8));
    
}

- (void)postRequestToGetUserPersonalSettings:(NSString*)mAuthToken
                                SessionToken:(NSString*)mSessionToken
{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  GETPERSONALSETTINGS;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@", SETTINGS, PERSONAL];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [mAppDelegate_.mWebEngine_ makeGETwithHeaderBodyRequestWithUrl:mRequestURL
                                                     withAuthToken:mAuthToken
                                                  withSessionToken:mSessionToken];
}
- (void)postRequestToCheckUserPersonalSettings:(NSString*)mAuthToken
                                  SessionToken:(NSString*)mSessionToken
{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  CHECKPERSONALSETTINGS;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/CheckPersonal", SETTINGS];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [mAppDelegate_.mWebEngine_ makeGETwithHeaderBodyRequestWithUrl:mRequestURL
                                                     withAuthToken:mAuthToken
                                                  withSessionToken:mSessionToken];

}
- (void)postRequestToUpdateUserPersonalSettings:(NSString*)mAuthToken
                                   SessionToken:(NSString*)mSessionToken
                                    StartWeight:(NSString*)mStartWeight
                                     GoalWeight:(NSString*)mGoalWeight
                                   HeightInches:(NSString*)mHeightInch
                                    HeightFeets:(NSString*)mHeightFeet
                                         Gender:(NSString*)mGender
                                  ActivityLevel:(NSString*)mActivityLevel
                                           Goal:(NSString*)mGoal
                                           DOB:(NSString*)mDOB
{
    //Here mGoal means CurrentWeight
    mAppDelegate_.mWebEngine_.mWebMethodName_=  UPDATEPERSONALSETTINGS;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@", SETTINGS, PERSONAL];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *body = [NSString stringWithFormat:@"StartWeight=%@&GoalWeight=%@&HeightFt=%@&HeightInch=%@&Gender=%@&ActivityLevel=%@&CurrentWeight=%@&BirthDate=%@",mStartWeight, mGoalWeight, mHeightFeet, mHeightInch, mGender, mActivityLevel, mGoal, mDOB];
    //[NSString stringWithFormat:@"StartWeight=%@&GoalWeight=%@&HeightFt=%@&HeightIn=%@&Gender=%@&ActivityLevel=%@&MealGoal=%@&DateOfBirth=%@",mStartWeight, mGoalWeight, mHeightFeet, mHeightInch, mGender, mActivityLevel, mGoal, mDOB]
    /*[mAppDelegate_.mWebEngine_ makePOSTRequestWithUrl:mRequestURL
                                             withBody:body
                                        withAuthToken:mAuthToken
                                     withSessionToken:mSessionToken];*/
    [mAppDelegate_.mWebEngine_ makePUTwithHeaderBodyRequestWithUrl:mRequestURL withBody:body withAuthToken:mAuthToken withSessionToken:mSessionToken];
}
- (void)postRequestToCheckUserMealPlanSettings:(NSString*)mAuthToken
                                  SessionToken:(NSString*)mSessionToken
{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  CHECKMEALPLANSETTINGS;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/CheckMealPlan", SETTINGS];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [mAppDelegate_.mWebEngine_ makeGETwithHeaderBodyRequestWithUrl:mRequestURL
                                                     withAuthToken:mAuthToken
                                                  withSessionToken:mSessionToken];

}
- (void)postRequestToGetUserCalories:(NSString*)mAuthToken
                        SessionToken:(NSString*)mSessionToken
{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  GETCALORIELEVEL;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@", SETTINGS, CALORIESTXT];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [mAppDelegate_.mWebEngine_ makeGETwithHeaderBodyRequestWithUrl:mRequestURL
                                                     withAuthToken:mAuthToken
                                                  withSessionToken:mSessionToken];

}
- (void)postRequestToGetMealPlans:(NSString*)mCalLevel
                        AuthToken:(NSString*)mAuthToken
                     SessionToken:(NSString*)mSessionToken
{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  GETMEALPLANS;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@?caloriesLevel=%@", SETTINGS, MEALPLANTEXT,mCalLevel];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [mAppDelegate_.mWebEngine_ makeGETwithHeaderBodyRequestWithUrl:mRequestURL
                                                     withAuthToken:mAuthToken
                                                  withSessionToken:mSessionToken];

}
- (void)postRequestToSaveMealPlans:(NSString*)mCalLevel
                          MealPlan:(NSString*)mMealPlan
                         AuthToken:(NSString*)mAuthToken
                      SessionToken:(NSString*)mSessionToken
{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  SAVEMEALPLANS;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@", SETTINGS, MEALPLANTEXT];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *body = [NSString stringWithFormat:@"MealPlan=%@&CaloriesLevel=%@",mMealPlan, mCalLevel];
    [mAppDelegate_.mWebEngine_ makePOSTRequestWithUrl:mRequestURL
                                             withBody:body
                                        withAuthToken:mAuthToken
                                     withSessionToken:mSessionToken];


}
- (void)postRequestToGetMealPreferences:(NSString*)mAuthToken
                           SessionToken:(NSString*)mSessionToken
{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  GETMEALPREFERENCES;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/MealPreferences", SETTINGS];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [mAppDelegate_.mWebEngine_ makeGETwithHeaderBodyRequestWithUrl:mRequestURL
                                                     withAuthToken:mAuthToken
                                                  withSessionToken:mSessionToken];

}
- (void)postRequestToSaveMealPreferences:(NSData*)mBody
                               AuthToken:(NSString*)mAuthToken
                            SessionToken:(NSString*)mSessionToken
{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  SAVEMEALPREFERENCES;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/MealPreferences", SETTINGS];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    /*[mAppDelegate_.mWebEngine_ makePOSTRequestWithUrl:mRequestURL
                                             withBody:mBody
                                        withAuthToken:mAuthToken
                                     withSessionToken:mSessionToken];*/
    [mAppDelegate_.mWebEngine_ makePOSTRequestWithUrlandReqData:mRequestURL
                                                       withData:mBody
                                                  withAuthToken:mAuthToken
                                               withSessionToken:mSessionToken];
}
- (void)postRequestForGetMealPlan:(NSString*)mDate
                        AuthToken:(NSString*)mAuthToken
                     SessionToken:(NSString*)mSessionToken
{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  GETMEALPLAN;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@", MEALPLANTEXT,mDate];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [mAppDelegate_.mWebEngine_ makeGETwithHeaderBodyRequestWithUrl:mRequestURL
                                                     withAuthToken:mAuthToken
                                                  withSessionToken:mSessionToken];

}
- (void)postRequestToChangeReportStatus:(NSString *)mDate
                               FoodLogDailyId:(NSString *)mFoodLogDailyId
                              FoodLogID:(NSString *)mFoodLogId
                               Reported:(NSString *)mReported
                              AuthToken:(NSString *)mAuthToken
                           SessionToken:(NSString *)mSessionToken
{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  CHANGEREPORTSTATUS;
    mAppDelegate_.mResponseMethods_.mIsLogMealReported = mReported;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@/%@/%@?Report=%@", MEALPLANTEXT,mDate,mFoodLogDailyId,mFoodLogId,mReported];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    /*[mAppDelegate_.mWebEngine_ makePOSTRequestWithUrl:mRequestURL
                                                     withAuthToken:mAuthToken
                                                  withSessionToken:mSessionToken];*/
    [mAppDelegate_.mWebEngine_ makePUTRequestWithUrl:mRequestURL withAuthToken:mAuthToken withSessionToken:mSessionToken];
}
- (void)postRequestForEditLogFood:(NSString *)mDate
                         MealType:(NSString *)mType
                        FoodLogDailyId:(NSString *)mFoodLogDailyId
                        FoodLogID:(NSString *)mFoodLogId
                        FoodID:(NSString *)mFoodID
                         Quantity:(NSString *)mQty
                           UnitID:(NSString *)mUnitID
                        Favorite:(NSString *)mFavorite
                        AuthToken:(NSString *)mAuthToken
                     SessionToken:(NSString *)mSessionToken
{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  EDITLOGFOOD;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@/%@/%@/%@?foodID=%@&Qty=%@&unitID=%@&favorite=%@", MEALPLANTEXT,mDate,mType,mFoodLogDailyId,mFoodLogId,mFoodID,mQty,mUnitID,mFavorite];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [mAppDelegate_.mWebEngine_ makePUTRequestWithUrl:mRequestURL
                                        withAuthToken:mAuthToken
                                     withSessionToken:mSessionToken];
}
- (void)postRequestForDeleteLogFood:(NSString*)mDate
                           FoodLogDailyId:(NSString*)mFoodLogDailyId
                          FoodLogID:(NSString*)mFoodLogId
                          AuthToken:(NSString*)mAuthToken
                       SessionToken:(NSString*)mSessionToken
{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  DELETELOGFOOD;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@/%@/%@", MEALPLANTEXT,mDate,mFoodLogDailyId,mFoodLogId];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [mAppDelegate_.mWebEngine_ makeDELETERequestWithUrl:mRequestURL
                                          withAuthToken:mAuthToken
                                       withSessionToken:mSessionToken];
}
//Upload photo
- (void)postRequestForUploadPhoto:(NSString*)mDate
                         MealName:(NSString*)mMeal
                         FoodName:(NSString*)mFoodName
                         Calories:(NSString*)mCalory
                            Image:(UIImage*)mImage
                        AuthToken:(NSString*)mAuthToken
                     SessionToken:(NSString*)mSessionToken
{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  ADDPHOTOFOOD;
    NSString *mRequestURL=WEBSERVICEURL;
    
    mRequestURL = [mRequestURL stringByAppendingFormat:@"Mealplan/Photo/%@/%@?foodName=%@&calories=%@",mDate,mMeal,mFoodName,mCalory];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [mAppDelegate_.mWebEngine_ makeRequestWithUrlForUploadPhoto:mRequestURL withData:UIImageJPEGRepresentation(mImage, 0.7) withAuthToken:mAuthToken withSessionToken:mSessionToken];   
}


- (void)postRequestForFoodAdd:(NSString*)mDate
                     MealType:(NSString*)mType
                       FoodID:(NSString*)mFoodId
                     Quantity:(NSString*)mQty
                       UnitID:(NSString*)mUnitID
                    AuthToken:(NSString*)mAuthToken
                 SessionToken:(NSString*)mSessionToken
{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  ADDGFOOD;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@/%@?foodID=%@&Qty=%@&unitID=%@", MEALPLANTEXT,mDate,mType,mFoodId,mQty,mUnitID];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [mAppDelegate_.mWebEngine_ makePOSTRequestWithUrl:mRequestURL withAuthToken:mAuthToken withSessionToken:mSessionToken];
}
- (void)postRequestForSearchFood:(NSString*)mSearchText
                       AuthToken:(NSString*)mAuthToken
                    SessionToken:(NSString*)mSessionToken
{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  SEARCHGFOOD;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@?SearchTerm=%@", FOODTEXT,mSearchText];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [mAppDelegate_.mWebEngine_ makeGETwithHeaderBodyRequestWithUrl:mRequestURL
                                       withAuthToken:mAuthToken
                                    withSessionToken:mSessionToken];

}
- (void)postRequestToGetFoodInfo:(NSString*)mFoodId
                       AuthToken:(NSString*)mAuthToken
                    SessionToken:(NSString*)mSessionToken
{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  FOODINFO;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@", FOODTEXT,mFoodId];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [mAppDelegate_.mWebEngine_ makeGETwithHeaderBodyRequestWithUrl:mRequestURL
                                                     withAuthToken:mAuthToken
                                                  withSessionToken:mSessionToken];

}
//Save Private Food
- (void)postRequestToSavePrivateFood:(NSString*)body withAuthToken:(NSString*)mAuthToken
                        SessionToken:(NSString*)mSessionToken
{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  SAVEPRIVATEFOOD;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/Privates", FOODTEXT];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [mAppDelegate_.mWebEngine_ makePOSTRequestWithUrl:mRequestURL withBody:body withAuthToken:mAuthToken withSessionToken:mSessionToken];
}

- (void)postRequestToGetPrivateFoods:(NSString*)mAuthToken
                        SessionToken:(NSString*)mSessionToken
{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  GETPRIVATEFOODS;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/Privates", FOODTEXT];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [mAppDelegate_.mWebEngine_ makeGETwithHeaderBodyRequestWithUrl:mRequestURL
                                                     withAuthToken:mAuthToken
                                                  withSessionToken:mSessionToken];
}
- (void)postRequestToGetAvailableDTGMeals:(NSString*)mDate
                            MealType:(NSString*)mMealType
                            withAuthToken:(NSString*)mAuthToken
                        SessionToken:(NSString*)mSessionToken
{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  GETDTGMEALS;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@/%@/Swap", MEALPLANTEXT,mDate,mMealType];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [mAppDelegate_.mWebEngine_ makeGETwithHeaderBodyRequestWithUrl:mRequestURL
                                                     withAuthToken:mAuthToken
                                                  withSessionToken:mSessionToken];
}

- (void)postRequestToGetRecentFoods:(NSString*)mMealtype
                      withAuthToken:(NSString*)mAuthToken
                          SessionToken:(NSString*)mSessionToken
{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  GETRECENTFOODS;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"Food/recent/%@",mMealtype];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [mAppDelegate_.mWebEngine_ makeGETwithHeaderBodyRequestWithUrl:mRequestURL
                                                     withAuthToken:mAuthToken
                                                  withSessionToken:mSessionToken];
}
//Get Food Units
- (void)postRequestToGetFoodUnits:(NSString*)mAuthToken
                       SessionToken:(NSString*)mSessionToken
{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  GETFOODUNITS;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"Food/Privates/Units"];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [mAppDelegate_.mWebEngine_ makeGETwithHeaderBodyRequestWithUrl:mRequestURL
                                                     withAuthToken:mAuthToken
                                                  withSessionToken:mSessionToken];
}
- (void)postRequestToGetFavoritesFoods:(NSString*)mAuthToken
                          SessionToken:(NSString*)mSessionToken
{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  GETFAVORITEFOODS;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/Favorites", FOODTEXT];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [mAppDelegate_.mWebEngine_ makeGETwithHeaderBodyRequestWithUrl:mRequestURL
                                                     withAuthToken:mAuthToken
                                                  withSessionToken:mSessionToken];
}
- (void)postRequestToAddFoodToFavorites:(NSString*)mFoodId
                               Quantity:(NSString*)mQty
                                 UnitID:(NSString*)mUnitID
                              AuthToken:(NSString*)mAuthToken
                           SessionToken:(NSString*)mSessionToken
{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  ADDFOODTOFAVORITEFOODS;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/Favorites?FoodID=%@&Qty=%@&UnitID=%@", @"food",mFoodId,mQty,mUnitID];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [mAppDelegate_.mWebEngine_ makePOSTRequestWithUrl:mRequestURL withAuthToken:mAuthToken withSessionToken:mSessionToken];
  /*  [mAppDelegate_.mWebEngine_ makePUTRequestWithUrl:mRequestURL
                                                     withAuthToken:mAuthToken
                                                  withSessionToken:mSessionToken];*/

}
- (void)postRequestToRemoveFoodToFavorites:(NSString*)mFoodId
                                 AuthToken:(NSString*)mAuthToken
                              SessionToken:(NSString*)mSessionToken
{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  REMOVEFOODFROMFAVORITEFOODS;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/Favorites?FoodID=%@", @"food",mFoodId];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [mAppDelegate_.mWebEngine_ makeDELETERequestWithUrl:mRequestURL
                                       withAuthToken:mAuthToken
                                    withSessionToken:mSessionToken];
}
- (void)postRequestToGetLookUp:(NSString*)mType
                     AuthToken:(NSString*)mAuthToken
                  SessionToken:(NSString*)mSessionToken
{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  mType;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"Info/Lookup/%@", mType] ;
    // [mRequestURL stringByAppendingFormat:@"Info/Lookups?Type=%@", mType]
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [mAppDelegate_.mWebEngine_ makeGETwithHeaderBodyRequestWithUrl:mRequestURL
                                          withAuthToken:mAuthToken
                                       withSessionToken:mSessionToken];
}
- (void)postRequestToGetMeals:(NSString*)mDate
                         Meal:(NSString*)mMeal
                    AuthToken:(NSString*)mAuthToken
                 SessionToken:(NSString*)mSessionToken
{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  GETMEALS;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@/%@/%@", MEALPLANTEXT,mDate, mMeal,SWAPTEXT];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [mAppDelegate_.mWebEngine_ makeGETwithHeaderBodyRequestWithUrl:mRequestURL
                                                     withAuthToken:mAuthToken
                                                  withSessionToken:mSessionToken];

}
- (void)postRequestToSwapMeal:(NSString*)mDate
                         Meal:(NSString*)mMeal
                       MealID:(NSString*)mMealId
                    AuthToken:(NSString*)mAuthToken
                 SessionToken:(NSString*)mSessionToken
{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  SWAPMEAL;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"MealPlan/%@/%@/Swap?MealID=%@", mDate, mMeal, mMealId];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [mAppDelegate_.mWebEngine_ makePUTRequestWithUrl:mRequestURL
                                        withAuthToken:mAuthToken
                                     withSessionToken:mSessionToken];
}
- (void)postRequestToLogout:(NSString*)mAuthToken
               SessionToken:(NSString*)mSessionToken
{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  LOGOUT;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"Account/%@", LOGOUT];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
   
    NSString *cookieValue = [[NSUserDefaults standardUserDefaults] valueForKey:DTGDevSession_Token];
    NSString *body = [NSString stringWithFormat:@"Cookie=%@",[self encodeToPercentEscapeString:cookieValue]];
   // [mAppDelegate_.mWebEngine_ makePOSTRequestWithUrl:mRequestURL withBody:body];
    [mAppDelegate_.mWebEngine_ makePOSTRequestWithUrl:mRequestURL
                                             withBody:body withAuthToken:mAuthToken withSessionToken:mSessionToken];
}
- (void)postRequestToGetDayWeight:(NSString*)mDate
                        AuthToken:(NSString*)mAuthToken
                     SessionToken:(NSString*)mSessionToken
{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  GetDayWeight;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@/%@", TrackersTXT, WeightTxt, mDate];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [mAppDelegate_.mWebEngine_ makeGETwithHeaderBodyRequestWithUrl:mRequestURL
                                                     withAuthToken:mAuthToken
                                                  withSessionToken:mSessionToken];
}
- (void)postRequestToGetWeightLogs:(NSString*)mAuthToken
                      SessionToken:(NSString*)mSessionToken{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  GetWeightLogs;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@", TrackersTXT, WeightTxt];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [mAppDelegate_.mWebEngine_ makeGETwithHeaderBodyRequestWithUrl:mRequestURL
                                                     withAuthToken:mAuthToken
                                                  withSessionToken:mSessionToken];
}
- (void)postRequestToGetWeightChartData:(NSString*)mRange
                              AuthToken:(NSString*)mAuthToken
                           SessionToken:(NSString*)mSessionToken
{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  GetWeightChartData;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@/%@", TrackersTXT, WeightTxt, mRange];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [mAppDelegate_.mWebEngine_ makeGETwithHeaderBodyRequestWithUrl:mRequestURL
                                                     withAuthToken:mAuthToken
                                                  withSessionToken:mSessionToken];
}
- (void)postRequestToAddWeightLog:(NSString*)mDate
                           Weight:(NSString*)mweight
                            Notes:(NSString*)mNotes
                        AuthToken:(NSString*)mAuthToken
                     SessionToken:(NSString*)mSessionToken
{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  AddWeightLog;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@", TrackersTXT, WeightTxt];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *body = [NSString stringWithFormat:@"StartDate=%@&Weight=%@&Notes=%@",mDate, mweight, mNotes];

    [mAppDelegate_.mWebEngine_ makePOSTRequestWithUrl:mRequestURL withBody:body withAuthToken:mAuthToken withSessionToken:mSessionToken];
   /*[mAppDelegate_.mWebEngine_ makePUTwithHeaderBodyRequestWithUrl:mRequestURL
                                                          withBody:body withAuthToken:mAuthToken
                                                  withSessionToken:mSessionToken];*/
}
- (void)postRequestToDeleteWeightLog:(NSString*)mId
                           AuthToken:(NSString*)mAuthToken
                        SessionToken:(NSString*)mSessionToken
{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  DeleteWeightLog;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@/%@", TrackersTXT, WeightTxt, mId];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [mAppDelegate_.mWebEngine_ makeDELETERequestWithUrl:mRequestURL
                                          withAuthToken:mAuthToken
                                       withSessionToken:mSessionToken];
}
- (void)postRequestToGetWaterLogs:(NSString *)mAuthToken
                          SessionToken:(NSString*)mSessionToken
{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  GetWaterLogs;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@", TrackersTXT, WaterTxt];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [mAppDelegate_.mWebEngine_ makeGETwithHeaderBodyRequestWithUrl:mRequestURL
                                                     withAuthToken:mAuthToken
                                                  withSessionToken:mSessionToken];
}
- (void)postRequestToGetDayMeasurement:(NSString*)mDate
                             AuthToken:(NSString*)mAuthToken
                          SessionToken:(NSString*)mSessionToken{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  GetDayMeasurement;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@/%@", TrackersTXT, MeasurementTXT, mDate];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [mAppDelegate_.mWebEngine_ makeGETwithHeaderBodyRequestWithUrl:mRequestURL
                                                     withAuthToken:mAuthToken
                                                  withSessionToken:mSessionToken];
}
- (void)postRequestToGetMeasurementLogs:(NSString*)mAuthToken
                           SessionToken:(NSString*)mSessionToken
{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  GetMeasurementLogs;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@", TrackersTXT, MeasurementTXT];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [mAppDelegate_.mWebEngine_ makeGETwithHeaderBodyRequestWithUrl:mRequestURL
                                                     withAuthToken:mAuthToken
                                                  withSessionToken:mSessionToken];
}
- (void)postRequestToAddMeasurementLog:(NSString*)mDate
                                  Arms:(NSString*)mArms
                                 Chest:(NSString*)mChest
                                 Waist:(NSString*)mWaist
                                  Hips:(NSString*)mHips
                                Thighs:(NSString*)mThighs
                                 Notes:(NSString*)mNotes
                             AuthToken:(NSString*)mAuthToken
                          SessionToken:(NSString*)mSessionToken
{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  AddMeasurementLog;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@", TrackersTXT, MeasurementTXT];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *body = [NSString stringWithFormat:@"StartDate=%@&Arms=%@&Chest=%@&Waist=%@&Hips=%@&Thighs=%@&Notes=%@", mDate,mArms, mChest, mWaist, mHips, mThighs, mNotes];
    
   /* [mAppDelegate_.mWebEngine_ makePUTwithHeaderBodyRequestWithUrl:mRequestURL
                                                          withBody:body
                                                     withAuthToken:mAuthToken
                                                  withSessionToken:mSessionToken];*/
    [mAppDelegate_.mWebEngine_ makePOSTRequestWithUrl:mRequestURL withBody:body withAuthToken:mAuthToken withSessionToken:mSessionToken];

}
- (void)postRequestToGetMeasurementChartData:(NSString*)mRange
                                   AuthToken:(NSString*)mAuthToken
                                SessionToken:(NSString*)mSessionToken
{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  GetMeasurementChartData;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@/%@", TrackersTXT, MeasurementTXT, mRange];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [mAppDelegate_.mWebEngine_ makeGETwithHeaderBodyRequestWithUrl:mRequestURL
                                                     withAuthToken:mAuthToken
                                                  withSessionToken:mSessionToken];
}
- (void)postRequestToDeleteMeasurementLog:(NSString*)mId
                                AuthToken:(NSString*)mAuthToken
                             SessionToken:(NSString*)mSessionToken{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  DeleteMeasurementLog;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@/%@", TrackersTXT, MeasurementTXT, mId];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [mAppDelegate_.mWebEngine_ makeDELETERequestWithUrl:mRequestURL
                                          withAuthToken:mAuthToken
                                       withSessionToken:mSessionToken];
}
- (void)postRequestToGetExerciseLogs:(NSString *)mAuthToken
                        SessionToken:(NSString*)mSessionToken
{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  GetExerciseLogs;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@", TrackersTXT, ExerciseTXT];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [mAppDelegate_.mWebEngine_ makeGETwithHeaderBodyRequestWithUrl:mRequestURL
                                                     withAuthToken:mAuthToken
                                                  withSessionToken:mSessionToken];

}
- (void)postRequestToGetDayExercise:(NSString*)mDate
                          AuthToken:(NSString*)mAuthToken
                       SessionToken:(NSString*)mSessionToken
{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  GetDayExercise;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@/%@", TrackersTXT, ExerciseTXT, mDate];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [mAppDelegate_.mWebEngine_ makeGETwithHeaderBodyRequestWithUrl:mRequestURL
                                                     withAuthToken:mAuthToken
                                                  withSessionToken:mSessionToken];
}
- (void)postRequestToGetExerciseChartData:(NSString*)mRange
                                AuthToken:(NSString*)mAuthToken
                             SessionToken:(NSString*)mSessionToken
{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  GetExerciseChartData;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@/%@", TrackersTXT, ExerciseTXT, mRange];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [mAppDelegate_.mWebEngine_ makeGETwithHeaderBodyRequestWithUrl:mRequestURL
                                                     withAuthToken:mAuthToken
                                                  withSessionToken:mSessionToken];

}
- (void)postRequestToDeleteExerciseLog:(NSString*)mId
                             AuthToken:(NSString*)mAuthToken
                          SessionToken:(NSString*)mSessionToken{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  DeleteExerciseLog;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@/%@", TrackersTXT, ExerciseTXT, mId];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [mAppDelegate_.mWebEngine_ makeDELETERequestWithUrl:mRequestURL
                                          withAuthToken:mAuthToken
                                       withSessionToken:mSessionToken];

}
- (void)postRequestToAddExerciseLog:(NSString*)mDate
                           Activity:(NSString*)mActivity
                           Duration:(NSString*)mDuration
                           Calories:(NSString*)mCal
                              Notes:(NSString*)mNotes
                          LogSource:(NSString*)mLogSource
                          AuthToken:(NSString*)mAuthToken
                       SessionToken:(NSString*)mSessionToken{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  AddExerciseLog;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@", TrackersTXT, ExerciseTXT];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *body = [NSString stringWithFormat:@"StartDate=%@&ActivityLUT=%@&Duration=%@&Calories=%@&Notes=%@&LogSource=%@",mDate,mActivity, mDuration, mCal, mNotes,mLogSource];
    
    [mAppDelegate_.mWebEngine_ makePOSTRequestWithUrl:mRequestURL withBody:body withAuthToken:mAuthToken withSessionToken:mSessionToken];
    /*
    [mAppDelegate_.mWebEngine_ makePUTwithHeaderBodyRequestWithUrl:mRequestURL
                                                          withBody:body
                                                     withAuthToken:mAuthToken
                                                  withSessionToken:mSessionToken];*/

    
}
- (void)postRequestToGetUserCurrentWeight:(NSString*)mAuthToken
                             SessionToken:(NSString*)mSessionToken{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  GetCurrentWeight;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@/CurrentWeight", TrackersTXT, ExerciseTXT];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [mAppDelegate_.mWebEngine_ makeGETwithHeaderBodyRequestWithUrl:mRequestURL
                                                     withAuthToken:mAuthToken
                                                  withSessionToken:mSessionToken];

}
- (void)postRequestToGetExerciseActivities:(NSString*)mAuthToken
                              SessionToken:(NSString*)mSessionToken{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  GetActivities;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@/Activities", TrackersTXT, ExerciseTXT];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [mAppDelegate_.mWebEngine_ makeGETwithHeaderBodyRequestWithUrl:mRequestURL
                                                     withAuthToken:mAuthToken
                                                  withSessionToken:mSessionToken];
}
- (void)postRequestToGetGlucoseLogs:(NSString *)mAuthToken
                       SessionToken:(NSString*)mSessionToken{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  GetGlucoseLogs;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@", TrackersTXT, GlucoseTXT];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [mAppDelegate_.mWebEngine_ makeGETwithHeaderBodyRequestWithUrl:mRequestURL
                                                     withAuthToken:mAuthToken
                                                  withSessionToken:mSessionToken];

}
- (void)postRequestToGetDayGlucose:(NSString*)mDate
                         AuthToken:(NSString*)mAuthToken
                      SessionToken:(NSString*)mSessionToken{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  GetDayGlucose;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@/%@", TrackersTXT, GlucoseTXT, mDate];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [mAppDelegate_.mWebEngine_ makeGETwithHeaderBodyRequestWithUrl:mRequestURL
                                                     withAuthToken:mAuthToken
                                                  withSessionToken:mSessionToken];

}
- (void)postRequestToAddGlucoseLog:(NSString*)mDate
                           Glucose:(NSString*)mGlucose
                             Notes:(NSString*)mNotes
                         AuthToken:(NSString*)mAuthToken
                      SessionToken:(NSString*)mSessionToken{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  AddGlucoseLog;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@", TrackersTXT, GlucoseTXT];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *body = [NSString stringWithFormat:@"Date=%@&BloodGlucose=%@&Notes=%@",mDate, mGlucose, mNotes];
    
    [mAppDelegate_.mWebEngine_ makePUTwithHeaderBodyRequestWithUrl:mRequestURL
                                                          withBody:body
                                                     withAuthToken:mAuthToken
                                                  withSessionToken:mSessionToken];
    
}
- (void)postRequestToGetGlucoseChartData:(NSString*)mRange
                               AuthToken:(NSString*)mAuthToken
                            SessionToken:(NSString*)mSessionToken{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  GetGlucoseChartData;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@/%@", TrackersTXT, GlucoseTXT, mRange];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [mAppDelegate_.mWebEngine_ makeGETwithHeaderBodyRequestWithUrl:mRequestURL
                                                     withAuthToken:mAuthToken
                                                  withSessionToken:mSessionToken];
    
}
- (void)postRequestToDeleteGlucoseLog:(NSString*)mId
                            AuthToken:(NSString*)mAuthToken
                         SessionToken:(NSString*)mSessionToken{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  DeleteGlucoseLog;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@/%@", TrackersTXT, GlucoseTXT, mId];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [mAppDelegate_.mWebEngine_ makeDELETERequestWithUrl:mRequestURL
                                          withAuthToken:mAuthToken
                                       withSessionToken:mSessionToken];
    
}
- (void)postRequestToGetJournalLogs:(NSString *)mAuthToken
                       SessionToken:(NSString*)mSessionToken{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  GetJournalLogs;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@",  JournalTXT];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [mAppDelegate_.mWebEngine_ makeGETwithHeaderBodyRequestWithUrl:mRequestURL
                                                     withAuthToken:mAuthToken
                                                  withSessionToken:mSessionToken];
}
- (void)postRequestToAddJournalLog:(NSString*)mDate
                          Category:(NSString*)mCat
                             Notes:(NSString*)mNotes
                         AuthToken:(NSString*)mAuthToken
                      SessionToken:(NSString*)mSessionToken{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  AddJournalLog;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@",  JournalTXT];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *body = [NSString stringWithFormat:@"Date=%@&JournalCategory=%@&Notes=%@",mDate, mCat, mNotes];
    
    [mAppDelegate_.mWebEngine_ makePUTwithHeaderBodyRequestWithUrl:mRequestURL
                                                          withBody:body
                                                     withAuthToken:mAuthToken
                                                  withSessionToken:mSessionToken];
}
- (void)postRequestToDeleteJournalLog:(NSString*)mId
                            AuthToken:(NSString*)mAuthToken
                         SessionToken:(NSString*)mSessionToken{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  DeleteJournalLog;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@", JournalTXT, mId];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [mAppDelegate_.mWebEngine_ makeDELETERequestWithUrl:mRequestURL
                                          withAuthToken:mAuthToken
                                       withSessionToken:mSessionToken];
}
- (void)postRequestToGetCholesterolLogs:(NSString *)mAuthToken
                           SessionToken:(NSString*)mSessionToken{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  GetCholesterolLogs;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@",  TrackersTXT, CholesterolTXT];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [mAppDelegate_.mWebEngine_ makeGETwithHeaderBodyRequestWithUrl:mRequestURL
                                                     withAuthToken:mAuthToken
                                                  withSessionToken:mSessionToken];
}
- (void)postRequestToAddCholesterolLog:(NSString*)mDate
                      TotalCholesterol:(NSString*)mCholesterol
                        LDLCholesterol:(NSString*)mLDL
                        HDLCholesterol:(NSString*)mHDL
                                 Notes:(NSString*)mNotes
                             AuthToken:(NSString*)mAuthToken
                          SessionToken:(NSString*)mSessionToken{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  AddCholesterolLog;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@", TrackersTXT, CholesterolTXT];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *body = [NSString stringWithFormat:@"Date=%@&TotalCholesterol=%@&LDLCholesterol=%@&HDLCholesterol=%@&Notes=%@", mDate, mCholesterol, mLDL, mHDL, mNotes];
    
    [mAppDelegate_.mWebEngine_ makePUTwithHeaderBodyRequestWithUrl:mRequestURL
                                                          withBody:body
                                                     withAuthToken:mAuthToken
                                                  withSessionToken:mSessionToken];

}
- (void)postRequestToDeleteCholesterolLog:(NSString*)mId
                                AuthToken:(NSString*)mAuthToken
                             SessionToken:(NSString*)mSessionToken{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  DeleteCholesterolLog;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@/%@",TrackersTXT, CholesterolTXT, mId];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [mAppDelegate_.mWebEngine_ makeDELETERequestWithUrl:mRequestURL
                                          withAuthToken:mAuthToken
                                       withSessionToken:mSessionToken];

}
- (void)postRequestToGetCholesterolChartData:(NSString*)mRange
                                   AuthToken:(NSString*)mAuthToken
                                SessionToken:(NSString*)mSessionToken{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  GetCholesterolChartData;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@/%@",TrackersTXT, CholesterolTXT, mRange];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [mAppDelegate_.mWebEngine_ makeGETwithHeaderBodyRequestWithUrl:mRequestURL
                                          withAuthToken:mAuthToken
                                       withSessionToken:mSessionToken];

}
- (void)postRequestToGetBMILogs:(NSString *)mAuthToken
                   SessionToken:(NSString*)mSessionToken{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  GetBMILogs;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@",  TrackersTXT, BMITXT];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [mAppDelegate_.mWebEngine_ makeGETwithHeaderBodyRequestWithUrl:mRequestURL
                                                     withAuthToken:mAuthToken
                                                  withSessionToken:mSessionToken];
}
- (void)postRequestToGetDayBMI:(NSString*)mDate
                     AuthToken:(NSString*)mAuthToken
                  SessionToken:(NSString*)mSessionToken{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  GetDayBMI;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@/%@", TrackersTXT, BMITXT, mDate];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [mAppDelegate_.mWebEngine_ makeGETwithHeaderBodyRequestWithUrl:mRequestURL
                                                     withAuthToken:mAuthToken
                                                  withSessionToken:mSessionToken];

}
- (void)postRequestToAddBMILog:(NSString*)mDate
                      HeightFt:(NSString*)mHeightFt
                   HeightInchs:(NSString*)mHeightInch
                        Weight:(NSString*)mWeight
                         Notes:(NSString*)mNotes
                     AuthToken:(NSString*)mAuthToken
                  SessionToken:(NSString*)mSessionToken{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  AddBMILog;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@", TrackersTXT, BMITXT];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *body = [NSString stringWithFormat:@"Date=%@&HeightFt=%@&HeightInch=%@&Weight=%@&Notes=%@", mDate, mHeightFt, mHeightInch, mWeight, mNotes];
    
    [mAppDelegate_.mWebEngine_ makePUTwithHeaderBodyRequestWithUrl:mRequestURL
                                                          withBody:body
                                                     withAuthToken:mAuthToken
                                                  withSessionToken:mSessionToken];
}
- (void)postRequestToGetBMIChartData:(NSString*)mRange
                           AuthToken:(NSString*)mAuthToken
                        SessionToken:(NSString*)mSessionToken{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  GetBMIChartData;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@/%@", TrackersTXT, BMITXT, mRange];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [mAppDelegate_.mWebEngine_ makeGETwithHeaderBodyRequestWithUrl:mRequestURL
                                                     withAuthToken:mAuthToken
                                                  withSessionToken:mSessionToken];
}
- (void)postRequestToDeleteBMIGlucoseLog:(NSString*)mId
                               AuthToken:(NSString*)mAuthToken
                            SessionToken:(NSString*)mSessionToken{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  DeleteBMILog;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@/%@",TrackersTXT, BMITXT, mId];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [mAppDelegate_.mWebEngine_ makeDELETERequestWithUrl:mRequestURL
                                          withAuthToken:mAuthToken
                                       withSessionToken:mSessionToken];

}
- (void)postRequestToGetGoalsForDashboard:(NSString*)mAuthToken
                             SessionToken:(NSString*)mSessionToken{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  GetDashboardGoals;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/Dashboard",GoalTxt];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [mAppDelegate_.mWebEngine_ makeGETwithHeaderBodyRequestWithUrl:mRequestURL
                                                     withAuthToken:mAuthToken
                                                  withSessionToken:mSessionToken];
}
- (void)postRequestToGetGoalSteps:(NSString*)mAuthToken
                     SessionToken:(NSString*)mSessionToken{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  GetGoalSteps;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/Steps",GoalTxt];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [mAppDelegate_.mWebEngine_ makeGETwithHeaderBodyRequestWithUrl:mRequestURL
                                                     withAuthToken:mAuthToken
                                                  withSessionToken:mSessionToken];
}
- (void)postRequestToGetGoalChartData:(NSString*)mStep
                                Range:(NSString*)mRange
                            AuthToken:(NSString*)mAuthToken
                         SessionToken:(NSString*)mSessionToken{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  GetGoalChartData;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@/%@", GoalTxt, mStep, mRange];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [mAppDelegate_.mWebEngine_ makeGETwithHeaderBodyRequestWithUrl:mRequestURL
                                                     withAuthToken:mAuthToken
                                                  withSessionToken:mSessionToken];
}
- (void)postRequestToGetGoalStepProgress:(NSString*)mUserStepId
                                    Date:(NSString*)mDate
                               AuthToken:(NSString*)mAuthToken
                            SessionToken:(NSString*)mSessionToken{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  GetStepProgress;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@/%@", GoalTxt, mUserStepId, mDate];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [mAppDelegate_.mWebEngine_ makeGETwithHeaderBodyRequestWithUrl:mRequestURL
                                                     withAuthToken:mAuthToken
                                                  withSessionToken:mSessionToken];

}
- (void)postRequestToGetGoalLogs:(NSString *)mAuthToken
                    SessionToken:(NSString*)mSessionToken{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  GetGoalLogs;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@",  GoalTxt];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [mAppDelegate_.mWebEngine_ makeGETwithHeaderBodyRequestWithUrl:mRequestURL
                                                     withAuthToken:mAuthToken
                                                  withSessionToken:mSessionToken];

}
- (void)postRequestToAddGoal:(NSString*)mDate
                      StepID:(NSString*)mStep
                  UserStepID:(NSString*)mUserStepId
                       Value:(NSString*)mValue
                       Notes:(NSString*)mNotes
                   AuthToken:(NSString*)mAuthToken
                SessionToken:(NSString*)mSessionToken{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  AddGoal;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@/%@", GoalTxt, mStep, mUserStepId];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *body = [NSString stringWithFormat:@"Date=%@&Value=%@&Notes=%@", mDate,mValue, mNotes];

    [mAppDelegate_.mWebEngine_ makePUTwithHeaderBodyRequestWithUrl:mRequestURL
                                                          withBody:body
                                                     withAuthToken:mAuthToken
                                                  withSessionToken:mSessionToken];
    
}
- (void)postRequestToDeleteGoal:(NSString*)mId
                      AuthToken:(NSString*)mAuthToken
                   SessionToken:(NSString*)mSessionToken{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  DeleteGoal;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@",GoalTxt, mId];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [mAppDelegate_.mWebEngine_ makeDELETERequestWithUrl:mRequestURL
                                          withAuthToken:mAuthToken
                                       withSessionToken:mSessionToken];
}
- (void)postRequestToGetStepLogs:(NSString *)mAuthToken
                    SessionToken:(NSString*)mSessionToken{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  GetStepLogs;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@",  TrackersTXT, StepsTxt];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [mAppDelegate_.mWebEngine_ makeGETwithHeaderBodyRequestWithUrl:mRequestURL
                                                     withAuthToken:mAuthToken
                                                  withSessionToken:mSessionToken];
}
- (void)postRequestToGetDayStep:(NSString*)mDate
                      AuthToken:(NSString*)mAuthToken
                   SessionToken:(NSString*)mSessionToken{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  GetDaySteps;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@/%@", TrackersTXT, StepsTxt, mDate];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [mAppDelegate_.mWebEngine_ makeGETwithHeaderBodyRequestWithUrl:mRequestURL
                                                     withAuthToken:mAuthToken
                                                  withSessionToken:mSessionToken];
    

}
- (void)postRequestToAddStepLog:(NSString*)mDate
                          Steps:(NSString*)mSteps
                          Notes:(NSString*)mNotes
                      LogSource:(NSString*)mLogSource
                      AuthToken:(NSString*)mAuthToken
                   SessionToken:(NSString*)mSessionToken{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  AddStepLog;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@", TrackersTXT, StepsTxt];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *body = [NSString stringWithFormat:@"StartDate=%@&Steps=%@&Notes=%@&LogSource=%@", mDate, mSteps, mNotes,mLogSource];
    
    [mAppDelegate_.mWebEngine_ makePOSTRequestWithUrl:mRequestURL withBody:body withAuthToken:mAuthToken withSessionToken:mSessionToken];
   /* [mAppDelegate_.mWebEngine_ makePUTwithHeaderBodyRequestWithUrl:mRequestURL
                                                          withBody:body
                                                     withAuthToken:mAuthToken
                                                  withSessionToken:mSessionToken];*/
}
- (void)postRequestToGetStepChartData:(NSString*)mRange
                            AuthToken:(NSString*)mAuthToken
                         SessionToken:(NSString*)mSessionToken{
    
    mAppDelegate_.mWebEngine_.mWebMethodName_=  GetStepChartData;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@/%@", TrackersTXT, StepsTxt, mRange];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [mAppDelegate_.mWebEngine_ makeGETwithHeaderBodyRequestWithUrl:mRequestURL
                                                     withAuthToken:mAuthToken
                                                  withSessionToken:mSessionToken];

}
- (void)postRequestToDeleteStepLog:(NSString*)mId
                         AuthToken:(NSString*)mAuthToken
                      SessionToken:(NSString*)mSessionToken{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  DeleteStepLog;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@/%@",TrackersTXT, StepsTxt, mId];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [mAppDelegate_.mWebEngine_ makeDELETERequestWithUrl:mRequestURL
                                          withAuthToken:mAuthToken
                                       withSessionToken:mSessionToken];
}
- (void)postRequestToGetTrackerGoals:(NSString*)mAuthToken
                        SessionToken:(NSString*)mSessionToken{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  GetTrackerGoals;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@",SETTINGS, GoalTxt];
    //[mRequestURL stringByAppendingFormat:@"%@/%@",SETTINGS, TrackersTXT];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [mAppDelegate_.mWebEngine_ makeGETwithHeaderBodyRequestWithUrl:mRequestURL
                                          withAuthToken:mAuthToken
                                       withSessionToken:mSessionToken];
}
- (void)postRequestToGetNotifications:(NSString*)mID
                            AuthToken:(NSString*)mAuthToken
                         SessionToken:(NSString*)mSessionToken{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  GetNotifications;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/Notifications/%@",SETTINGS, mID];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [mAppDelegate_.mWebEngine_ makeGETwithHeaderBodyRequestWithUrl:mRequestURL
                                                     withAuthToken:mAuthToken
                                                  withSessionToken:mSessionToken];

}
- (void)postRequestToSaveNotifications:(NSString*)mID
                               Message:(NSString*)mCoachMessages
                                  Goal:(NSString*)mGoalReached
                                 Daily:(NSString*)mDailyReminder
                                Weekly:(NSString*)mWeeklyReminder
                             AuthToken:(NSString*)mAuthToken
                          SessionToken:(NSString*)mSessionToken{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  SaveNotifications;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/Notifications/%@",SETTINGS, mID];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *body = [NSString stringWithFormat:@"CoachMessages=%@&GoalReached=%@&DailyReminder=%@&WeeklyReminder=%@", mCoachMessages, mGoalReached, mDailyReminder, mWeeklyReminder];
    [mAppDelegate_.mWebEngine_ makePOSTRequestWithUrl:mRequestURL
                                             withBody:body
                                        withAuthToken:mAuthToken
                                     withSessionToken:mSessionToken];
    
}
- (void)postRequestToGetMessagesList:(NSString*)mFolder
                                Page:(NSString*)mNum
                          UnreadOnly:(NSString*)mFlag
                           AuthToken:(NSString*)mAuthToken
                        SessionToken:(NSString*)mSessionToken{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  GetMessagesList;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@?page=%@&unreadOnly=%@",MessagesTXT, mFolder, mNum, mFlag];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [mAppDelegate_.mWebEngine_ makeGETwithHeaderBodyRequestWithUrl:mRequestURL
                                                     withAuthToken:mAuthToken
                                                  withSessionToken:mSessionToken];
}
- (void)postRequestToGetMessageThread:(NSString*)mID
                            AuthToken:(NSString*)mAuthToken
                         SessionToken:(NSString*)mSessionToken{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  GetMessage;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@",MessagesTXT, mID];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [mAppDelegate_.mWebEngine_ makeGETwithHeaderBodyRequestWithUrl:mRequestURL
                                                     withAuthToken:mAuthToken
                                                  withSessionToken:mSessionToken];
}
- (void)postRequestToArchiveMessage:(NSString*)mID
                             AuthToken:(NSString*)mAuthToken
                          SessionToken:(NSString*)mSessionToken{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  ArchiveMessage;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@?messageID=%@",MessagesTXT, mID];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [mAppDelegate_.mWebEngine_ makePOSTRequestWithUrl:mRequestURL
                                        withAuthToken:mAuthToken
                                     withSessionToken:mSessionToken];
}
- (void)postRequestToDeleteMessage:(NSString*)mID
                         AuthToken:(NSString*)mAuthToken
                      SessionToken:(NSString*)mSessionToken
{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  DeleteMessage;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@?messageID=%@",MessagesTXT, mID];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [mAppDelegate_.mWebEngine_ makeDELETERequestWithUrl:mRequestURL
                                        withAuthToken:mAuthToken
                                     withSessionToken:mSessionToken];

}
- (void)postRequestToReplyToMessage:(NSString*)mRecipentID
                               Type:(NSString*)mType
                            Subject:(NSString*)mSubject
                               Body:(NSString*)mBody
                          AuthToken:(NSString*)mAuthToken
                       SessionToken:(NSString*)mSessionToken{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  ReplyMessage;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@",MessagesTXT];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *body = [NSString stringWithFormat:@"To=%@&Type=%@&Subject=%@&Body=%@", mRecipentID, mType, mSubject, mBody];
    [mAppDelegate_.mWebEngine_ makePUTwithHeaderBodyRequestWithUrl:mRequestURL
                                                          withBody:body
                                                     withAuthToken:mAuthToken
                                                  withSessionToken:mSessionToken];


}
- (void)postRequestToCheckRecipent:(NSString*)mRecipentName
                         AuthToken:(NSString*)mAuthToken
                      SessionToken:(NSString*)mSessionToken{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  CheckRecipent;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/CheckRecipient?Recipient=%@",MessagesTXT, mRecipentName];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [mAppDelegate_.mWebEngine_ makeGETwithHeaderBodyRequestWithUrl:mRequestURL
                                                     withAuthToken:mAuthToken
                                                  withSessionToken:mSessionToken];

}
- (void)postRequestToSendNewMessage:(NSString*)mRecipentID
                               Type:(NSString*)mType
                            Subject:(NSString*)mSubject
                               Body:(NSString*)mBody
                          AuthToken:(NSString*)mAuthToken
                       SessionToken:(NSString*)mSessionToken{
    mAppDelegate_.mWebEngine_.mWebMethodName_=  SendNewMessage;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@",MessagesTXT];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *body = [NSString stringWithFormat:@"To=%@&Type=%@&Subject=%@&Body=%@", mRecipentID, mType, mSubject, mBody];
    [mAppDelegate_.mWebEngine_ makePUTwithHeaderBodyRequestWithUrl:mRequestURL
                                                          withBody:body
                                                     withAuthToken:mAuthToken
                                                  withSessionToken:mSessionToken];

    
}
#pragma mark - Demo Meal Plans
-(void)postRequestTogetDemoMealPlan:(NSString *)mAuthToken
                 SessionToken:(NSString*)mSessionToken {
    
    mAppDelegate_.mWebEngine_.mWebMethodName_=  GETDEMOPLAN;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@", SETTINGS,DEMOPLANTXT];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [mAppDelegate_.mWebEngine_ makeGETwithHeaderBodyRequestWithUrl:mRequestURL
                                                     withAuthToken:mAuthToken
                                                  withSessionToken:mSessionToken];
    
}
#pragma mark - Discussion forums
-(void)postRequestForcategory:(NSString *)mAuthToken
                 SessionToken:(NSString*)mSessionToken {

    mAppDelegate_.mWebEngine_.mWebMethodName_=  GETCATEGORYDATA;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@", BOARDSTXT];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [mAppDelegate_.mWebEngine_ makeGETwithHeaderBodyRequestWithUrl:mRequestURL
                                                     withAuthToken:mAuthToken
                                                  withSessionToken:mSessionToken];

}

- (void)postRequestForforums:(NSString*)category
                   AuthToken:(NSString*)mAuthToken
                SessionToken:(NSString*)mSessionToken{
    
    mAppDelegate_.mWebEngine_.mWebMethodName_=  GETFORUMSINCATEGORY;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@", BOARDSTXT,category];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [mAppDelegate_.mWebEngine_ makeGETwithHeaderBodyRequestWithUrl:mRequestURL
                                                     withAuthToken:mAuthToken
                                                  withSessionToken:mSessionToken];
}

- (void)postRequestForThreads:(NSString*)category
                        forum:(NSString*)forumId
                         page:(NSString*)pageNo
                    AuthToken:(NSString*)mAuthToken
                 SessionToken:(NSString*)mSessionToken {
    mAppDelegate_.mWebEngine_.mWebMethodName_=  GETTHREADSINFORUM;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@/%@?page=%@", BOARDSTXT,category,forumId,pageNo];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [mAppDelegate_.mWebEngine_ makeGETwithHeaderBodyRequestWithUrl:mRequestURL
                                                     withAuthToken:mAuthToken
                                                  withSessionToken:mSessionToken];
}
//post reauest for posts
-(void)postRequestForPosts:(NSString*)category
                     forum:(NSString*)forumId
                    thread:(NSString*)threadId
                      page:(NSString*)pageNo
                 AuthToken:(NSString*)mAuthToken
              SessionToken:(NSString*)mSessionToken {
    
    mAppDelegate_.mWebEngine_.mWebMethodName_=  GETPOSTSINTHREADS;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@/%@/%@?page=%@", BOARDSTXT,category,forumId,threadId,pageNo];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [mAppDelegate_.mWebEngine_ makeGETwithHeaderBodyRequestWithUrl:mRequestURL
                                                     withAuthToken:mAuthToken
                                                  withSessionToken:mSessionToken];

}
//Add new thread
-(void)postRequestForAddNewThread:(NSString*)category
                            forum:(NSString*)forumId
                             Title:(NSString*)mTitle
                             Body:(NSString*)mBody
                        AuthToken:(NSString*)mAuthToken
                     SessionToken:(NSString*)mSessionToken {
    
    mAppDelegate_.mWebEngine_.mWebMethodName_=  ADDNEWTHREAD;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@/%@", BOARDSTXT,category,forumId];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *body = [NSString stringWithFormat:@"threadTitle=%@&postBody=%@",mTitle,mBody];
    [mAppDelegate_.mWebEngine_ makePOSTRequestWithUrl:mRequestURL
                                             withBody:body
                                        withAuthToken:mAuthToken
                                     withSessionToken:mSessionToken];
    
}

//Add new Post
-(void)postRequestForAddNewPost:(NSString*)category
                            forum:(NSString*)forumId
                            Thread:(NSString*)threadId
                             Body:(NSString*)mBody
                        AuthToken:(NSString*)mAuthToken
                   SessionToken:(NSString*)mSessionToken {
    
    mAppDelegate_.mWebEngine_.mWebMethodName_=  ADDPOSTTOTHREAD;
    NSString *mRequestURL=WEBSERVICEURL;
    mRequestURL = [mRequestURL stringByAppendingFormat:@"%@/%@/%@/%@", BOARDSTXT,category,forumId,threadId];
    mRequestURL = [mRequestURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    mRequestURL = [mRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString *body = [NSString stringWithFormat:@"postBody=%@",mBody];
    [mAppDelegate_.mWebEngine_ makePOSTRequestWithUrl:mRequestURL
                                             withBody:body
                                        withAuthToken:mAuthToken
                                     withSessionToken:mSessionToken];
}

@end
