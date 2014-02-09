//
//  RootViewController.m
//  noitu
//
//  Created by Hoang le on 3/20/13.
//  Copyright (c) 2013 Hoang le. All rights reserved.
//

#import "RootController.h"

@interface RootController ()

@end

@implementation RootController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       
        // Custom initialization
    }
    return self;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"Welcome";
        rootModel = [[RootModel alloc]init];
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
      

    
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    rootView =[[RootView alloc]initWithFrame:self.view.bounds andData:rootModel];
    rootView.delegate = self;
    [self.view addSubview:rootView];
    [rootView release];
}

- (void)buyButtonTapped:(id)sender {
    NSLog(@"@aaaaaaa");
    StoreController *storeController = [[StoreController alloc]init];
//    [self presentViewController:storeController animated:YES completion:nil];
//    [storeController release];
    storeController.delegate = self;
    [self addChildViewController:storeController];
    [self.view addSubview:storeController.view];
//    [storeController.view release];
    [storeController release];
    NSLog(@"@bbbbbbbb");
    
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark store controller delegate

- (void)updateCoininVIew
{
    UILabel *coinLB = (UILabel *)[rootView viewWithTag:kTagOfCoinLabel];
//     .coins = [[[NSUserDefaults standardUserDefaults] objectForKey:@"coins"] intValue];
    coinLB.text = [NSString stringWithFormat:@"%d",[[[NSUserDefaults standardUserDefaults] objectForKey:@"coins"] intValue]];
}

- (void)btnPressSound
{
    SystemSoundID audioEffect;
    NSString *path  = [[NSBundle mainBundle] pathForResource:@"btn_press" ofType:@"wav"];
    NSURL *pathURL = [NSURL fileURLWithPath : path];
    AudioServicesCreateSystemSoundID((CFURLRef) pathURL, &audioEffect);
    AudioServicesPlaySystemSound(audioEffect);
}

#pragma mark



- (void)playBtnPress
{
    [self btnPressSound];
    PlayController *playVC = [[PlayController alloc]init];
    playVC.delegate = self;
//    playVC.modalPresentationStyle = UIModalPresentationCurrentContext;
//    playVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//    playVC.modalPresentationStyle = UIModalPresentationFullScreen;;
//    [playVC setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
//    [self presentViewController:playVC animated:YES completion:nil];
    [self presentViewController:playVC animated:YES completion:nil];
//    [self.navigationController pushViewController:playVC animated:YES];
    [playVC release];
}

- (void)playBtnPressNextLevel
{

    PlayController *playVC = [[PlayController alloc]init];
    playVC.delegate = self;

    //    playVC.modalPresentationStyle = UIModalPresentationFullScreen;;
    //    [playVC setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    //    [self presentViewController:playVC animated:YES completion:nil];
    [self presentViewController:playVC animated:NO completion:nil];
    //    [self.navigationController pushViewController:playVC animated:YES];
    [playVC release];
}

- (void)startOverBtnTapped
{
    [self btnPressSound];
    NSNumber *coin = [NSNumber numberWithInt:kInitialCoin];
    [[NSUserDefaults standardUserDefaults] setValue:coin forKey:@"coins"];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:@"@@@@" forKey:@"hintString"];
    [[NSUserDefaults standardUserDefaults] setValue:(id)[NSNumber numberWithInt:1] forKey:@"level"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self playBtnPress];
}

- (void)howtoButtonTapped
{
    [self btnPressSound];
    HowController *howVC = [[HowController alloc]init];
    howVC.delegate = self;
    [self presentViewController:howVC animated:NO completion:nil];
    [howVC release];
}

@end
