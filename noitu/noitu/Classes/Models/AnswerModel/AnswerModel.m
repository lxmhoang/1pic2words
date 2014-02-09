//
//  AnswerModel.m
//  noitu
//
//  Created by Hoang le on 3/20/13.
//  Copyright (c) 2013 Hoang le. All rights reserved.
//

#import "AnswerModel.h"

@implementation AnswerModel

@synthesize numcharleft,numcharright,leftString,rightString,answer,width;

- (id)initWithNumCharOfLeft:(int)_numcharleft NumCharOfRight:(int)_numcharright LeftString:(NSString *)_leftString RightString:(NSString *)_rightString CorrectAnswer:(NSString *)_answer
{
    self = [super init];
    if (self)
    {
        numcharleft = _numcharleft;
        numcharright = _numcharright;
        leftString = _leftString;
        rightString = _rightString;
        answer = _answer;
        width = MAX(numcharleft+numcharright,MAX([leftString length],[rightString length]))*40-8;
        
    }
    return self;
}

@end
