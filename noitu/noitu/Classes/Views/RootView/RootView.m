//
//  RootView.m
//  noitu
//
//  Created by Hoang le on 3/20/13.
//  Copyright (c) 2013 Hoang le. All rights reserved.
//

#import "RootView.h"

@implementation RootView
@synthesize delegate;

- (void)createTopInfo
{
    UILabel *levelLabel = [[UILabel alloc]init];
    levelLabel.text = [NSString stringWithFormat:@"%d/100",[[[NSUserDefaults standardUserDefaults] objectForKey:@"level"] intValue]];
    [levelLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:20]];
    [levelLabel sizeToFit];
    
    [levelLabel setFrame:CGRectMake((kWidthOfScreen - levelLabel.frame.size.width)/2, (kHeightOfNavigationBar - levelLabel.frame.size.height)/2, levelLabel.frame.size.width, levelLabel.frame.size.height)];
    [levelLabel setBackgroundColor:[UIColor clearColor]];
    [levelLabel setTextColor:[UIColor whiteColor]];
    [self addSubview:levelLabel];
    [levelLabel release];
    
    coinView = [[UIView alloc]init];
    [coinView setBackgroundColor:[UIColor clearColor]];
    
    
    coinLabel = [[UILabel alloc]init];
    coinLabel.text = [NSString stringWithFormat:@"%d",[[[NSUserDefaults standardUserDefaults] objectForKey:@"coins"] intValue]];
    [coinLabel setFont:[UIFont fontWithName:@"ArialMT" size:17]];
    [coinLabel setTextAlignment:NSTextAlignmentRight];
    [coinLabel sizeToFit];
    [coinLabel setFrame:CGRectMake(0, 5, 75, 33)];
    [coinLabel setBackgroundColor:[UIColor clearColor]];
    [coinLabel setTextColor:[UIColor yellowColor]];
    [coinLabel setTag:kTagOfCoinLabel];
    [coinView addSubview:coinLabel];
    [coinLabel release];
    
    coinImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"coins.png"]];
    [coinImageView setBackgroundColor:[UIColor clearColor]];
    [coinImageView setFrame:CGRectMake(120-43, 5, 33, 33)];
    coinImageView.userInteractionEnabled = YES;
    coinImageView.layer.zPosition = 9999;
    
    
    [coinView addSubview:coinImageView];
    [coinImageView release];
    
    [coinView setFrame:CGRectMake(kWidthOfScreen - 120, 0, 120, 44)];
    //    [coinView setBackgroundColor:[UIColor redColor]];
    
    coinView.userInteractionEnabled = YES;
    UITapGestureRecognizer *_tap = [[UITapGestureRecognizer alloc]initWithTarget:delegate action:@selector(buyButtonTapped:)];
    [coinView addGestureRecognizer:_tap];
    [_tap release];
    
    [self addSubview:coinView];
    [coinView release];
    
}


- (void)createNavigationBar
{
    UINavigationBar *naviBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, kHeightOfNavigationBar)];
    
    
    [naviBar setBarTintColor:[UIColor brownColor]];
    
     
    UINavigationItem *navItem = [UINavigationItem alloc];
    navItem.title = @"";
    [naviBar pushNavigationItem:navItem animated:YES];
    
    [self addSubview:naviBar];
    [navItem release];
    [naviBar release];
    [self createTopInfo];
    
}

- (void)startOverBtnTappedInView
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:[NSString stringWithFormat:@"Reset your coin to %d and play level 1. Are you sure ?",50]  delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alertView show];
}

- (id)initWithFrame:(CGRect)frame andData:(RootModel *)_data
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createNavigationBar];
        
        UIImageView *chars = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1word2pics.png"]];
        [chars setFrame:CGRectMake(60, 40, 200, 260)];
        [self addSubview:chars];
        [chars release];
        
        rootModel = [_data retain];
//        [self setBackgroundColor:[UIColor colorWithRed:215.0/255.0 green:255.0/255.0 blue:155.0/255.0 alpha:1.0]];
//        self.backgroundColor = kBackGroundColor;
        [self setBackgroundColor:kBackGroundColor];
//        self.backgroundColor = kBackGroundColor;
        [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
        
        UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [playBtn addTarget:delegate action:@selector(playBtnPress) forControlEvents:UIControlEventTouchUpInside];
        [playBtn setFrame:CGRectMake(30, 250, 260, 38)];
        [playBtn setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
//        [playBtn setTitle:@"PLAY" forState:UIControlStateNormal];
        [self addSubview:playBtn];
        
        
        UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        buyButton.frame = CGRectMake(30, 250+38+20, 260, 38);
        [buyButton setBackgroundImage:[UIImage imageNamed:@"Store.png"] forState:UIControlStateNormal];
        [buyButton addTarget:delegate action:@selector(buyButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:buyButton];
        
        UIButton *howtoBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        howtoBtn.frame = CGRectMake(30, 250+38+20+38+20, 260, 38);
        [howtoBtn setBackgroundImage:[UIImage imageNamed:@"how to play.png"] forState:UIControlStateNormal];
        [howtoBtn addTarget:delegate action:@selector(howtoButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:howtoBtn];
        
        
        UIButton *startOverBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        startOverBtn.frame = CGRectMake(30, 250+38+20+38+20+38+20, 260, 38);
        [startOverBtn setBackgroundImage:[UIImage imageNamed:@"start over.png"] forState:UIControlStateNormal];
        [startOverBtn addTarget:self action:@selector(startOverBtnTappedInView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:startOverBtn];
        
        
        // Initialization code
        [self animate];

        
    }
    return self;
}

- (void)animate
{
//    UIImageView *starImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"star.png"]];
//    [self addSubview:starImgView];
//    [starImgView setFrame:CGRectMake(10, 50, 50, 50)];
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.5f];
//    [UIView setAnimationRepeatCount:1000000];
//    starImgView.alpha = 0;
//    [UIView commitAnimations];
//    [self viewWithTag:i].layer.transform = CATransform3DMakeRotation(M_PI,0.0,1.0,0.0); //flip halfway
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [delegate startOverBtnTapped];
    }
}

@end
