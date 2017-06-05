//
//  ExamplePhotoModel.h
//  CocoaPods-NYTPhotoViewer
//
//  Created by Uber on 02/05/2017.
//  Copyright © 2017 Uber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NYTPhotoViewer/NYTPhoto.h>

@interface ExamplePhotoModel : NSObject <NYTPhoto>

// Redeclare all the properties as readwrite for sample/testing purposes.
@property (nonatomic) UIImage *image;
@property (nonatomic) NSData *imageData;
@property (nonatomic) UIImage *placeholderImage;
@property (nonatomic) NSAttributedString *attributedCaptionTitle;
@property (nonatomic) NSAttributedString *attributedCaptionSummary;
@property (nonatomic) NSAttributedString *attributedCaptionCredit;


- (instancetype)initFromUIImageView:(UIImageView*) imgView;
- (instancetype)initFromUIImage:(UIImage*) img;

@end

