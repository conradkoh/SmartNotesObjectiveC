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

- (void)viewDidLoad {
    [super viewDidLoad];
    model = [[SmartNotesModel alloc]init];
    // Do any additional setup after loading the view, typically from a nib.
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

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
