//
//  PlayView.m
//  noitu
//
//  Created by Hoang le on 3/20/13.
//  Copyright (c) 2013 Hoang le. All rights reserved.
//

#import "HowView.h"

@implementation HowView
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

- (void)setFocusForResultViewWithTag:(int)int_tag
{
    [asV setFocusWithTag:int_tag];
    [rV setFocusWithTag:int_tag];
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

- (void)doneStep1
{
    UILabel *sub1 = (UILabel *)[[self superview] viewWithTag:kTagOfSubtitle1];
    sub1.text = @"FIRST TWO LETTERS IS REVEALED";
    
    UIImageView *arrowIV = (UIImageView *)[self viewWithTag:kTagOfArrowDown3];
    arrowIV.alpha = 0;
    
    [UIView animateWithDuration:1.5 animations:^{
        tpV.alpha = 0;
    } completion:^(BOOL finished) {
        [self step2];
//        UIView *transView = [[UIView alloc]initWithFrame:CGRectMake(0, kHeightOfNavigationBar, kWidthOfScreen, kHeightOfScreen-kHeightOfNavigationBar)];
//        transView.layer.zPosition = 1;
//        [transView setBackgroundColor:[UIColor clearColor]];
//        UITapGestureRecognizer *_tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(step2:)];
//        [transView addGestureRecognizer:_tap2];
//        [_tap2 release];
//        [[self superview] addSubview:transView];
//        [transView release];
    }];
    

}



- (void)pickCharPressed:(UITapGestureRecognizer *)_sender
{
    InputButtonView *btn = (InputButtonView *)_sender.view;
    NSLog(@"aaaaaaaa %d",btn.tagg);
    
    [[self viewWithTag:(kTagOfArrowDown1+btn.tagg)] setAlpha:0];
    [[self viewWithTag:(kTagOfArrowDown1+btn.tagg+1)] setAlpha:1];
    
    for (UIView *_view in tpV.subviews)
    {
        if ([_view isKindOfClass:[InputButtonView class]]){
            InputButtonView *btnView = (InputButtonView *)_view;
            if (btnView.tagg!=btn.tagg+1){
                for (UIGestureRecognizer *ges in btnView.gestureRecognizers)
                    ges.enabled = NO;
            }else{
                for (UIGestureRecognizer *ges in btnView.gestureRecognizers)
                    ges.enabled = YES;
            }
        }
    }
    

    
    
    int tagOfThatView = [[[NSUserDefaults standardUserDefaults] valueForKey:kStringtagOfFocusedLabelInAnswerView] intValue];
//    [delegate charPickedFromView:_sender.currentTitle];
    
//    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:kStringtagOfFocusedLabelInAnswerView]);
    [asV setNewChar:(InputButtonView *)_sender.view];
    
    for (UIView *_view in asV.subviews){
        for (UIGestureRecognizer *_ges in _view.gestureRecognizers){
            _ges.enabled = NO;
        }
    }
    
    
//        NSLog(@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:kStringtagOfFocusedLabelInAnswerView]);
    [rV setNewChar:(InputButtonView *)_sender.view atTag:tagOfThatView];
    
//    UIView *_tmpView = (UIImageView *)[self viewWithTag:kTagOfArrowDown];
//    _tmpView setFrame:CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
    
    if ((tagOfThatView <100+playModel.numcharleft)&&([asV checkFullCharLeft])){
        NSLog(@"full char left");
        if ([asV checkCorrectAnswerLeft]){
            [asV completeLeftString];
            NSLog(@"left string is correct !!!");
        }
        [self doneStep1];
    }else  if ((tagOfThatView >=100+playModel.numcharleft)&&([asV checkFullCharRight]))
    {
        NSLog(@"full char right	");
        if ([asV checkCorrectAnswerRight]){
            [asV completeRightString];
            NSLog(@"right string is correct !!!");
        }
    }
}

- (void)createNavigationBar
{
    UINavigationBar *naviBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, kHeightOfNavigationBar)];
    
    [naviBar setBarTintColor:[UIColor brownColor]];
    UINavigationItem *navItem = [UINavigationItem alloc];
//    navItem.title = @"Play";
   
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 30, 30);
//    btn setBackgroundImage:<#(UIImage *)#> forState:<#(UIControlState)#>
    [btn setImage: [UIImage imageNamed:@"arrow_left.png"] forState:UIControlStateNormal];
    [btn addTarget:delegate action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];

//    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"arrow_left.png"] style:UIBarButtonItemStyleDone target:delegate action:@selector(dismiss)];
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc]initWithTitle:@"Back" style:UIBarButtonSystemItemCancel target:delegate action:@selector(dismiss)];
    
    [cancelBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor yellowColor], UITextAttributeTextColor,nil] forState:UIControlStateNormal];
//    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
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
    NSLog(@"AAAAAAAAAAAAA %@",playModel.leftSource);
    UILabel *levelLabel = [[UILabel alloc]init];
    levelLabel.text = [NSString stringWithFormat:@"%d",playModel.level];
        [levelLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:25]];
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
    [coinLabel setFont:[UIFont fontWithName:@"ArialMT" size:20]];
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

//    coinView.userInteractionEnabled = YES;
//    UITapGestureRecognizer *_tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(test)];
//    [coinView addGestureRecognizer:_tap];
//    [_tap release];
    
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
    UIView *newView = (UIImageView *)[self viewWithTag:kTagOfZoomImageView];
    NSLog(@"2222");
    
