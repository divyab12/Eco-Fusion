//
//  TransparentView.m
//  ServeItUp
//
//  Created by EHEandme on 5/30/13.
//  Copyright (c) 2013 valuelabs. All rights reserved.
//

#import "TransparentView.h"
#import <QuartzCore/QuartzCore.h>




@implementation TransparentView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor blackColor]];
        self.alpha = 0.7f;
    }
    return self;
}

@end
