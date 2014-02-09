//
//  PlayView.m
//  noitu
//
//  Created by Hoang le on 3/20/13.
//  Copyright (c) 2013 Hoang le. All rights reserved.
//

#import "PlayView.h"

@implementation PlayView
@synthesize delegate;



- (void)putCharBack:(UILabel *)_asvLb
{
    NSInteger tag = _asvLb.tag;
    [asV removeCharWithTag:tag];
    UILabel *resultLb = (UILabel *)[rV viewWithTag:tag];
    resultLb.text = @"";
    UIButton *shoudAppearBtn = (UIButton *)[tpV viewWithTag:tag];
    [shoudAppearBtn setHidden:NO];
    [shoudAppearBtn setTag:99999];
}

- (void)removeChar:(UITapGestureRecognizer *)_sender
{
    UILabel *senderViewLb = (UILabel *)_sender.view;
    if ([senderViewLb.text isEqualToString:@""])
    {
//        return;
    }
    NSInteger tag = _sender.view.tag;
    [asV removeCharWithTag:tag];
//    UILabel *answerLb = (UILabel *)[asV viewWithTag:tag];
//    
//    answerLb.text = @"";
    UILabel *resultLb = (UILabel *)[rV viewWithTag:tag];
    resultLb.text = @"";
//    UILabel *tmpLabel = (UILabel *)_sender.view;
//    tmpLabel.text = @"";
    UIButton *shoudAppearBtn = (UIButton *)[tpV viewWithTag:tag];
    [shoudAppearBtn setHidden:NO];
    [shoudAppearBtn setTag:99999];
}

- (void)tapTmpViewAfterAnimation:(UIGestureRecognizer *)_tap
{
    [_tap.view removeFromSuperview];
    [delegate correctAnswerFromView];
}



- (void)pickCharPressed:(UITapGestureRecognizer *)_sender
{
    int tagOfThatView = [[[NSUserDefaults standardUserDefaults] valueForKey:kStringtagOfFocusedLabelInAnswerView] intValue];
//    [delegate charPickedFromView:_sender.currentTitle];
    
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:kStringtagOfFocusedLabelInAnswerView]);
    [asV setNewChar:(InputButtonView *)_sender.view];
        NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:kStringtagOfFocusedLabelInAnswerView]);
    [rV setNewChar:(InputButtonView *)_sender.view atTag:tagOfThatView];
    
    if ((tagOfThatView <100+playModel.numcharleft)&&([asV checkFullCharLeft])){
        NSLog(@"full char left");
        if ([asV checkCorrectAnswerLeft]){
            [asV completeLeftString];
            NSLog(@"left string is correct !!!");
        }
    }else  if ((tagOfThatView >=100+playModel.numcharleft)&&([asV checkFullCharRight]))
    {
        NSLog(@"full char right	");
        if ([asV checkCorrectAnswerRight]){
            [asV completeRightString];
            NSLog(@"right string is correct !!!");
        }
    }
    
//    if ([asV checkFullChar])
//    {
//        if ([asV checkCorrectAnswer]){
//
//            return;
//            
//        }else
//        {
//            // hien mau xanh cho ky tu nhap vao cuoi cung, de chi ra rang no dang duoc focus , trong truong hop fullchar nhung ket qua chua dung
//            int focusedLabelTag = [[[NSUserDefaults standardUserDefaults] valueForKey:kStringtagOfFocusedLabelInAnswerView] intValue];
//            UILabel *tmp = (UILabel *)[asV viewWithTag:focusedLabelTag];
//            
//            [tmp setBackgroundColor:kColorOfFocusedLabel];
//            [self incorrectAnswerFromSubView];
//
//        }
//        NSLog(@"%@",@"da full");
//    }else{
//        NSLog(@"%@",@"chua full");
//    }

}

- (void)createNavigationBar
{
    UINavigationBar *naviBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, kHeightOfNavigationBar)];
    
    UINavigationItem *navItem = [UINavigationItem alloc];
//    navItem.title = @"Play";
   
    
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonSystemItemCancel target:delegate action:@selector(dismiss)];
//    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"Menu.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    navItem.leftBarButtonItem = cancelBtn;
    
    
     [naviBar pushNavigationItem:navItem animated:YES];

    
    [self addSubview:naviBar];
    [cancelBtn release];
    [navItem release];
    [naviBar release];
    
}