//    NSLog(@"ref count of imgview : %d", [newImageView retainCount]);
    if (newView)
    {
        [newView removeFromSuperview];
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
    
    UIView *newView = [[UIView alloc]initWithFrame:CGRectMake(kXOfRightImage, kYOfImage, 120, 120)];
    [newView setBackgroundColor:[UIColor whiteColor]];
    [newView.layer setCornerRadius:10.0f];
    [newView addSubview:newImgView];
    
    [newImgView setFrame:CGRectMake(5, 5, 110, 110)];
    
   
    
    NSLog(@"3");
    
    
    UITapGestureRecognizer *_tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToNormal:)];
    _tap.numberOfTapsRequired = 1;
    [clearView addGestureRecognizer:_tap];
    
    
    //             [self addSubview:clearView];
    [_tap release];
    
    [[self superview] addSubview:clearView];
    
    
    
    
    [clearView addSubview:newView];
    //    [newImgView setFrame:CGRectMake(kXOfLeftImage+30, kYOfImage+30, 200, 200)];
    
    //    UIImageView *tmpImgView = [[UIImageView alloc]initWithImage:tappedImgView.image];
    //    [tmpImgView setFrame:CGRectMake(kXOfLeftImage, kYOfImage, 110, 110)];
    //    [clearView addSubview:tmpImgView];
    
    UIView *protectView = [[UIView alloc]initWithFrame:self.bounds];
    [[self superview] addSubview:protectView];
    [protectView release];
    
    [UIView animateWithDuration:0.2f
                     animations:^{
                         [newView setFrame:CGRectMake(10, kYOfImage+30, 300, 300)];
                         [newImgView setFrame:CGRectMake(5, 5, 290, 290)];
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
    
//    UIView *leftNewView = [[UIView alloc]initWithFrame:CGRectMake(kXOfLeftImage, kYOfImage, 110, 110)];
    
    NSLog(@"2");
    
    UIView *newView = [[UIView alloc]initWithFrame:CGRectMake(kXOfLeftImage, kYOfImage, 120, 120)];
    [newView setBackgroundColor:[UIColor whiteColor]];
    [newView.layer setCornerRadius:10.0f];
    [newView addSubview:newImgView];
    
    [newImgView setFrame:CGRectMake(5, 5, 110, 110)];
    
    NSLog(@"3");
    
    
        UITapGestureRecognizer *_tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToNormal:)];
    _tap.numberOfTapsRequired = 1;
    [clearView addGestureRecognizer:_tap];
    
    
    //             [self addSubview:clearView];
    [_tap release];
    
    [[self superview] addSubview:clearView];
    

    
    
    [clearView addSubview:newView];
//    [newImgView setFrame:CGRectMake(kXOfLeftImage+30, kYOfImage+30, 200, 200)];
    
