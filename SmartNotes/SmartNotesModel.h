//
//  SmartNotesModel.h
//  SmartNotes
//
//  Created by Conrad Koh on 8/8/15.
//  Copyright © 2015 ConradKoh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SmartNote.h"

@interface SmartNotesModel : NSObject

//- (NSArray*) GetMatchingNotes: (NSString*) query;
- (NSArray*) GetMatchingNotesSorted: (NSString*) query;
- (NSString*) GetSearchNoteViewString;
- (SmartNote*) GetEditingNote;
- (void) SetEditingNote: (NSUInteger) index;
- (void) SaveEditingNote: (NSString*) noteData;

- (void) AddNotesFromStringArr: (NSArray*) notesArr;
- (void) AddNote: (NSString*) noteData;
- (void) DeleteAllNotes;
- (void) DeleteNoteFromView: (NSUInteger) viewIndex;
- (void) SaveToFile;
- (NSString*) NoteTitleAtIndex: (NSUInteger) index;
- (NSString*) NoteDetailAtIndex: (NSUInteger) index;
- (NSString*) ExportAll;
- (void) LoadDataFromString: (NSString*) data;

- (NSArray*) GetSearchView;
- (NSString*) SearchNoteTitleAtIndex: (NSUInteger) index;
- (NSString*) SearchNoteDetailAtIndex: (NSUInteger) index;
- (void) ResetViews;

@end
