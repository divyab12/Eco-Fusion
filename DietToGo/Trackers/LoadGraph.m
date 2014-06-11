//
//  LoadGraph.m
//  CorePlotSample
//
//  Created by Divya Reddy on 30/10/13.
//  Copyright (c) 2013 Divya Reddy. All rights reserved.
//

#import "LoadGraph.h"
#import "MeasurementListViewController.h"
#import "CholesterolListViewController.h"
#import "GoalListViewController.h"

//[CPTColor colorWithComponentRed:133/255.0f green:124/255.0f blue:109/255.0f alpha:1]
#define  XaxisRed 133
#define  XaxisGreen 124
#define  XaxisBlue 109

//[CPTColor colorWithComponentRed:169/255.0f green:169/255.0f blue:169/255.0f alpha:1]
#define  YaxisRed 169
#define  YaxisGreen 169
#define  YaxisBlue 169

//[CPTColor colorWithComponentRed:148/255.0f green:203/255.0f blue:36/255.0f alpha:1]
#define  GoalLineRed 148
#define  GoalLineGreen 203
#define  GoalLineBlue 36

//[CPTColor colorWithComponentRed:223/255.0f green:195/255.0f blue:158/255.0f alpha:1]
#define  MainPlotRed 223
#define  MainPlotGreen 195
#define  MainPlotBlue 158

//[CPTColor colorWithComponentRed:229/255.0f green:206/255.0f blue:174/255.0f alpha:1.0]
#define  GredientLevelOneRed 229
#define  GredientLevelOneGreen 206
#define  GredientLevelOneBlue 174

//[CPTColor colorWithComponentRed:235/255.0f green:219/255.0f blue:196/255.0f alpha:1.0]
#define  GredientLevelTwoRed 235
#define  GredientLevelTwoGreen 219
#define  GredientLevelTwoBlue 196

//[CPTColor colorWithComponentRed:238/255.0f green:223/255.0f blue:202/255.0f alpha:1.0]
#define  GredientLevelThreeRed 238
#define  GredientLevelThreeGreen 223
#define  GredientLevelThreeBlue 202

@implementation LoadGraph
@synthesize hostingView = _hostingView;
@synthesize graph = _graph;
@synthesize graphData = _graphData;
@synthesize mXAxisLabels,mYAxisLabels, mParentClass;
// Initialise the scatter plot in the provided hosting view with the provided data.
// The data array should contain NSValue objects each representing a CGPoint.
-(id)initWithHostingView:(CPTGraphHostingView *)hostingView andData:(NSMutableArray *)data xAxis:(NSMutableArray*)xData yAxis:(NSMutableArray*)ydata
{
    self = [super init];
    if ( self != nil ) {
        self.hostingView = hostingView;
        self.graphData = data;
        self.mXAxisLabels = xData;
        self.mYAxisLabels = ydata;
        CPTXYGraph *graph = [[CPTXYGraph alloc] initWithFrame: CGRectZero];
        graph.plotAreaFrame.masksToBorder = NO;
        self.graph = nil;
    }
    
    return self;

}
-(void)goalData:(NSMutableArray *)data{
        self.goalGraphData = data;
}

