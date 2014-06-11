//
//  LoadingView.m
//  LoadingView
//
//  Created by Matt Gallagher on 12/04/09.
//  Copyright Matt Gallagher 2009. All rights reserved.
// 
//  Permission is given to use this source code file, free of charge, in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//

#import "LoadingView.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
//
// NewPathWithRoundRect
//
// Creates a CGPathRect with a round rect of the given radius.
//
CGPathRef NewPathWithRoundRect(CGRect rect, CGFloat cornerRadius)
{
	//
	// Create the boundary path
	//
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathMoveToPoint(path, NULL,
		rect.origin.x,
		rect.origin.y + rect.size.height - cornerRadius);

	// Top left corner
	CGPathAddArcToPoint(path, NULL,
		rect.origin.x,
		rect.origin.y,
		rect.origin.x + rect.size.width,
		rect.origin.y,
		cornerRadius);

	// Top right corner
	CGPathAddArcToPoint(path, NULL,
		rect.origin.x + rect.size.width,
		rect.origin.y,
		rect.origin.x + rect.size.width,
		rect.origin.y + rect.size.height,
		cornerRadius);

	// Bottom right corner
	CGPathAddArcToPoint(path, NULL,
		rect.origin.x + rect.size.width,
		rect.origin.y + rect.size.height,
		rect.origin.x,
		rect.origin.y + rect.size.height,
		cornerRadius);

	// Bottom left corner
	CGPathAddArcToPoint(path, NULL,
		rect.origin.x,
		rect.origin.y + rect.size.height,
		rect.origin.x,
		rect.origin.y,
		cornerRadius);

	// Close the path at the rounded rect
	CGPathCloseSubpath(path);
	
	return path;
}

@implementation LoadingView

//
// loadingViewInView:
//
// Constructor for this view. Creates and adds a loading view for covering the
// provided aSuperview.
//
// Parameters:
//    aSuperview - the superview that will be covered by the loading view
//
// returns the constructed view, already added as a subview of the aSuperview
//	(and hence retained by the superview)
//

//- (void)loadingViewInView:(UIView *)aSuperview
//{
//	self.frame = [aSuperview bounds];
//	self.opaque = NO;
//	self.autoresizingMask =UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//	[aSuperview addSubview:self];
//
//	UIActivityIndicatorView *activityIndicatorView =
//	[[[UIActivityIndicatorView alloc]
//	  initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite]
//	 autorelease];
//	activityIndicatorView.frame=CGRectMake(0, 0,35,35);
////	activityIndicatorView.activityIndicatorViewStyle=uiac
//	[self addSubview:activityIndicatorView];
//	activityIndicatorView.autoresizingMask =
//	UIViewAutoresizingFlexibleLeftMargin |
//	UIViewAutoresizingFlexibleRightMargin |
//	UIViewAutoresizingFlexibleTopMargin |
//	UIViewAutoresizingFlexibleBottomMargin;
//	[activityIndicatorView startAnimating];
//	
//
//	CGRect activityIndicatorRect = activityIndicatorView.frame;
//	activityIndicatorRect.origin.x = 0.5 * (self.frame.size.width - activityIndicatorRect.size.width);
//	activityIndicatorRect.origin.y = self.frame.size.height/2;
//	
//	activityIndicatorView.frame = activityIndicatorRect;
//	
//	// Set up the fade-in animation
//	CATransition *animation = [CATransition animation];
//	[animation setType:kCATransitionFade];
//	[[aSuperview layer] addAnimation:animation forKey:@"layerAnimation"];
//	
//
//}