//    UIImageView *tmpImgView = [[UIImageView alloc]initWithImage:tappedImgView.image];
//    [tmpImgView setFrame:CGRectMake(kXOfLeftImage, kYOfImage, 110, 110)];
//    [clearView addSubview:tmpImgView];
    
    UIView *protectView = [[UIView alloc]initWithFrame:self.bounds];
    [[self superview] addSubview:protectView];
    [protectView release];
    
    [UIView animateWithDuration:0.2f
    animations:^{
        [newView setFrame:CGRectMake(10, kYOfImage+30, 300, 300)];
        [newImgView setFrame:CGRectMake(5, 5, 290, 290)];
    }
    completion:^(BOOL finished)
     {
         if (finished)
         {
             NSLog(@"Done...");
//             [tmpImgView removeFromSuperview];
             [newView setTag:kTagOfZoomImageView];
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

- (void)step3:(UIGestureRecognizer *)_sender
{
    [_sender.view removeFromSuperview];
    
    [UIView animateWithDuration:1.0 animations:^{
        [[[self superview] viewWithTag:kTagOfSubtitle2] setAlpha:0];
    } completion:^(BOOL finished) {
        nil;
    }];

    
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView animateWithDuration:2.0 animations:^{
        leftView.alpha = 1;
        for (int i=0;i<playModel.numcharleft;i++){
            UILabel *lb = (UILabel *)[asV viewWithTag:i+100];
            lb.alpha = 1;
            lb.text = [[playModel.answer substringWithRange:NSMakeRange(i, 1)] uppercaseString];
        }
        for (int i=playModel.numcharleft;i<playModel.leftString.length;i++){
            UILabel *lb = (UILabel *)[asV viewWithTag:i+200];
            lb.alpha = 1;
            lb.text = [[playModel.leftString substringWithRange:NSMakeRange(i, 1)] uppercaseString];
            //            [asV viewWithTag:(200+i)].alpha = 1;
        }
    } completion:^(BOOL finished) {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }];
    
    
    NSLog(@"STEP ##3333##");
}

- (void)step2
{
    
//    UILabel *subtitle = [[UILabel alloc]initWithFrame:CGRectMake(0, kYOfAnswerView+100, 320, 100)];
//    subtitle.textAlignment = NSTextAlignmentCenter;
//    subtitle.text = @"THIS WORD PRESENT RIGHT IMAGE TAP ANYWHERE TO CONTINUE";
//    subtitle.numberOfLines = 2;
//    [subtitle setBackgroundColor:[UIColor clearColor]];
//    [subtitle setFont:[UIFont fontWithName:@"Arial-Bold" size:25.0]];
//    [subtitle setTextColor:[UIColor yellowColor]];
//    [subtitle setTag:kTagOfSubtitle2];
//    [self addSubview:subtitle];
//    [subtitle release];
    
//    subtitle.alpha = 0;
    
    UIImageView *arrowIV = (UIImageView *)[self viewWithTag:kTagOfArrowDown3];
    
    UILabel *sub1 = (UILabel *)[[self superview] viewWithTag:kTagOfSubtitle1];
    sub1.text = @"GUESS SECOND WORD";
    sub1.alpha = 0;
//    [_sender.view removeFromSuperview];
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
//    [UIView animateWithDuration:1.5 animations:^{
//        [[[self superview] viewWithTag:kTagOfSubtitle1] setAlpha:0];
//    } completion:^(BOOL finished) {
//        [_sender.view removeFromSuperview];
//        [[[self superview] viewWithTag:kTagOfSubtitle1] removeFromSuperview];
//        NSLog(@"TAP 2 ......");
//       
//    }];
//    
   [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
//       [leftView setAlpha:0];
       [rightView setAlpha:1];
       tpV.alpha = 1;
       sub1.alpha = 1;
       arrowIV.alpha = 1;
       
//       for (int i=0;i<playModel.numcharleft;i++){
//           UILabel *lb = (UILabel *)[asV viewWithTag:i+100];
//           lb.alpha = 0;
//           lb.text = [[playModel.answer substringWithRange:NSMakeRange(i, 1)] uppercaseString];
//       }
//       for (int i=playModel.numcharleft;i<playModel.leftString.length;i++){
//           UILabel *lb = (UILabel *)[asV viewWithTag:i+200];
//           lb.alpha = 0;
//           lb.text = [[playModel.leftString substringWithRange:NSMakeRange(i, 1)] uppercaseString];
//       }
       
       for (int i=playModel.numcharleft;i<playModel.answer.length;i++){
           UILabel *lb = (UILabel *)[asV viewWithTag:i+100];
           lb.alpha = 1;
//           lb.text = [[playModel.answer substringWithRange:NSMakeRange(i, 1)] uppercaseString];
       }
       for (int i=0;i<playModel.numcharleft;i++){
           UILabel *lb = (UILabel *)[asV viewWithTag:i+300];
           lb.alpha = 1;
//           lb.text = [[playModel.rightString substringWithRange:NSMakeRange(i, 1)] uppercaseString];
           //            [asV viewWithTag:(200+i)].alpha = 1;
       }
   } completion:^(BOOL finished) {
       [[UIApplication sharedApplication] endIgnoringInteractionEvents];

//       [[UIApplication sharedApplication] endIgnoringInteractionEvents];
//       UIView *transView = [[UIView alloc]initWithFrame:CGRectMake(0, kHeightOfNavigationBar, kWidthOfScreen, kHeightOfScreen-kHeightOfNavigationBar)];
//       transView.layer.zPosition = 1;
//       [transView setBackgroundColor:[UIColor clearColor]];
//       UITapGestureRecognizer *_tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(step3:)];
//       [transView addGestureRecognizer:_tap2];
//       [_tap2 release];
//       [[self superview] addSubview:transView];
//       [transView release];
   }];

}

- (void)makeArrow
{

    UIView *_view1 = (UIImageView *)[self viewWithTag:kTagOfArrowDown1];
    UIView *_view2 = (UIImageView *)[self viewWithTag:kTagOfArrowDown2];
    UIView *_view3 = (UIImageView *)[self viewWithTag:kTagOfArrowDown3];
    UIView *_view4 = (UIImageView *)[self viewWithTag:kTagOfArrowDown4];
    UIView *_view5 = (UIImageView *)[self viewWithTag:kTagOfArrowDown5];
    [UIView animateWithDuration:0.5 delay:0 options:nil animations:^{
        [_view1 setFrame:CGRectMake(_view1.frame.origin.x, kYOfTypingView-50, 35, 35)];
        [_view2 setFrame:CGRectMake(_view2.frame.origin.x, kYOfTypingView-50, 35, 35)];
        [_view3 setFrame:CGRectMake(_view3.frame.origin.x, kYOfTypingView-50, 35, 35)];
        [_view4 setFrame:CGRectMake(_view4.frame.origin.x, kYOfTypingView-50, 35, 35)];
        [_view5 setFrame:CGRectMake(_view5.frame.origin.x, kYOfTypingView-50, 35, 35)];
    } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
            [_view1 setFrame:CGRectMake(_view1.frame.origin.x, kYOfTypingView-40, 35, 35)];
            [_view3 setFrame:CGRectMake(_view3.frame.origin.x, kYOfTypingView-40, 35, 35)];
            [_view4 setFrame:CGRectMake(_view4.frame.origin.x, kYOfTypingView-40, 35, 35)];
            [_view2 setFrame:CGRectMake(_view2.frame.origin.x, kYOfTypingView-40, 35, 35)];
            [_view5 setFrame:CGRectMake(_view5.frame.origin.x, kYOfTypingView-40, 35, 35)];
        } completion:^(BOOL finished) {
            [self makeArrow];
        }];

    }];
}