// This does the actual work of creating the plot if we don't already have a graph object.
-(void)initialisePlot
{
    // Start with some simple sanity checks before we kick off
    if ( (self.hostingView == nil) || (self.graphData == nil) ) {
        NSLog(@"TUTSimpleScatterPlot: Cannot initialise plot without hosting view or data.");
        return;
    }
    
    if ( self.graph != nil ) {
        NSLog(@"TUTSimpleScatterPlot: Graph object already exists.");
        return;
    }
    
    // Create a graph object which we will use to host just one scatter plot.
    CGRect frame = CGRectMake(0, 0, 300, 260);
    //[self.hostingView bounds];
    self.graph = [[CPTXYGraph alloc] initWithFrame:frame] ;
        
    self.graph.paddingTop = 0.0f;
    self.graph.paddingLeft = 0.0f;
    self.graph.paddingRight = 0.0f;
    self.graph.paddingBottom = 0.0f;
    
    if ([self.mParentClass isKindOfClass:[MeasurementListViewController class]] || [self.mParentClass isKindOfClass:[CholesterolListViewController class]] || [self.mParentClass isKindOfClass:[GoalListViewController class]]) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
            self.graph.plotAreaFrame.paddingTop = 40.0f;
            
        }else{
            self.graph.plotAreaFrame.paddingTop = 60.0f;
        }
    }else{
         if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
             self.graph.plotAreaFrame.paddingTop = 5.0f;

         }else{
             self.graph.plotAreaFrame.paddingTop = 30.0f;
         }

    }
    self.graph.plotAreaFrame.paddingRight = 10.0f;
    self.graph.plotAreaFrame.paddingBottom = 55.0f;
    self.graph.plotAreaFrame.paddingLeft = 30.0f;
    self.graph.masksToBorder = NO;
    self.graph.plotAreaFrame.axisSet.borderLineStyle = nil;
    self.graph.plotAreaFrame.borderWidth = 0;
    self.graph.plotAreaFrame.cornerRadius = 0;
	// Tie the graph we've created with the hosting view.
    self.hostingView.hostedGraph = self.graph;
    
    // If you want to use one of the default themes - apply that here.
    //[self.graph applyTheme:[CPTTheme themeNamed:kCPTPlainWhiteTheme]];
    
	// Create a line style that we will apply to the axis and data line.
	CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
	lineStyle.lineColor = [CPTColor grayColor];
	lineStyle.lineWidth = 1.0f;
	
    // Create a text style that we will use for the axis labels.
	CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
	textStyle.fontName = @"Helvetica";
	textStyle.fontSize = 14;
	textStyle.color = [CPTColor blackColor];
	
    // Create the plot symbol we're going to use.
    CPTPlotSymbol *plotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    plotSymbol.fill = [CPTFill fillWithColor:[CPTColor greenColor]];

    plotSymbol.lineStyle = lineStyle;
    plotSymbol.size = CGSizeMake(8.0, 8.0);
	
   
    float xAxisMin = 0;
    float xAxisMax = [self.mXAxisLabels count]+1;
    NSInteger yAxisMin = 0;//[[self.mYAxisLabels objectAtIndex:0] intValue];
    NSInteger yAxisMax = [[self.mYAxisLabels objectAtIndex:[self.mYAxisLabels count]-1] intValue];
    //This is to fixed show circle fully.
    yAxisMax =yAxisMax + yAxisMax/4;
    

	// We modify the graph's plot space to setup the axis' min / max values.
	CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)self.graph.defaultPlotSpace;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(xAxisMin) length:CPTDecimalFromInt(xAxisMax )];
	plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromInt(yAxisMin) length:CPTDecimalFromInt(yAxisMax )];
    plotSpace.xScaleType = CPTScaleTypeLinear;
    plotSpace.yScaleType = CPTScaleTypeLinear;
    
	

    // Modify the graph's axis with a label, line style, etc.
	CPTXYAxisSet *axisSet = (CPTXYAxisSet *)self.graph.axisSet;
    
    CPTMutableTextStyle *textStyle_ = [CPTMutableTextStyle textStyle];
    textStyle_.fontName = @"Helvetica-Bold";
    textStyle_.fontSize = 14;
    textStyle_.color = [CPTColor grayColor];
	//axisSet.xAxis.title = @"Time";
	axisSet.xAxis.titleTextStyle = textStyle_;
	axisSet.xAxis.titleOffset = 30.0f;
	axisSet.xAxis.axisLineStyle = lineStyle;
	axisSet.xAxis.majorTickLineStyle = lineStyle;
	axisSet.xAxis.minorTickLineStyle = lineStyle;
    //	axisSet.xAxis.labelTextStyle = textStyle_;
    axisSet.xAxis.labelingPolicy = CPTAxisLabelingPolicyNone;
	axisSet.xAxis.labelOffset = 0.0f;
	axisSet.xAxis.majorIntervalLength = CPTDecimalFromFloat(30.0f);
	axisSet.xAxis.minorTicksPerInterval = 0;
	axisSet.xAxis.minorTickLength = 5.0f;
	axisSet.xAxis.majorTickLength = 7.0f;
    
    // Create a text style that we will use for the axis labels.
    NSMutableArray *customTickLocations =  [[NSMutableArray alloc] init];
    for (int i = 0; i< self.mXAxisLabels.count; i++) {
        [customTickLocations addObject:[NSDecimalNumber numberWithInt:i]];
    }
    NSArray *xAxisLabels     = self.mXAxisLabels;// [NSArray arrayWithObjects:@"Start", @"Current", @"Goal", @"Label D", nil];
    NSUInteger labelLocation     = 0;
    NSMutableArray *customLabels = [NSMutableArray arrayWithCapacity:[xAxisLabels count]];
    for ( NSNumber *tickLocation in customTickLocations ) {
        
        CPTAxisLabel *newLabel = [[CPTAxisLabel alloc] initWithText:[xAxisLabels objectAtIndex:labelLocation++] textStyle:axisSet.xAxis.labelTextStyle];
        newLabel.tickLocation = [tickLocation decimalValue];

        newLabel.offset = axisSet.xAxis.labelOffset + axisSet.xAxis.majorTickLength;
        newLabel.rotation = M_PI/2;
        [customLabels addObject:newLabel];
    }
    
    
    axisSet.xAxis.axisLabels = [NSSet setWithArray:customLabels];

    //x axis label style
    CPTMutableTextStyle *Xstyle = [CPTMutableTextStyle textStyle];
    Xstyle.color = [CPTColor colorWithComponentRed:XaxisRed/255.0f green:XaxisGreen/255.0f blue:XaxisBlue/255.0f alpha:1];
    Xstyle.fontName = @"Bariol-Regular";
    Xstyle.fontSize = 12.0f;
    axisSet.xAxis.labelTextStyle = Xstyle;
    
    //y axis label style
    CPTMutableTextStyle *Ystyle = [CPTMutableTextStyle textStyle];
    Ystyle.color = [CPTColor colorWithComponentRed:YaxisRed/255.0f green:YaxisGreen/255.0f blue:YaxisBlue/255.0f alpha:1];
    Ystyle.fontName = @"Bariol-Regular";
    Ystyle.fontSize = 8.0f;
    axisSet.yAxis.labelTextStyle = Ystyle;

    
    //x major or y major gridLineStyle
    CPTMutableLineStyle *gridLineStyle = [CPTMutableLineStyle lineStyle];
    gridLineStyle.lineColor = [CPTColor blackColor];
    gridLineStyle.lineWidth = 1.0f;
    //axisSet.xAxis.majorGridLineStyle=gridLineStyle;
    CPTMutableTextStyle *yTextStyle_ = [CPTMutableTextStyle textStyle];
    yTextStyle_.fontName = @"Helvetica-Bold";
    yTextStyle_.fontSize = 14;
    yTextStyle_.color = [CPTColor grayColor];
   	axisSet.yAxis.titleTextStyle = yTextStyle_;
    axisSet.yAxis.axisConstraints = [CPTConstraints constraintWithLowerOffset:0.0];
    axisSet.yAxis.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0.0");
	axisSet.yAxis.titleOffset = 50.0f;
	axisSet.yAxis.axisLineStyle = lineStyle;
    axisSet.yAxis.hidden = TRUE;
	axisSet.yAxis.majorTickLineStyle = lineStyle;
	axisSet.yAxis.minorTickLineStyle = lineStyle;
	axisSet.yAxis.labelOffset = 3.0f;
	axisSet.yAxis.majorIntervalLength = CPTDecimalFromFloat(100.0f);
	axisSet.yAxis.minorTicksPerInterval = 0;
	axisSet.yAxis.minorTickLength = 5.0f;
	axisSet.yAxis.majorTickLength = 7.0f;
    
    axisSet.xAxis.visibleRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f)
                                                              length:CPTDecimalFromFloat(100.0f)];
    axisSet.xAxis.gridLinesRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0f)
                                                                length:CPTDecimalFromFloat(100.0f)];
    
    //
    // for setting values in to y axis array
    // Create a text style that we will use for the axis labels.
    NSMutableArray *ycustomTickLocations = [[NSMutableArray alloc] init];
    for (int i = 0; i< self.mYAxisLabels.count; i++) {
         [ycustomTickLocations addObject:[NSDecimalNumber numberWithInt:[[self.mYAxisLabels objectAtIndex:i] intValue]]];
    }
    NSSet *yMajorTickLocations = [NSSet setWithArray:ycustomTickLocations];

    
    NSArray *yAxisLabels     = self.mYAxisLabels;// [NSArray arrayWithObjects:@"Start", @"Current", @"Goal", @"Label D", nil];
    NSUInteger ylabelLocation     = 0;
    NSMutableArray *ycustomLabels = [NSMutableArray arrayWithCapacity:[yAxisLabels count]+1];
    for ( NSNumber *tickLocation in ycustomTickLocations) {
        CPTAxisLabel *newLabel = [[CPTAxisLabel alloc] initWithText:[yAxisLabels objectAtIndex:ylabelLocation++] textStyle:axisSet.yAxis.labelTextStyle];
        newLabel.tickLocation = [tickLocation decimalValue];
        newLabel.offset = axisSet.yAxis.labelOffset + axisSet.yAxis.majorTickLength + axisSet.yAxis.labelOffset + axisSet.yAxis.majorTickLength;
    
        //            newLabel.rotation     = M_PI / 4;
        
        [ycustomLabels addObject:newLabel];
    }
   
    axisSet.yAxis.axisLabels = [NSSet setWithArray:ycustomLabels];
    axisSet.yAxis.labelingPolicy = CPTAxisLabelingPolicyNone;
    axisSet.yAxis.majorTickLocations = yMajorTickLocations;
    axisSet.yAxis.tickDirection = CPTSignNone;
    //
    
    //y major gridLineStyle
    CPTMutableLineStyle *dashLineStyle = [CPTMutableLineStyle lineStyle];
    dashLineStyle.lineColor = [CPTColor lightGrayColor];
    dashLineStyle.lineWidth = 1.5f;
    dashLineStyle.dashPattern = [NSArray arrayWithObjects:[NSDecimalNumber numberWithInt:1],[NSDecimalNumber numberWithInt:2],nil];
    dashLineStyle.patternPhase = 0.0f;
    
    CPTMutableLineStyle *fullLineStyle = [CPTMutableLineStyle lineStyle];
    fullLineStyle.lineColor = [CPTColor lightGrayColor];
    fullLineStyle.lineWidth = 0.5f;
    //fullLineStyle.dashPattern = [NSArray arrayWithObjects:[NSDecimalNumber numberWithInt:1],nil];
    //fullLineStyle.lineCap = 0;
    fullLineStyle.patternPhase = 0.0f;
    
    axisSet.yAxis.majorGridLineStyle=fullLineStyle;
	// Add a plot to our graph and axis. We give it an identifier so that we
	// could add multiple plots (data lines) to the same graph if necessary.
	CPTScatterPlot *plot = [[CPTScatterPlot alloc] init] ;
	plot.dataSource = self;
	plot.identifier = @"mainplot";
    // Create a line style that we will apply to the axis and data line.
	CPTMutableLineStyle *graphlineStyle = [CPTMutableLineStyle lineStyle];
	graphlineStyle.lineColor = [CPTColor clearColor];
	graphlineStyle.lineWidth = 1.0f;

	//plot.dataLineStyle = lineStyle;
    plot.dataLineStyle = graphlineStyle;
	plot.plotSymbol = plotSymbol;
    
    // for goal view
    CPTScatterPlot *plot1 = [[CPTScatterPlot alloc] init] ;
	plot1.dataSource = self;
	plot1.identifier = @"graphPlot";
	plot1.dataLineStyle = lineStyle;
	plot1.plotSymbol = plotSymbol;

