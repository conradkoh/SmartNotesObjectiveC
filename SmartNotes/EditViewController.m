//
//  EditViewController.m
//  Transposer
//
//  Created by Conrad Koh on 20/7/15.
//  Copyright © 2015 ConradKoh. All rights reserved.
//

#import "EditViewController.h"

@interface EditViewController ()

@end

@implementation EditViewController{
    SmartNotesModel* model;
}
@synthesize Button_Cancel;
@synthesize Button_Save;
@synthesize TextView_Main;

- (void)viewDidLoad {
    [super viewDidLoad];
    model = [[SmartNotesModel alloc]init];
    TextView_Main.text = [[model GetEditingNote] GetNoteData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    //Tap to hide keyboard
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tapGesture];
    //tapGesture.delegate = self;
    // Do any additional setup after loading the view.
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
    return UIStatusBarStyleLightContent;
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


@end
