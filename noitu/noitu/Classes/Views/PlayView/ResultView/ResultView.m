//
//  ResultView.m
//  noitu
//
//  Created by Hoang Le on 3/25/13.
//  Copyright (c) 2013 Hoang le. All rights reserved.
//

#import "ResultView.h"

@implementation ResultView
@synthesize delegate;

- (void)setFocusWithTag:(int)_focusTag
{
    for (int i=0;i<[playModel.answer length];i++)
    {
         UILabel *tmpLB = (UILabel *)[self viewWithTag:(i+100)];
         if (tmpLB.backgroundColor == [UIColor greenColor]){
             [tmpLB setBackgroundColor:[UIColor clearColor]];
            break;
        }
    }
    
    UILabel *willBeFocused = (UILabel *)[self viewWithTag:(100+_focusTag-100)];
    [willBeFocused setBackgroundColor:[UIColor greenColor]];
    
    
}

//- (void)removeCharWithTag:(int)removedTag
//{
//    
//    for (int i=0;i<[playModel.answer length];i++)
//    {
//        UILabel *tmpLB = (UILabel *)[self viewWithTag:(i+100)];
//        if (tmpLB.backgroundColor == [UIColor greenColor]){
//            [tmpLB setBackgroundColor:[UIColor clearColor]];
//            break;
//        }
//    }
//    
//    UILabel *focusLB = (UILabel *)[self viewWithTag:removedTag];
//    [focusLB setBackgroundColor:[UIColor greenColor]];
//}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setFocus:(UITapGestureRecognizer *)_sender
{
    UILabel *tappedLB = (UILabel *)_sender.view;
    NSNumber *tagOfFocusingLabel = [[NSUserDefaults standardUserDefaults] valueForKey:kStringtagOfFocusedLabelInAnswerView];
    
    if (tappedLB.tag == [tagOfFocusingLabel intValue])
    {
        //        [tappedLB setBackgroundColor:[UIColor whiteColor]];
        //        [[NSUserDefaults standardUserDefaults] setValue:nil forKey:kStringtagOfFocusedLabelInAnswerView];
        //        [[NSUserDefaults standardUserDefaults] synchronize];
        return;
    }
    
    
    if (tagOfFocusingLabel != nil){
        UILabel *focusingLB = (UILabel *)[self viewWithTag:[tagOfFocusingLabel intValue]];
        [focusingLB setBackgroundColor:[UIColor clearColor]];
        
    }
    
    
    
    [tappedLB setBackgroundColor:kColorOfFocusedLabel];
    
    
    
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:tappedLB.tag] forKey:kStringtagOfFocusedLabelInAnswerView];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    int test = [[[NSUserDefaults standardUserDefaults] valueForKey:kStringtagOfFocusedLabelInAnswerView] intValue];
    NSLog(@"test : %d", test);
}

- (void)eraseAll
{
    for (int i=100+[playModel.answer length]-1;i>=100;i--)
    {
        UILabel *lb = (UILabel *)[self viewWithTag:i];
        if ((![lb.text isEqualToString:@""])&&([lb.gestureRecognizers count]>0)){
                 [delegate performSelector:@selector(removeChar:) withObject:[lb.gestureRecognizers lastObject]];   
        }
    }
}

- (void)createSubViews
{
    
//    [self setBackgroundColor:[UIColor redColor]];
    UIImageView *clearIconImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kSizeOfResultSquare, kSizeOfResultSquare)];
    [clearIconImgView setImage:[UIImage imageNamed:@"clear.png"]];
//    [clearIconImgView setBackgroundColor:[UIColor whiteColor]];
    clearIconImgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *clearTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(eraseAll)];
    [clearIconImgView addGestureRecognizer:clearTap];
    [clearTap release];
    [self addSubview:clearIconImgView];
    [clearIconImgView release];
    
    int bp = 0;
    bp+=kSizeOfResultSquare+kDistanceResultSquare;
    
    int count = 100;
    for (int i=0;i<[playModel.answer length];i++)
    {
        UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(bp, 0, kSizeOfResultSquare, kSizeOfResultSquare)];
        [lb.layer setCornerRadius:3.0f];
        [lb setTag:count];
            count++;
        [lb setBackgroundColor:[UIColor clearColor]];
        [lb setFont:[UIFont fontWithName:@"Verdana-Bold" size:25]];
        [lb setTextAlignment:NSTextAlignmentCenter];
        [lb setTextColor:[UIColor whiteColor]];
        lb.text = @"";
        lb.userInteractionEnabled = YES;
        UITapGestureRecognizer *_tap = [[UITapGestureRecognizer alloc]initWithTarget:delegate action:@selector(removeChar:)];
        [lb addGestureRecognizer:_tap];
        [_tap release];
//        lb.userInteractionEnabled = YES;
//        UITapGestureRecognizer *_tapLB = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(setFocus:)];
//        [lb addGestureRecognizer:_tapLB];
//        [_tapLB release];
        
        [self addSubview:lb];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(bp, kSizeOfResultSquare+0, kSizeOfResultSquare, 4)];
        [line setBackgroundColor:[UIColor yellowColor]];
        [self addSubview:line];
        [line release];
        
        
        [lb release];
        bp+=kSizeOfResultSquare+kDistanceResultSquare;
    }
    
    UILabel *focusLabel = (UILabel *)[self viewWithTag:[[[NSUserDefaults standardUserDefaults] valueForKey:kStringtagOfFocusedLabelInAnswerView] intValue]];
    [focusLabel setBackgroundColor:kColorOfFocusedLabel];
}

- (id)initWithData:(PlayModel *)_data andDelegate:(id)_delegate
{
    self = [super init];
    if (self){
        playModel = [_data retain];
        delegate = [_delegate retain];
        int width = ([playModel.answer length]+1)*(kDistanceResultSquare+kSizeOfResultSquare)-kDistanceResultSquare;
        int valueDevice = [[UIDevice currentDevice] resolution];
        if (valueDevice<3)
        {
                [self setFrame:CGRectMake((kWidthOfScreen - width)/2, kYOfResultView-30, width, kHeighOfResultView)];
        }
        else
        {
        [self setFrame:CGRectMake((kWidthOfScreen - width)/2, kYOfResultView, width, kHeighOfResultView)];
        //        [self setBackgroundColor:[UIColor redColor]];
        }
            [self createSubViews];
        //        [self setBackgroundColor:[UIColor redColor]];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setNewChar:(InputButtonView *)_sender atTag:(int)tagOfThatView
{
//    int count = 100;
//    UILabel *tmpLabel = (UILabel *)[self viewWithTag:count];
    int length = [playModel.answer length];
//    while ((![tmpLabel.text isEqualToString:@""])&&(count < length+100)) {
//        count++;
//        tmpLabel = (UILabel *)[self viewWithTag:count];
//    }
    int count = tagOfThatView;
    UILabel *tmpLabel = (UILabel *)[self viewWithTag:count];
    if (count<length+100)
    {
        tmpLabel.text = [_sender.lb.text uppercaseString];

        [_sender setTag:count];
        [_sender setHidden:YES];
    }
}

@end
