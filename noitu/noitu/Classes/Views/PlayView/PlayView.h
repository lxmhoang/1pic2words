//
//  PlayView.h
//  noitu
//
//  Created by Hoang le on 3/20/13.
//  Copyright (c) 2013 Hoang le. All rights reserved.
//

#include <AudioToolbox/AudioToolbox.h>
#import <UIKit/UIKit.h>
#import "PlayModel.h"
#import <QuartzCore/QuartzCore.h>
#import "Common.h"
#import "AnswerView.h"
#import "TypingView.h"
#import "UIDevice+Resolutions.h"
#import "ResultView.h"

#import "WinView.h"


@protocol PlayViewDelegate <NSObject>

- (void)correctAnswerFromView;
- (void)buyButtonTapped;

//- (void)charPickedFromView:(NSString *)charPicked;
@end

@interface PlayView : UIView <TypingViewDelegate, AnswerViewDelegate, ResultViewDelegate, UIGestureRecognizerDelegate>
{
    UILabel *coinLabel;
    UIImageView *coinImageView;
    UIView *coinView;
    PlayModel *playModel;
    AnswerView *asV;
    TypingView *tpV;
    ResultView *rV;
    UIImageView *correctImgView;
//    WinView *winView;
    UIView *blackView;
    
    
}

@property (nonatomic, assign) __weak id delegate;

- (int)checkNumOfEmptyLabelInResultView;
- (int)checkNumOfRemoveableChars;
- (int)getIndexOfRevealLabel:(int)numOfEmptyLB;

- (void)resizeCoinView;
- (void)putCharBack:(UILabel *)_asvLb;
- (id)initWithFrame:(CGRect)_frame andData:(PlayModel *)_data;
- (void)removeALetterFromController;
- (void)revealALetterFromController:(int)numOfEmptyLB;

- (void)revealLeftWordFromController;
- (void)revealRightWordFromController;
//- (void)charPickedFromController:(NSString *)_char;

@end