- (void)step1:(UIGestureRecognizer *)_sender
{
    
    [_sender.view removeFromSuperview];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    [UIView animateWithDuration:1.0 animations:^{
        rightView.alpha = 0;
        tpV.alpha = 0;
       
        for (int i=playModel.numcharleft;i<playModel.answer.length;i++){
            UILabel *lb = (UILabel *)[asV viewWithTag:i+100];
            lb.alpha = 0;
//            lb.text = [[playModel.answer substringWithRange:NSMakeRange(i, 1)] uppercaseString];
        }
        for (int i=0;i<playModel.numcharleft;i++){
            UILabel *lb = (UILabel *)[asV viewWithTag:i+300];
            lb.alpha = 0;
//            lb.text = [[playModel.leftString substringWithRange:NSMakeRange(i, 1)] uppercaseString];
            //            [asV viewWithTag:(200+i)].alpha = 1;
        }
//        rV.alpha = 0;
//        tpV.alpha = 0;
//        leftSourceLB.alpha = 0;
//        rightSourceLB.alpha = 0;
        fbBtn.alpha = 0;
    } completion:^(BOOL finished) {
        
        
        UILabel *subtitle = (UILabel *)[[self superview] viewWithTag:kTagOfSubtitle1];
        
        subtitle.text = @"FIRST WORD PRESENT LEFT IMAGE GUEST THIS WORD";


        
        subtitle.alpha = 0;
        [UIView animateWithDuration:2.0 animations:^{
//            [leftView setAlpha:1.0];
//            for (int i=0;i<playModel.numcharleft;i++){
//                UILabel *lb = (UILabel *)[asV viewWithTag:i+100];
//                lb.alpha = 1;
//                lb.text = [[playModel.answer substringWithRange:NSMakeRange(i, 1)] uppercaseString];
//            }
//            for (int i=playModel.numcharleft;i<playModel.leftString.length;i++){
//                UILabel *lb = (UILabel *)[asV viewWithTag:i+200];
//                lb.alpha = 1;
//                lb.text = [[playModel.leftString substringWithRange:NSMakeRange(i, 1)] uppercaseString];
//                //            [asV viewWithTag:(200+i)].alpha = 1;
//            }
            subtitle.alpha = 1;
        } completion:^(BOOL finished) {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            tpV.alpha = 1;
            UIImageView *arrowView = [[UIImageView alloc]initWithFrame:CGRectMake(15, kYOfTypingView-40, 35, 35)];
            arrowView.image = [UIImage imageNamed:@"arrow_down.png"];
            [arrowView setTag:kTagOfArrowDown1];
            [self addSubview:arrowView];
            [arrowView release];
            
            UIImageView *arrowView2 = [[UIImageView alloc]initWithFrame:CGRectMake(15+53, kYOfTypingView-40, 35, 35)];
            arrowView2.image = [UIImage imageNamed:@"arrow_down.png"];
            [arrowView2 setTag:kTagOfArrowDown2];
            [self addSubview:arrowView2];
            [arrowView2 release];
            
            UIImageView *arrowView3 = [[UIImageView alloc]initWithFrame:CGRectMake(15+53*2, kYOfTypingView-40, 35, 35)];
            arrowView3.image = [UIImage imageNamed:@"arrow_down.png"];
            [arrowView3 setTag:kTagOfArrowDown3];
            [self addSubview:arrowView3];
            [arrowView3 release];
            
            UIImageView *arrowView4 = [[UIImageView alloc]initWithFrame:CGRectMake(15+53*3, kYOfTypingView-40, 35, 35)];
            arrowView4.image = [UIImage imageNamed:@"arrow_down.png"];
            [arrowView4 setTag:kTagOfArrowDown4];
            [self addSubview:arrowView4];
            [arrowView4 release];
            
            UIImageView *arrowView5 = [[UIImageView alloc]initWithFrame:CGRectMake(15+53*4, kYOfTypingView-40, 35, 35)];
            arrowView5.image = [UIImage imageNamed:@"arrow_down.png"];
            [arrowView5 setTag:kTagOfArrowDown5];
            [self addSubview:arrowView5];
            [arrowView5 release];
            
            arrowView2.alpha=0;
            arrowView3.alpha=0;
            arrowView4.alpha=0;
            arrowView5.alpha=0;
            
            [self makeArrow];

            
//            [UIView beginAnimations:nil context:nil];
//            [UIView setAnimationDuration:0.5f];
//            [UIView setAnimationRepeatCount:1000000];
//            [arrowView setFrame:CGRectMake(20, kYOfTypingView-50, 35, 35)];
//            [arrowView setFrame:CGRectMake(20, kYOfTypingView-40, 35, 35)];
//            [UIView commitAnimations];
            for (UIView *_view in asV.subviews)
            {
                for (UIGestureRecognizer *ges in _view.gestureRecognizers)
                    ges.enabled = NO;
            }
            
            for (UIView *_view in tpV.subviews)
            {
                if ([_view isKindOfClass:[InputButtonView class]]){
                    InputButtonView *btnView = (InputButtonView *)_view;
                    if (btnView.tagg!=0){
                        for (UIGestureRecognizer *ges in btnView.gestureRecognizers)
                            ges.enabled = NO;
                    }
                }                
            }
                
            return;

                
                //            for (int i=0;i<playModel.numcharleft;i++){
                //                UILabel *lb = (UILabel *)[asV viewWithTag:i+100];
                //                lb.text = [[playModel.answer substringWithRange:NSMakeRange(i, 1)] uppercaseString];
                //            }
                //
                //            for (int i=playModel.numcharleft;i<playModel.leftString.length;i++)
                //            {
                //                UILabel *lb = (UILabel *)[asV viewWithTag:i+200];
                //                lb.text = [[playModel.leftString substringWithRange:NSMakeRange(i, 1)] uppercaseString];
                //            }
                
//                UIView *clearView = [[UIView alloc] initWithFrame:CGRectMake(0, kHeightOfNavigationBar, kWidthOfScreen, kHeightOfScreen-kHeightOfNavigationBar)];
//                clearView.layer.zPosition = 1;
//                [clearView setBackgroundColor:[UIColor clearColor]];
//                UITapGestureRecognizer *_tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(step2:)];
//                [clearView addGestureRecognizer:_tap2];
//                [_tap2 release];
//                [[self superview] addSubview:clearView];
//                [clearView release];
                

                
           
            
            
        }];
    }];    

 
}

