//
//  FirstViewController.m
//  SmartNotes
//
//  Created by Conrad Koh on 2/8/15.
//  Copyright © 2015 ConradKoh. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController (){
    SmartNotesModel* _model;
}

@end

@implementation FirstViewController
@synthesize TextField_Input;
@synthesize TextView_Display_Data;
@synthesize TextView_Display_SearchResults;
@synthesize UIView_TextView_Container;
@synthesize Constraint_Bottom_Distance;
@synthesize Constraint_TextView_Display_Data_Bottom;
@synthesize TableView_noteView;
@synthesize UIView_ResponseView;
@synthesize Button_Hide_Keyboard;
@synthesize Constraint_Button_Hide_Keyboard_Bottom;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    _model = [[SmartNotesModel alloc]init];
    [TextView_Display_Data setHidden:YES];
    [Button_Hide_Keyboard setHidden:YES];
    
    [TextField_Input addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    TextField_Input.delegate = self;
    TableView_noteView.delegate = self;
    TableView_noteView.dataSource = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) textFieldDidChange: (UIControlEvents*) event{
    NSArray* searchResults = [_model GetMatchingNotes:TextField_Input.text];
    NSMutableArray* searchResultsStr = [[NSMutableArray alloc]init];
    for(SmartNote* note in searchResults){
        NSString* noteData = [note GetNoteData];
        [searchResultsStr addObject:noteData];
    }
    [TextView_Display_Data setDataDetectorTypes:UIDataDetectorTypeNone];
    TextView_Display_Data.text = [searchResultsStr componentsJoinedByString:@"\n"];
    [TextView_Display_Data setDataDetectorTypes:UIDataDetectorTypeAll];
    
    [TableView_noteView reloadData];
    if([TextField_Input.text isEqualToString:@""]){
        [TextView_Display_Data setHidden:YES];
    }
    else{
        [TextView_Display_Data setHidden:NO];
    }
}

- (BOOL)textFieldShouldReturn:(nonnull UITextField *)textField{
    [textField resignFirstResponder];
    NSString* newNoteData = textField.text;
    [_model AddNote:newNoteData];
    textField.text = @"";
    if(textField == TextField_Input){
        [TextView_Display_Data setHidden:YES];
    }
    [TableView_noteView reloadData];
    return NO;
}

-(void) keyboardWillShow:(NSNotification*) notification{
    [TextField_Input setTranslatesAutoresizingMaskIntoConstraints:YES];
    [TextView_Display_Data setTranslatesAutoresizingMaskIntoConstraints:YES];
    [Button_Hide_Keyboard setTranslatesAutoresizingMaskIntoConstraints:YES];
    
    CGFloat offset = -258 + 40 + 55;
    [TableView_noteView setContentInset:UIEdgeInsetsMake(0, 0, -offset, 0)];
    [TableView_noteView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, -offset, 0)];
    
    CGRect textfieldFrame = TextField_Input.frame;
    //textfieldFrame.origin.y = textfieldFrame.origin.y - 258 + 40;
    textfieldFrame.origin.y = textfieldFrame.origin.y + offset;
    textfieldFrame.size.height = 30;

    CGRect textViewFrame = TextView_Display_Data.frame;
    textViewFrame.origin.y = textViewFrame.origin.y + offset;
    
    CGRect buttonHideKeyboardFrame = Button_Hide_Keyboard.frame;
    buttonHideKeyboardFrame.origin.y = buttonHideKeyboardFrame.origin.y + offset;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.29];
    
    [self.view removeConstraint:Constraint_Bottom_Distance];
    [self.view removeConstraint:Constraint_TextView_Display_Data_Bottom];
    [self.view removeConstraint:Constraint_Button_Hide_Keyboard_Bottom];
    [TextField_Input setFrame:textfieldFrame];
    [TextView_Display_Data setFrame:textViewFrame];
    [Button_Hide_Keyboard setFrame: buttonHideKeyboardFrame];
    
    [Button_Hide_Keyboard setHidden:NO];
    [self.view updateConstraintsIfNeeded];
    [UIView commitAnimations];
}

-(void) keyboardWillHide:(NSNotification*) notification{
    [TextField_Input setTranslatesAutoresizingMaskIntoConstraints:YES];
    [TextView_Display_Data setTranslatesAutoresizingMaskIntoConstraints:YES];
    [Button_Hide_Keyboard setTranslatesAutoresizingMaskIntoConstraints:YES];
    
    CGFloat offset = 258 - 40 - 55;
    [TableView_noteView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [TableView_noteView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, -offset, 0)];
    

    
    CGRect textfieldFrame = TextField_Input.frame;
    textfieldFrame.origin.y = textfieldFrame.origin.y + offset;
    textfieldFrame.size.height = 30;
    
    CGRect textViewFrame = TextView_Display_Data.frame;
    textViewFrame.origin.y = textViewFrame.origin.y + offset;
    
    CGRect buttonHideKeyboardFrame = Button_Hide_Keyboard.frame;
    buttonHideKeyboardFrame.origin.y = buttonHideKeyboardFrame.origin.y + offset;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [self.view removeConstraint:Constraint_Bottom_Distance];
    [self.view removeConstraint:Constraint_TextView_Display_Data_Bottom];
    [self.view removeConstraint:Constraint_Button_Hide_Keyboard_Bottom];
    
    [TextField_Input setFrame:textfieldFrame];
    [TextView_Display_Data setFrame:textViewFrame];
    [Button_Hide_Keyboard setFrame:buttonHideKeyboardFrame];
    
    [Button_Hide_Keyboard setHidden:YES];
    [self.view updateConstraintsIfNeeded];
    [UIView commitAnimations];
}

