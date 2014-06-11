//
//  UIDevice+Resolutions.m
//  ServeItUp
//
//  Created by EHEandme on 6/11/13.
//  Copyright (c) 2013 valuelabs. All rights reserved.
//

#import "UIDevice+Resolutions.h"

@implementation UIDevice (Resolutions)

- (UIDeviceResolution)resolution
{
    UIDeviceResolution resolution = UIDeviceResolution_Unknown;
    UIScreen *mainScreen = [UIScreen mainScreen];
    CGFloat scale = ([mainScreen respondsToSelector:@selector(scale)] ? mainScreen.scale : 1.0f);
    CGFloat pixelHeight = (CGRectGetHeight(mainScreen.bounds) * scale);
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        if (scale == 2.0f) {
            if (pixelHeight == 960.0f)
                resolution = UIDeviceResolution_iPhoneRetina4;
            else if (pixelHeight == 1136.0f)
                resolution = UIDeviceResolution_iPhoneRetina5;
            
        } else if (scale == 1.0f && pixelHeight == 480.0f)
            resolution = UIDeviceResolution_iPhoneStandard;
        
    } else {
        if (scale == 2.0f && pixelHeight == 2048.0f) {
            resolution = UIDeviceResolution_iPadRetina;
            
        } else if (scale == 1.0f && pixelHeight == 1024.0f) {
            resolution = UIDeviceResolution_iPadStandard;
        }
    }
    
    return resolution;
}
/*
 //How to use this Category..
 int valueDevice = [[UIDevice currentDevice] resolution];
 
 NSLog(@"valueDevice: %d ...", valueDevice);
 
 if (valueDevice == 0)
 {
 //unknow device - you got me!
 }
 else if (valueDevice == 1)
 {
 //standard iphone 3GS and lower
 }
 else if (valueDevice == 2)
 {
 //iphone 4 & 4S
 }
 else if (valueDevice == 3)
 {
 //iphone 5
 }
 else if (valueDevice == 4)
 {
 //ipad 2
 }
 else if (valueDevice == 5)
 {
 //ipad 3 - retina display
 }
 
 //device..
 int valueDevice = [[UIDevice currentDevice] resolution];
 
 NSLog(@"valueDevice: %d ...", valueDevice);
 if (valueDevice == 2 || valueDevice ==1 )
 {
 NSLog(@"iphone 3G( v-1) and 4 & 4S ( v-2 )");
 }
 else if (valueDevice == 3)
 {
 NSLog(@"iphone 5");
 }
 
 */

@end
