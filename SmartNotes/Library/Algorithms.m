//
//  Algorithms.m
//  SmartNotes
//
//  Created by Conrad Koh on 13/8/15.
//  Copyright © 2015 ConradKoh. All rights reserved.
//

#import "Algorithms.h"

@implementation Algorithms

//INDEPENDENT METHODS


+(NSDate *)ConvertDayToDate:(NSString *)dayString{
    NSDate* output;
    NSDate* now = [NSDate date];
    for(int dayOffset = 1; dayOffset < 8; ++dayOffset){
        NSDate* expectedDate = [now dateByAddingTimeInterval:dayOffset*24*60*60];
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"EEEE"];
        
        NSString* expectedDayString = [dateFormatter stringFromDate:expectedDate];
        if([[expectedDayString lowercaseString] isEqualToString: [dayString lowercaseString]] && [dayString length] > 5) {
            output = expectedDate;
        }
    }
    
    if(output == nil){
        if([[dayString lowercaseString] isEqualToString:@"tomorrow"]){
            NSDate* expectedDate = [now dateByAddingTimeInterval:1*24*60*60];
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"EEEE"];
            
            output = expectedDate;
        }
        else if([[dayString lowercaseString] isEqualToString:@"yesterday"]){
            NSDate* expectedDate = [now dateByAddingTimeInterval:-1*24*60*60];
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"EEEE"];
            output = expectedDate;
        }
        else if([[dayString lowercaseString] isEqualToString:@"today"]){
            output = now;
        }
    }
    return output;
}

//DEPENDENT METHODS

+(NSString *)ConvertDayToDateString:(NSString *)dayString{
    NSDate* date = [Algorithms ConvertDayToDate:dayString];
    NSString* output;
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd-MM-YYYY"];
    output = [dateFormatter stringFromDate:date];
    
//    NSDate* now = [NSDate date];
//    for(int dayOffset = 1; dayOffset < 8; ++dayOffset){
//        NSDate* expectedDate = [now dateByAddingTimeInterval:dayOffset*24*60*60];
//        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
//        [dateFormatter setDateFormat:@"EEEE"];
//        
//        NSString* expectedDayString = [dateFormatter stringFromDate:expectedDate];
//        if([expectedDayString containsString: dayString] && [dayString length] > 2) {
//            [dateFormatter setDateFormat:@"dd-MM-YYYY"];
//            output = [dateFormatter stringFromDate:expectedDate];
//        }
//    }
    return output;
}


+(NSString *)ReplaceAllDaysWithDates:(NSString *)sentence{
    NSArray* inputTokens = [sentence componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSMutableArray* inputTokensMutable = [[NSMutableArray alloc]initWithArray:inputTokens];
    for(int tokenIdx = 0; tokenIdx < [inputTokensMutable count]; ++tokenIdx){
        NSString* date = [Algorithms ConvertDayToDateString:[inputTokensMutable objectAtIndex:tokenIdx]];
        if(date != nil){
            [inputTokensMutable replaceObjectAtIndex:tokenIdx withObject:date];
        }
    }
    return [inputTokensMutable componentsJoinedByString:@" "];
}

+(NSArray *)ExtractDaysAsDates:(NSString *)sentence{
    NSArray* sentenceTokens = [sentence componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSMutableArray* extractedDates = [[NSMutableArray alloc]init];
    for(NSString* word in sentenceTokens){
        NSDate* date = [Algorithms ConvertDayToDate:word];
        if(date!=nil){
            [extractedDates addObject:date];
        }
    }
    
    return extractedDates;
}
@end
