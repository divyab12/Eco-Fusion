	//
	//  WebEngine.h
	//	HPAC
	//  Copyright 2011 EHEandme. All rights reserved.
	//

#import <Foundation/Foundation.h>

typedef enum {
    WebDAVOKStatusCode = 200,
    WebDAVCreatedStatusCode = 201,
    WebDAVNoContentStatusCode = 204,
	WebDavListingStatusCode = 207,
    WebDAVUnauthorized = 401,
    WebDAVPaymentRequired = 402,
    WebDAVForbiddenStatusCode = 403,
    WebDAVNotFoundStatusCode = 404,
    WebDAVMethodNotAllowedStatusCode = 405,
    WebDAVConflictStatusCode = 409,
    HTTPNotImplementedErrorCode = 501,
} ResponseStatusCode;

@class AppDelegate;

@interface WebEngine : NSObject {
	
    /**
     * AppDelegate object creating
     */
	AppDelegate *_pAppDelegate;
        
@public
    
    /**
     * NSMutableData webData parameter
     */
	NSMutableData *webData;
}

@property(nonatomic,strong)NSString *mWebMethodName_;
@property(nonatomic) NSInteger mStatusCode;

/**
 * Method used to initialize class
 */
- (id)init;

/**
 * Method used to post GET request  
 * @param mReqStr_ for url to post request
 */
- (void)makeGETRequestWithUrl:(NSString*)mReqStr_;

/**
 * Method used to post POST request  
 * @param mReqStr_ for url to post request
 */
- (void)makePOSTRequestWithUrl:(NSString *)mReqStr_
                      withBody:(NSString*)body;
- (void)makePOSTRequestWithUrl:(NSString *)mReqStr_
                      withBody:(NSString*)body
                 withAuthToken:(NSString*)mAuthToken
              withSessionToken:(NSString*)mSessionToken;
/**
 * Method used to post POST request
 * @param mReqStr_ for url to post request
 * @param mAuthToken for the Authorization token in header
 * @param mSessionToken for the session token in header
 */

- (void)makePOSTRequestWithUrl:(NSString *)mReqStr_
                     withAuthToken:(NSString*)mAuthToken
              withSessionToken:(NSString*)mSessionToken;

- (void)makePOSTRequestWithUrlandReqData:(NSString *)mReqStr_
                                withData:(NSData*)bodyData
                           withAuthToken:(NSString*)mAuthToken
                        withSessionToken:(NSString*)mSessionToken;
/**
 * Method used to post request to upload photo
 * @param imagedata for the data of the image to be posted
 * @param mToken for the token
 */
- (void)makeRequestWithUrlForUploadPhoto:(NSString *)mReqStr_
                                withData:(NSData*)imageData
                           withAuthToken:(NSString*)mAuthToken_
                        withSessionToken:(NSString*)mToken_;

/**
 * Method used to post GET request with header
 * @param mReqStr_ for url to post request
 * @param body for the request body
 */
- (void)makeGETwithHeaderBodyRequestWithUrl:(NSString*)mReqStr_ 
                              withAuthToken:(NSString*)mAuthToken_
                            withSessionToken:(NSString*)mToken_;
/**
 * Method used to post Delete request with header
 * @param mReqStr_ for url to post request
 * @param body for the request body
 * @param mToken_ for the header field of the request
 */
- (void)makeDELETEwithHeaderBodyRequestWithUrl:(NSString*)mReqStr_
                                      withBody:(NSString*)body 
                                         Token:(NSString*)mToken_;
/**
 * Method used to post Delete request with header
 * @param mReqStr_ for url to post request
 * @param mAuthToken for the Authorization token in header
 * @param mSessionToken for the session token in header
 */
- (void)makeDELETERequestWithUrl:(NSString*)mReqStr_
                   withAuthToken:(NSString*)mAuthToken_
                withSessionToken:(NSString*)mToken_;
/**
 * Method used to post PUT request with header
 * @param mReqStr_ for url to post request
 * @param body for the request body
 * @param mAuthToken for the Authorization token in header
 * @param mSessionToken for the session token in header
 */
- (void)makePUTwithHeaderBodyRequestWithUrl:(NSString*)mReqStr_
                                   withBody:(NSString*)body 
                              withAuthToken:(NSString*)mAuthToken_
                           withSessionToken:(NSString*)mToken_;
/**
 * Method used to post PUT request with url
 * @param mReqStr_ for url to post request
 * @param mAuthToken_ for the authorization token
 * @param mToken_ for the session token
 */
- (void)makePUTRequestWithUrl:(NSString*)mReqStr_
                withAuthToken:(NSString*)mAuthToken_
             withSessionToken:(NSString*)mToken_;
@end
