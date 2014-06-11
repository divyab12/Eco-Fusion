//
//  GlassView.m
//  EHERD
//
//  Created by EHEandme on 12/3/13.
//  Copyright (c) 2013 valuelabs. All rights reserved.
//

#import "GlassView.h"
#import "FilledGlass.h"

@implementation GlassView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame percentage:(float)percent
{
     self = [self initWithFrame:frame];
    
    if (self != Nil) {
    
    UIImageView *glassView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    glassView.image = [UIImage imageNamed:@"glass.png"];
    glassView.backgroundColor = [UIColor clearColor];
    [self addSubview:glassView];

    //Glass shape View
    FilledGlass *glass = [[FilledGlass alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) percentage:percent];
    [self addSubview:glass];

    UIButton *addBtn =  [[UIButton alloc] initWithFrame:CGRectMake(60, 55, 33, 33)];
    [addBtn setImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
    //[addBtn addTarget:self action:@selector(addMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:addBtn];
    }
    
   // NSLog(@"initWithFrame");
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    //NSLog(@"drawRect");
}
 */


@end
