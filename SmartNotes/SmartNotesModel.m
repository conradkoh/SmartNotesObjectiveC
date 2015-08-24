//
//  SmartNotesModel.m
//  SmartNotes
//
//  Created by Conrad Koh on 8/8/15.
//  Copyright © 2015 ConradKoh. All rights reserved.
//

#import "SmartNotesModel.h"

static SmartNotesModel* singleton;
static NSString* notesFilePath;
static NSString* archiveFilePath;
@implementation SmartNotesModel{
    NSMutableArray* allNotes;
    NSMutableArray* _archivedNotes;
    NSMutableArray* _searchNoteView;
    SmartNote* editingNote;
}

- (nonnull instancetype)init{
    
    if(singleton == nil){
        [self CheckFiles];
        singleton = [super init];
        [self LoadNotes];
        _searchNoteView = allNotes;
    }
    return singleton;
}

- (void) CheckFiles{
    NSError* error;
    NSArray* basePaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [basePaths objectAtIndex:0];
    notesFilePath = [documentsDirectory stringByAppendingPathComponent:@"allNotes.plist"];
    archiveFilePath = [documentsDirectory stringByAppendingPathComponent:@"notesArchive.plist"];
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:notesFilePath]){
        NSString* bundle = [[NSBundle mainBundle] pathForResource:@"allNotes" ofType:@"plist"];
        [fileManager copyItemAtPath:bundle toPath:notesFilePath error:&error];
    }
    if(![fileManager fileExistsAtPath:archiveFilePath]){
        NSString* bundle = [[NSBundle mainBundle] pathForResource:@"notesArchive" ofType:@"plist"];
        [fileManager copyItemAtPath:bundle toPath:archiveFilePath error:&error];
    }
}
- (void) LoadNotes{
    NSMutableArray* noteStrings = [[NSMutableArray alloc]init];
    noteStrings = [NSMutableArray arrayWithContentsOfFile:notesFilePath];
    allNotes = [[NSMutableArray alloc]init];
    for(NSString* noteData in noteStrings){
        SmartNote* note = [[SmartNote alloc]init];
        [note SetNoteData:noteData];
        [allNotes addObject:note];
    }
    if(allNotes == nil){
        allNotes = [[NSMutableArray alloc]init];
    }
    
    NSMutableArray* archivedNoteStrings = [[NSMutableArray alloc]initWithContentsOfFile:notesFilePath];
    _archivedNotes = [[NSMutableArray alloc]init];
    for(NSString* archivedNoteData in archivedNoteStrings){
        SmartNote* note = [[SmartNote alloc]init];
        [note SetNoteData:archivedNoteData];
        [_archivedNotes addObject:note];
    }
    if(_archivedNotes == nil){
        _archivedNotes = [[NSMutableArray alloc]init];
    }
}

//RETURN VAL IS ARRAY OF SmartNotes
//- (NSArray *)GetMatchingNotes:(NSString *)query{
//    static NSString* queryHistory = @"";
//    NSMutableArray* searchScope;
//    if([query containsString:queryHistory]){
//        searchScope = _searchNoteView;
//    }
//    else{
//        searchScope = allNotes;
//    }
//    queryHistory = query;
//    
//    double matchThreshold = 100;
//    query = [query stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    
//    if([query isEqualToString:@""]){
//        _searchNoteView = allNotes;
//    }
//    
//    else{
//        query = [query lowercaseString];
//        NSMutableArray* matchingNotes = [[NSMutableArray alloc]init];
//        
//        NSArray* queryTokens = [query componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//        for(SmartNote* note in searchScope){
//            NSString* lowerCaseBlock = [[note GetNoteData] lowercaseString];
//            double matchesFound = 0;
//            for(NSString* queryToken in queryTokens){
//                if([lowerCaseBlock containsString:queryToken]){
//                    matchesFound = matchesFound + 1;
//                }
//            }
//            
//            double percentageMatch = (matchesFound/[queryTokens count]) * 100;
//            if(percentageMatch >= matchThreshold){
//                [matchingNotes addObject:note];
//            }
//            
//        }
//        _searchNoteView = matchingNotes;
//    }
//    
//    return _searchNoteView;
//}

