//
//  MessagesDataGetter.h
//  EHEandme
//
//  Created by Divya Reddy on 06/01/14.
//  Copyright (c) 2014 EHEandme. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessagesDataGetter : NSObject{
    /**
     * AppDelegate object creating
     */
    AppDelegate *mAppDelegate_;
    
}
@property (nonatomic,retain) NSMutableDictionary *mMessagesListDict_, *mMessagesDetailDict_;
/**
 * Method used to initialize class
 */
- (id)init;
@end