- (void)createTopInfo
{
    UILabel *levelLabel = [[UILabel alloc]init];
    levelLabel.text = [NSString stringWithFormat:@"LV %d",playModel.level];
    [levelLabel sizeToFit];
    
    [levelLabel setFrame:CGRectMake((kWidthOfScreen - levelLabel.frame.size.width)/2, (kHeightOfNavigationBar - levelLabel.frame.size.height)/2, levelLabel.frame.size.width, levelLabel.frame.size.height)];
    [levelLabel setBackgroundColor:[UIColor clearColor]];
    [levelLabel setTextColor:[UIColor yellowColor]];
    [self addSubview:levelLabel];
    [levelLabel release];
    
    coinView = [[UIView alloc]init];
    [coinView setBackgroundColor:[UIColor clearColor]];
    
    
    coinLabel = [[UILabel alloc]init];
    coinLabel.text = [NSString stringWithFormat:@"%d",playModel.coins];
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
    UITapGestureRecognizer *_tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(test)];
    [coinView addGestureRecognizer:_tap];
    [_tap release];
    
    [self addSubview:coinView];
    [coinView release];
    
}

- (void)resizeCoinView
{
    [coinView setFrame:CGRectMake(kWidthOfScreen - coinImageView.frame.size.width - coinLabel.frame.size.width -10, 0, coinImageView.frame.size.width+coinLabel.frame.size.width+10, 44)];
}

- (void)test{
    [delegate buyButtonTapped];
}

- (void)tapToNormal:(UITapGestureRecognizer *)_sender
{
    NSLog(@"Tap to normal");
    NSLog(@"sender view : %@",_sender.view);
    [_sender.view removeFromSuperview];
    NSLog(@"remove successful");
//   [[self viewWithTag:kTagOfZoomImageView] removeFromSuperview];
    return;
//    UIView *zoomImgView = [self viewWithTag:kTagOfZoomImageView];
    
    
    [[self viewWithTag:kTagOfAlphaView] removeFromSuperview];
    for (UIView *tmp in self.subviews)
    {
        NSLog(@"Sub view :%@",tmp);
    }
    return;
    UIImageView *newImageView = (UIImageView *)[self viewWithTag:kTagOfZoomImageView];
    NSLog(@"2222");
    
//    NSLog(@"ref count of imgview : %d", [newImageView retainCount]);
    if (newImageView)
    {
        [newImageView removeFromSuperview];
//        [newImageView setHidden:YES];
//        newImageView = nil;
//        [newImageView release];
    }
    else{
        NSLog(@"ko co ma remove");
    }
    NSLog(@"3333");
    UIView *alphaView = [self viewWithTag:kTagOfAlphaView];
//    NSLog(@"ref count of alphaView : %d", [alphaView retainCount]);
    NSLog(@"4444");
    if (alphaView)
    {
        [alphaView removeFromSuperview];
//        [alphaView release];
    }else
    {
         NSLog(@"alphaView ko co ma remove");
    }
    NSLog(@"5555");
    
}

- (void)tapRightImgView:(UITapGestureRecognizer *)_sender
{
    NSLog(@"tap left img view");
    UIView *clearView = [[UIView alloc]initWithFrame:self.bounds];
    
    
    UIView *darkView = [[UIView alloc]initWithFrame:self.bounds];
    [darkView setBackgroundColor:[UIColor blackColor]];
    darkView.alpha = 0.7;
    [darkView setTag:kTagOfAlphaView];
    [clearView addSubview:darkView];
    
    
    NSLog(@"1");
    UIImageView *tappedImgView = (UIImageView *)_sender.view;
    UIImageView *newImgView = [[UIImageView alloc]initWithImage:tappedImgView.image];
    //    UIView *newImgView = [[UIView alloc]initWithFrame:CGRectMake(30, 50, 80, 80)];
    //    [newImgView setBackgroundColor:[UIColor redColor]];
    NSLog(@"2");
    [newImgView setFrame:CGRectMake(kXOfRightImage, kYOfImage, 110, 110)];
    
    NSLog(@"3");
    
    
    UITapGestureRecognizer *_tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToNormal:)];
    _tap.numberOfTapsRequired = 1;
    [clearView addGestureRecognizer:_tap];
    
    
    //             [self addSubview:clearView];
    [_tap release];
    
    [[self superview] addSubview:clearView];
    
    
    
    
    [clearView addSubview:newImgView];
    //    [newImgView setFrame:CGRectMake(kXOfLeftImage+30, kYOfImage+30, 200, 200)];
    
    //    UIImageView *tmpImgView = [[UIImageView alloc]initWithImage:tappedImgView.image];
    //    [tmpImgView setFrame:CGRectMake(kXOfLeftImage, kYOfImage, 110, 110)];
    //    [clearView addSubview:tmpImgView];
    
    UIView *protectView = [[UIView alloc]initWithFrame:self.bounds];
    [[self superview] addSubview:protectView];
    [protectView release];
    
    [UIView animateWithDuration:0.4f
                     animations:^{
                         [newImgView setFrame:CGRectMake(60, kYOfImage+30, 200, 200)];
                     }
                     completion:^(BOOL finished)
     {
         if (finished)
         {
             NSLog(@"Done...");
             //             [tmpImgView removeFromSuperview];
             [newImgView setTag:kTagOfZoomImageView];
             //             [newImgView setFrame:CGRectMake(kXOfLeftImage+30, kYOfImage+30, 200, 200)];
             [protectView removeFromSuperview];
         }
     }
     ];
    //    [tmpImgView release];
    [darkView release];
    [newImgView release];
    [clearView release];
    
    NSLog(@"Tap ...");
}

