//
//  SmartNote.m
//  SmartNotes
//
//  Created by Conrad Koh on 8/8/15.
//  Copyright © 2015 ConradKoh. All rights reserved.
//

#import "SmartNote.h"
#import "Constants.h"
static NSString* const blockDelimiter = @"\n<blockdelimiter>\n";
@implementation SmartNote{
    NSString* _noteData;
    NSString* _noteTitle;
    NSString* _noteDetail;
    NOTETYPE _noteType;
    
}

- (instancetype)init{
    self = [super init];
    _noteType = TRANSIENT;
    _noteData = [[DELIMITER_COPYSTART stringByAppendingString:@"\n"]stringByAppendingString: DELIMITER_COPYEND];
    _noteTitle = @"";
    _noteDetail = @"";
    return self;
}

- (NSString* )GetNoteData{
    
    return _noteData;
}

-(NOTETYPE)GetNoteType{
    NSArray* noteDataLines = [_noteData componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if([noteDataLines count] > 0){
        NSString* noteDataSpecifier = [noteDataLines objectAtIndex:0];
        if([noteDataSpecifier isEqualToString: PERSISTENTNOTESPECIFIER]){
            _noteType = PERSISTENT;
        }
        else{
            _noteType = TRANSIENT;
        }
    }
    else{
        _noteType = UNSPECIFIED;
    }

    return _noteType;
}

-(void)SetNoteType:(NOTETYPE)noteType{
    _noteType = noteType;
    return;
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
//    NSArray* dataTokens = [tempTitle componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
//    NSString* firstLine = [dataTokens objectAtIndex:0];
//    if([firstLine isEqualToString:PERSISTENTNOTESPECIFIER]){
//        if([dataTokens count] > 1){
//            _noteTitle = [dataTokens objectAtIndex:1];
//        }
//    }
//    else{
//        if([dataTokens count] > 0){
//            _noteTitle = [dataTokens objectAtIndex:0];
//        }
//    }
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
//    NSArray* dataTokens = [tempDetail componentsSeparatedByCharactersInSet:[NSCharacterSet whites]];
//    NSString* firstLine = [dataTokens objectAtIndex:0];
//    if([firstLine isEqualToString:PERSISTENTNOTESPECIFIER]){
//        if([dataTokens count] > 2){
//            _noteDetail = [dataTokens objectAtIndex:2];
//        }
//    }
//    else{
//        if([dataTokens count] > 1){
//            _noteDetail = [dataTokens objectAtIndex:1];
//        }
//    }
    
    return [_noteDetail stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

-(BOOL) MatchesQuery:(NSString *)query{
    query = [query stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    query = [query lowercaseString];
    
    NSArray* queryTokens = [query componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSUInteger queryTokenCount = [queryTokens count];
    double matches = 0;
    double tolerance = 100;
    
    for(NSString* queryToken in queryTokens){
        NSString* lowerCaseNoteData = [_noteData lowercaseString];
        NSArray* noteTokens = [lowerCaseNoteData componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSDateFormatter* dateformatter = [[NSDateFormatter alloc]init];
        [dateformatter setDateFormat:@"dd-MM-yyyy"];
        [dateformatter setTimeZone:[[NSCalendar currentCalendar] timeZone]];
        NSDate* dateObj = [dateformatter dateFromString:queryToken];
        NSString* day;
        if(dateObj!= nil){
            [dateformatter setDateFormat:@"EEEE"];
            day = [[dateformatter stringFromDate:dateObj] lowercaseString];
        }
        
        BOOL queryTokenFound = false;
        for(NSString* noteToken in noteTokens){
            if(queryTokenFound == false){
                if([noteToken containsString:queryToken]){
                    matches = matches + 1;
                    queryTokenFound = true;
                    break;
                }
                else{
                    if(day != nil){
                        NSRange dayRange = [noteToken rangeOfString:day];
                        if(dayRange.location == 0){
                            matches = matches + 1;
                            queryTokenFound = true;
                            break;
                        }
                    }
                }
            }
            
        }
    }
    
    double perecentageMatch = (matches / queryTokenCount) * 100;
    if(perecentageMatch >= tolerance){
        return true;
    }
    else{
        return false;
    }
}
@end
