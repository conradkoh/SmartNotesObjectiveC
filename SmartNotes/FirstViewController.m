//
//  FirstViewController.m
//  SmartNotes
//
//  Created by Conrad Koh on 2/8/15.
//  Copyright © 2015 ConradKoh. All rights reserved.
//

#import "FirstViewController.h"
NSString* const SEPERATOR = @"\n---------------------\n";

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
@synthesize Constraint_Button_Hide_Keyboard_Bottom;
@synthesize Constraint_TextField_Input_Right;
@synthesize Constraint_UIImageView_TextField_Input_Background_Bottom;
@synthesize TableView_noteView;
@synthesize UIView_ResponseView;
@synthesize Button_Hide_Keyboard;
@synthesize UIImageView_TextField_Background;

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
    //INITIALIZATION
    
    //END INTIALIZATION
    
    //
    //INPUT PARSING
//    NSArray* inputTokens = [TextField_Input.text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    NSMutableArray* inputTokensMutable = [[NSMutableArray alloc]initWithArray:inputTokens];
//    for(int tokenIdx = 0; tokenIdx < [inputTokensMutable count]; ++tokenIdx){
////        NSDate* now = [NSDate date];
////        for(int dayOffset = 1; dayOffset < 8; ++dayOffset){
////            NSDate* expectedDate = [now dateByAddingTimeInterval:dayOffset*24*60*60];
////            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
////            [dateFormatter setDateFormat:@"EEEE"];
////            NSString* expectedDayString = [dateFormatter stringFromDate:expectedDate];
////            if([[inputTokensMutable objectAtIndex:tokenIdx] isEqualToString: expectedDayString]){
////                [dateFormatter setDateFormat:@"dd-MM-YYYY"];
////                NSString* datex = [dateFormatter stringFromDate:expectedDate];
////                [inputTokensMutable replaceObjectAtIndex:tokenIdx withObject: datex];
////                break;
////            }
////        }
//        NSString* date = [Algorithms ConvertDayToDate:[inputTokensMutable objectAtIndex:tokenIdx]];
//        if(date != nil){
//            if(tokenIdx > 0 &&
//               ![[inputTokensMutable objectAtIndex:(tokenIdx - 1)] isEqualToString:@"next"] &&
//               ![[inputTokensMutable objectAtIndex:(tokenIdx - 1)] isEqualToString:@"every"] &&
//               ![[inputTokensMutable objectAtIndex:(tokenIdx - 1)] isEqualToString:@"last"])
//            {
//                [synonyms addObject:[inputTokensMutable objectAtIndex:tokenIdx]];
//                [inputTokensMutable replaceObjectAtIndex:tokenIdx withObject:date];
//            }
//            
//        }
//    }
//    
//    TextField_Input.text = [inputTokensMutable componentsJoinedByString:@" "];
    TextField_Input.text = [Algorithms ReplaceAllDaysWithDates:TextField_Input.text];
    //END INPUT PARSING

    //SEARCH
    
    NSArray* searchResults = [_model GetMatchingNotesSorted:TextField_Input.text];
    NSMutableArray* searchResultsStr = [[NSMutableArray alloc]init];
    for(SmartNote* note in searchResults){
        NSString* noteData = [note GetNoteData];
        [searchResultsStr addObject:noteData];
    }
    [TextView_Display_Data setDataDetectorTypes:UIDataDetectorTypeNone];
    TextView_Display_Data.text = [searchResultsStr componentsJoinedByString:SEPERATOR];
    [TextView_Display_Data setDataDetectorTypes:UIDataDetectorTypeAll];
    
    [TableView_noteView reloadData];
    if([TextField_Input.text isEqualToString:@""]){
        [TextView_Display_Data setHidden:YES];
    }
    else{
        [TextView_Display_Data setHidden:NO];
    }
    //END SEARCH
    
}

