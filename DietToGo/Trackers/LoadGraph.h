//
//  LoadGraph.h
//  CorePlotSample
//
//  Created by Divya Reddy on 30/10/13.
//  Copyright (c) 2013 Divya Reddy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CorePlot-CocoaTouch.h"
#import "AppDelegate.h"
@interface LoadGraph : NSObject<CPTScatterPlotDataSource> {
    AppDelegate *mAppDelegate;
    CPTGraphHostingView *_hostingView;
	CPTXYGraph *_graph;
	NSMutableArray *_graphData;

}
@property (nonatomic, retain) id mParentClass;

@property (nonatomic, assign) float GoalWeightLbs;
@property (nonatomic, retain) CPTGraphHostingView *hostingView;
@property (nonatomic, retain) CPTXYGraph *graph;
@property (nonatomic, retain) NSMutableArray *graphData;
@property (nonatomic, retain) NSMutableArray *goalGraphData;

@property (nonatomic,retain) NSMutableArray  *mXAxisLabels;
@property (nonatomic,retain) NSMutableArray *mYAxisLabels;
// Methods to create this object and attach it to it's hosting view.
//+(ScatterPlotDataGetter *)plotWithHostingView:(CPTGraphHostingView *)hostingView andData:(NSMutableArray *)data;
-(id)initWithHostingView:(CPTGraphHostingView *)hostingView andData:(NSMutableArray *)data xAxis:(NSMutableArray*)xData yAxis:(NSMutableArray*)ydata;
-(void)goalData:(NSMutableArray *)data;

// Specific code that creates the scatter plot.
-(void)initialisePlot;

@end
