//
//  AnswerView.m
//  noitu
//
//  Created by Hoang le on 3/20/13.
//  Copyright (c) 2013 Hoang le. All rights reserved.
//

#import "AnswerView.h"

@implementation AnswerView

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

- (void)flipRightChars:(int)initTag
{
    __block int i=initTag;
    [UIView animateWithDuration:0.1 delay:0 options:nil  animations:^{
        
        [self viewWithTag:i].layer.transform = CATransform3DMakeRotation(M_PI_2,0.0,1.0,0.0); //flip halfway
        
        
    } completion:^(BOOL finished){
        
        
        
        UILabel *tmp = (UILabel *)[self viewWithTag:i];
        tmp.text = [[playModel.rightString substringWithRange:NSMakeRange(i-300, 1)] uppercaseString];
        [UIView animateWithDuration:0.1 delay:0 options:nil animations:^{
            [self viewWithTag:i].layer.transform = CATransform3DMakeRotation(M_PI_2*4,0.0,1.0,0.0); //flip halfway
            
        }completion:^(BOOL finished)
         {
//
             i=i+1;
             if (i<300+[playModel.rightString length]-playModel.numcharright)
             {
                 [self flipRightChars:i];
             }else
             {
                 if (([self checkFullChar])&&([self checkCorrectAnswer])){

                         [delegate correctAnswerFromSubView];

                 }else
                 {
                         [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                 }
             }
         }
         
         ];

//        NSLog(@"hhhh");
    }];
}

- (void)flipLeftChars:(int)initTag
{
    __block int i=initTag;
        [UIView animateWithDuration:0.1 delay:0 options:nil  animations:^{

                [self viewWithTag:i].layer.transform = CATransform3DMakeRotation(M_PI_2,0.0,1.0,0.0); //flip halfway

            
        } completion:^(BOOL finished){
                            
            UILabel *tmp = (UILabel *)[self viewWithTag:i];
            tmp.text = [[playModel.leftString substringWithRange:NSMakeRange(i-200, 1)] uppercaseString];
            [UIView animateWithDuration:0.1 delay:0 options:nil animations:^{
                [self viewWithTag:i].layer.transform = CATransform3DMakeRotation(M_PI_2*4,0.0,1.0,0.0); //flip halfway
            
            }completion:^(BOOL finished)
             {
                 
             }
             
             ];
            i=i+1;
            if (i<200+[playModel.leftString length])
            {
              [self flipLeftChars:i];
            }else
            {
                if (([self checkFullChar])&&([self checkCorrectAnswer])){
                    
                    [delegate correctAnswerFromSubView];
                    
                }else
                {
                    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                }
            }
            NSLog(@"zzzz");
        }];
    
}

- (void)completeRightString
{
    SystemSoundID audioEffect;
    NSString *path  = [[NSBundle mainBundle] pathForResource:@"success" ofType:@"wav"];
    NSURL *pathURL = [NSURL fileURLWithPath : path];
    AudioServicesCreateSystemSoundID((CFURLRef) pathURL, &audioEffect);
    AudioServicesPlaySystemSound(audioEffect);
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [self flipRightChars:300];
}

- (void)redblackLeft
{
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionRepeat animations:^{
        [UIView setAnimationRepeatCount:3];
        for (int i=0;i<playModel.numcharleft;i++){
            UILabel *tmpLB = (UILabel *)[self viewWithTag:(100+i)];
            [tmpLB setTextColor:[UIColor redColor]];
            tmpLB.alpha = 0;
        }
    } completion:^(BOOL finished) {
        for (int i=0;i<playModel.numcharleft;i++){
            UILabel *tmpLB = (UILabel *)[self viewWithTag:(100+i)];
            [tmpLB setTextColor:[UIColor blackColor]];
            tmpLB.alpha = 1;
        }
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];

    }];
}

- (void)redblackRight
{
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionRepeat animations:^{
        [UIView setAnimationRepeatCount:3];
        for (int i=playModel.numcharleft;i<playModel.answer.length;i++){
            UILabel *tmpLB = (UILabel *)[self viewWithTag:(100+i)];
            [tmpLB setTextColor:[UIColor redColor]];
            tmpLB.alpha = 0;
        }
    } completion:^(BOOL finished) {
        for (int i=playModel.numcharleft;i<playModel.answer.length;i++){
            UILabel *tmpLB = (UILabel *)[self viewWithTag:(100+i)];
            [tmpLB setTextColor:[UIColor blackColor]];
            tmpLB.alpha = 1;
        }
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
    }];
}