- (void)createSubviews
{
    [self createNavigationBar];
    
    [self createTopInfo];
    
    blackView = [[UIView alloc]initWithFrame:CGRectMake(-1000, -1000, 320, 640)];
    [blackView setBackgroundColor:[UIColor clearColor]];
    blackView.alpha = 0.8;
//    blackView.layer.zPosition = 1;
//    [blackView setHidden:YES];
    
    correctImgView = [[UIImageView alloc]initWithFrame:CGRectMake(-320, 325, 320, 160)];
    NSArray *tmpArr = [NSArray arrayWithObjects:@"awesome.png", @"correct.png", @"good job.png", @"excellent.png", nil];
    int tmpInt = arc4random()%4;
    [correctImgView setImage:[UIImage imageNamed:tmpArr[tmpInt]]];
    [blackView addSubview:correctImgView];
    [self addSubview:blackView];
    
    leftSourceLB = [[UILabel alloc]initWithFrame:CGRectMake(5-kSizeOfImage/2, kYOfImage+kSizeOfImage/2-10, kSizeOfImage, 20)];
    [leftSourceLB setTextAlignment:NSTextAlignmentCenter];
    leftSourceLB.text = playModel.leftSource;
    [leftSourceLB setFont:[UIFont fontWithName:@"Arial-BoldMT" size:10]];
    [leftSourceLB setTransform:CGAffineTransformMakeRotation(-M_PI / 2)];
    [leftSourceLB setBackgroundColor:[UIColor clearColor]];
    [self addSubview:leftSourceLB];
    [leftSourceLB release];
    
    rightSourceLB = [[UILabel alloc]initWithFrame:CGRectMake(315-kSizeOfImage/2, kYOfImage+kSizeOfImage/2-10, kSizeOfImage, 20)];
    [rightSourceLB setTextAlignment:NSTextAlignmentCenter];
    rightSourceLB.text = playModel.rightSource;
    [rightSourceLB setFont:[UIFont fontWithName:@"Arial-BoldMT" size:10]];
    [rightSourceLB setTransform:CGAffineTransformMakeRotation(-M_PI / 2)];
    [rightSourceLB setBackgroundColor:[UIColor clearColor]];
    [self addSubview:rightSourceLB];
    [rightSourceLB release];
    
    leftView = [[UIView alloc]initWithFrame:CGRectMake(kXOfLeftImage, kYOfImage, kSizeOfImage, kSizeOfImage)];
    [leftView setBackgroundColor:[UIColor whiteColor]];
    [leftView.layer setCornerRadius:10.0f];
    

    
//    UIImageView *leftIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",playModel.leftString]]];
    UIImageView *leftIV = [[UIImageView alloc]initWithImage:playModel.leftImage];
    NSLog(@"left image : %@",playModel.leftString);
    [leftIV setBackgroundColor:[UIColor colorWithRed:230/255.0 green:223/255.0 blue:213/255.0 alpha:1.0]];
    [leftIV setFrame:CGRectMake(5, 5, kSizeOfImage-5-5, kSizeOfImage-5-5)];
    [leftIV.layer setCornerRadius:10.0f];
    leftIV.userInteractionEnabled = YES;
    
    
    UITapGestureRecognizer *_tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapLeftImgView:)];
    [leftIV addGestureRecognizer:_tap];
    [_tap release];
    
    
    [leftView addSubview:leftIV];
    [self addSubview:leftView];

    [leftIV release];
    [leftView release];
    
    rightView = [[UIView alloc]initWithFrame:CGRectMake(kXOfRightImage, kYOfImage, kSizeOfImage, kSizeOfImage)];
    [rightView setBackgroundColor:[UIColor whiteColor]];
    [rightView.layer setCornerRadius:10.0f];
    
//    UIImageView *rightIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",playModel.rightString]]];
    UIImageView *rightIV = [[UIImageView alloc]initWithImage:playModel.rightImage];
    NSLog(@"right image : %@",playModel.rightString);
    NSLog(@"answer image : %@",playModel.answer);
    
    rightIV.userInteractionEnabled = YES;
    UITapGestureRecognizer *_tapRight = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapRightImgView:)];
    [rightIV addGestureRecognizer:_tapRight];
    [_tapRight release];
    
    [rightIV setBackgroundColor:[UIColor colorWithRed:230/255.0 green:223/255.0 blue:213/255.0 alpha:1.0]];
//    [rightIV setImage:[UIImage imageNamed:@"capital.png"]];
    [rightIV setFrame:CGRectMake(5, 5, kSizeOfImage-5-5, kSizeOfImage-5-5)];
    [rightIV.layer setCornerRadius:10.0f];
    [rightView addSubview:rightIV];
    [self addSubview:rightView];
    [rightIV release];
    [rightView release];
    