- (void)loadingViewInView:(UIView *)aSuperview
{
	self.frame = [aSuperview bounds];
	self.opaque = NO;
	self.autoresizingMask =UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[aSuperview addSubview:self];
	
	/*const CGFloat DEFAULT_LABEL_WIDTH = 280.0;
	 const CGFloat DEFAULT_LABEL_HEIGHT = 50.0;
	 CGRect labelFrame = CGRectMake(0, 0, DEFAULT_LABEL_WIDTH, DEFAULT_LABEL_HEIGHT);
	 UILabel *loadingLabel =
	 [[[UILabel alloc]
	 initWithFrame:labelFrame]
	 autorelease];
	 loadingLabel.text = NSLocalizedString(@"Loading...", nil);
	 loadingLabel.textColor = [UIColor blackColor];
	 loadingLabel.backgroundColor = [UIColor clearColor];
	 loadingLabel.textAlignment = UITextAlignmentCenter;
	 loadingLabel.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
	 loadingLabel.autoresizingMask =
	 UIViewAutoresizingFlexibleLeftMargin |
	 UIViewAutoresizingFlexibleRightMargin |
	 UIViewAutoresizingFlexibleTopMargin |
	 UIViewAutoresizingFlexibleBottomMargin;
	 
	 [loadingView addSubview:loadingLabel];*/
	UIActivityIndicatorView *activityIndicatorView =
	[[UIActivityIndicatorView alloc]
	  initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityIndicatorView.color = BLACK_COLOR;
	[self addSubview:activityIndicatorView];
	activityIndicatorView.autoresizingMask =
	UIViewAutoresizingFlexibleLeftMargin |
	UIViewAutoresizingFlexibleRightMargin |
	UIViewAutoresizingFlexibleTopMargin |
	UIViewAutoresizingFlexibleBottomMargin;
	[activityIndicatorView startAnimating];
	
	/*CGFloat totalHeight =
	 loadingLabel.frame.size.height +
	 activityIndicatorView.frame.size.height;
	 labelFrame.origin.x = floor(0.5 * (loadingView.frame.size.width - DEFAULT_LABEL_WIDTH));
	 labelFrame.origin.y = floor(0.5 * (loadingView.frame.size.height - totalHeight));
	 loadingLabel.frame = labelFrame;*/
	
	CGRect activityIndicatorRect = activityIndicatorView.frame;
    activityIndicatorRect.size.width = 30;
    activityIndicatorRect.size.height = 30;
	activityIndicatorRect.origin.x = 0.5 * (self.frame.size.width - activityIndicatorRect.size.width);
	//	activityIndicatorRect.origin.y =loadingLabel.frame.origin.y + loadingLabel.frame.size.height;
	activityIndicatorRect.origin.y = self.frame.size.height/2;
	
	activityIndicatorView.frame = activityIndicatorRect;
	
	// Set up the fade-in animation
	CATransition *animation = [CATransition animation];
	[animation setType:kCATransitionFade];
	[[aSuperview layer] addAnimation:animation forKey:@"layerAnimation"];
}
	
//
// removeView
//
// Animates the view out from the superview. As the view is removed from the
// superview, it will be released.
//
- (void)removeView
{
	UIView *aSuperview = [self superview];
	[super removeFromSuperview];

	// Set up the animation
	CATransition *animation = [CATransition animation];
	[animation setType:kCATransitionFade];
	
	[[aSuperview layer] addAnimation:animation forKey:@"layerAnimation"];
}

// drawRect:
// Draw the view.
//- (void)drawRect:(CGRect)rect
//{
//	rect.size.height -= 1;
//	rect.size.width -= 1;
//	
//	const CGFloat RECT_PADDING = 8.0;
//	rect = CGRectInset(rect, RECT_PADDING, RECT_PADDING);
//	
//	const CGFloat ROUND_RECT_CORNER_RADIUS = 5.0;
//	CGPathRef roundRectPath = NewPathWithRoundRect(CGRectMake(0,0,320,480), ROUND_RECT_CORNER_RADIUS);
//
//	CGPathRelease(roundRectPath);
//}
//


- (void)drawRect:(CGRect)rect
{
	// Memory leak for rect value , never been used
	/*rect.size.height -= 1;
	 rect.size.width -= 1;
	 
	 const CGFloat RECT_PADDING = 8.0;
	 rect = CGRectInset(rect, RECT_PADDING, RECT_PADDING);
	 */
	const CGFloat ROUND_RECT_CORNER_RADIUS = 5.0;
    AppDelegate *mApp = [AppDelegate appDelegateInstance];
    CGRect frame = CGRectMake(0,0,320,mApp.window.frame.size.height);
    
	//CGPathRef roundRectPath = NewPathWithRoundRect(rect, ROUND_RECT_CORNER_RADIUS);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        frame = CGRectMake(0,0,768,1024);
    } 
	CGPathRef roundRectPath = NewPathWithRoundRect(frame, ROUND_RECT_CORNER_RADIUS);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	const CGFloat BACKGROUND_OPACITY = 0;//0.5;
	CGContextSetRGBFillColor(context, 0, 0, 0, BACKGROUND_OPACITY);
	CGContextAddPath(context, roundRectPath);
	CGContextFillPath(context);
	
	const CGFloat STROKE_OPACITY = 0.25;
	CGContextSetRGBStrokeColor(context, 1, 1, 1, STROKE_OPACITY);
	CGContextAddPath(context, roundRectPath);
	CGContextStrokePath(context);
	
	CGPathRelease(roundRectPath);
}
// dealloc
// Release instance memory.

@end