- (void)wrongLeftString{
    SystemSoundID audioEffect;
    NSString *path  = [[NSBundle mainBundle] pathForResource:@"wrong" ofType:@"wav"];
    NSURL *pathURL = [NSURL fileURLWithPath : path];
    AudioServicesCreateSystemSoundID((CFURLRef) pathURL, &audioEffect);
    AudioServicesPlaySystemSound(audioEffect);
    [self redblackLeft];
}

- (void)wrongRightString{
    SystemSoundID audioEffect;
    NSString *path  = [[NSBundle mainBundle] pathForResource:@"wrong" ofType:@"wav"];
    NSURL *pathURL = [NSURL fileURLWithPath : path];
    AudioServicesCreateSystemSoundID((CFURLRef) pathURL, &audioEffect);
    AudioServicesPlaySystemSound(audioEffect);
    [self redblackRight];
}

- (void)completeLeftString
{
    // Do the first half of the flip

    
//    [UIView animateWithDuration:1.0 delay:0 options:nil  animations:^{
//        for (int i=playModel.numcharleft+200;i<[playModel.leftString length]+200;i++)
//        {
//            [self viewWithTag:i].layer.transform = CATransform3DMakeRotation(M_PI,0.0,1.0,0.0); //flip halfway
//        }
//        NSLog(@"111 %@",[self viewWithTag:101].layer);
//    } completion:^(BOOL finished){
//        for (int i=playModel.numcharleft+200;i<[playModel.leftString length]+200;i++)
//        {
//            UILabel *tmp = (UILabel *)[self viewWithTag:i];
//            tmp.text = [[playModel.leftString substringWithRange:NSMakeRange(i-200, 1)] uppercaseString];
//        }
//        [UIView animateWithDuration:1.0 delay:0 options:nil  animations:^{
//            for (int i=playModel.numcharleft+200;i<[playModel.leftString length]+200;i++)
//            {
//
//                [self viewWithTag:i].layer.transform = CATransform3DMakeRotation(M_PI,0.0,1.0,0.0); //flip halfway
//            }
//            NSLog(@"222 %@",[self viewWithTag:101].layer);
//        } completion:^(BOOL finished){
//            NSLog(@"333");
//        }];
//    }
//     
//    ];
    
    SystemSoundID audioEffect;
    NSString *path  = [[NSBundle mainBundle] pathForResource:@"success" ofType:@"wav"];
    NSURL *pathURL = [NSURL fileURLWithPath : path];
    AudioServicesCreateSystemSoundID((CFURLRef) pathURL, &audioEffect);
    AudioServicesPlaySystemSound(audioEffect);
    
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
            [self flipLeftChars:playModel.numcharleft+200];
   

}

- (void)removeCharWithTag:(int)removedTag
{
    
    UILabel *willNotBeFocusLabel = (UILabel *)[self viewWithTag:[[[NSUserDefaults standardUserDefaults] valueForKey:kStringtagOfFocusedLabelInAnswerView] intValue]];
    [willNotBeFocusLabel setBackgroundColor:[UIColor whiteColor]];
    
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:removedTag] forKey:kStringtagOfFocusedLabelInAnswerView];
    [[NSUserDefaults standardUserDefaults] synchronize];
      
    UILabel *labelShouldBeRemove = (UILabel *)[self viewWithTag:removedTag];
    if (![labelShouldBeRemove.text isEqualToString:@""]){
        SystemSoundID audioEffect;
        NSString *path  = [[NSBundle mainBundle] pathForResource:@"small_amount_of_water_in_drinking_glass_movement_version_2" ofType:@"mp3"];
        NSURL *pathURL = [NSURL fileURLWithPath : path];
        AudioServicesCreateSystemSoundID((CFURLRef) pathURL, &audioEffect);
        AudioServicesPlaySystemSound(audioEffect);
    }
    
    labelShouldBeRemove.text = @"";
    [labelShouldBeRemove setBackgroundColor:kColorOfFocusedLabelAnswerView];
    [delegate setFocusForResultViewWithTag:[[[NSUserDefaults standardUserDefaults] valueForKey:kStringtagOfFocusedLabelInAnswerView] intValue]];
    
    for (UIGestureRecognizer *tmp in labelShouldBeRemove.gestureRecognizers){
        [labelShouldBeRemove removeGestureRecognizer:tmp];
    }
    
    
    UITapGestureRecognizer *_tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(setFocus:)];
    [labelShouldBeRemove addGestureRecognizer:_tap];
    [_tap release];
}