- (NSArray *)GetMatchingNotesSorted:(NSString *)query{
    static NSString* previousQuery = @"";
    NSMutableArray* searchScope = allNotes;
    
    if([query isEqualToString:@""]) {
        _searchNoteView = allNotes;
    }
    else{
        if([query containsString:previousQuery]){
            searchScope = _searchNoteView;
        }
        else{
            searchScope = allNotes;
        }
        
        NSMutableArray* transientNotes = [[NSMutableArray alloc]init];
        NSMutableArray* persistentNotes = [[NSMutableArray alloc]init];
        
        query = [query lowercaseString];
        for(SmartNote* note in searchScope){
            if([note MatchesQuery:query]){
                NOTETYPE noteType = [note GetNoteType];
                if(noteType == TRANSIENT){
                    [transientNotes addObject:note];
                }
                else if(noteType == PERSISTENT) {
                    [persistentNotes addObject:note];
                }
            }
            
        }
        
        NSMutableArray* sortedNotes = [[NSMutableArray alloc] initWithArray:transientNotes];
        [sortedNotes addObjectsFromArray:persistentNotes];
        _searchNoteView = sortedNotes;
    }
    previousQuery = query;
    return _searchNoteView;
}


- (SmartNote*) GetEditingNote{
    return editingNote;
}

- (void)SetEditingNote:(NSUInteger)index{
    editingNote = [_searchNoteView objectAtIndex:index];
    return;
}

-(void) SaveEditingNote: (NSString*) newNoteData{
    [editingNote SetNoteData:newNoteData];
    [self ResetViews];
    [self SaveToFile];
    return;
    
}

-(void)AddNotesFromStringArr:(NSArray *)notesArr{
    for(NSString* currentNoteData in notesArr){
        SmartNote* currentNote = [[SmartNote alloc]init];
        [currentNote SetNoteData: currentNoteData];
        [allNotes addObject:currentNote];
    }
    [self ResetViews];
    [self SaveToFile];
    
    return;
}

-(void)AddNote:(NSString *)noteData{
    SmartNote* note = [[SmartNote alloc]init];
    [note SetNoteData:noteData];
    [allNotes insertObject:note atIndex:0];
    [self ResetViews];
    [self SaveToFile];
}

- (void)DeleteNoteFromView:(NSUInteger)viewIndex{
    SmartNote* noteToDelete = [_searchNoteView objectAtIndex:viewIndex];
    [_searchNoteView removeObjectAtIndex:viewIndex];
    if(![self DeleteNoteFromAllNotes:noteToDelete]){
        [self DeleteNoteFromArchive:noteToDelete];
    }
//    
//    [_archivedNotes addObject:noteToDelete];
//    [allNotes removeObject:noteToDelete];
    [self SaveToFile];
}

- (BOOL) DeleteNoteFromArchive: (SmartNote*) note{
    @try {
        [_archivedNotes removeObject:note];
        return TRUE;
    }
    @catch (NSException *exception) {
        NSLog(@"DeleteNoteFromArchive failed. %@", exception.reason);
        return FALSE;
    }
    @finally {
    }
}

- (BOOL) DeleteNoteFromAllNotes: (SmartNote*) note{
    @try {
        [allNotes removeObject:note];
        [_archivedNotes addObject:note];
        return TRUE;
    }
    @catch (NSException *exception) {
        NSLog(@"DeleteNoteFromAllNotes failed. %@", exception.reason);
        return FALSE;
    }
    @finally {
    }
}

-(void)SaveToFile{
    //save all notes
    NSMutableArray* noteStrings = [[NSMutableArray alloc]init];
    for(SmartNote* note in allNotes){
        [noteStrings addObject:[note GetNoteData]];
    }
    BOOL successAllNotes = [noteStrings writeToFile:notesFilePath atomically:YES];
    NSAssert(successAllNotes, @"failed to save all notes");
    
    //save archived note
    NSMutableArray* archivedNoteStrings = [[NSMutableArray alloc]init];
    for(SmartNote* note in _archivedNotes){
        [archivedNoteStrings addObject: [note GetNoteData]];
    }
    BOOL successArchivedNotes = [archivedNoteStrings writeToFile:archiveFilePath atomically:YES];
    NSAssert(successArchivedNotes, @"failed to save archive");
}

-(NSString *)NoteTitleAtIndex:(NSUInteger)index{
    SmartNote* note = [allNotes objectAtIndex:index];
    return [note GetNoteTitle];
}

-(NSString*) NoteDetailAtIndex:(NSUInteger)index{
    SmartNote* note = [allNotes objectAtIndex:index];
    return [note GetNoteDetail];
}

-(NSArray *)GetSearchView{
    return _searchNoteView;
}

-(NSString *)SearchNoteTitleAtIndex:(NSUInteger)index{
    SmartNote* note = [_searchNoteView objectAtIndex:index];
    return [note GetNoteTitle];
}

-(NSString *)SearchNoteDetailAtIndex:(NSUInteger)index{
    SmartNote* note = [_searchNoteView objectAtIndex:index];
    return [note GetNoteDetail];
}

-(void) ResetViews{
    _searchNoteView = allNotes;
}

@end