//    asM = [[AnswerModel alloc]initWithNumCharOfLeft:3 NumCharOfRight:3 LeftString:@"cash" RightString:@"turtle" CorrectAnswer:@"castle"];
    
    asV = [[AnswerView alloc]initWithData:playModel andDelegate:self];
        
    tpV = [[TypingView alloc]initWithData:playModel andDelegate:self];
    
    rV = [[ResultView alloc]initWithData:playModel andDelegate:self];
    [rV setHidden:YES];
    
    [self addSubview:rV];
    [self addSubview:tpV];
    
    [self addSubview:asV];
    [tpV release];
    [asV release];
    
//    fbBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    int valueDevice = [[UIDevice currentDevice] resolution];
//    if (valueDevice <3){
//    [fbBtn setFrame:CGRectMake(kLeftSpaceTypingRect + 5*kDistanceTypingSquare + 5 * kSizeOfTypingSquare,kYOfTypingView + kSizeOfTypingSquare + kDistanceTypingSquare-30,  kSizeOfTypingSquare, kSizeOfTypingSquare)];
//    }
//    else{
//    [fbBtn setFrame:CGRectMake(kLeftSpaceTypingRect + 5*kDistanceTypingSquare + 5 * kSizeOfTypingSquare+6,kYOfTypingView + kSizeOfTypingSquare + kDistanceTypingSquare+6,  kSizeOfTypingSquare-12, kSizeOfTypingSquare-12)];
//    }
//    [fbBtn setBackgroundImage:[UIImage imageNamed:@"hint.png"] forState:UIControlStateNormal];
//    [fbBtn addTarget:delegate action:@selector(hint) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:fbBtn];

    
   // ********************************************************** ANIMATE ***************************************************************************
    
    NSLog(@"vvvvv");
    
    
    
    UILabel *subtitle = [[UILabel alloc]initWithFrame:CGRectMake(0, kYOfImage+kSizeOfImage+10, 320, 40)];
    subtitle.textAlignment = NSTextAlignmentCenter;
    subtitle.text = @"TAP ANYWHERE TO CONTINUE";
    subtitle.numberOfLines = 2;
    [subtitle setBackgroundColor:[UIColor clearColor]];
    [subtitle setFont:[UIFont fontWithName:@"Arial-Bold" size:25.0]];
    [subtitle setTextColor:[UIColor yellowColor]];
    [subtitle setTag:kTagOfSubtitle1];
    [self addSubview:subtitle];
    [subtitle release];
    
    UIView *zzzzz = [[UIView alloc] initWithFrame:CGRectMake(0, kHeightOfNavigationBar, kWidthOfScreen, kHeightOfScreen-kHeightOfNavigationBar)];
    zzzzz.layer.zPosition = 1;
    [zzzzz setBackgroundColor:[UIColor clearColor]];
    UITapGestureRecognizer *_tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(step1:)];
    [zzzzz addGestureRecognizer:_tap1];
    [_tap1 release];
    [self addSubview:zzzzz];
    [zzzzz release];
    
    


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

    NSString *hintString = [[NSUserDefaults standardUserDefaults] stringForKey:@"hintString"];
    int revealIndex =-1;
    int revealWord =-1;
    if (![[hintString substringWithRange:NSMakeRange(1, 1)] isEqualToString:@"@"]){
        revealIndex = [[hintString substringWithRange:NSMakeRange(1, 1)] intValue];
    }
    
    if (![[hintString substringWithRange:NSMakeRange(2, 1)] isEqualToString:@"@"]){
        revealWord = [[hintString substringWithRange:NSMakeRange(2, 1)] intValue];
    }
    

    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    NSLog(@"height : %f", screenBounds.size.height);
    self = [super initWithFrame:_frame];
    if (self)
    {
        
        
        playModel = [_data retain];
//        [self setBackgroundColor:kBackGroundColor];
        UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.png"]];
        self.backgroundColor = background;
//        [background release];
        
        
        [self createSubviews];
        if (revealIndex!=-1)
            [self revealALetterFromController:revealIndex];
        if (revealWord==0)
            [self revealLeftWordFromController];
        if (revealWord ==1)
            [self revealRightWordFromController];
    }
    NSLog(@"oooooooo %@   %@   %@", asV, tpV, rV);
    
//    WinView *winView = [[WinView alloc]initWithFrame:CGRectMake(-kWidthOfScreen, 0, kWidthOfScreen, kHeightOfScreen) andWord:playModel.answer];
//    [winView setTag:1412];
//    [self addSubview:winView];
//    [winView release];
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