- (void)viewWillAppear:(BOOL)animated{
    [TableView_noteView reloadData];
}
- (IBAction)TextField_Input_Editing_Did_Begin:(id)sender {

}
- (IBAction)TextField_Input_Editing_Did_End:(id)sender {
}

- (IBAction)Button_Hide_Keyboard_Touch_Up_Inside:(id)sender {
    TextField_Input.text = @"";
    [TextView_Display_Data setHidden:YES];
    [TextField_Input resignFirstResponder];
}

#pragma TableViewInit
-(NSInteger) numberOfSectionsInTableView:(nonnull UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSUInteger count = 0;
    if(tableView == TableView_noteView){
        return [_model GetSearchView].count;
    }
    return count;
}

-(nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    NSString* cellIdentifier = @"cellBase";
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];;
    
    [cell setBackgroundColor: [[UIColor alloc] initWithRed:20 green:30 blue:30 alpha:0.1]];
    [cell.textLabel setTextColor:[UIColor blackColor]];
    [cell.detailTextLabel setTextColor:[UIColor grayColor]];
    //Main View
    if(tableView == TableView_noteView){
//        
//        //        Add/Edit buttons
//        UIButton* addButton = [[UIButton alloc]initWithFrame:(CGRectMake(5, 6, 40, 40))];
//        UIButton* editButton = [[UIButton alloc]initWithFrame:(CGRectMake(45, 6, 40, 40))];
//        
//        //        UIButton* addButton = [[UIButton alloc]initWithFrame:(CGRectMake(290, 6, 40, 40))];
//        //        UIButton* editButton = [[UIButton alloc]initWithFrame:(CGRectMake(335, 6, 40, 40))];
//        [addButton setImage:[UIImage imageNamed:@"Icon_Button_Add_Small"] forState:UIControlStateNormal];
//        [editButton setImage:[UIImage imageNamed:@"Icon_Button_Edit_Small"] forState:UIControlStateNormal];
//        [addButton setTag:indexPath.row];
//        [editButton setTag:indexPath.row];
//        
//        [addButton addTarget:self action:@selector(MainAddButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//        [editButton addTarget:self action:@selector(MainEditButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//        
//        [cell addSubview:addButton];
//        [cell addSubview:editButton];
//        [cell setIndentationWidth:85];
//        [cell setIndentationLevel:1];
//        
//        // cell.frame.size.width = 200;
//        
//        
        cell.textLabel.text = [_model SearchNoteTitleAtIndex:indexPath.row];
        cell.detailTextLabel.text = [_model SearchNoteDetailAtIndex: indexPath.row];
    }
    //Search Bar
//    else if(tableView == self.searchDisplayController.searchResultsTableView){
//        
//        
//        //Add/Edit buttons
//        UIButton* addButton = [[UIButton alloc]initWithFrame:(CGRectMake(5, 6, 40, 40))];
//        UIButton* editButton = [[UIButton alloc]initWithFrame:(CGRectMake(45, 6, 40, 40))];
//        [addButton setImage:[UIImage imageNamed:@"Icon_Button_Add_Small"] forState:UIControlStateNormal];
//        [editButton setImage:[UIImage imageNamed:@"Icon_Button_Edit_Small"] forState:UIControlStateNormal];
//        [addButton setTag:indexPath.row];
//        [editButton setTag:indexPath.row];
//        
//        [addButton addTarget:self action:@selector(SearchAddButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//        [editButton addTarget:self action:@selector(SearchEditButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//        
//        [cell addSubview:addButton];
//        [cell addSubview:editButton];
//        [cell setIndentationWidth:85];
//        [cell setIndentationLevel:1];
//        
//        
//        NSString* song = [searchResults objectAtIndex:indexPath.row];
//        NSRange rangeOfNewLineChar = [song rangeOfString:@"\n"];
//        if(rangeOfNewLineChar.location!= NSNotFound){
//            NSString* title = [[song substringToIndex: rangeOfNewLineChar.location] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//            NSString* details = [[song substringFromIndex:rangeOfNewLineChar.location + 1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//            cell.textLabel.text = title;
//            cell.detailTextLabel.text = details;
//        }
//        else{
//            cell.textLabel.text = song;
//        }
//    }
    
    return cell;
}

- (nullable NSIndexPath *)tableView:(nonnull UITableView *)tableView willSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return indexPath;
}

- (void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{

    if(tableView == TableView_noteView){
        [_model SetEditingNote:indexPath.row];
        UIStoryboard* storyboard = [self storyboard];
        UIViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"EditView"];
        [self presentViewController:vc animated:YES completion:nil];
        [TableView_noteView deselectRowAtIndexPath:indexPath animated:YES];
        
    }
    
}

//delete function
- (void)tableView:(nonnull UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    if(tableView == TableView_noteView){
        if(editingStyle == UITableViewCellEditingStyleDelete){
            if([TextField_Input.text isEqualToString:@""]){
                
                [_model DeleteNoteFromView:indexPath.row];
                [TableView_noteView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
    }
    
}

@end
