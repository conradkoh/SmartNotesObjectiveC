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
    MODE _mode;
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
@synthesize Button_Toggle_Persist;
@synthesize UIImageView_TextField_Background;
@synthesize ImageView_TopBar;

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
    _mode = DEFAULT;
    
    //Application enter background
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    //Tap to dismiss Keyboard
    [ImageView_TopBar setUserInteractionEnabled:YES];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [ImageView_TopBar addGestureRecognizer:tap];
    
    //Long press on textview
//    UILongPressGestureRecognizer* longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(textViewLongPressed:)];
//    [TextView_Display_Data addGestureRecognizer:longPress];
}

//- (void) textViewLongPressed:(NSObject*) sender{
//    if([TextField_Input isFirstResponder]){
//        [TextView_Display_Data setSelectedRange:NSMakeRange(0, [TextView_Display_Data.text length])];
//        UITextPosition* start = [TextView_Display_Data positionFromPosition:[TextView_Display_Data beginningOfDocument] offset:0];
//        UITextPosition* end = [TextView_Display_Data positionFromPosition:[TextView_Display_Data beginningOfDocument] offset:[TextView_Display_Data.text length]];
//        UITextRange* selectionRange = [TextView_Display_Data textRangeFromPosition:start toPosition:end];
//        //[TextView_Display_Data setSelectedTextRange:selectionRange];
//        CGRect rect = [TextView_Display_Data firstRectForRange:selectionRange];
//        [TextView_Display_Data drawRect:rect];
//        
//    }
//}
- (void)dismissKeyboard{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) applicationWillEnterBackground{
    dispatch_async(dispatch_get_main_queue(), ^{
        [TextField_Input becomeFirstResponder];
    });
}
- (UIStatusBarStyle) preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

-(void) textFieldDidChange: (UIControlEvents*) event{
    //INITIALIZATION
    
    //END INTIALIZATION
    TextField_Input.text = [Algorithms ReplaceAllDaysWithDates:TextField_Input.text];
    //END INPUT PARSING

    //SEARCH
    
//    NSArray* searchResults = [_model GetMatchingNotesSorted:TextField_Input.text];
//    NSMutableArray* searchResultsStr = [[NSMutableArray alloc]init];
//    for(SmartNote* note in searchResults){
//        NSString* noteData = [note GetNoteData];
//        [searchResultsStr addObject:noteData];
//    }
//    [TextView_Display_Data setDataDetectorTypes:UIDataDetectorTypeNone];
//    TextView_Display_Data.text = [searchResultsStr componentsJoinedByString:SEPERATOR];
//    [TextView_Display_Data setDataDetectorTypes:UIDataDetectorTypeAll];
    
    [_model GetMatchingNotesSorted:TextField_Input.text];
    [TextView_Display_Data setDataDetectorTypes:UIDataDetectorTypeNone];
    TextView_Display_Data.text = [_model GetSearchNoteViewString];
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
    if(_mode == PERSIST){
        textField.text = [PERSISTENTNOTESPECIFIER stringByAppendingString:@" "];
    }
    else{
        textField.text = @"";
    }
    
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
    CGRect statusBarFrameSize = [[UIApplication sharedApplication]statusBarFrame];
    
    CGFloat offset = -(keyboardFrame.size.height) - statusBarFrameSize.size.height + 20;
    
    //check if status bar is large version when hotspot is on

    if(statusBarFrameSize.size.height > 20){
        keyboardFrame = CGRectMake(keyboardFrame.origin.x, keyboardFrame.origin.y - 20, keyboardFrame.size.width, keyboardFrame.size.height);
    }
    
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
    [TableView_noteView setContentInset:UIEdgeInsetsMake(0, 0, offset, 0)];
    [TableView_noteView setScrollIndicatorInsets:UIEdgeInsetsMake(0, 0, offset, 0)];
    
    CGRect textfieldFrame = TextField_Input.frame;
    CGRect textfieldBackgroundFrame = UIImageView_TextField_Background.frame;
    CGRect textViewFrame = TextView_Display_Data.frame;
    CGRect buttonHideKeyboardFrame = Button_Hide_Keyboard.frame;
    CGFloat padding = (textfieldBackgroundFrame.size.height - textfieldFrame.size.height) / 2;
    

    textfieldFrame.origin.y = textfieldFrame.origin.y + offset - padding;
    
    //textfieldFrame.origin.y = viewFrame.size.height - textfieldFrame.size.height-150;
    textfieldFrame.size.width += Button_Hide_Keyboard.frame.size.width;
    
    
    textfieldBackgroundFrame.origin.y = textfieldBackgroundFrame.origin.y + offset - padding;
    
    
    textViewFrame.origin.y = textViewFrame.origin.y + offset - padding;
    
    
    buttonHideKeyboardFrame.origin.y = buttonHideKeyboardFrame.origin.y + offset - padding;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    
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
    TextView_Display_Data.text = [_model GetSearchNoteViewString];
    [TextField_Input becomeFirstResponder];
}
- (IBAction)TextField_Input_Editing_Did_Begin:(id)sender {

}
- (IBAction)TextField_Input_Editing_Did_End:(id)sender {
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

        cell.textLabel.text = [_model SearchNoteTitleAtIndex:indexPath.row];
        cell.detailTextLabel.text = [_model SearchNoteDetailAtIndex: indexPath.row];
    }
    return cell;
}

- (nullable NSIndexPath *)tableView:(nonnull UITableView *)tableView willSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return indexPath;
}

//tap to select
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


- (IBAction)Button_Toggle_Persist_Touch_Up_Inside:(id)sender {
    NSString* pNoteSpec = [PERSISTENTNOTESPECIFIER stringByAppendingString:@" "]; //PERSISTENTNOTESPECIFIER IS FOUND IN SMARTNOTE.H
    if(_mode == DEFAULT){
        _mode = PERSIST;
        TextField_Input.text = [pNoteSpec stringByAppendingString:TextField_Input.text];
        [Button_Toggle_Persist setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        //Button_Toggle_Persist.titleLabel.text = @"h";
    }
    else{
        NSArray* tokens = [TextField_Input.text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if([[tokens objectAtIndex:0] isEqualToString:PERSISTENTNOTESPECIFIER]) {
            NSRange pNoteSpecIdx = [TextField_Input.text rangeOfString:pNoteSpec];
            if(pNoteSpecIdx.location != NSNotFound){
                TextField_Input.text = [TextField_Input.text substringFromIndex:pNoteSpecIdx.location + [pNoteSpec length]];
            }
        }
        [Button_Toggle_Persist setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //Button_Toggle_Persist.titleLabel.textColor = [UIColor whiteColor];
        _mode = DEFAULT;
    }
}
- (IBAction)Button_Export_TouchUpInside:(id)sender {
    UIPasteboard* pb = [UIPasteboard generalPasteboard];
    [pb setString:[_model ExportAll]];
     
}

- (IBAction)Button_Hide_Keyboard_Touch_Up_Inside:(id)sender {
    //[TextView_Display_Data setHidden:YES];
    [TableView_noteView reloadData];
    [TextField_Input resignFirstResponder];
}
@end
