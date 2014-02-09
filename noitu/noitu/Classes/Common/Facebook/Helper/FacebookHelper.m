//
//  FacebookHelper.m
//  mytcom
//
//  Created by Ngo Xuan Tung on 2/27/11.
//  Copyright 2011 SETA:CINQ Vietnam., Ltd. All rights reserved.
//

#import "FacebookHelper.h"
#import "Facebook.h"
#import "JSON.h"
#import "Common.h"

#define kFacebookAccessToken	@"kFacebookAccessToken"
#define kFacebookExpirationDate	@"kFacebookExpirationDate"

@implementation FacebookHelper

@synthesize uploadDelegate, publicDelegate;
@synthesize username;

- (void)postToFaceBook:(PlayModel *)_pm
{
    NSString *thumbURL = [NSString stringWithFormat:kDefaultThumbURL,_pm.answer];
//    NSString *imageLink = [NSString stringWithFormat:@"%@",[result objectForKey:@"link"]];
    
    currentAPICall = kDialogFeedUser;
    //            appDelegate = (ScorecardAppDelegate *)[[UIApplication sharedApplication] delegate];

//    NSDictionary *propertyvalue = [NSDictionary dictionaryWithObjectsAndKeys:@"zzzzzzz", @"text", @"http://itunes.apple.com/us/app/myApp/id12345?mt=8", @"href", nil];
    
//    NSDictionary *properties = [NSDictionary dictionaryWithObjectsAndKeys:propertyvalue, @"Download it free:", nil];
    
    NSDictionary *actions = [NSDictionary dictionaryWithObjectsAndKeys:@"Dislike", @"name",@"https://itunes.apple.com/app/id627264994", @"link", nil];
    
    SBJSON *jsonWriter = [[SBJSON new] autorelease];
    
//    NSString *finalproperties = [jsonWriter stringWithObject:properties];
    
    NSString *finalactions = [jsonWriter stringWithObject:actions];

    NSString *description = [NSString stringWithFormat:@"Which word is combined by first %d letters of left pic and last %d letters of right pic ?", _pm.numcharleft, _pm.numcharright];
    description = [description stringByAppendingFormat:@"Available letters: "];
    
    for (int i=0;i<_pm.initString.length;i++){
        NSString *test = [NSString stringWithFormat:@"-%@",[[_pm.initString uppercaseString] substringWithRange:NSMakeRange(i, 1)]];
        description = [description stringByAppendingString:test];
        
    }
    
    
    
    NSString* propString = @"{\"Download it free: \":{\"href\":\"https://itunes.apple.com/app/id627264994\",\"text\":\"On iTunes AppStore\"}}";

    
    NSMutableDictionary* dialogParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                         kAppId, @"app_id",
                                         @"https://itunes.apple.com/app/id627264994", @"link",
                                         thumbURL, @"picture",
                                         @"Help me guess this word", @"name",
                                         description, @"description",
                                         propString, @"properties",
                                         finalactions, @"actions",
                                         nil];
    
    [facebook dialog:@"feed"
           andParams:dialogParams
         andDelegate:self];
    
    
    
    return;
//    currentAPICall = kAPIGraphUserPhotosPost;
//    NSString *strMessage = @"This is the photo caption";
//    NSMutableDictionary* photosParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                                         _image,@"source",
//                                         strMessage,@"message",
//                                         nil];
//    
//    [facebook requestWithGraphPath:@"me/photos"
//                                     andParams:photosParams
//                                 andHttpMethod:@"POST"
//                                   andDelegate:self];
}

+ (BOOL)isAuthorized {
	return ([[NSUserDefaults standardUserDefaults] objectForKey:kFacebookAccessToken] != nil);
}

- (id)initWithDelegate:(id)_delegate
{
	self = [super init];
	if (self) {
        delegate = [_delegate retain];
		facebook = [[Facebook alloc] initWithAppId:kFacebookHelperAppId];
		NSString *_accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:kFacebookAccessToken];
		NSDate *_expirationDate = [[NSUserDefaults standardUserDefaults] objectForKey:kFacebookExpirationDate];
		if (_accessToken != nil) {
			facebook.accessToken = [_accessToken retain];
			facebook.expirationDate = [_expirationDate retain];
		}
		currentMethod = [[NSMutableString alloc] initWithString:@""];
	}
	return self;
}

