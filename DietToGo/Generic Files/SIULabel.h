//
//  SIULabel.h
//  Miso
//
//  Created by Joshua Wu on 11/15/11.
//  Copyright (c) 2011 Miso. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    SIULabelVerticalAlignmentTop,
    SIULabelVerticalAlignmentMiddle,
    SIULabelVerticalAlignmentBottom
} SIULabelVerticalAlignment;

@interface SIULabel : UILabel 
{
    int _lineHeight;
}

@property (nonatomic, assign) int lineHeight;
@property (nonatomic, assign) SIULabelVerticalAlignment verticalAlignment;

@end