- (BOOL)checkFullChar
{
    int count = 100;
    int length = [playModel.answer length];
    UILabel *tmpLabel = (UILabel *)[self viewWithTag:count];
    while ((![tmpLabel.text isEqualToString:@""])&&(count < length+100)) {
        count++;
        tmpLabel = (UILabel *)[self viewWithTag:count];
    }
    if (count==length+100)
    {
        return YES;
    }else{
        return NO;
    }
}

- (BOOL)checkCorrectAnswer
{
    NSString *tmpStr = @"";
    for (int i=0;i<[playModel.answer length];i++){
        UILabel *tmpLabel = (UILabel *)[self viewWithTag:100+i];
        tmpStr = [tmpStr stringByAppendingString:tmpLabel.text];
    }
    if ([tmpStr isEqualToString:[playModel.answer uppercaseString]]){
        return YES;
    }
    return NO;
}

- (BOOL)checkFullCharLeft
{
    int count = 100;
    int length = playModel.numcharleft;
    UILabel *tmpLabel = (UILabel *)[self viewWithTag:count];
    while ((![tmpLabel.text isEqualToString:@""])&&(count < length+100)) {
        count++;
        tmpLabel = (UILabel *)[self viewWithTag:count];
    }
    if (count==length+100)
    {
        return YES;
    }else{
        return NO;
    }
}

- (BOOL)checkFullCharRight
{
    int count = 100+playModel.numcharleft;
    int length = [playModel.answer length];
    UILabel *tmpLabel = (UILabel *)[self viewWithTag:count];
    while ((![tmpLabel.text isEqualToString:@""])&&(count < length+100)) {
        count++;
        tmpLabel = (UILabel *)[self viewWithTag:count];
    }
    if (count==length+100)
    {
        return YES;
    }else{
        return NO;
    }
}

- (BOOL)checkCorrectAnswerLeft
{
    NSString *tmpStr = @"";
    for (int i=0;i<playModel.numcharleft;i++){
        UILabel *tmpLabel = (UILabel *)[self viewWithTag:100+i];
        tmpStr = [tmpStr stringByAppendingString:tmpLabel.text];
    }
    NSString *partOfLeftString = [playModel.leftString substringWithRange:NSMakeRange(0, playModel.numcharleft)];
    
    if ([tmpStr isEqualToString:[partOfLeftString uppercaseString]]){
        return YES;
    }
    return NO;
}

