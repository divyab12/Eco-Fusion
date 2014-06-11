//
//  Timeview.h
//  EHERD
//
//  Created by EHEandme on 11/30/13.
//  Copyright (c) 2013 valuelabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Timeview : UIView
-(id)initWithFrame:(CGRect)frame percentage:(float)percent;
-(void)changeViewPercentage:(float)percent;
@end
