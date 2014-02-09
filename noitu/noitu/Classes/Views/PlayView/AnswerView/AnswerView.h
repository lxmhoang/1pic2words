//
//  AnswerView.h
//  noitu
//
//  Created by Hoang le on 3/20/13.
//  Copyright (c) 2013 Hoang le. All rights reserved.
//

#import "math.h"
#import <UIKit/UIKit.h>
#import "Common.h"
#import "PlayModel.h"
#import <QuartzCore/QuartzCore.h>
#import "InputButtonView.h"
#include <AudioToolbox/AudioToolbox.h>

@protocol AnswerViewDelegate <NSObject>

- (void)setFocusForResultViewWithTag:(int)_tag;
- (void)correctAnswerFromSubView;
- (void)correctAnswerFromSubViewInHowTo;
- (void)removeChar:(UIGestureRecognizer *)_tap;
- (void)incorrectAnswerFromSubView;
- (void)putCharBack:(UILabel *)_asvLb;




@end

@interface AnswerView : UIView
{
    PlayModel *playModel;
}

@property (nonatomic, retain) id delegate;

- (void)wrongRightString;
- (void)wrongLeftString;
- (void)setFocusWithTag:(int)_focusTag;
- (id)initWithData:(PlayModel *)_data andDelegate:(id)_delegate;
- (void)setNewChar:(InputButtonView *)_sender;
- (void)removeCharWithTag:(int)removedTag;
- (BOOL)checkFullChar;
- (BOOL)checkCorrectAnswer;
- (BOOL)checkFullCharLeft;
- (BOOL)checkFullCharRight;
- (BOOL)checkCorrectAnswerLeft;
- (BOOL)checkCorrectAnswerRight;
- (void)completeLeftString;
- (void)completeRightString;


@end
