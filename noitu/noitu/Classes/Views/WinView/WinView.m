//
//  WinView.m
//  1word2pics
//
//  Created by Hoang le on 5/2/13.
//  Copyright (c) 2013 Hoang le. All rights reserved.
//

#import "WinView.h"

@implementation WinView

@synthesize v1;

- (id)initWithFrame:(CGRect)frame andWord:(NSString *)_word
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.8]];
//        self.alpha = 0.8;
        UIView *boxView = [[UIView alloc]initWithFrame:CGRectMake(20, 150, 280, 280)];
        [boxView.layer setCornerRadius:15.0f];
        [boxView setBackgroundColor:[UIColor grayColor]];
        boxView.alpha=1;
        

        
        UILabel *lbViewTitle = [[UILabel alloc]initWithFrame:CGRectMake(40, 15, 200, 60)];
        [lbViewTitle setBackgroundColor:[UIColor clearColor]];
        lbViewTitle.text = @"LEVEL COMPLETED The word is ";
        lbViewTitle.numberOfLines = 2;
        [lbViewTitle setTextColor:[UIColor whiteColor]];
        lbViewTitle.textAlignment = NSTextAlignmentCenter;
        lbViewTitle.font = [UIFont boldSystemFontOfSize:20.0f];
        
        [boxView addSubview:lbViewTitle];
        [lbViewTitle release];
        
        UILabel *lbViewText = [[UILabel alloc]initWithFrame:CGRectMake(20, 120, 240, 40)];
        lbViewText.text = [NSString stringWithFormat:@"You get %d coins",_word.length*kCoinEachLetter];
        lbViewText.numberOfLines = 2;
        [lbViewText setTextAlignment:NSTextAlignmentCenter];
        [lbViewText setTextColor:[UIColor whiteColor]];
        [lbViewText setBackgroundColor:[UIColor clearColor]];

        lbViewText.font = [UIFont boldSystemFontOfSize:18.0f];
       
        [boxView addSubview:lbViewText];
        [lbViewText release];
        
        
        CAGradientLayer *gradient = [CAGradientLayer layer];
//        gradient.endPoint = CGPointMake(20, 20);
        [gradient setCornerRadius:15.0f];
        gradient.frame = boxView.bounds;
        gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[UIColor colorWithRed:38/225.0 green:128/225.0 blue:50/225.0 alpha:1] CGColor],nil];
        gradient.locations = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.1], nil];
        
        [boxView.layer insertSublayer:gradient atIndex:0];
        
        
        [self addSubview:boxView];
        
        [boxView release];
        
        int l1 = _word.length*33-3;
        
        UIView *answerView = [[UIView alloc]initWithFrame:CGRectMake((280-l1)/2, 85, l1, 40)];
        [answerView setBackgroundColor:[UIColor clearColor]];
        float t=0;
        for (int i=0;i<_word.length;i++)
        {
            InputButtonView *letter = [[InputButtonView alloc]initWithText:[_word substringWithRange:NSMakeRange(i, 1)] andFrame:CGRectMake(t, 3, 30, 30) andTag:0];
            [answerView addSubview:letter];
            [letter release];
            t+=33;
        }
        
        [boxView addSubview:answerView];
        [answerView release];        

        // Initialization code
        
        int l2=33*_word.length;
        
        UIView *coinsView = [[UIView alloc]initWithFrame:CGRectMake((280-l2)/2, 160, l2, 40)];
        
        t=0;
        for (int i=0;i<_word.length;i++)
        {
            UIImageView *starImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"100coin.png"]];
            [starImgView setFrame:CGRectMake(t, 0, 33, 33)];
            [coinsView addSubview:starImgView];
            [starImgView release];
            t+=33;
            
        }
        [boxView addSubview:coinsView];
        [coinsView release];

        
        UILabel *nextLevel = [[UILabel alloc]initWithFrame:CGRectMake(60, 200, 160, 60)];
        nextLevel.text = @"NEXT LEVEL";
        [nextLevel setTextAlignment:NSTextAlignmentCenter];
        nextLevel.font = [UIFont boldSystemFontOfSize:22.0f];
        [nextLevel.layer setCornerRadius:10.0f];
        [nextLevel setTextColor:[UIColor redColor]];
        
        [nextLevel setBackgroundColor:[UIColor yellowColor]];
        [boxView addSubview:nextLevel];
        [nextLevel release];
        
        
//        
//        [self spinCoin:0];
        
    }
    return self;
}

//- (void)spinCoin:(int)times
//{
//    // Create a block scoped variable to store the amount of spins.
//    __block int blockTimes = times;
//    
//    // Animate the coin to spin.
//    [UIView animateWithDuration:0.5
//                          delay:0.0
//                        options: UIViewAnimationCurveEaseOut
//                     animations:^{
//                         v1.transform = CGAffineTransformMakeScale(0.001, 1);
//                     }
//                     completion:^(BOOL completed){
//                         [UIView animateWithDuration:0.5
//                                               delay:0.0
//                                             options: UIViewAnimationCurveEaseOut
//                                          animations:^{
//                                              v1.transform = CGAffineTransformMakeScale(1, 1);
//                                          }
//                                          completion:^(BOOL finished){
//                                              if (blockTimes < 400) {
//                                                  // Spin 4 times.
//                                                  [self spinCoin:blockTimes+1];
//                                              }
//                                          }];
//                     }];
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
