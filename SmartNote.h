//
//  SmartNote.h
//  SmartNotes
//
//  Created by Conrad Koh on 8/8/15.
//  Copyright © 2015 ConradKoh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Algorithms.h"
#import "Typedefinitions.h"
static NSString* const PERSISTENTNOTESPECIFIER = @"[persistent]";
@interface SmartNote : NSObject
- (NSString* ) GetNoteData;
- (NOTETYPE) GetNoteType;
- (void) SetNoteType: (NOTETYPE) noteType;
- (void) SetNoteData: (NSString*) noteData;
- (NSString*) GetNoteTitle;
- (NSString*) GetNoteDetail;

- (BOOL) MatchesQuery: (NSString*) query;
@end
