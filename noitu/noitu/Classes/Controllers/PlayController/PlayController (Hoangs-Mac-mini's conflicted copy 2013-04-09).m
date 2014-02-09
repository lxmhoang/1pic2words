//
//  PlayController.m
//  noitu
//
//  Created by Hoang le on 3/20/13.
//  Copyright (c) 2013 Hoang le. All rights reserved.
//

#import "PlayController.h"

@interface PlayController ()

@end

@implementation PlayController
@synthesize playView, playModel;

//- (void)charPickedFromView:(NSString *)charPicked
//{
//    [playView charPickedFromController:charPicked];
//}




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)buyButtonTapped {
    StoreController *storeController = [[StoreController alloc]init];
    storeController.delegate = self;
    //    [self presentViewController:storeController animated:YES completion:nil];
    //    [storeController release];
    [self addChildViewController:storeController];
    [self.view addSubview:storeController.view];
    [storeController release];
    
    
}

- (void)reloadModelAndView
{

    if (playModel != nil)
        [playModel release];
    if (playView != nil)
    {
        [playView release];
        [[self.view.subviews lastObject] removeFromSuperview];
    }
    playModel = [[PlayModel alloc]initWithLevel:[level intValue]];

    
   
    
    playView = [[PlayView alloc]initWithFrame:self.view.bounds andData:playModel];
    playView.delegate = self;
    [self.view addSubview:playView];
    [playView release];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        level = [NSNumber numberWithInt:1];
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"level"]==nil) {
            [[NSUserDefaults standardUserDefaults] setValue:(id)level forKey:@"level"];
        }
        
        level = [[NSUserDefaults standardUserDefaults] objectForKey:@"level"];
        
        [self reloadModelAndView];
         
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    facebook = [[FacebookHelper alloc] initWithDelegate:self];
    facebook.uploadDelegate = self;
  
    
//    [self.navigationController.navigationBar setBackgroundColor:[UIColor redColor]];
//    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];  //this get you to the root of your app's

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImage*)captureView
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.view.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark store controller delegate

- (void)updateCoininVIew
{
    UILabel *coinLB = (UILabel *)[playView viewWithTag:kTagOfCoinLabel];
    playModel.coins = [[[NSUserDefaults standardUserDefaults] objectForKey:@"coins"] intValue];
    coinLB.text = [NSString stringWithFormat:@"%d",playModel.coins];
    
}

#pragma mark PlayView Delegate

- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)correctAnswerFromView
{
    if ([level intValue] == kMaxLevel)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Max level" message:@"Game over ! You've reached max level" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
        level = [NSNumber numberWithInt:1];
    }else{
        level = [NSNumber numberWithInt:[level intValue]+1];
        [[NSUserDefaults standardUserDefaults] setValue:(id)level forKey:@"level"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self reloadModelAndView];
    }
}

- (void)hint
{
    HintView *hintView = [[HintView alloc]initWithFrame:self.view.bounds];
    hintView.delegate = self;
    [self.view addSubview:hintView];
    [hintView release];
}

- (void)shareFB:(UIGestureRecognizer *)_sender
{
    [[[_sender.view superview] superview] removeFromSuperview];
    screenShotImage = [[self captureView] retain];
   if ([FacebookHelper isAuthorized])
   {
//       [facebook sendStatus:@"hadsjfkalsjfklajdfklasdjfklas"];
       screenShotImage = [[self captureView] retain];
//       NSData *imgData = UIImagePNGRepresentation(screenShotImage);
       
       [facebook postToFaceBook:screenShotImage];
       
//       [facebook uploadImage:imgData withTitle:@"Help me solve it"];
//       [facebook sendStatus:@"asdfasdfasdfasdfasdf"];
//       [screenShotImage release];
//       [imgData release];
   }else{
       [facebook authorize];
   }
}

- (void)uploadError:(NSError *)error
{
    UIAlertView* _alert = [[UIAlertView alloc] initWithTitle:@"share error" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [_alert show];
    [_alert release];
}

- (void)uploadCompeleteWithURLString:(NSString *)URLString
{
    if (URLString == (id)[NSNull null] || URLString == nil || [URLString isEqualToString:@""]) {
        UIAlertView* _alert = [[UIAlertView alloc] initWithTitle:@"share error" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [_alert show];
        [_alert release];
    }
    else{
        UIAlertView* _alert = [[UIAlertView alloc] initWithTitle:@"share success" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [_alert show];
        [_alert release];
    }
}



- (void)finishLoginSuccess
{
    [facebook postToFaceBook:screenShotImage];
}

#pragma mark HintView Delegate

- (void)removeALetterFromView{
    int coin = [[[NSUserDefaults standardUserDefaults] valueForKey:@"coins"] intValue];
    if (coin>=1000){
        coin -= 1000;
        [[NSUserDefaults standardUserDefaults] setInteger:coin forKey:@"coins"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self updateCoininVIew];
        [self removeALetter];
        
    }else{
        [self buyButtonTapped];
    }
}

- (void)revealALetterFromView
{
    
}

- (void)revealAWordFromView{
    
}

- (void)shuffleFromView
{
    
}



#pragma mark method for Hint

- (void)removeALetter
{
    [playView removeALetterFromController];
    NSLog(@"A LETTER HAS BEEN REMOVED");
    for (UIView *tmp in self.view.subviews){
        if ([tmp isKindOfClass:[HintView class]])
        {
            [tmp removeFromSuperview];
            break;
            
        }
    }
}


@end