- (void)tapLeftImgView:(UITapGestureRecognizer *)_sender
{
    NSLog(@"tap left img view");
    UIView *clearView = [[UIView alloc]initWithFrame:self.bounds];
    
    
    UIView *darkView = [[UIView alloc]initWithFrame:self.bounds];
    [darkView setBackgroundColor:[UIColor blackColor]];
    darkView.alpha = 0.7;
    [darkView setTag:kTagOfAlphaView];
    [clearView addSubview:darkView];
    
    
    NSLog(@"1");
    UIImageView *tappedImgView = (UIImageView *)_sender.view;
    UIImageView *newImgView = [[UIImageView alloc]initWithImage:tappedImgView.image];
//    UIView *newImgView = [[UIView alloc]initWithFrame:CGRectMake(30, 50, 80, 80)];
//    [newImgView setBackgroundColor:[UIColor redColor]];
    NSLog(@"2");
    [newImgView setFrame:CGRectMake(kXOfLeftImage, kYOfImage, 110, 110)];
    
    NSLog(@"3");
    
    
        UITapGestureRecognizer *_tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToNormal:)];
    _tap.numberOfTapsRequired = 1;
    [clearView addGestureRecognizer:_tap];
    
    
    //             [self addSubview:clearView];
    [_tap release];
    
    [[self superview] addSubview:clearView];
    

    
    
    [clearView addSubview:newImgView];
//    [newImgView setFrame:CGRectMake(kXOfLeftImage+30, kYOfImage+30, 200, 200)];
    
//    UIImageView *tmpImgView = [[UIImageView alloc]initWithImage:tappedImgView.image];
//    [tmpImgView setFrame:CGRectMake(kXOfLeftImage, kYOfImage, 110, 110)];
//    [clearView addSubview:tmpImgView];
    
    UIView *protectView = [[UIView alloc]initWithFrame:self.bounds];
    [[self superview] addSubview:protectView];
    [protectView release];
    
    [UIView animateWithDuration:0.4f
    animations:^{
        [newImgView setFrame:CGRectMake(60, kYOfImage+30, 200, 200)];
    }
    completion:^(BOOL finished)
     {
         if (finished)
         {
             NSLog(@"Done...");
//             [tmpImgView removeFromSuperview];
             [newImgView setTag:kTagOfZoomImageView];
//             [newImgView setFrame:CGRectMake(kXOfLeftImage+30, kYOfImage+30, 200, 200)];
             [protectView removeFromSuperview];
         }
     }
     ];
//    [tmpImgView release];
    [darkView release];
    [newImgView release];
    [clearView release];
    
    NSLog(@"Tap ...");
