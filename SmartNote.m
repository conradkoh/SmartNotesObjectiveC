//
//  SmartNote.m
//  SmartNotes
//
//  Created by Conrad Koh on 8/8/15.
//  Copyright © 2015 ConradKoh. All rights reserved.
//

#import "SmartNote.h"

static NSString* const blockDelimiter = @"\n<blockdelimiter>\n";
@implementation SmartNote{
    NSString* _noteData;
    NSString* _noteTitle;
    NSString* _noteDetail;
}

- (instancetype)init{
    self = [super init];
    return self;
}

- (NSString* )GetNoteData{
    return _noteData;
}


-(void) SetNoteData: (NSString*) noteData{
    _noteData = [noteData copy];
}

- (NSString *)GetNoteTitle{
    NSString* tempTitle = [_noteData stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSRange newLineCharRange = [tempTitle rangeOfString:@"\n"];
    if(newLineCharRange.location!=NSNotFound){
        _noteTitle = [tempTitle substringToIndex:newLineCharRange.location];
    }
    else{
        _noteTitle = _noteData;
    }
    return _noteTitle;
}

- (NSString*) GetNoteDetail{
    NSString* tempDetail = [_noteData stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSRange newLineCharRange = [tempDetail rangeOfString:@"\n"];
    if(newLineCharRange.location != NSNotFound){
        _noteDetail = [tempDetail substringFromIndex:newLineCharRange.location];
    }
    else{
        _noteDetail = @"";
    }
    
    return [_noteDetail stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
@end