- (void)dealloc {
	[username release];
	[facebook release];
	
	[super dealloc];
}

/*
 * Delete all the authorization information stored in app
 * @param
 * @return
 */
+ (void)deleteCredential {
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:kFacebookAccessToken];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:kFacebookExpirationDate];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"fbUsername"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *each in cookieStorage.cookies) {
		if ([[each domain] rangeOfString:@"facebook"].length > 0) {
			[cookieStorage deleteCookie:each];
		}
    }	
}

/*
 * Request to authorize
 * @param
 * @return
 */
- (void)authorize {
	NSArray *permissions = [NSArray arrayWithObjects:@"read_stream", @"offline_access", @"publish_stream", @"email", @"user_status", @"user_photos", nil];
	[facebook authorize:permissions delegate:self];
}

/*
 * Request to get username
 * @param
 * @return
 */
- (void)getUsername {
	[facebook requestWithGraphPath:@"me?fields=email" andDelegate:self];
}

/*
 * Request to upload an image to Facebook using form upload
 * @param: NSData data - the data of the image to upload
 * @param: NSString title - the title of the new image
 * @return
 */
- (void)uploadImage:(NSData *)data withTitle:(NSString *)title {
    [currentMethod setString:@"upload"];
    
    UIImage* _image = [UIImage imageWithData:data];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:_image, @"picture",title, @"message",nil];
    [facebook requestWithGraphPath:@"me/photos" andParams:params andHttpMethod:@"POST" andDelegate:self];
    
    
//	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.facebook.com/method/photos.upload"]];
//	[request setHTTPMethod:@"POST"];
//	
//	NSString *boundary = @"0xKhTmLbOuNdArY";
//	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
//	[request setValue:contentType forHTTPHeaderField:@"Content-Type"];
//	
//	NSMutableData *body = [NSMutableData data];
//	
//	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"format\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//	[body appendData:[@"json" dataUsingEncoding:NSUTF8StringEncoding]];
//	[body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//	
//	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"sdk\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//	[body appendData:[@"ios" dataUsingEncoding:NSUTF8StringEncoding]];
//	[body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//	
//	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"version\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//	[body appendData:[@"2" dataUsingEncoding:NSUTF8StringEncoding]];
//	[body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//	
//	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//	[body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"access_token\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//	[body appendData:[[[NSUserDefaults standardUserDefaults] objectForKey:kFacebookAccessToken] dataUsingEncoding:NSUTF8StringEncoding]];
//	[body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//	
//	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//	[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"media\"; filename=\"%@\"\r\n", title] dataUsingEncoding:NSUTF8StringEncoding]];
//	[body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//	[body appendData:data];
//	[body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//	
//	[body appendData:[[NSString stringWithFormat:@"--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//	
//	// setting the body of the post to the reqeust
//	[request setHTTPBody:body];
//	
//	NSURLConnection *connection = [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
//	[connection start];
//	[request release];
}

/*
 * Request to upload a movie to Facebook using form upload
 * @param: NSData data - the data of the movie to upload
 * @param: NSString title - the title of the new movie
 * @return
 */
