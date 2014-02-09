//
//  AnswerModel.h
//  noitu
//
//  Created by Hoang le on 3/20/13.
//  Copyright (c) 2013 Hoang le. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnswerModel : NSObject
{
    
}

@property (nonatomic) int width;
@property (nonatomic) int numcharright;
@property (nonatomic) int numcharleft;
@property (nonatomic, retain) NSString *leftString;
@property (nonatomic, retain) NSString *rightString;
@property (nonatomic, retain) NSString *answer;

- (id)initWithNumCharOfLeft:(int)_numcharleft NumCharOfRight:(int)_numcharright LeftString:(NSString *)_leftString RightString:(NSString *)_rightString CorrectAnswer:(NSString*)_answer;

@end