setUpForPlot:{
    
    
    
    CPTPlotSymbol *aaplSymbol1 = [CPTPlotSymbol dashPlotSymbol];
    aaplSymbol1.fill = [CPTFill fillWithColor:[CPTColor redColor]];
    CPTMutableLineStyle *goalLineStyle = [CPTMutableLineStyle lineStyle];
    goalLineStyle.lineColor = [CPTColor colorWithComponentRed:GoalLineRed/255.0f green:GoalLineGreen/255.0f blue:GoalLineBlue/255.0f alpha:1];
    goalLineStyle.lineWidth = 1.5f;
    aaplSymbol1.lineStyle = goalLineStyle;
    aaplSymbol1.size = CGSizeMake(640.0f, 640.0f);
    plot1.plotSymbol = aaplSymbol1;
   
}
   //to fill graph  with colour
    //plot.areaFill = [CPTFill fillWithColor:[CPTColor redColor]];
    CPTGradient *stocksBackgroundGradient = [[CPTGradient alloc] init] ;
    //Changed graph colors as per DTG
    stocksBackgroundGradient = [stocksBackgroundGradient addColorStop:[CPTColor colorWithComponentRed:GredientLevelOneRed/255.0f green:GredientLevelOneGreen/255.0f blue:GredientLevelOneBlue/255.0f alpha:1.0] atPosition:0.0];
    stocksBackgroundGradient = [stocksBackgroundGradient addColorStop:[CPTColor colorWithComponentRed:GredientLevelTwoRed/255.0f green:GredientLevelTwoGreen/255.0f blue:GredientLevelTwoBlue/255.0f alpha:1.0] atPosition:0.5];
    stocksBackgroundGradient = [stocksBackgroundGradient addColorStop:[CPTColor colorWithComponentRed:GredientLevelThreeRed/255.0f green:GredientLevelThreeGreen/255.0f blue:GredientLevelThreeBlue/255.0f alpha:1.0] atPosition:0.75];
    stocksBackgroundGradient = [stocksBackgroundGradient addColorStop:[CPTColor colorWithComponentRed:GredientLevelThreeRed/255.0f green:GredientLevelThreeGreen/255.0f blue:GredientLevelThreeBlue/255.0f alpha:1.0] atPosition:0.9];
    stocksBackgroundGradient.angle = 270.0;
    plot.areaFill = [CPTFill fillWithGradient:stocksBackgroundGradient];
    plot.areaBaseValue = CPTDecimalFromInteger(0);
    plot.interpolation = CPTScatterPlotInterpolationCurved;
    
  	[self.graph addPlot:plot];
    if (self.goalGraphData!=nil) {
        [self.graph addPlot:plot1];

    }

}

