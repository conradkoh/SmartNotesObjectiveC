//
//  Algorithms.h
//  SmartNotes
//
//  Created by Conrad Koh on 13/8/15.
//  Copyright © 2015 ConradKoh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Algorithms : NSObject
//INDEPENDENT METHODS
+ (NSDate*) ConvertDayToDate: (NSString*) dayString;

//DEPENDENT METHODS
+ (NSString*) ConvertDayToDateString: (NSString*) dayString;
+ (NSString*) ReplaceAllDaysWithDates: (NSString*) sentence;
+ (NSArray*) ExtractDaysAsDates: (NSString*) sentence;
@end