- (void)correctAnswerFromSubViewInHowTo
{
    [blackView setFrame:CGRectMake(0, 0, 320, 640)];
    [blackView setBackgroundColor:[UIColor blackColor]];
    blackView.layer.zPosition = 1;
    [blackView setHidden:NO];
    blackView.alpha = 0;
    WinView *winView = [[WinView alloc]initWithFrame:CGRectMake(0, -kHeightOfScreen, kWidthOfScreen, kHeightOfScreen) andWord:playModel.answer];
    
    [self.superview addSubview:winView];
    
    [winView release];
    sleep(0.5);
    
    [UIView animateWithDuration:1.0 animations:^{
        for (int i=playModel.numcharleft;i<playModel.leftString.length;i++)
        {
            UILabel *grayLabelTop = (UILabel *)[asV viewWithTag:200+i];
            grayLabelTop.alpha=0;
        }
        for (int i=0;i<playModel.rightString.length-playModel.numcharright;i++)
        {
            UILabel *grayLabelBot = (UILabel *)[asV viewWithTag:300+i];
            grayLabelBot.alpha=0;
        }
    }completion:^(BOOL finished){
        //        NSLog(@"%f",)
        float width = [asV viewWithTag:100+playModel.answer.length-1].frame.origin.x-[asV viewWithTag:100].frame.origin.x+32;
        float leftPoint = (kWidthOfScreen-width)/2;
        float distanceToLeft = [asV viewWithTag:100].frame.origin.x+asV.frame.origin.x-leftPoint;
        [UIView animateWithDuration:1.0 animations:^{
            
            for (int i=0;i<playModel.answer.length;i++){
                UILabel *asLB = (UILabel *)[asV viewWithTag:100+i];
                [asLB setFrame:CGRectMake(asLB.frame.origin.x-distanceToLeft, 20, kSizeOfAnswerSquare, kSizeOfAnswerSquare)];
            }
            
        }completion:^(BOOL finished) {
            //            UIView *test1 = [[UIView alloc]initWithFrame:CGRectMake(0, kYOfAnswerView, 84, 16)];
            //            [test1 setBackgroundColor:[UIColor whiteColor]];
            //            UIView *test2 = [[UIView alloc]initWithFrame:CGRectMake(152+84, kYOfAnswerView, 84, 16)];
            //            [test2 setBackgroundColor:[UIColor whiteColor]];
            //            [self.superview addSubview:test1];
            //            [self.superview addSubview:test2];
            //            [test1 release];
            //            [test2 release];
            sleep(1.0);
            
            [UIView animateWithDuration:0.5
                             animations:^{
                                 [winView setFrame:self.bounds];
                                 blackView.alpha = 0.7;
                                 //                [winView setHidden:NO];
                                 //                [correctImgView setFrame:CGRectMake(320, 325, 320, 160)];
                             }
                             completion:^(BOOL finished) {
                                 //                [blackView setBackgroundColor:[UIColor clearColor]];
                                 [UIView animateWithDuration:0.2 animations:^{
                                     [winView setFrame:CGRectMake(0, -30, kWidthOfScreen, kHeightOfScreen)];
                                 }completion:^(BOOL finished){
                                     [UIView animateWithDuration:0.2 animations:^{
                                         [winView setFrame:self.bounds];
                                     }completion:^(BOOL finished){
                                         [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                                         UIView *test = [[UIView alloc]initWithFrame:self.bounds];
                                         [[self superview] addSubview:test];
                                         
                                         
                                         UITapGestureRecognizer *finalTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(finalTap:)];
                                         [test addGestureRecognizer:finalTap];
                                         [finalTap release];
                                         [test release];
                                         
                                         
                                     }];
                                     
                                 }];
                                 
                                 
                             }
             ];
        }];
    }
     ];
}

