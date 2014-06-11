//
//  CameraGuide.h
//  EHEandme
//
//  Created by Suresh on 2/28/14.
//  Copyright (c) 2014 EHEandme. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraGuide : UIView
@property (strong, nonatomic) IBOutlet UILabel *guideTopLbl;
@property (strong, nonatomic) IBOutlet UILabel *guideBottomLbl;
@property (strong, nonatomic) IBOutlet UIButton *guideCloseBtn;
@property (strong, nonatomic) IBOutlet UIButton *guideCloseTopBtn;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UIView *bottomView;

@property (strong, nonatomic) IBOutlet UIView *middleView;
@property (strong, nonatomic) IBOutlet UILabel *middleViewLbl;

@property (strong, nonatomic) IBOutlet UIView *slideView;
@property (strong, nonatomic) IBOutlet UILabel *slideViewLbl;

@property (strong, nonatomic) IBOutlet UIView *checkBoxView;
@property (strong, nonatomic) IBOutlet UILabel *checkBoxViewLbl;
@end
