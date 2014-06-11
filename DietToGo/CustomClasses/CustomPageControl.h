//
//  CustomPageControl.h
//  EHEandme
//
//  Created by Divya Reddy on 17/12/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@interface CustomPageControl : UIPageControl
{
    UIImage* activeImage;
    UIImage* inactiveImage;
}
@property(nonatomic, retain) UIImage* activeImage;
@property(nonatomic, retain) UIImage* inactiveImage;
@end
