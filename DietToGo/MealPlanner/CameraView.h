//
//  CameraView.h
//  EHEandme
//
//  Created by Suresh on 2/18/14.
//  Copyright (c) 2014 EHEandme. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CameraView : UIView
@property (strong, nonatomic) IBOutlet UIView *mTransparentView;

@property (strong, nonatomic) IBOutlet UIView *mTakePhotoView;

@property (strong, nonatomic) IBOutlet UIButton *mTakeBtn;
@property (strong, nonatomic) IBOutlet UIButton *mUploadBtn;
@property (strong, nonatomic) IBOutlet UIButton *mCancelBtn;


@property (strong, nonatomic) IBOutlet UIView *mUsePhotoView;
@property (strong, nonatomic) IBOutlet UIImageView *mPreview;

@property (strong, nonatomic) IBOutlet UIButton *mRetakeBtn;
@property (strong, nonatomic) IBOutlet UIButton *mUsePhoto;

@end
