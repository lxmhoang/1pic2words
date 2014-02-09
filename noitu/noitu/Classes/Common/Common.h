#define kURLForPlayModel @"http://gohanvn.com/Words/Rest/level/%d"
#define kURLForData @"http://gohanvn.com/Words/Rest"
#define kURLForLeftImage @"http://gohanvn.com/image_dir/%@"

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define dontUpperY IS_IPHONE_5||([[NSUserDefaults standardUserDefaults] boolForKey:@"noads"])

#define kCoinEachLetter 10


//#define kBackGroundColor [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.png"]]
#define kBackGroundColor  [UIColor colorWithRed:158.0/225.0 green:81.0/255.0 blue:60.0/255.0 alpha:1.0]

#define kMaxLevel 100

// NavigationBar Info

#define kHeightOfNavigationBar 44

// AnswerView Info

#define kSizeOfAnswerSquare 32
#define kDistanceAnswerSquare 8


#define kYOfAnswerView dontUpperY ? 265 : 230

//#define kYOfTypingView dontUpperY ?  375: 350
#define kYOfTypingView 375
//230

// ResultView Info

#define kSizeOfResultSquare 30
#define kDistanceResultSquare 5
#define kYOfResultView 325
#define kHeighOfResultView 50

// Screen Info

#define kWidthOfScreen 320

//#if (IS_IPHONE_5) // note this may be different, don't have acces to Xcode right now.
#define kHeightOfScreen [[UIScreen mainScreen] applicationFrame].size.height
//#define kHeightOfScreen 480
//#endif



#define kTest NSLog(@"shit");


// TypingView Info

#define kHeighOfTypingview 100
#define kDistanceTypingSquare 5
#define kLeftSpaceTypingRect 5
#define kSizeOfTypingSquare 48

// Image Info

#define kYOfImage 70
#define kSizeOfImage 145
#define kXOfLeftImage 10
#define kXOfRightImage 165

// Facebook app info

#define kFacebookHelperAppId        @"502282736501998"

// items array

#define kProductIDOf1000  @"com.lxmhoang.1word2pics.products.1000coins"
#define kProductIDOf2500  @"com.lxmhoang.1word2pics.products.2500coins"
#define kProductIDOf7500  @"com.lxmhoang.1word2pics.products.7500coins"
#define kProductIDOf20000  @"com.lxmhoang.1word2pics.products.20000coins"
#define kProductIDOf50000  @"com.lxmhoang.1word2pics.products.50000coins"

// tag

#define kTagOfAlphaView 221
#define kTagOfZoomImageView 222


#define kStringtagOfFocusedLabelInAnswerView @"tagOfFocusedLabelInAnswerView"

#define kColorOfFocusedLabel [UIColor greenColor]
#define kColorOfFocusedLabelAnswerView [UIColor greenColor]

#define kHeightOfTopBarPopUpIAP 60
#define kHeightOfRowStoreItem 70

#define kTagOfHintView 454

#define kTagOfCoinLabel 111

#define kTagOfSubtitle1 222

#define kTagOfSubtitle2 333

#define kTagOfArrowDown1 551
#define kTagOfArrowDown2 552
#define kTagOfArrowDown3 553
#define kTagOfArrowDown4 554
#define kTagOfArrowDown5 555

#define kInitialCoin 50
