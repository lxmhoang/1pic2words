//
//  TypingView.m
//  noitu
//
//  Created by Hoang le on 3/21/13.
//  Copyright (c) 2013 Hoang le. All rights reserved.
//

#import "TypingView.h"

@implementation TypingView

@synthesize delegate;



- (void)createSubViews
{
    NSString *indexOfRevealLetter = @"-1";
    NSString *hintString = [[NSUserDefaults standardUserDefaults] stringForKey:@"hintString"];
    if (![[hintString substringWithRange:NSMakeRange(1, 1)] isEqualToString:@"@"]){
        indexOfRevealLetter = [hintString substringWithRange:NSMakeRange(1, 1)];
              
    }
    int bp=kLeftSpaceTypingRect;
    for (int i=0;i<6;i++)
    {
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        btn.titleLabel.font = [UIFont systemFontOfSize:22];
//        [btn setFrame:CGRectMake(bp, 0, kSizeOfTypingSquare, kSizeOfTypingSquare)];
//        [btn setTitle:[playModel.initString substringWithRange:NSMakeRange(i, 1)] forState:UIControlStateNormal];
//        [btn addTarget:delegate action:@selector(pickCharPressed:) forControlEvents:UIControlEventTouchUpInside];
        InputButtonView *btn = [[InputButtonView alloc]initWithText:[playModel.initString substringWithRange:NSMakeRange(i, 1)] andFrame:CGRectMake(bp, 0, kSizeOfTypingSquare, kSizeOfTypingSquare) andTag:i];
        [self addSubview:btn];
        UITapGestureRecognizer *_tap = [[UITapGestureRecognizer alloc]initWithTarget:delegate action:@selector(pickCharPressed:)];
        [btn addGestureRecognizer:_tap];                                     
        [_tap release];
        [btn release];
//        [btn addTarget:delegate action:@selector(pickCharPressed:) forControlEvents:UIControlEventTouchUpInside];
        bp+=kSizeOfTypingSquare+kDistanceTypingSquare;
        if ([btn.lb.text isEqualToString:@"*"])
        {
            [btn removeFromSuperview];
        }
//        NSLog(@" String : %@",playModel.initString);
//        if ([[playModel.initString substringWithRange:NSMakeRange(i, 1)] isEqualToString:[btn.lb.text uppercaseString]])
//        {
//            [btn removeFromSuperview];
//        }
    }
    bp = kLeftSpaceTypingRect;
    for (int i=6;i<11;i++)
    {
        InputButtonView *btn = [[InputButtonView alloc]initWithText:[playModel.initString substringWithRange:NSMakeRange(i, 1)] andFrame:CGRectMake(bp, kSizeOfTypingSquare+kDistanceTypingSquare, kSizeOfTypingSquare, kSizeOfTypingSquare) andTag:i];
        [self addSubview:btn];
        UITapGestureRecognizer *_tap = [[UITapGestureRecognizer alloc]initWithTarget:delegate action:@selector(pickCharPressed:)];
        [btn addGestureRecognizer:_tap];
        [_tap release];
        [btn release];
        bp+=kSizeOfTypingSquare+kDistanceTypingSquare;
        NSLog(@" String : %@",playModel.initString);
        if ([btn.lb.text isEqualToString:@"*"])
        {
            [btn removeFromSuperview];
        }
        
//        if ([[playModel.initString substringWithRange:NSMakeRange(i, 1)] isEqualToString:[btn.lb.text uppercaseString]])
//        {
//            [btn removeFromSuperview];
//        }
//        NSLog(@" String : %@",playModel.initString);
//        if ([[playModel.initString substringWithRange:NSMakeRange(i, 1)] isEqualToString:[btn.lb.text uppercaseString]])
//        {
//            [btn removeFromSuperview];
//        }
    }
}

- (id)initWithData:(PlayModel *)_data andDelegate:(id)_delegate
{
    self = [super init];
    if (self){
        playModel = [_data retain];
        delegate = [_delegate retain];
        int valueDevice = [[UIDevice currentDevice] resolution];
        if (valueDevice<3)
        {
            [self setFrame:CGRectMake(0, kYOfTypingView-30, kWidthOfScreen, kHeighOfTypingview)];
        }
        else
        {
        [self setFrame:CGRectMake(0, kYOfTypingView, kWidthOfScreen, kHeighOfTypingview)];
//        [self setBackgroundColor:[UIColor redColor]];
        }
        [self createSubViews];
//        [self setBackgroundColor:[UIColor redColor]];
    }
    return self;
}

@end