// Delegate method that returns the number of points on the plot
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
	if ( [plot.identifier isEqual:@"mainplot"] )
	{
        return [self.graphData count];
	}
    else{
        return 1;
    
    }
	
	return 0;
}

// Delegate method that returns a single X or Y value for a given plot.
-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
	if ( [plot.identifier isEqual:@"mainplot"] )
	{
        NSValue *value = [self.graphData objectAtIndex:index];
        CGPoint point = [value CGPointValue];
        
        // FieldEnum determines if we return an X or Y value.
		if ( fieldEnum == CPTScatterPlotFieldX )
		{
            return [NSNumber numberWithFloat:point.x];
		}
		else	// Y-Axis
		{
            return [NSNumber numberWithFloat:point.y];
          

		}
	}
    // for goal value
    else{
        NSValue *value = [self.goalGraphData objectAtIndex:index];
        CGPoint point = [value CGPointValue];
        
        if ( fieldEnum == CPTScatterPlotFieldX )
		{
            return [NSNumber numberWithFloat:point.x];
		}
		else	// Y-Axis
		{
            return [NSNumber numberWithFloat:point.y];
            
		}
    
    }
	
	return [NSNumber numberWithFloat:0];
}
-(CPTPlotSymbol *)symbolForScatterPlot:(CPTScatterPlot *)plot recordIndex:(NSUInteger)idx{
    
    if (([plot.identifier  isEqual: @"mainplot"])) {
        if (idx == self.mXAxisLabels.count-1) {
            CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
            
            lineStyle.lineColor = [CPTColor colorWithComponentRed:MainPlotRed/255.0f green:MainPlotGreen/255.0f blue:MainPlotBlue/255.0f alpha:1];
            lineStyle.lineWidth = 2.5f;
            CPTPlotSymbol *aaplSymbol = [CPTPlotSymbol ellipsePlotSymbol];
            aaplSymbol.fill = [CPTFill fillWithColor:[CPTColor whiteColor]];
            aaplSymbol.lineStyle = lineStyle;
            aaplSymbol.size = CGSizeMake(9.f, 9.f);
            plot.plotSymbol = aaplSymbol;
            return aaplSymbol;

        }else{
            CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
            lineStyle.lineColor = [CPTColor clearColor];
            lineStyle.lineWidth = 1.0f;
            CPTPlotSymbol *aaplSymbol = [CPTPlotSymbol ellipsePlotSymbol];
            aaplSymbol.fill = [CPTFill fillWithColor:[CPTColor clearColor]];
            aaplSymbol.lineStyle = lineStyle;
            aaplSymbol.size = CGSizeMake(10.f, 10.f);
            plot.plotSymbol = aaplSymbol;
            return aaplSymbol;
        }
    }else{
        
    }
    return nil;
}
/*Method used to display label's on graph based on index.
-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index {
     if (([plot.identifier  isEqual: @"mainplot"])) {
         return nil;
     }else{
         CPTTextLayer *label;
         label = [[CPTTextLayer alloc] initWithText:@"Goal"];
         CPTMutableTextStyle *textStyle = [label.textStyle mutableCopy];
         textStyle.fontName = @"Bariol-Regular";
         textStyle.fontSize = 12.0f;
         textStyle.color = [CPTColor colorWithComponentRed:148/255.0f green:203/255.0f blue:36/255.0f alpha:1];
         label.textStyle = textStyle;
         return label;

     }
   
}*/
@end
