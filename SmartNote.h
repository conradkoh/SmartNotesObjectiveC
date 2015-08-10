//
//  SmartNote.h
//  SmartNotes
//
//  Created by Conrad Koh on 8/8/15.
//  Copyright © 2015 ConradKoh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SmartNote : NSObject
- (NSString* ) GetNoteData;
- (void) SetNoteData: (NSString*) noteData;
- (NSString*) GetNoteTitle;
- (NSString*) GetNoteDetail;
@end