- (void)correctAnswerFromSubView
{
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    UILabel *sub1 = (UILabel *)[[self superview] viewWithTag:kTagOfSubtitle1];
    sub1.text = @"THE FINAL WORD IS 'HOUSE'";
    sub1.alpha = 0;
    
    [UIView animateWithDuration:2.0 animations:^{
        sub1.alpha = 1;
    } completion:^(BOOL finished) {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        [self correctAnswerFromSubViewInHowTo];
        
        //        [self correctAnswerFromSubView];
    }];
    
    
//    [UIView animateWithDuration:0.5
//            animations:^{
//                [winView setFrame:self.bounds];
////                [winView setHidden:NO];
////                [correctImgView setFrame:CGRectMake(320, 325, 320, 160)];
//            }
//            completion:^(BOOL finished) {
////                [blackView setBackgroundColor:[UIColor clearColor]];
//                [UIView animateWithDuration:0.2 animations:^{
//                    [winView setFrame:CGRectMake(0, -30, kWidthOfScreen, kHeightOfScreen)];
//                }completion:^(BOOL finished){
//                    [UIView animateWithDuration:0.2 animations:^{
//                        [winView setFrame:self.bounds];
//                    }completion:^(BOOL finished){
//                        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
//                        UIView *test = [[UIView alloc]initWithFrame:self.bounds];
//                        [[self superview] addSubview:test];
//                        
//                        
//                        UITapGestureRecognizer *finalTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(finalTap:)];
//                        [test addGestureRecognizer:finalTap];
//                        [finalTap release];
//                        [test release];
//
//                       
//                    }];
//
//                }];
//                
//
//            }
//     ];
    
//    int coins = [[[NSUserDefaults standardUserDefaults] objectForKey:@"coins"] intValue];
//    
//    coins = coins+playModel.answer.length*kCoinEachLetter;
//    NSNumber *num = [NSNumber numberWithInt:coins];
//    NSLog(@" new coin : %d",[num intValue]);
//    [[NSUserDefaults standardUserDefaults] setObject:(id)num forKey:@"coins"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (BOOL)checkAvailableWhenReveal:(int)_r
{
    UILabel *rVLabel = (UILabel *)[rV viewWithTag:(100+_r)];
//    if ([rVLabel.text isEqualToString:[[playModel.answer substringWithRange:NSMakeRange(_r, 1)] uppercaseString]]){
//        return NO;
//    }
    if ([rVLabel.text isEqualToString:@""]){
        return YES;
    }
    return NO;
}

- (void)revealLeftWordFromController
{
    for (int i = 0; i<playModel.numcharleft;i++)
    {
        [self revealALetterFromController:i];
//        NSString *revealedChar = [playModel.answer substringWithRange:NSMakeRange(i, 1)];
//        
//        int tmpTag = 100+i;
//        
//        UILabel *revealLB = (UILabel *)[rV viewWithTag:tmpTag];
//        
//        [self performSelector:@selector(removeChar:) withObject:[revealLB.gestureRecognizers objectAtIndex:0]];
//        
//        
//        for (UIView *tmp in tpV.subviews)
//        {
//            if ([tmp isKindOfClass:[InputButtonView class]])
//            {
//                InputButtonView *inputTmp = (InputButtonView *)tmp;
//                if ([inputTmp.lb.text isEqualToString:[revealedChar uppercaseString]]){
//                    NSLog(@"reveal char : %@",inputTmp.lb.text);
//                    [self performSelector:@selector(pickCharPressed:) withObject:[inputTmp.gestureRecognizers objectAtIndex:0]];
//
//                    break;
//                }
//            }
//        }
    }
}

- (void)revealRightWordFromController
{
    for (int i = playModel.numcharleft; i<[playModel.answer length];i++)
    {
        [self revealALetterFromController:i];
//        NSString *revealedChar = [playModel.answer substringWithRange:NSMakeRange(i, 1)];
//        
//        int tmpTag = 100+i;
//        
//        UILabel *revealLB = (UILabel *)[rV viewWithTag:tmpTag];
//        
//        [self performSelector:@selector(removeChar:) withObject:[revealLB.gestureRecognizers objectAtIndex:0]];
//        
//        
//        for (UIView *tmp in tpV.subviews)
//        {
//            if ([tmp isKindOfClass:[InputButtonView class]])
//            {
//                InputButtonView *inputTmp = (InputButtonView *)tmp;
//                if ([inputTmp.lb.text isEqualToString:[revealedChar uppercaseString]]){
//                    NSLog(@"reveal char : %@",inputTmp.lb.text);
//                    [self performSelector:@selector(pickCharPressed:) withObject:[inputTmp.gestureRecognizers objectAtIndex:0]];
//                    break;
//                }
//            }
//        }
    }
}

- (int)checkNumOfEmptyLabelInResultView
{
    int count = 0;
    for (int i=0;i<playModel.answer.length;i++)
    {
        UILabel *rVLabel = (UILabel *)[rV viewWithTag:(100+i)];
        if ([rVLabel.text isEqualToString:@""]){
            count++;
        }
    }
    return count;
}

- (int)getIndexOfRevealLabel:(int)numOfEmptyLB
{
    int k = arc4random()%numOfEmptyLB+1;
    for (int i=0;i<playModel.answer.length;i++)
    {
        UILabel *rVLabel = (UILabel *)[rV viewWithTag:(100+i)];
        if ([rVLabel.text isEqualToString:@""]){
            k--;
        }
        if (k==0){
            return i;
        }
    }
    NSLog(@"getIndexOfRevealLabel ERROR !!!!!!");
    return 99;
    
}




- (void)revealALetterFromController:(int)r;
{

 
    NSString *revealedChar = [playModel.answer substringWithRange:NSMakeRange(r, 1)];
    
    int tmpTag = 100+r;
    
    UILabel *revealLB = (UILabel *)[rV viewWithTag:tmpTag];
    
    if ([revealLB.gestureRecognizers count]==0)
        return;
        
    [self performSelector:@selector(removeChar:) withObject:[revealLB.gestureRecognizers objectAtIndex:0]];
    
    int tagFocus = [[[NSUserDefaults standardUserDefaults] valueForKey:kStringtagOfFocusedLabelInAnswerView] intValue];
    
    for (UIView *tmp in tpV.subviews)
    {
        if ([tmp isKindOfClass:[InputButtonView class]])
        {
            InputButtonView *inputTmp = (InputButtonView *)tmp;
            if ([inputTmp.lb.text isEqualToString:[revealedChar uppercaseString]]){
                NSLog(@"reveal char : %@",inputTmp.lb.text);
//                [playModel revealCharInDB:inputTmp.tagg];

                [self performSelector:@selector(pickCharPressed:) withObject:[inputTmp.gestureRecognizers objectAtIndex:0]];
                
                break;
            }
        }
    }
    
    // remove gesture
    
    UILabel *asVLabel = (UILabel *)[asV viewWithTag:tagFocus];
    for (UIGestureRecognizer *ges in asVLabel.gestureRecognizers){
        NSLog(@"1");
        [asVLabel removeGestureRecognizer:ges];
                NSLog(@"2");
    }
    
    UILabel *rVLabel = (UILabel *)[rV viewWithTag:tagFocus];
    for (UIGestureRecognizer *ges in rVLabel.gestureRecognizers){
                NSLog(@"3");
        [rVLabel removeGestureRecognizer:ges];
                NSLog(@"4");
    }
    
    

    
}

- (int)checkNumOfRemoveableChars
{
    int count=0;
    for (UIView *tmp in tpV.subviews){
        if (([tmp isKindOfClass:[InputButtonView class]])&&(![tmp isHidden])){
            InputButtonView *obj = (InputButtonView *)tmp;
            NSRange range = [playModel.answer rangeOfString:[obj.lb.text lowercaseString]];
            if (range.location == NSNotFound){
                count++;
            }
        }
    }
    return count;
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
    [playModel removeCharInDB:willBeRemoveBtn.tagg];
    [willBeRemoveBtn removeFromSuperview];
    
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
