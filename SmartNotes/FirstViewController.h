//
//  FirstViewController.h
//  SmartNotes
//
//  Created by Conrad Koh on 2/8/15.
//  Copyright © 2015 ConradKoh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SmartNotesModel.h"

@interface FirstViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *TextView_Display_Data;
@property (weak, nonatomic) IBOutlet UITextView *TextView_Display_SearchResults;
@property (weak, nonatomic) IBOutlet UITextField *TextField_Input;
@property (weak, nonatomic) IBOutlet UIView *UIView_TextView_Container;
@property (weak, nonatomic) IBOutlet UITableView *TableView_noteView;
- (IBAction)TextField_Input_Editing_Did_Begin:(id)sender;
- (IBAction)TextField_Input_Editing_Did_End:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Constraint_Bottom_Distance;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Constraint_TextView_Display_Data_Bottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Constraint_Button_Hide_Keyboard_Bottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Constraint_TextField_Input_Right;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Constraint_UIImageView_TextField_Input_Background_Bottom;

@property (weak, nonatomic) IBOutlet UIView *UIView_ResponseView;
@property (weak, nonatomic) IBOutlet UIButton *Button_Hide_Keyboard;
@property (weak, nonatomic) IBOutlet UIButton *Button_Toggle_Persist;
@property (weak, nonatomic) IBOutlet UIImageView *UIImageView_TextField_Background;

- (IBAction)Button_Hide_Keyboard_Touch_Up_Inside:(id)sender;
- (IBAction)Button_Toggle_Persist_Touch_Up_Inside:(id)sender;

@end