- (BOOL)textFieldShouldReturn:(nonnull UITextField *)textField{
    //[textField resignFirstResponder];
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
    [UIImageView_TextField_Background setTranslatesAutoresizingMaskIntoConstraints:YES];
    [self.view setTranslatesAutoresizingMaskIntoConstraints:YES];
    
    CGRect keyboardFrame = [[[notification userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect screenFrame = [UIScreen mainScreen].bounds;
    
    
    CGFloat offset = -(keyboardFrame.size.height);
    
    [TableView_noteView setContentInset:UIEdgeInsetsMake(0, 0, -(offset - TextView_Display_Data.frame.size.height), 0)];
    [TableView_noteView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, -(offset - TextView_Display_Data.frame.size.height), 0)];
    
    CGRect textfieldFrame = TextField_Input.frame;
    CGRect buttonHideKeyboardFrame = Button_Hide_Keyboard.frame;
    CGRect textfieldBackgroundFrame = UIImageView_TextField_Background.frame;
    CGRect textViewFrame = TextView_Display_Data.frame;
    CGFloat padding = (textfieldBackgroundFrame.size.height - textfieldFrame.size.height) / 2;
    
    textfieldFrame.origin.y = keyboardFrame.origin.y - textfieldFrame.size.height - padding;
    
    buttonHideKeyboardFrame.origin.y = keyboardFrame.origin.y - buttonHideKeyboardFrame.size.height - padding;

    textfieldBackgroundFrame.origin.y = keyboardFrame.origin.y - textfieldBackgroundFrame.size.height;

    textViewFrame.origin.y = keyboardFrame.origin.y - textfieldBackgroundFrame.size.height - textViewFrame.size.height;
    textfieldFrame.size.width = screenFrame.size.width - Button_Hide_Keyboard.frame.size.width;


    [UIView beginAnimations:nil context:nil];
    NSTimeInterval animationDuration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView setAnimationDuration:animationDuration];
    UIViewAnimationCurve animationCurve = [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] floatValue];
    [UIView setAnimationCurve:animationCurve];
    
    [self.view removeConstraint:Constraint_Bottom_Distance];
    [self.view removeConstraint:Constraint_TextView_Display_Data_Bottom];
    [self.view removeConstraint:Constraint_Button_Hide_Keyboard_Bottom];
    [self.view removeConstraint:Constraint_TextField_Input_Right];
    [self.view removeConstraint:Constraint_UIImageView_TextField_Input_Background_Bottom];
    [TextField_Input setFrame:textfieldFrame];
    [TextView_Display_Data setFrame:textViewFrame];
    [Button_Hide_Keyboard setFrame: buttonHideKeyboardFrame];
    [UIImageView_TextField_Background setFrame:textfieldBackgroundFrame];
    
    [Button_Hide_Keyboard setHidden:NO];
    [self.view updateConstraintsIfNeeded];
    [UIView commitAnimations];
}

-(void) keyboardWillHide:(NSNotification*) notification{
    [TextField_Input setTranslatesAutoresizingMaskIntoConstraints:YES];
    [TextView_Display_Data setTranslatesAutoresizingMaskIntoConstraints:YES];
    [Button_Hide_Keyboard setTranslatesAutoresizingMaskIntoConstraints:YES];
    [UIImageView_TextField_Background setTranslatesAutoresizingMaskIntoConstraints:YES];
    [self.view setTranslatesAutoresizingMaskIntoConstraints:YES];
    
    CGRect keyboardFrame = [[[notification userInfo] valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect screenFrame = [UIScreen mainScreen].bounds;
    CGRect viewFrame = self.view.frame;
    
    CGFloat uiBarHeight = 42;
    
    CGFloat offset = keyboardFrame.size.height - uiBarHeight;
    
    [TableView_noteView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    [TableView_noteView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, -offset, 0)];
    
    CGRect textfieldFrame = TextField_Input.frame;
    CGRect textfieldBackgroundFrame = UIImageView_TextField_Background.frame;
    CGRect textViewFrame = TextView_Display_Data.frame;
    CGRect buttonHideKeyboardFrame = Button_Hide_Keyboard.frame;
    CGFloat padding = (textfieldBackgroundFrame.size.height - textfieldFrame.size.height) / 2;
    

    textfieldFrame.origin.y = textfieldFrame.origin.y + offset - padding;
    
    //textfieldFrame.origin.y = viewFrame.size.height - textfieldFrame.size.height-150;
    textfieldFrame.size.width += Button_Hide_Keyboard.frame.size.width;
    
    
    textfieldBackgroundFrame.origin.y = textfieldBackgroundFrame.origin.y + offset - padding;
    
    
    textViewFrame.origin.y = textViewFrame.origin.y + offset;
    
    
    buttonHideKeyboardFrame.origin.y = buttonHideKeyboardFrame.origin.y + offset - padding;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [self.view removeConstraint:Constraint_Bottom_Distance];
    [self.view removeConstraint:Constraint_TextView_Display_Data_Bottom];
    [self.view removeConstraint:Constraint_Button_Hide_Keyboard_Bottom];
    [self.view removeConstraint:Constraint_TextField_Input_Right];
    [self.view removeConstraint:Constraint_UIImageView_TextField_Input_Background_Bottom];
    
    [Button_Hide_Keyboard setHidden:YES];
    [TextField_Input setFrame:textfieldFrame];
    [TextView_Display_Data setFrame:textViewFrame];
    [Button_Hide_Keyboard setFrame:buttonHideKeyboardFrame];
    [UIImageView_TextField_Background setFrame:textfieldBackgroundFrame];
    
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
    //TextField_Input.text = @"";
    [TextView_Display_Data setHidden:YES];
    //[_model ResetViews];
    [TableView_noteView reloadData];
    [TextField_Input resignFirstResponder];
}

#pragma TableViewInit
-(NSInteger) numberOfSectionsInTableView:(nonnull UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSUInteger count = 0;
    if(tableView == TableView_noteView){
        count = [_model GetSearchView].count;
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
            [_model DeleteNoteFromView:indexPath.row];
            [TableView_noteView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    
}

@end
