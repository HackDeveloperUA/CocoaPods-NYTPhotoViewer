//
//  MyImageView.m
//  CocoaPods-NYTPhotoViewer
//
//  Created by Uber on 03/05/2017.
//  Copyright © 2017 Uber. All rights reserved.
//

#import "MyImageView.h"

@implementation MyImageView

- (void)dealloc
{
    NSLog(@"%s - MyImageView", __FUNCTION__);
    
    // if non-ARC, remember to include the following line, too:
    //
    // [super dealloc];
}

@end