- (BOOL)checkCorrectAnswerRight
{
    NSString *tmpStr = @"";
    for (int i=playModel.numcharleft;i<[playModel.answer length];i++){
        UILabel *tmpLabel = (UILabel *)[self viewWithTag:100+i];
        tmpStr = [tmpStr stringByAppendingString:tmpLabel.text];
    }
    NSString *partOfRightString = [playModel.rightString substringWithRange:NSMakeRange([playModel.rightString length]-playModel.numcharright, playModel.numcharright)];
    
    if ([tmpStr isEqualToString:[partOfRightString uppercaseString]]){
        return YES;
    }
    return NO;
}
- (void)setNewChar:(InputButtonView *)_sender
{
    NSNumber *focusingLabelTag = [[NSUserDefaults standardUserDefaults] valueForKey:kStringtagOfFocusedLabelInAnswerView];
    if (focusingLabelTag == nil)
    {
        int count = 100;
        UILabel *tmpLabel = (UILabel *)[self viewWithTag:count];
        int length = [playModel.answer length];
        while ((![tmpLabel.text isEqualToString:@""])&&(count < length+100)) {
            count++;
            tmpLabel = (UILabel *)[self viewWithTag:count];
        }
        if (count<length+100)
        {
            tmpLabel.text = [_sender.lb.text uppercaseString];
            tmpLabel.userInteractionEnabled = YES;
            UITapGestureRecognizer *_tap = [[UITapGestureRecognizer alloc]initWithTarget:delegate action:@selector(removeChar:)];
            [tmpLabel addGestureRecognizer:_tap];
            [_tap release];
            [_sender setTag:count];
            [_sender setHidden:YES];
        }
    }
    else 
    {
        if (![[(UILabel *)[self viewWithTag:[focusingLabelTag intValue]] text] isEqualToString:@""])
        {
            UILabel *tmp = (UILabel *)[self viewWithTag:[focusingLabelTag intValue]];
            NSArray *test = [tmp gestureRecognizers];
            
            NSLog(@"test gesture : %@",test);
            [delegate putCharBack:tmp];
            [delegate removeChar:[tmp.gestureRecognizers lastObject]];
        }
        UILabel *tmpLabel = (UILabel *)[self viewWithTag:[focusingLabelTag intValue]];
        [tmpLabel setBackgroundColor:[UIColor whiteColor]];
        tmpLabel.text = [_sender.lb.text uppercaseString];
        tmpLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *_tap = [[UITapGestureRecognizer alloc]initWithTarget:delegate action:@selector(removeChar:)];
        [tmpLabel addGestureRecognizer:_tap];
        [_tap release];
        [_sender setTag:[focusingLabelTag intValue]];
        [_sender setHidden:YES];
    }
    
    if (![self checkFullChar]){
        [self setFocusToNext];
    }else{
        UILabel *tmp = (UILabel *)[self viewWithTag:focusingLabelTag];
        
        [tmp setBackgroundColor:kColorOfFocusedLabelAnswerView];
        [delegate setFocusForResultViewWithTag:focusingLabelTag];
        //        [delegate incorrectAnswerFromSubView];
        //        [(UILabel *)[self viewWithTag:focusingLabelTag] setBackgroundColor:kColorOfFocusedLabelAnswerView];
    }
    
//    if (([focusingLabelTag intValue]<100+playModel.numcharleft)&&([self checkFullCharLeft])){
//        NSLog(@"full char left");
//        if ([self checkCorrectAnswerLeft]){
//            [self completeLeftString];
//            NSLog(@"left string is correct !!!");
//        }
//    }else  if (([focusingLabelTag intValue]>=100+playModel.numcharleft)&&([self checkFullCharRight]))
//    {
//        NSLog(@"full char right	");
//        if ([self checkCorrectAnswerRight]){
//            [self completeRightString];
//            NSLog(@"right string is correct !!!");
//        }
//    }

    

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithData:(PlayModel *)_data andDelegate:(id)_delegate
{
    self = [super init];
    if (self){
        playModel = [_data retain];
        delegate = [_delegate retain];
//        int width = MAX(playModel.numcharleft+playModel.numcharright,MAX([playModel.leftString length],[playModel.rightString length]))*40-8;
        int width = MAX([playModel.rightString length]-playModel.numcharright, playModel.numcharleft)+MAX(playModel.numcharright, [playModel.leftString length] - playModel.numcharleft);
        width =  width*(kSizeOfAnswerSquare+kDistanceAnswerSquare)-kDistanceAnswerSquare;
       
        [self setFrame:CGRectMake((kWidthOfScreen-width)/2, kYOfAnswerView, width, kSizeOfAnswerSquare*2+8)];
        [self setBackgroundColor:[UIColor clearColor]];
        [self createSubViews];
    }
    return self;
}

- (void)setFocusToNext
{
    int tagOfNextFocus= [[[NSUserDefaults standardUserDefaults] valueForKey:kStringtagOfFocusedLabelInAnswerView] intValue]+1;
    
    while ((![[(UILabel *)[self viewWithTag:tagOfNextFocus] text] isEqualToString:@""])&&(tagOfNextFocus<100+[playModel.answer length]))
    {
        tagOfNextFocus++;
    }
    NSLog(@"Tag of next focus : %d", tagOfNextFocus);
//    = [[[NSUserDefaults standardUserDefaults] valueForKey:kStringtagOfFocusedLabelInAnswerView] intValue]+1;
    if (tagOfNextFocus>=100+[playModel.answer length])
    {
        tagOfNextFocus= [[[NSUserDefaults standardUserDefaults] valueForKey:kStringtagOfFocusedLabelInAnswerView] intValue]+1;
        while ((![[(UILabel *)[self viewWithTag:tagOfNextFocus] text] isEqualToString:@""])&&(tagOfNextFocus>100))
        {
            tagOfNextFocus--;
        }
        if (tagOfNextFocus == 99)
        {
            NSLog(@"WTF !!!! FULL TEXT ROI MA VAN KHONG DUNG, GOI Y : NEN XOA CAI VUA DIEN");
            return;
        }
        
    }
    
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:tagOfNextFocus] forKey:kStringtagOfFocusedLabelInAnswerView];
    [[NSUserDefaults standardUserDefaults] synchronize];
    UILabel *nextFocusLabel = (UILabel *)[self viewWithTag:tagOfNextFocus];
    [nextFocusLabel setBackgroundColor:kColorOfFocusedLabelAnswerView];
    [delegate setFocusForResultViewWithTag:[[[NSUserDefaults standardUserDefaults] valueForKey:kStringtagOfFocusedLabelInAnswerView] intValue]];
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
        [focusingLB setBackgroundColor:[UIColor whiteColor]];
        
    }
    
    
    
    [tappedLB setBackgroundColor:kColorOfFocusedLabelAnswerView];
    [delegate setFocusForResultViewWithTag:tappedLB.tag];
    

    
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:tappedLB.tag] forKey:kStringtagOfFocusedLabelInAnswerView];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    int test = [[[NSUserDefaults standardUserDefaults] valueForKey:kStringtagOfFocusedLabelInAnswerView] intValue];
    
    NSLog(@"test : %d", test);
    
}

