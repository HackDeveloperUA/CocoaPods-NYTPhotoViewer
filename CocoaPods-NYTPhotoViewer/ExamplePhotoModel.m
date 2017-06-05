//
//  ExamplePhotoModel.m
//  CocoaPods-NYTPhotoViewer
//
//  Created by Uber on 02/05/2017.
//  Copyright © 2017 Uber. All rights reserved.
//

#import "ExamplePhotoModel.h"

@implementation ExamplePhotoModel

- (instancetype)initFromUIImageView:(UIImageView*) imgView
{
    self = [super init];
    if (self) {
        if (imgView.image)
            self.image = imgView.image;
    }
    return self;
}

- (instancetype)initFromUIImage:(UIImage*) img
{
    self = [super init];
    if (self) {
        if (img)
            self.image = img;
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"%s - ExamplePhotoModel", __FUNCTION__);
    
    // if non-ARC, remember to include the following line, too:
    //
    // [super dealloc];
}

@end
