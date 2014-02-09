//
//  DownloadImageRequest.m
//  Task4_Flickr
//
//  Created by Hoang Le on 12/18/12.
//  Copyright (c) 2012 Hoang Le. All rights reserved.
//

#import "DownloadImageRequest.h"


@implementation DownloadImageRequest

@synthesize index;

- (id)initWithURL:(NSURL *)newURL indexOfRequest:(int)_index;
{
    self = [super initWithURL:newURL];
    if (self)
    {
        index = _index;
    }
    return self;

}

@end