- (void)createSubViews
{
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:100] forKey:kStringtagOfFocusedLabelInAnswerView];
    [[NSUserDefaults standardUserDefaults] synchronize];
    int bp=0;
    int count = 100;
    int n1 = [playModel.rightString length]-playModel.numcharright-playModel.numcharleft;
    if (n1>0)
        bp=kSizeOfAnswerSquare*n1+kDistanceAnswerSquare*n1;
    
    int leftgraycount = 200+playModel.numcharleft;
    for (int i=0;i<[playModel.leftString length];i++)
    {
        UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(bp, 0, kSizeOfAnswerSquare, kSizeOfAnswerSquare)];
        [lb.layer setCornerRadius:3.0f];
        if (i >= playModel.numcharleft){
            [lb setBackgroundColor:[UIColor grayColor]];
            [lb setTag:leftgraycount];

            leftgraycount ++;
        }
        else{
            [lb setTag:count];
            [lb setBackgroundColor:[UIColor whiteColor]];
            [lb setUserInteractionEnabled:YES];
            UITapGestureRecognizer *_tapLB = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(setFocus:)];
            [lb addGestureRecognizer:_tapLB];
            [_tapLB release];
            count++;
            if ([[playModel.initString substringWithRange:NSMakeRange(count-100, 1)] isEqualToString:[[playModel.initString substringWithRange:NSMakeRange(count-100, 1)] uppercaseString]])
            {
                [lb removeFromSuperview];
            }
        }
        [lb setFont:[UIFont fontWithName:@"Verdana-Bold" size:25]];
        [lb setTextAlignment:NSTextAlignmentCenter];
        lb.text = @"";

        [self addSubview:lb];

        
        [lb release];
        bp+=kSizeOfAnswerSquare+kDistanceAnswerSquare;
    }
    int rightgraycount = 300;
    int n2 = playModel.numcharleft-([playModel.rightString length]-playModel.numcharright);
    bp = 0;
    if (n2>0)
        bp = kSizeOfAnswerSquare*n2+kDistanceAnswerSquare*n2;
    
//    bp=0;
    for (int i=0;i<[playModel.rightString length];i++)
    {
        UILabel *lb = [[UILabel alloc]initWithFrame:CGRectMake(bp, 40, kSizeOfAnswerSquare, kSizeOfAnswerSquare)];
        [lb.layer setCornerRadius:3.0f];
        if (i < playModel.numcharleft+n1){
            [lb setBackgroundColor:[UIColor grayColor]];
            [lb setTag:rightgraycount];
            rightgraycount++;
        }else{
            [lb setTag:count];
            
            [lb setBackgroundColor:[UIColor whiteColor]];
            count++;
            [lb setUserInteractionEnabled:YES];
            UITapGestureRecognizer *_tapLB = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(setFocus:)];
            [lb addGestureRecognizer:_tapLB];
            [_tapLB release];
            if ([[playModel.initString substringWithRange:NSMakeRange(count-100, 1)] isEqualToString:[[playModel.initString substringWithRange:NSMakeRange(count-100, 1)] uppercaseString]])
            {
                [lb removeFromSuperview];
            }
        }
        [lb setFont:[UIFont fontWithName:@"Verdana-Bold" size:25]];
        [lb setTextAlignment:NSTextAlignmentCenter];
        lb.text = @"";

        [self addSubview:lb];
        
        //       if (answerModel.numcharleft==i+1)
        //       {
        //           UIView *line = [[UIView alloc]initWithFrame:CGRectMake(bp+36, 0, 1, 32)];
        //           line.backgroundColor = [UIColor yellowColor];
        //           [self addSubview:line];
        //           [line release];
        //       }
        
        [lb release];
        bp+=kSizeOfAnswerSquare+kDistanceAnswerSquare;
    }
    UILabel *initFocusLabel = (UILabel *)[self viewWithTag:[[[NSUserDefaults standardUserDefaults] valueForKey:kStringtagOfFocusedLabelInAnswerView] intValue]];
    [initFocusLabel setBackgroundColor:kColorOfFocusedLabelAnswerView];
    [delegate setFocusForResultViewWithTag:[[[NSUserDefaults standardUserDefaults] valueForKey:kStringtagOfFocusedLabelInAnswerView] intValue]];
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
