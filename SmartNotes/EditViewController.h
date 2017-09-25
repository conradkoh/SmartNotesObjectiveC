//
//  EditViewController.h
//  Transposer
//
//  Created by Conrad Koh on 20/7/15.
//  Copyright © 2015 ConradKoh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SmartNotesModel.h"
#import "Typedefinitions.h"
@interface EditViewController : UIViewController <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *Button_Cancel;
@property (weak, nonatomic) IBOutlet UIButton *Button_Save;
@property (weak, nonatomic) IBOutlet UITextView *TextView_Main;
@property (weak, nonatomic) IBOutlet UIButton *Button_Persist;
@property (weak, nonatomic) IBOutlet UIImageView *ImageView_TopBar;
- (IBAction)Button_Cancel_Touch_Up_Inside:(id)sender;
- (IBAction)Button_Save_Touch_Up_Inside:(id)sender;

@end
