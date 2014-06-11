//
//  EditLandingViewController.m
//  EHEandme
//
//  Created by Divya Reddy on 01/11/13.
//  Copyright (c) 2013 EHEandme. All rights reserved.
//

#import "EditLandingViewController.h"
#import "EditLandindingTableViewCell.h"
#import "LandingViewController.h"
#import "GenericDataBase.h"

#define WeightText @"Weight"
#define WeightImage @"weighingmachine.png"
#define MealText @"Meal Planner"
#define MealImage @"mealicon.png"
#define StepsText @"Steps"
#define StepsImage @"stepsicon.png"
#define ExerciseText @"Exercise"
#define ExerciseImage @"exerciseman.png"
#define WaterText @"Water"
#define WaterImage @"water.png"
@interface EditLandingViewController ()

@end

@implementation EditLandingViewController
@synthesize mTrackersArray,mTrackersImgsArray, mUnHideTrackersDict,mGoalsArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // for setting the view below 20px in iOS7.0.
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        self.edgesForExtendedLayout = UIRectEdgeLeft | UIRectEdgeRight;
#endif

    // Do any additional setup after loading the view from its nib.
    mAppDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    //for tracking
    if (mAppDelegate.mTrackPages) {
        self.trackedViewName=@"Dashboard Edit page";
    }
    //end
    mTrackersArray = [[NSMutableArray alloc]init];//WithObjects:@"Weight", @"Meal Planner", @"Steps", @"Exercise", @"Water", nil];
    mTrackersImgsArray = [[NSMutableArray alloc]init];//WithObjects:@"weighingmachine1.png", @"mealicon.png", @"stepsicon1.png",@"exerciseicon@2x.png", @"water.png",   nil];
    
    //to get the tracker order and store the table details into array
    NSArray *mArray = [mAppDelegate.mLandingViewController.mTrackerOrder componentsSeparatedByString:@","];
    
    for (int i =0; i < mArray.count; i++) {
        NSString *mText = [mArray objectAtIndex:i];
        
        if ([mText isEqualToString:@"Weight"]) {
            [self.mTrackersArray addObject:WeightText];
            [self.mTrackersImgsArray addObject:WeightImage];
        }else if ([mText isEqualToString:@"Meal"]) {
            [self.mTrackersArray addObject:MealText];
            [self.mTrackersImgsArray addObject:MealImage];
        }else if ([mText isEqualToString:@"Exercise"]) {
            [self.mTrackersArray addObject:ExerciseText];
            [self.mTrackersImgsArray addObject:ExerciseImage];
        }else if ([mText isEqualToString:@"Step"]) {
            [self.mTrackersArray addObject:StepsText];
            [self.mTrackersImgsArray addObject:StepsImage];
        }else if ([mText isEqualToString:@"Water"]) {
            [self.mTrackersArray addObject:WaterText];
            [self.mTrackersImgsArray addObject:WaterImage];
        }
    }
    //to check for hide/unhide the tracker
    NSMutableDictionary *mDict = [mAppDelegate.mGenericDataBase_ getTrackerOrderForDate];
    NSString *mVisibleTrackers = [mDict objectForKey:@"VisibleTrackers"];
    NSArray *mArray2 = [mVisibleTrackers componentsSeparatedByString:@","];
    mUnHideTrackersDict = [[NSMutableDictionary alloc]init];
    [self.mUnHideTrackersDict setValue:@"true" forKey:WeightText];
    [self.mUnHideTrackersDict setValue:@"true" forKey:MealText];
    [self.mUnHideTrackersDict setValue:@"true" forKey:ExerciseText];
    [self.mUnHideTrackersDict setValue:@"true" forKey:StepsText];
    [self.mUnHideTrackersDict setValue:@"true" forKey:WaterText];
    
    for (int i =0; i < mArray2.count; i++) {
        NSString *mText = [mArray2 objectAtIndex:i];
        
        if ([mText isEqualToString:@"Weight"]) {
            [self.mUnHideTrackersDict setValue:@"false" forKey:WeightText];
        }else if ([mText isEqualToString:@"Meal"]) {
            [self.mUnHideTrackersDict setValue:@"false" forKey:MealText];
        }else if ([mText isEqualToString:@"Exercise"]) {
            [self.mUnHideTrackersDict setValue:@"false" forKey:ExerciseText];
        }else if ([mText isEqualToString:@"Step"]) {
            [self.mUnHideTrackersDict setValue:@"false" forKey:StepsText];
        }else if ([mText isEqualToString:@"Water"]) {
            [self.mUnHideTrackersDict setValue:@"false" forKey:WaterText];
        }
    }
    //end

    NSString *imgName;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        imgName = @"topbar.png";
        [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = [[UIImage alloc ]init];
    }else{
        imgName = @"topbar1.png";
    }
    [mAppDelegate setNavControllerTitle:NSLocalizedString(@"EDIT_HOMEPAGE", nil) imageName:imgName forController:self];
    
    self.navigationItem.hidesBackButton=YES;
    self.navigationItem.leftBarButtonItem=nil;
    
    //[[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"menu.png"] title:nil target:self action:@selector(menuAction:) forController:self rightOrLeft:0];
    
    [[GenricUI instance] setNavigationItemButtonsWithBackGroundImage:[UIImage imageNamed:@"donebtn.png"] title:nil target:self action:@selector(doneAction:) forController:self rightOrLeft:1];
    [mAppDelegate hideEmptySeparators:self.mTrackersTblView];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        [self.mTrackersTblView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    [mAppDelegate hideEmptySeparators:self.mGoalsTblView];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        [self.mGoalsTblView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    self.mGoalsLbl.font = Bariol_Regular(22);
    self.mGoalsLbl.textColor = RGB_A(136, 136, 136, 1);
    self.mTrackersLbl.font = Bariol_Regular(22);
    self.mTrackersLbl.textColor = RGB_A(136, 136, 136, 1);
    self.mLbl1.font = Bariol_Regular(17);
    self.mLbl1.textColor = BLACK_COLOR;
    self.mlbl2.font = Bariol_Regular(17);
    self.mlbl2.textColor = BLACK_COLOR;
    self.mlbl3.font = Bariol_Regular(17);
    self.mlbl3.textColor = BLACK_COLOR;
    self.mlbl4.font = Bariol_Regular(17);
    self.mlbl4.textColor = BLACK_COLOR;
    self.mlbl5.font = Bariol_Regular(17);
    self.mlbl5.textColor = BLACK_COLOR;

    if ([mAppDelegate.mResponseMethods_.userType intValue] == 4) {
        //to load the goals in the local array
        mGoalsArray = [[NSMutableArray alloc]init];
        [mGoalsArray addObjectsFromArray:mAppDelegate.mLandingViewController.mMainGoalsArray];
        
        //to change the sequence of the goals
        NSArray *mSeqGolsArray = [mAppDelegate.mLandingViewController.mGoalOrder componentsSeparatedByString:@","];
        for (int iCount = 0; iCount < mSeqGolsArray.count; iCount++) {
            NSString *mMainstep = [NSString stringWithFormat:@"%d", [[mSeqGolsArray objectAtIndex:iCount]  intValue]];
            
            for (int iGoalCount = 0; iGoalCount < self.mGoalsArray.count; iGoalCount++) {
                NSString *mSubStep = [NSString stringWithFormat:@"%d", [[[self.mGoalsArray objectAtIndex:iGoalCount] objectForKey:@"GoalStep"]  intValue]];
                if ([mSubStep intValue] == [mMainstep intValue]) {
                    [self.mGoalsArray exchangeObjectAtIndex:iCount withObjectAtIndex:iGoalCount];

                }
                
            }
        }
        // to remove the hidden goals
        for (int i =0; i<self.mGoalsArray.count ; i++) {
            NSString *mGoalStep = [NSString stringWithFormat:@"%d", [[[self.mGoalsArray objectAtIndex:i] objectForKey:@"GoalStep"] intValue]];
            NSArray *mVisibleGoals = [mAppDelegate.mLandingViewController.mGoalsShown componentsSeparatedByString:@","];
             NSMutableDictionary *mDict = (NSMutableDictionary*)[self.mGoalsArray objectAtIndex:i];
            BOOL flag = FALSE;
            for (int j = 0; j < mVisibleGoals.count; j++) {
                NSString *mshownStep = [NSString stringWithFormat:@"%d", [[mVisibleGoals objectAtIndex:j]  intValue]];
                if ([mGoalStep intValue] == [mshownStep intValue] && !flag) {
                    flag = TRUE;
                }
            }
            //the step id is not hidden
            if (flag) {
                [mDict setValue:@"false" forKey:@"hidden"];
            }else{
                [mDict setValue:@"true" forKey:@"hidden"];

            }
            [self.mGoalsArray replaceObjectAtIndex:i withObject:mDict];

        }
        [self.mGoalsTblView setEditing:TRUE];
        [self.mTrackersTblView setEditing:TRUE];
        self.mGoalsTblView.allowsSelectionDuringEditing = TRUE;
        self.mTrackersTblView.allowsSelectionDuringEditing = TRUE;
        self.mGoalsTblView.frame = CGRectMake(self.mGoalsTblView.frame.origin.x, self.mGoalsTblView.frame.origin.y, self.mGoalsTblView.frame.size.width, [self caluclateGoalsTableHeight]);
        self.mTrackersLbl.frame = CGRectMake(self.mTrackersLbl.frame.origin.x, self.mGoalsTblView.frame.origin.y+self.mGoalsTblView.frame.size.height+40, self.mTrackersLbl.frame.size.width, self.mTrackersLbl.frame.size.height);
        self.mTrackersImgView.frame = CGRectMake(self.mTrackersImgView.frame.origin.x, self.mTrackersLbl.frame.origin.y+self.mTrackersLbl.frame.size.height+5, self.mTrackersImgView.frame.size.width, self.mTrackersImgView.frame.size.height);
        self.mTrackersTblView.frame = CGRectMake(self.mTrackersTblView.frame.origin.x, self.mTrackersImgView.frame.origin.y+self.mTrackersImgView.frame.size.height, self.mTrackersTblView.frame.size.width, self.mTrackersTblView.frame.size.height);
        
    }else
    {
        self.mGoalsLbl.hidden = TRUE;
        self.mGoalImgView.hidden = TRUE;
        self.mGoalsTblView.hidden = TRUE;
        self.mTrackersLbl.frame = CGRectMake(self.mTrackersLbl.frame.origin.x, self.mGoalsLbl.frame.origin.y, self.mTrackersLbl.frame.size.width, self.mTrackersLbl.frame.size.height);
        self.mTrackersImgView.frame = CGRectMake(self.mTrackersImgView.frame.origin.x, self.mGoalImgView.frame.origin.y, self.mTrackersImgView.frame.size.width, self.mTrackersImgView.frame.size.height);
        self.mTrackersTblView.frame = CGRectMake(0, self.mGoalsTblView.frame.origin.y, 320, 60*5);//each row hieght*n0.of rows
        [self.mTrackersTblView setEditing:TRUE];
        self.mTrackersTblView.allowsSelectionDuringEditing = TRUE;
        //self.mTrackersTblView.scrollEnabled = FALSE;
    }
    if ([[GenricUI instance] isiPhone5]) {
        self.mScrollView.frame = CGRectMake(0, 0, 320, 504);
    }
    self.mScrollView.contentSize = CGSizeMake(320, self.mTrackersTblView.frame.origin.y+self.mTrackersTblView.frame.size.height+20);
}
#pragma mark TABLE VIEW DELEGATE METHODS
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.mGoalsTblView) {
        return self.mGoalsArray.count;
    }else{
        return self.mTrackersArray.count;

    }
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.mTrackersTblView) {
        return 60;
    }else{
        //goal label
        UILabel *lGoalLbl = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 180, 15)];
        lGoalLbl.font = Bariol_Regular(17);
        lGoalLbl.textColor = BLACK_COLOR;
        lGoalLbl.lineBreakMode = LINE_BREAK_WORD_WRAP;
        lGoalLbl.numberOfLines = 0;
        lGoalLbl.textAlignment = UITextAlignmentLeft;
        lGoalLbl.backgroundColor = CLEAR_COLOR;
        
        lGoalLbl.text = [[self.mGoalsArray objectAtIndex:indexPath.row] objectForKey:@"Label"];
        CGSize size =  [lGoalLbl.text sizeWithFont:lGoalLbl.font constrainedToSize:CGSizeMake(lGoalLbl.frame.size.width, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
        return size.height+20;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"EditLandindingTableViewCell";
    
    EditLandindingTableViewCell *cell = (EditLandindingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray * topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"EditLandindingTableViewCell" owner:self options:nil];
        
        for(id currentObject in topLevelObjects)
        {
            if([currentObject isKindOfClass:[UITableViewCell class]])
            {
                cell = (EditLandindingTableViewCell *)currentObject;
                break;
            }
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.mBtn1.frame = CGRectMake(240, 25, 17.5, 10);//260
    cell.mBtn2.frame = CGRectMake(230, 0, 17.5+20, 60);

    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        cell.mBtn1.frame = CGRectMake(220, 25, 17.5, 10);//260
        cell.mBtn2.frame = CGRectMake(210, 0, 17.5+20, 60);

    }
    cell.mBtn1.tag = indexPath.row;
    cell.mBtn2.tag = indexPath.row;
  
    if (tableView == self.mGoalsTblView) {
        [cell.mBtn2 addTarget:self action:@selector(goalSelected:) forControlEvents:UIControlEventTouchUpInside];
        cell.mLbl1.textColor = BLACK_COLOR;
        cell.mLbl1.backgroundColor = CLEAR_COLOR;
        cell.mLbl1.font = Bariol_Regular(17);
        cell.mLbl1.frame = CGRectMake(15, 10, 180, 15);
        cell.mLbl1.numberOfLines = 0;
        cell.mLbl1.lineBreakMode = LINE_BREAK_WORD_WRAP;
        cell.mLbl1.text = [[self.mGoalsArray objectAtIndex:indexPath.row] objectForKey:@"Label"];
        CGSize size =  [ cell.mLbl1.text sizeWithFont: cell.mLbl1.font constrainedToSize:CGSizeMake( cell.mLbl1.frame.size.width, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
        cell.mLbl1.frame = CGRectMake(cell.mLbl1.frame.origin.x, cell.mLbl1.frame.origin.y, cell.mLbl1.frame.size.width, size.height);
        cell.mBtn2.frame = CGRectMake(cell.mBtn2.frame.origin.x, 0, cell.mBtn2.frame.size.width, size.height+20);//total row height
        cell.mBtn1.frame = CGRectMake(cell.mBtn1.frame.origin.x, (size.height+20-20)/2, cell.mBtn1.frame.size.width, cell.mBtn1.frame.size.height);//260
        //cell.mBtn2.backgroundColor = BLUE_COLOR;

        if ([[[self.mGoalsArray objectAtIndex:indexPath.row] objectForKey:@"hidden"] boolValue]) {
            [cell.mBtn2 setSelected:TRUE];
            [cell.mBtn1 setImage:[UIImage imageNamed:@"eyeiconslashed.png"] forState:UIControlStateNormal];
            cell.mLbl1.textColor = RGB_A(170, 170, 170, 1);
            
        }else{
            [cell.mBtn2 setSelected:FALSE];
            [cell.mBtn1 setImage:[UIImage imageNamed:@"eyeicon.png"] forState:UIControlStateNormal];
            
        }

        
    }else{
        
        [cell.mBtn2 addTarget:self action:@selector(TrackerSelected:) forControlEvents:UIControlEventTouchUpInside];
        UIImage *lImg = [UIImage imageNamed:[self.mTrackersImgsArray objectAtIndex:indexPath.row]];
        cell.mImgView1.frame = CGRectMake(15, 20, 20, 20);
        cell.mImgView1.contentMode = UIViewContentModeScaleAspectFit;
        cell.mImgView1.image = lImg;
        
        cell.mLbl1.text = [self.mTrackersArray objectAtIndex:indexPath.row];
        cell.mLbl1.textColor = BLACK_COLOR;
        cell.mLbl1.font = Bariol_Regular(17);
        cell.mLbl1.frame = CGRectMake(cell.mImgView1.frame.origin.x+cell.mImgView1.frame.size.width+10, 0, 100, 60);
        cell.mLbl1.numberOfLines = 0;
        cell.mLbl1.lineBreakMode = LINE_BREAK_WORD_WRAP;
        
        if ([[self.mUnHideTrackersDict objectForKey:[self.mTrackersArray objectAtIndex:indexPath.row]] boolValue]) {
            [cell.mBtn2 setSelected:TRUE];
            [cell.mBtn1 setImage:[UIImage imageNamed:@"eyeiconslashed.png"] forState:UIControlStateNormal];
            cell.mLbl1.textColor = RGB_A(170, 170, 170, 1);

        }else{
            [cell.mBtn2 setSelected:FALSE];
            [cell.mBtn1 setImage:[UIImage imageNamed:@"eyeicon.png"] forState:UIControlStateNormal];

        }
        
    }
    

    return cell;
}
- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) {
        // code
        for(UIView* view in tableView.subviews)
        {
            if([[[view class] description] isEqualToString:@"UITableViewWrapperView"])
            {
                for(UIView* viewTwo in view.subviews) {
                    if([[[viewTwo class] description] isEqualToString:@"EditLandindingTableViewCell"]) {
                        for(UIView* viewThree in viewTwo.subviews) {
                            if([[[viewThree class] description] isEqualToString:@"UITableViewCellScrollView"]) {
                                for(UIView* viewFour in viewThree.subviews) {
                                    if([[[viewFour class] description] isEqualToString:@"UITableViewCellReorderControl"]) {
                                        // Creates a new subview the size of the entire cell
                                        UIView *movedReorderControl = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetMaxX(viewFour.frame), CGRectGetMaxY(viewFour.frame))];
                                        // Adds the reorder control view to our new subview
                                        [movedReorderControl addSubview:viewFour];
                                        
                                        // Adds our new subview to the cell
                                        [cell addSubview:movedReorderControl];
                                        // CGStuff to move it to the left
                                        CGSize moveLeft = CGSizeMake(movedReorderControl.frame.size.width - viewFour.frame.size.width, movedReorderControl.frame.size.height - viewFour.frame.size.height);
                                        CGAffineTransform transform = CGAffineTransformIdentity;
                                        transform = CGAffineTransformTranslate(transform, -moveLeft.width, -moveLeft.height);
                                        // Performs the transform
                                        [movedReorderControl setTransform:transform];
                                        

                                        for(UIImageView* viewFive in viewFour.subviews) {
                                            // your stuff here
                                            viewFive.frame = CGRectMake(0, 60-(13.5/2), 23.5, 13.5);
                                            viewFive.image = [UIImage imageNamed:@"upanddownarrow.png"];
                                        }
                                        
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }else{
        for(UIView* view in cell.subviews)
        {
            if([[[view class] description] isEqualToString:@"UITableViewCellReorderControl"])
            {
                // Creates a new subview the size of the entire cell
                UIView *movedReorderControl = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetMaxX(view.frame), CGRectGetMaxY(view.frame))];
                // Adds the reorder control view to our new subview
                [movedReorderControl addSubview:view];
                
                // Adds our new subview to the cell
                [cell addSubview:movedReorderControl];
                // CGStuff to move it to the left
                CGSize moveLeft = CGSizeMake(movedReorderControl.frame.size.width - view.frame.size.width, movedReorderControl.frame.size.height - view.frame.size.height);
                CGAffineTransform transform = CGAffineTransformIdentity;
                transform = CGAffineTransformTranslate(transform, -moveLeft.width, -moveLeft.height);
                // Performs the transform
                [movedReorderControl setTransform:transform];
                
                //change the image
                for(UIImageView* cellGrip in view.subviews)
                {
                    if([cellGrip isKindOfClass:[UIImageView class]])
                        [cellGrip setImage:nil];
                    cellGrip.backgroundColor = [UIColor clearColor];
                    //cellGrip.frame = CGRectMake(50, 4, 50, 30);
                    cellGrip.frame = CGRectMake(0, 60-(13.5/2), 23.5, 13.5);
                    cellGrip.image = [UIImage imageNamed:@"upanddownarrow.png"];
                }
            }
        }

    }
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:
(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (indexPath.row == 0) // Don't move the first row
//        
//        return NO;
//    
//    
//
    if (tableView == self.mTrackersTblView) {
        if ([[self.mUnHideTrackersDict objectForKey:[self.mTrackersArray objectAtIndex:indexPath.row]] boolValue]) {
            return NO;
        }
    }else{
        if ([[[self.mGoalsArray objectAtIndex:indexPath.row] objectForKey:@"hidden"] boolValue]) {
            return NO;

        }
    }
    return YES;
    
}
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    
    if (tableView == self.mTrackersTblView) {
        NSString *stringToMove = [self.mTrackersArray objectAtIndex:sourceIndexPath.row];
        [self.mTrackersArray removeObjectAtIndex:sourceIndexPath.row];
        [self.mTrackersArray insertObject:stringToMove atIndex:destinationIndexPath.row];
        stringToMove = [self.mTrackersImgsArray objectAtIndex:sourceIndexPath.row];
        [self.mTrackersImgsArray removeObjectAtIndex:sourceIndexPath.row];
        [self.mTrackersImgsArray insertObject:stringToMove atIndex:destinationIndexPath.row];

    }else{
        NSString *stringToMove = [self.mGoalsArray objectAtIndex:sourceIndexPath.row];
        [self.mGoalsArray removeObjectAtIndex:sourceIndexPath.row];
        [self.mGoalsArray insertObject:stringToMove atIndex:destinationIndexPath.row];
    }
    
}
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if (tableView == self.mTrackersTblView) {
        if ([proposedDestinationIndexPath row] < [self.mTrackersArray count]) {
            return proposedDestinationIndexPath;
        }
        NSIndexPath *betterIndexPath = [NSIndexPath indexPathForRow:[self.mTrackersArray count]-1 inSection:0];
        return betterIndexPath;
    }else{
        if ([proposedDestinationIndexPath row] < [self.mGoalsArray count]) {
            return proposedDestinationIndexPath;
        }
        NSIndexPath *betterIndexPath = [NSIndexPath indexPathForRow:[self.mGoalsArray count]-1 inSection:0];
        return betterIndexPath;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
}

- (void)goalSelected:(UIButton*)btn{
    if ([btn isSelected]) {
        [btn setSelected:FALSE];
        NSMutableDictionary *mDict = (NSMutableDictionary*) [self.mGoalsArray objectAtIndex:btn.tag];
        [mDict setValue:@"false" forKey:@"hidden"];
        [self.mGoalsArray replaceObjectAtIndex:btn.tag withObject:mDict];
    }else{
        [btn setSelected:TRUE];
        NSMutableDictionary *mDict = (NSMutableDictionary*) [self.mGoalsArray objectAtIndex:btn.tag];
        [mDict setValue:@"true" forKey:@"hidden"];
        [self.mGoalsArray replaceObjectAtIndex:btn.tag withObject:mDict];
    }
    [self.mGoalsTblView reloadData];
}
- (void)TrackerSelected:(UIButton*)btn{
    if ([btn isSelected]) {
        [btn setSelected:FALSE];
        [self.mUnHideTrackersDict setValue:@"false" forKey:[self.mTrackersArray objectAtIndex:btn.tag]];
    }else{
        [btn setSelected:TRUE];
        [self.mUnHideTrackersDict setValue:@"true" forKey:[self.mTrackersArray objectAtIndex:btn.tag]];

    }
    [self.mTrackersTblView reloadData];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMGoalsLbl:nil];
    [self setMGoalsTblView:nil];
    [self setMTrackersLbl:nil];
    [self setMTrackersTblView:nil];
    [self setMGoalImgView:nil];
    [self setMTrackersImgView:nil];
    [super viewDidUnload];
}

- (NSString*)getTheKeyValueinDBforTracker:(NSString*)mTrackerText{
    NSString *mActualText;
    if ([mTrackerText isEqualToString:WeightText]) {
        mActualText = @"Weight";
    }else if ([mTrackerText isEqualToString:ExerciseText]) {
        mActualText = @"Exercise";
    }else if ([mTrackerText isEqualToString:MealText]) {
        mActualText = @"Meal";
    }else if ([mTrackerText isEqualToString:StepsText]) {
        mActualText = @"Step";
    }else if ([mTrackerText isEqualToString:WaterText]) {
        mActualText = @"Water";
    }
    return mActualText;
}
- (CGFloat)caluclateGoalsTableHeight{
    CGFloat height = 0;
    
    for (int i =0 ; i < self.mGoalsArray.count; i++) {
        //goal label
        UILabel *lGoalLbl = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 180, 15)];
        lGoalLbl.font = Bariol_Regular(17);
        lGoalLbl.textColor = BLACK_COLOR;
        lGoalLbl.lineBreakMode = LINE_BREAK_WORD_WRAP;
        lGoalLbl.numberOfLines = 0;
        lGoalLbl.textAlignment = UITextAlignmentLeft;
        lGoalLbl.backgroundColor = CLEAR_COLOR;
        
        lGoalLbl.text = [[self.mGoalsArray objectAtIndex:i] objectForKey:@"Label"];
        CGSize size =  [lGoalLbl.text sizeWithFont:lGoalLbl.font constrainedToSize:CGSizeMake(lGoalLbl.frame.size.width, 10000) lineBreakMode:LINE_BREAK_WORD_WRAP];
        height+=size.height+20;

    }
    return height;
}
- (void)doneAction:(id)sender {
    //to save the goals sequence and order for usertype 4
    if ([mAppDelegate.mResponseMethods_.userType intValue] == 4) {
        DLog(@"%@", self.mGoalsArray);
        //to check the number of goals hidden count
        int noOfHiddenGoals = 0;
        for (int iCount = 0; iCount < self.mGoalsArray.count; iCount++) {
            if ([[[self.mGoalsArray objectAtIndex:iCount] objectForKey:@"hidden"] boolValue]) {
                noOfHiddenGoals++;
            }
        }
        if (noOfHiddenGoals == self.mGoalsArray.count) {
            [UtilitiesLibrary showAlertViewWithTitle:@"Alert" :@"Un-hide atleast one goal."];
            return;
        }
         // to update the sequence of goals in the DB
        NSString *mGoalSequence = @"";
        for (int iCount = 0; iCount < self.mGoalsArray.count; iCount++) {
           mGoalSequence = [mGoalSequence stringByAppendingString:[NSString stringWithFormat:@"%d,",[[[self.mGoalsArray objectAtIndex:iCount] objectForKey:@"GoalStep"] intValue]]];
        }
        mGoalSequence = [mGoalSequence stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
        //to get the unhidden goal list
        NSString *mUnhiddenGoals = @"";
         for (int iCount = 0; iCount < self.mGoalsArray.count; iCount++) {
             if (![[[self.mGoalsArray objectAtIndex:iCount] objectForKey:@"hidden"] boolValue]) {
                  mUnhiddenGoals = [mUnhiddenGoals stringByAppendingString:[NSString stringWithFormat:@"%d,",[[[self.mGoalsArray objectAtIndex:iCount] objectForKey:@"GoalStep"] intValue]]];
             }
         }
        mUnhiddenGoals = [mUnhiddenGoals stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
        [mAppDelegate.mGenericDataBase_ updateGoalsOrder:mGoalSequence
                                           VisisbleGoals:mUnhiddenGoals];

    }
    DLog(@"%@", self.mUnHideTrackersDict);
    //to check the number of trackers hidden count
    int noOfHiddenTrackers = 0;
    NSArray *mValues = [self.mUnHideTrackersDict allValues];
    NSArray *mKeys = [self.mUnHideTrackersDict allKeys];
    for (int iValCount = 0; iValCount < mValues.count; iValCount++) {
        if ([[mValues objectAtIndex:iValCount] boolValue]) {
            noOfHiddenTrackers++;
        }
    }
    if (noOfHiddenTrackers >4) {
        [UtilitiesLibrary showAlertViewWithTitle:@"Alert" :@"Un-hide atleast one tracker."];
        return;
    }
    NSString *mTrackerSequence = @"";
    // to update the sequence in the DB
    for (int iCount = 0; iCount < self.mTrackersArray.count; iCount++) {
        NSString *mText = [self.mTrackersArray objectAtIndex:iCount];
        NSString *mActualText = [self getTheKeyValueinDBforTracker:mText];
        
        if (iCount == 0) {
            mTrackerSequence = mActualText;
        }else if (iCount < self.mTrackersArray.count){
            mTrackerSequence = [mTrackerSequence stringByAppendingString:@","];
            mTrackerSequence = [mTrackerSequence stringByAppendingString:mActualText];
        }else{
            mTrackerSequence = [mTrackerSequence stringByAppendingString:mActualText];
        }
    }
    //to get the unhidden tracker list
    NSString *mUnhiddenTrackers = @"";
    for (int iValCount = 0; iValCount < mValues.count; iValCount++) {
        if (![[mValues objectAtIndex:iValCount] boolValue]) {
            NSString *mActualText = [self getTheKeyValueinDBforTracker:[mKeys objectAtIndex:iValCount]];
            mUnhiddenTrackers=[mUnhiddenTrackers stringByAppendingString:mActualText];
            mUnhiddenTrackers=[mUnhiddenTrackers stringByAppendingString:@","];

        }
    }
    mUnhiddenTrackers = [mUnhiddenTrackers stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
    
    [mAppDelegate.mGenericDataBase_ updateTrackerOrder:mTrackerSequence
                                      VisisbleTrackers:mUnhiddenTrackers];
    
    
    [self.navigationController popViewControllerAnimated:TRUE];
}
@end