//    NSLog(@"retainCount of zoomimageview before: %d",[[self viewWithTag:222] retainCount]);
////    return;
//    UIImageView *tappedImgView = (UIImageView *)_sender.view;
// 
//
//    UIView *alphaView = [[UIView alloc]initWithFrame:self.bounds];
//    
//    [alphaView setBackgroundColor:[UIColor blackColor]];
//    alphaView.alpha = 0.7;
//    [alphaView setTag:kTagOfAlphaView];
//    
//    
//    
//    UIImageView *newImageView = [[UIImageView alloc]initWithImage:[tappedImgView.image retain]];
//    
//    newImageView.userInteractionEnabled = YES;
//    [newImageView setFrame:CGRectMake(kXOfLeftImage+5, kYOfImage+5, 110, 110)];
//    
//    
//    
//    
//    
//    UITapGestureRecognizer *_tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToNormal:)];
//    _tap.numberOfTapsRequired = 1;
//    [_tap setDelaysTouchesBegan:YES];
//    
//    [newImageView addGestureRecognizer:_tap];
//    [_tap release];
//    UITapGestureRecognizer *_tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToNormal:)];
//    _tap2.numberOfTapsRequired = 1;
//    [alphaView addGestureRecognizer:_tap2];
//    [_tap2 release];
//    
//    [self addSubview:alphaView];
//    
//    [self addSubview:newImageView];
//    
//    NSLog(@"uiimageview address : %@",newImageView);
//    
//
//    
////    [UIView beginAnimations:nil context:nil];
////    [UIView setAnimationDuration:0.5f];
////    [newImageView setFrame:CGRectMake(kXOfLeftImage+30, kYOfImage+30, 200, 200)];
////    
////    [UIView commitAnimations];
//    [newImageView setTag:kTagOfZoomImageView];
//    [newImageView release];
//    [alphaView release];
    
    
    
}

- (void)createSubviews
{
    [self createNavigationBar];
    
    [self createTopInfo];
    
    blackView = [[UIView alloc]initWithFrame:CGRectMake(-1000, -1000, 320, 640)];
    [blackView setBackgroundColor:[UIColor blackColor]];
    blackView.alpha = 0.8;
//    blackView.layer.zPosition = 1;
//    [blackView setHidden:YES];
    
    correctImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 160)];
    [correctImgView setImage:[UIImage imageNamed:@"good job.png"]];
    [blackView addSubview:correctImgView];
    [self addSubview:blackView];
    
    
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(kXOfLeftImage, kYOfImage, kSizeOfImage, kSizeOfImage)];
    [leftView setBackgroundColor:[UIColor whiteColor]];
    [leftView.layer setCornerRadius:10.0f];
    

    
    UIImageView *leftIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",playModel.leftString]]];
    NSLog(@"left image : %@",playModel.leftString);
    [leftIV setBackgroundColor:[UIColor colorWithRed:230/255.0 green:223/255.0 blue:213/255.0 alpha:1.0]];
    [leftIV setFrame:CGRectMake(5, 5, 110, 110)];
    [leftIV.layer setCornerRadius:10.0f];
    leftIV.userInteractionEnabled = YES;
    
    
    UITapGestureRecognizer *_tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapLeftImgView:)];
    [leftIV addGestureRecognizer:_tap];
    [_tap release];
    
    
    [leftView addSubview:leftIV];
    [self addSubview:leftView];
    [leftIV release];
    [leftView release];
    
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(kXOfRightImage, kYOfImage, kSizeOfImage, kSizeOfImage)];
    [rightView setBackgroundColor:[UIColor whiteColor]];
    [rightView.layer setCornerRadius:10.0f];
    
    UIImageView *rightIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",playModel.rightString]]];
    NSLog(@"right image : %@",playModel.rightString);
    NSLog(@"answer image : %@",playModel.answer);
    
    rightIV.userInteractionEnabled = YES;
    UITapGestureRecognizer *_tapRight = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapRightImgView:)];
    [rightIV addGestureRecognizer:_tapRight];
    [_tapRight release];
    
    [rightIV setBackgroundColor:[UIColor colorWithRed:230/255.0 green:223/255.0 blue:213/255.0 alpha:1.0]];
//    [rightIV setImage:[UIImage imageNamed:@"capital.png"]];
    [rightIV setFrame:CGRectMake(5, 5, 110, 110)];
    [rightIV.layer setCornerRadius:10.0f];
    [rightView addSubview:rightIV];
    [self addSubview:rightView];
    [rightIV release];
    [rightView release];
    
