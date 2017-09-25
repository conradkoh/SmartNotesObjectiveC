//
//  SecondViewController.m
//  SmartNotes
//
//  Created by Conrad Koh on 2/8/15.
//  Copyright © 2015 ConradKoh. All rights reserved.
//

#import "ImportViewController.h"

@interface ImportViewController (){
    SmartNotesModel* model;
}
@property (weak, nonatomic) IBOutlet UITextView *UITextView_ImportExportData;

@end

@implementation ImportViewController
@synthesize TextView_Rules;
@synthesize ImageView_TopBar;

- (void)viewDidLoad {
    [super viewDidLoad];
    model = [[SmartNotesModel alloc]init];
    
    //Tap to dismiss Keyboard
    [ImageView_TopBar setUserInteractionEnabled:YES];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [ImageView_TopBar addGestureRecognizer:tap];
}
- (IBAction)Button_Import_Touch_Up_Inside:(id)sender {
    NSString* data = _UITextView_ImportExportData.text;
    [model LoadDataFromString:data];
}
- (IBAction)Button_Export_Touch_Up_Inside:(id)sender {
    NSString* data = [model ExportAll];
    _UITextView_ImportExportData.text = data;
    [[UIPasteboard generalPasteboard] setString:data];
}
- (IBAction)Button_Paste_Touch_Up_Inside:(id)sender {
    NSString* data = [[UIPasteboard generalPasteboard] string];
    _UITextView_ImportExportData.text = data;
}
- (IBAction)Button_Clear_Touch_Up_Inside:(id)sender {
    [model DeleteAllNotes];
}

-(void) dismissKeyboard{
    //[TextView_Main resignFirstResponder];
    [self.view endEditing:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