- (void)uploadMovie:(NSData *)data withTitle:(NSString *)title {
	NSLog(@"Call upload movie");
	[currentMethod setString:@"upload"];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://api-video.facebook.com/method/video.upload"]];
	
	[request setHTTPMethod:@"POST"];
	
	NSString *boundary = @"0xKhTmLbOuNdArY";
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	[request setValue:contentType forHTTPHeaderField:@"Content-Type"];
	
	NSMutableData *body = [NSMutableData data];
	
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"Content-Disposition: form-data; name=\"format\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"json" dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"Content-Disposition: form-data; name=\"sdk\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"ios" dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"Content-Disposition: form-data; name=\"version\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"2" dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"Content-Disposition: form-data; name=\"access_token\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[[NSUserDefaults standardUserDefaults] objectForKey:kFacebookAccessToken] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"media\"; filename=\"%@\"\r\n", title] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"Content-Type: video/mpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:data];
	[body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithFormat:@"--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	// setting the body of the post to the reqeust
	[request setHTTPBody:body];
	
	NSURLConnection *connection = [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
	[connection start];
	NSLog(@"Request %@",request);
	[request release];
}

/*
 * Request to send a status to user's wall - twit
 * @param
 * @return
 */
- (void)sendStatus:(NSString *)status {
	NSLog(@"%@", status);
	[currentMethod setString:@"public"];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.facebook.com/method/stream.publish"]];
	
	[request setHTTPMethod:@"POST"];
	
	NSString *boundary = @"0xKhTmLbOuNdArY";
	NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	[request setValue:contentType forHTTPHeaderField:@"Content-Type"];
	
	NSMutableData *body = [NSMutableData data];
	
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"Content-Disposition: form-data; name=\"format\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"json" dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"Content-Disposition: form-data; name=\"sdk\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"ios" dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"Content-Disposition: form-data; name=\"version\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"2" dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"Content-Disposition: form-data; name=\"access_token\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[[[NSUserDefaults standardUserDefaults] objectForKey:kFacebookAccessToken] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"Content-Disposition: form-data; name=\"message\"\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[status dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	
	[body appendData:[[NSString stringWithFormat:@"--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	// setting the body of the post to the reqeust
	[request setHTTPBody:body];
	
	NSURLConnection *connection = [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
	[connection start];
	[request release];
}

#pragma mark -
#pragma mark FBConnect Handler

- (void)fbDidLogin {
	// Save credential information
	[[NSUserDefaults standardUserDefaults] setObject:facebook.accessToken forKey:kFacebookAccessToken];
	[[NSUserDefaults standardUserDefaults] setObject:facebook.expirationDate forKey:kFacebookExpirationDate];
	[[NSUserDefaults standardUserDefaults] synchronize];
    
    if ([delegate respondsToSelector:@selector(finishLoginSuccess)]) {
        [delegate finishLoginSuccess];
    }
}


- (void)fbDidNotLogin:(BOOL)cancelled {
	
}


- (void)fbDidLogout {
	
}

- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
	
}

- (void)request:(FBRequest *)request didLoad:(id)result {
    if ([currentMethod isEqualToString:@"upload"]) {
		if (uploadDelegate && [(NSObject *)uploadDelegate respondsToSelector:@selector(uploadCompeleteWithURLString:)]) {
//			NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
//			NSLog(@"%@", responseString);
//			NSDictionary *responseDictionary = [responseString JSONValue];
//			NSString *link = [responseDictionary objectForKey:@"link"];
//			if (link != nil) {
//				if ([link rangeOfString:@"&"].location != NSNotFound) {
//					NSString *url = [link substringToIndex:[link rangeOfString:@"&"].location];
//					[uploadDelegate uploadCompeleteWithURLString:url];
//				}
//				else {
//					[uploadDelegate uploadCompeleteWithURLString:link];
//				}
//			}
//			[responseString release];
            [uploadDelegate uploadCompeleteWithURLString:@"success"];
		}
	}
    else if ([result objectForKey:@"email"]!=nil)
        {
       
        username = [[NSString alloc] initWithString:[result objectForKey:@"email"]];
        [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"fbUsername"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:kFacebookDidGetName object:nil];
     
    }else
    {
    
    
    if ([result isKindOfClass:[NSArray class]] && ([result count] > 0)) {
        result = [result objectAtIndex:0];
    }
    
    switch (currentAPICall) {
        case kAPIGraphPhotoData: // step 3
        {
            // Facebook doesn't allow linking to images on fbcdn.net.  So for now use default thumb stored on Picasa
            NSString *thumbURL = kDefaultThumbURL;
            NSString *imageLink = [NSString stringWithFormat:@"%@",[result objectForKey:@"link"]];
            
            currentAPICall = kDialogFeedUser;
//            appDelegate = (ScorecardAppDelegate *)[[UIApplication sharedApplication] delegate];
            
            
            NSMutableDictionary* dialogParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                                 kAppId, @"app_id",
                                                 imageLink, @"link",
                                                 thumbURL, @"picture",
                                                 @"con con cua ", @"name",
                                                 nil];
            
            [facebook dialog:@"feed"
                               andParams:dialogParams
                             andDelegate:self];
            
            
            break;
        }
        case kAPIGraphUserPhotosPost: // step 2
        {
            
            NSString *imageID = [NSString stringWithFormat:@"%@",[result objectForKey:@"id"]];
            NSLog(@"id of uploaded screen image %@",imageID);
            
            currentAPICall = kAPIGraphPhotoData;
//            appDelegate = (Scorecard4AppDelegate *)[[UIApplication sharedApplication] delegate];
            
            [facebook requestWithGraphPath:imageID
                                           andDelegate:self];
            break;
        }
    }
    }
}



#pragma mark -
#pragma mark NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite {
	if ([currentMethod isEqualToString:@"upload"]) {
		float progress = (float)totalBytesWritten/(float)totalBytesExpectedToWrite;
		if (uploadDelegate && [(NSObject *)uploadDelegate respondsToSelector:@selector(uploadProgress:)]) {
			[uploadDelegate uploadProgress:progress];
		}
	}
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	if ([currentMethod isEqualToString:@"upload"]) {
		if (uploadDelegate && [(NSObject *)uploadDelegate respondsToSelector:@selector(uploadError:)]) {
			[uploadDelegate uploadError:error];
		}
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	if ([currentMethod isEqualToString:@"upload"]) {
		if (uploadDelegate && [(NSObject *)uploadDelegate respondsToSelector:@selector(uploadCompeleteWithURLString:)]) {
			NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
			NSLog(@"%@", responseString);
			NSDictionary *responseDictionary = [responseString JSONValue];
			NSString *link = [responseDictionary objectForKey:@"link"];
			if (link != nil) {
				if ([link rangeOfString:@"&"].location != NSNotFound) {
					NSString *url = [link substringToIndex:[link rangeOfString:@"&"].location];
					[uploadDelegate uploadCompeleteWithURLString:url];
				}
				else {
					[uploadDelegate uploadCompeleteWithURLString:link];
				}
			}
			[responseString release];
		}
	}
	else {
		if (publicDelegate && [(NSObject *)publicDelegate respondsToSelector:@selector(publicComplete)]) {
			[publicDelegate publicComplete];
		}
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	if (responseData != nil) {
		[responseData release];
	}
	responseData = nil;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	if (responseData == nil) {
		responseData = [[NSMutableData alloc] init];
	}
	[responseData appendData:data];
}

#pragma mark FBDiaglogDelegate

/**
 * Called when the dialog succeeds and is about to be dismissed.
 */
- (void)dialogDidComplete:(FBDialog *)dialog {


    
    NSLog(@"dialogDidComplete");
    switch (currentAPICall) {
        case kDialogFeedUser:
        {
            NSLog(@"Feed published successfully.");
            break;
        }
    }
}

/**
 * Called when the dialog succeeds with a returning url.
 */
- (void)dialogCompleteWithUrl:(NSURL *)url{
    if (![url query]) {
        NSLog(@"User canceled dialog or there was an error");
        
    }
    else{
        [delegate finishShareSuccess];
    }
     NSLog(@"dialogCompleteWithUrl  %@",url);
}

/**
 * Called when the dialog get canceled by the user.
 */
- (void)dialogDidNotCompleteWithUrl:(NSURL *)url{
    NSLog(@"dialogDidNotCompleteWithUrl  %@",url);
}

/**
 * Called when the dialog is cancelled and is about to be dismissed.
 */
- (void)dialogDidNotComplete:(FBDialog *)dialog{
    NSLog(@"dialogDidNotComplete");
}

/**
 * Called when dialog failed to load due to an error.
 */
- (void)dialog:(FBDialog*)dialog didFailWithError:(NSError *)error{
    NSLog(@"%@",error);
}

/**
 * Asks if a link touched by a user should be opened in an external browser.
 *
 * If a user touches a link, the default behavior is to open the link in the Safari browser,
 * which will cause your app to quit.  You may want to prevent this from happening, open the link
 * in your own internal browser, or perhaps warn the user that they are about to leave your app.
 * If so, implement this method on your delegate and return NO.  If you warn the user, you
 * should hold onto the URL and once you have received their acknowledgement open the URL yourself
 * using [[UIApplication sharedApplication] openURL:].
 */
- (BOOL)dialog:(FBDialog*)dialog shouldOpenURLInExternalBrowser:(NSURL *)url{
    return YES;
}

@end