//    asM = [[AnswerModel alloc]initWithNumCharOfLeft:3 NumCharOfRight:3 LeftString:@"cash" RightString:@"turtle" CorrectAnswer:@"castle"];
    
    asV = [[AnswerView alloc]initWithData:playModel andDelegate:self];
        
    tpV = [[TypingView alloc]initWithData:playModel andDelegate:self];
    
    rV = [[ResultView alloc]initWithData:playModel andDelegate:self];
    
    [self addSubview:rV];
    [self addSubview:tpV];
    
    [self addSubview:asV];
    [tpV release];
    [asV release];
    
    UIButton *fbBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    int valueDevice = [[UIDevice currentDevice] resolution];
    if (valueDevice <3){
    [fbBtn setFrame:CGRectMake(kLeftSpaceTypingRect + 5*kDistanceTypingSquare + 5 * kSizeOfTypingSquare,kYOfTypingView + kSizeOfTypingSquare + kDistanceTypingSquare-30,  kSizeOfTypingSquare, kSizeOfTypingSquare)];
    }
    else{
    [fbBtn setFrame:CGRectMake(kLeftSpaceTypingRect + 5*kDistanceTypingSquare + 5 * kSizeOfTypingSquare+6,kYOfTypingView + kSizeOfTypingSquare + kDistanceTypingSquare+6,  kSizeOfTypingSquare-12, kSizeOfTypingSquare-12)];
    }
    [fbBtn setBackgroundImage:[UIImage imageNamed:@"hint.png"] forState:UIControlStateNormal];
    [fbBtn addTarget:delegate action:@selector(hint) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:fbBtn];
    [fbBtn release];
    

        

}

- (void)resetByModel:(PlayModel *)_data
{
    playModel = [_data retain];
    for (UIView *test in self.subviews)
    {
        [test removeFromSuperview];
    }
    [self createSubviews];
}

- (id)initWithFrame:(CGRect)_frame andData:(id)_data
{
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    NSLog(@"height : %f", screenBounds.size.height);
    self = [super initWithFrame:_frame];
    if (self)
    {
        
        
        playModel = [_data retain];
//        [self setBackgroundColor:kBackGroundColor];
//        UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"bg.jpg"]];
        self.backgroundColor = kBackGroundColor;
//        [background release];
        [self createSubviews];
    }
    NSLog(@"oooooooo %@   %@   %@", asV, tpV, rV);
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)finalTap:(id)_sender
{
    [delegate correctAnswerFromView];
}

- (void)tapWhenIncorrectAnswer:(UIGestureRecognizer *)_sender
{
    [_sender.view removeFromSuperview];
}

#pragma mark AnswerViewDelegate

- (void)incorrectAnswerFromSubView
{
    return;
    UIView *tmpView = [[UIView alloc]initWithFrame:self.bounds];
    [tmpView setBackgroundColor:[UIColor blackColor]];
    tmpView.alpha = 0.8;
    
    UIImageView *tmpImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 160)];
    [tmpImgView setImage:[UIImage imageNamed:@"try again.png"]];
    [tmpView addSubview:tmpImgView];
    [tmpImgView release];
    
    [self addSubview:tmpView];
    [tmpView release];
    
    [UIView animateWithDuration:1.5 animations:^{
        [tmpImgView setFrame:CGRectMake(0, 180, 320, 160)];
    }
                     completion:^(BOOL finished) {
                         
                         UITapGestureRecognizer *finalTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapWhenIncorrectAnswer:)];
                         [tmpView addGestureRecognizer:finalTap];
                         [finalTap release];
                     }];
}

- (void)correctAnswerFromSubView
{


    [blackView setFrame:CGRectMake(0, 0, 320, 640)];
//    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
//    [self bringSubviewToFront:blackView];
    blackView.layer.zPosition = 1;
    [blackView setHidden:NO];
    [UIView animateWithDuration:0.5
            animations:^{
                [correctImgView setFrame:CGRectMake(0, 180, 320, 160)];
            }
            completion:^(BOOL finished) {
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                UIView *test = [[UIView alloc]initWithFrame:self.bounds];
                [[self superview] addSubview:test];


                UITapGestureRecognizer *finalTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(finalTap:)];
                [test addGestureRecognizer:finalTap];
                [finalTap release];
                [test release];

            }
     ];
}

- (void)removeALetterFromController
{
    NSMutableArray *listOfRemoveableChar = [[NSMutableArray alloc] init];
    for (UIView *tmp in tpV.subviews){
        if ([tmp isKindOfClass:[InputButtonView class]]){
            InputButtonView *obj = (InputButtonView *)tmp;
            NSRange range = [playModel.answer rangeOfString:[obj.lb.text lowercaseString]];
            if (range.location == NSNotFound){
                [listOfRemoveableChar addObject:obj];
            }
        }
    }
    
    int r = arc4random()%[listOfRemoveableChar count];
    NSLog(@"num of removable char : %d %d",[listOfRemoveableChar count],r);
    InputButtonView *willBeRemoveBtn = [listOfRemoveableChar objectAtIndex:r];
    [willBeRemoveBtn removeFromSuperview];
    [playModel removeCharInDB:willBeRemoveBtn.lb.text];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
