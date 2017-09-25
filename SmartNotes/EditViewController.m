//
//  EditViewController.m
//  Transposer
//
//  Created by Conrad Koh on 20/7/15.
//  Copyright © 2015 ConradKoh. All rights reserved.
//

#import "EditViewController.h"
#import "Constants.h"

@interface EditViewController ()

@end

@implementation EditViewController{
    SmartNotesModel* model;
    NOTETYPE notetype;
    
}
@synthesize Button_Cancel;
@synthesize Button_Save;
@synthesize Button_Persist;
@synthesize TextView_Main;
@synthesize ImageView_TopBar;

- (void)viewDidLoad {
    [super viewDidLoad];
    model = [[SmartNotesModel alloc]init];
    TextView_Main.text = [[model GetEditingNote] GetNoteData];
    TextView_Main.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    //Tap to dismiss Keyboard
    [ImageView_TopBar setUserInteractionEnabled:YES];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [ImageView_TopBar addGestureRecognizer:tap];
    
    
    //Check what type of note this is
    if([TextView_Main.text rangeOfString:PERSISTENTNOTESPECIFIER].location == 0){
        notetype = PERSISTENT;
        [Button_Persist setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    }
    else{
        notetype = TRANSIENT;
        [Button_Persist setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillDisappear:(BOOL)animated{
    [self.view endEditing: YES];
}

-(void) dismissKeyboard{
    //[TextView_Main resignFirstResponder];
    [self.view endEditing:YES];
}

- (UIStatusBarStyle) preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)Button_Cancel_Touch_Up_Inside:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)Button_Save_Touch_Up_Inside:(id)sender {
    [model SaveEditingNote: TextView_Main.text];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)Button_Persist_Touch_Up_Inside:(id)sender {
    if(notetype == PERSISTENT){
        NSRange rangeOfPersist = [TextView_Main.text rangeOfString:PERSISTENTNOTESPECIFIER];
        notetype = TRANSIENT;
        [Button_Persist setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        if(rangeOfPersist.location == 0){
            NSString* newText = [[TextView_Main.text substringFromIndex:rangeOfPersist.length] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [TextView_Main setText:newText];
        }
        
    }
    else if(notetype == TRANSIENT){
        notetype = PERSISTENT;
        [Button_Persist setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        NSString* newText = [[[PERSISTENTNOTESPECIFIER stringByAppendingString:@" "]stringByAppendingString:TextView_Main.text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [TextView_Main setText:newText];
    }
}

- (void)textViewDidChange:(UITextView *)textView{
    if([textView isEqual:TextView_Main]){
        if([TextView_Main.text rangeOfString:PERSISTENTNOTESPECIFIER].location == 0){
            notetype = PERSISTENT;
            [Button_Persist setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        }
        else{
            notetype = TRANSIENT;
            [Button_Persist setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
}

-(void) keyboardDidShow:(NSNotification*) notification{
    NSDictionary* info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    self.TextView_Main.contentInset = UIEdgeInsetsMake(0,0, keyboardSize.height, 0);
    self.TextView_Main.scrollIndicatorInsets= self.TextView_Main.contentInset;
}

-(void) keyboardDidHide:(NSNotification*) notification{
    self.TextView_Main.contentInset = UIEdgeInsetsZero;
    self.TextView_Main.scrollIndicatorInsets = UIEdgeInsetsZero;
}

- (IBAction)Button_Copy_TouchUpInside:(id)sender {
    NSString* content = TextView_Main.text;
    
    NSUInteger startIdx = [TextView_Main.text rangeOfString:DELIMITER_COPYSTART].location + DELIMITER_COPYSTART.length;
    NSUInteger endIdx = [TextView_Main.text rangeOfString:DELIMITER_COPYEND].location;
    if(startIdx != NSNotFound && endIdx != NSNotFound && startIdx < endIdx){
        NSRange range = NSMakeRange(startIdx, endIdx - startIdx - 1);
        NSString* result = [[content substringWithRange:range] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        UIPasteboard* pb = [UIPasteboard generalPasteboard];
        [pb setString:result];
    }
}

@end
