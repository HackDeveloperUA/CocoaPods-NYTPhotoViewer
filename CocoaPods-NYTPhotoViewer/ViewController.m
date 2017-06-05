//
//  ViewController.m
//  CocoaPods-NYTPhotoViewer
//
//  Created by Uber on 02/05/2017.
//  Copyright © 2017 Uber. All rights reserved.
//

#import "ViewController.h"

// Fraemworks
#import <NYTPhotoViewer/NYTPhotosViewController.h>
#import <SDWebImage/UIImageView+WebCache.h>


// My models
#import "ExamplePhotoModel.h"
#import "MyImageView.h"



// Не нужная хуета
typedef NS_ENUM(NSUInteger, NYTViewControllerPhotoIndex) {
    NYTViewControllerPhotoIndexCustomEverything = 1,
    NYTViewControllerPhotoIndexLongCaption = 2,
    NYTViewControllerPhotoIndexDefaultLoadingSpinner = 3,
    NYTViewControllerPhotoIndexNoReferenceView = 4,
    NYTViewControllerPhotoIndexCustomMaxZoomScale = 5,
    NYTViewControllerPhotoIndexGif = 6,
    NYTViewControllerPhotoCount,
};


@interface ViewController () <NYTPhotosViewControllerDelegate>

@property (nonatomic, strong) NSArray *photos;
@property (weak, nonatomic) IBOutlet UIButton *openPhotoButton;
@property (weak, nonatomic) IBOutlet UIView *redView;

@property (weak, nonatomic) IBOutlet UIImageView *imgForGesture;
@property (nonatomic, strong) ExamplePhotoModel* photo;
@end

@implementation ViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnImageView:)];
    tapped.numberOfTapsRequired = 1;
    self.imgForGesture.userInteractionEnabled = YES;
    [self.imgForGesture addGestureRecognizer:tapped];
}


#pragma mark - Action

- (IBAction)openPhotoAction:(UIButton *)sender {
    
    NSURL* urlPic = [NSURL URLWithString:@"http://www.discover-middleeast.com/wp-content/uploads/2016/07/2016_04_23_Landing_Moffet10.jpg"];
    
    ExamplePhotoModel *photo= [[ExamplePhotoModel alloc] init];
    NYTPhotosViewController* photoVC = [[NYTPhotosViewController alloc] initWithPhotos:@[photo]];
    MyImageView*  imageView = [[MyImageView alloc] init];
    
    __weak NYTPhotosViewController *weakPhotoVC = photoVC;
    __weak ExamplePhotoModel *weakPhoto = photo;
    __weak MyImageView* weakImgView = imageView;
    
    
    [weakImgView sd_setImageWithURL:urlPic
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                            
                            if (image){
                                weakPhoto.image = imageView.image;
                                [weakPhotoVC updateImageForPhoto:weakPhoto];
                            }
                        }];
    
    [self presentViewController:photoVC animated:YES completion:nil];

}

#pragma mark - Other


-(void)tapOnImageView :(UITapGestureRecognizer*) gesture
{
    if ([gesture.view isKindOfClass:[UIImageView class]]) {
        
        ExamplePhotoModel* photo = [[ExamplePhotoModel alloc] initFromUIImageView:self.imgForGesture];
        NYTPhotosViewController* photoVC = [[NYTPhotosViewController alloc] initWithPhotos:@[photo]];
        [self presentViewController:photoVC animated:YES completion:nil];
    }
}




#pragma mark - NYTPhotosViewControllerDelegate

// При закрытие фото, оно сжимается и как бы всасывается в то view которое мы указали, в нашем случае это uibutton
-(UIView*)photosViewController:(NYTPhotosViewController *)photosViewController referenceViewForPhoto:(id<NYTPhoto>)photo {
  
    if ([photo isEqual:self.photos[NYTViewControllerPhotoIndexNoReferenceView]]) {
        return nil;
    }
    return self.openPhotoButton;
    //return self.imgForGesture;

}



// Пока грузиться фото, мы можем поставить свое uiview/(или его наследников) на экран. Например я поставил цветной UILabel
-(UIView*)photosViewController:(NYTPhotosViewController*)photosViewController loadingViewForPhoto:(id <NYTPhoto>)photo {
    
    if ([photo isEqual:self.photos[NYTViewControllerPhotoIndexCustomEverything]]) {
        UILabel *loadingLabel = [[UILabel alloc] init];
        loadingLabel.text = @"Custom Loading...";
        loadingLabel.textColor = [UIColor greenColor];
        return loadingLabel;
    }
    return nil;
}



// Можем вместо стандартного описание возвратить uiview. Типо если такое photo, тогда возвратить uilabel
-(UIView*)photosViewController:(NYTPhotosViewController*)photosViewController captionViewForPhoto:(id <NYTPhoto>)photo {
  
    if ([photo isEqual:self.photos[2]]) {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"Custom Caption View";
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor redColor];
        return label;
    }
    return nil;
}

// Для отдельно взятой фотографии можем задать максимальный зум
-(CGFloat)photosViewController:(NYTPhotosViewController*)photosViewController maximumZoomScaleForPhoto:(id <NYTPhoto>)photo {
    if ([photo isEqual:self.photos[4]]) {
        return 10.0f;
    }
    return 1.0f;
}


// Метод еще не дописан, но расчитан на то что можно так кастомизировать UILabel который находиться под фото где описание
- (NSDictionary *)photosViewController:(NYTPhotosViewController *)photosViewController overlayTitleTextAttributesForPhoto:(id <NYTPhoto>)photo {
    if ([photo isEqual:self.photos[1]]) {
        return @{NSForegroundColorAttributeName: [UIColor grayColor]};
    }
    
    return nil;
}

// Метод который устанавливает текст в UINavigationBar. По стандарту мы ставим колличество наших фото, Например 1из3
- (NSString*)photosViewController:(NYTPhotosViewController*)photosViewController titleForPhoto:(id<NYTPhoto>)photo atIndex:(NSUInteger)photoIndex totalPhotoCount:(NSUInteger)totalPhotoCount {
    
    if ([photo isEqual:self.photos[NYTViewControllerPhotoIndexCustomEverything]]) {
        return [NSString stringWithFormat:@"%lu/%lu", (unsigned long)photoIndex+1, (unsigned long)totalPhotoCount];
    }
    
    return nil;
}


// Вызывается в тот момент как уже перемахнули фото и эффект перехода окончен
-(void)photosViewController:(NYTPhotosViewController*)photosViewController didNavigateToPhoto:(id <NYTPhoto>)photo atIndex:(NSUInteger)photoIndex{
    
    NSLog(@"didNavigateToPhoto");
}

// Вызывается при откртии UIActivityViewController
-(void)photosViewController:(NYTPhotosViewController*)photosViewController actionCompletedWithActivityType:(NSString*)activityType{
    NSLog(@"actionCompletedWithActivityType");
}

// Вызывается при намерений закрыть контроллер с фото
- (void)photosViewControllerWillDismiss:(NYTPhotosViewController *)photosViewController{
    NSLog(@"photosViewControllerWillDismiss");
}

// Вызывается когда контроллер с этими фото закрылся
- (void)photosViewControllerDidDismiss:(NYTPhotosViewController *)photosViewController {
    NSLog(@"Did Dismiss Photo Viewer: %@", photosViewController);
}

// Если return 'YES' тогда при долгом нажатии не будет появляться кнопка Copy.
- (BOOL)photosViewController:(NYTPhotosViewController *)photosViewController handleLongPressForPhoto:(id <NYTPhoto>)photo withGestureRecognizer:(UILongPressGestureRecognizer *)longPressGestureRecognizer {
    
    return YES;
}

// Если return 'YES' тогда UIActivityViewController показываться не будет. 'NO' будет этот контроллер
- (BOOL)photosViewController:(NYTPhotosViewController *)photosViewController handleActionButtonTappedForPhoto:(id <NYTPhoto>)photo {
    return YES;
}
#pragma mark - Other methods

// Изначально в newTestPhotos поставим некоторые фото nil, как будто они не успели прогрузиться, а здесь их добавим

- (void)updateImagesOnPhotosViewController:(NYTPhotosViewController *)photosViewController afterDelayWithPhotos:(NSArray *)photos {
    CGFloat updateImageDelay = 2.1;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(updateImageDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        for (ExamplePhotoModel *photo in photos) {
            if (!photo.image && !photo.imageData) {
                photo.image = [UIImage imageNamed:@"5"];
                
                // метод обновления фото, если был nil, то нужно обновить
                [photosViewController updateImageForPhoto:photo];
            }
        }
    });
    
}


+ (NSArray *)newTestPhotos {

    NSMutableArray *photos = [NSMutableArray array];
    
   
    /* Содержимое модели
     
    @property (nonatomic) UIImage *image;
    @property (nonatomic) NSData *imageData;
    @property (nonatomic) UIImage *placeholderImage;
    @property (nonatomic) NSAttributedString *attributedCaptionTitle;
    @property (nonatomic) NSAttributedString *attributedCaptionSummary;
    @property (nonatomic) NSAttributedString *attributedCaptionCredit;
    */
    
    // +
    // Настройка (нижнего текста)
    // attributedCaptionTitle - Самый большой шрифт. Сюда пишим просто индекс картинки
    // attributedCaptionSummary - Второй шрифт. Краткое описание.
    // attributedCaptionCredit  - Третий шрифт. Сюда можно загнать аж целую статью
    
    
    for (NSUInteger i = 0; i < NYTViewControllerPhotoCount; i++) {

        // Наша модель
        ExamplePhotoModel *photo = [[ExamplePhotoModel alloc] init];

        NSString *captionTitle   = @"title";
        NSString *captionSummary = @"summary";
        NSString *captionCredit  = @"credit";
        
        // Если самый обычный вариант
        if (i == 0)
        {
            photo.image = [UIImage imageNamed:@"1"];
            photo.placeholderImage = [UIImage imageNamed:@"1p"];
            captionCredit = @"photo with custom everything";
        }
        
        // Если долгое описание к картинке
        if (i == 1)
        {
            photo.image = [UIImage imageNamed:@"2"];
            photo.placeholderImage = [UIImage imageNamed:@"2p"];
             captionCredit = @"photo with long caption. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum maximus laoreet vehicula. Maecenas elit quam, pellentesque at tempor vel, tempus non sem. Vestibulum ut aliquam elit. Vivamus rhoncus sapien turpis, at feugiat augue luctus id. Nulla mi urna, viverra sed augue malesuada, bibendum bibendum massa. Cras urna nibh, lacinia vitae feugiat eu, consectetur a tellus. Morbi venenatis nunc sit amet varius pretium. Duis eget sem nec nulla lobortis finibus. Nullam pulvinar gravida est eget tristique. Curabitur faucibus nisl eu diam ullamcorper, at pharetra eros dictum. Suspendisse nibh urna, ultrices a augue a, euismod mattis felis. Ut varius tortor ac efficitur pellentesque. Mauris sit amet rhoncus dolor. Proin vel porttitor mi. Pellentesque lobortis interdum turpis, vitae tincidunt purus vestibulum vel. Phasellus tincidunt vel mi sit amet congue.";
        }
        
        if (i == 2)
        {
            photo.image = [UIImage imageNamed:@"3"];
            photo.placeholderImage = [UIImage imageNamed:@"3p"];
            captionCredit = @"photo with loading spinner";
        }
        
        
        if (i == 3)
        {
            photo.image = [UIImage imageNamed:@"4"];
            photo.placeholderImage = [UIImage imageNamed:@"4p"];
            captionCredit = @"photo without reference view";
        }
        
        
        if (i == 4)
        {
            photo.image = [UIImage imageNamed:@"5"];
            photo.placeholderImage = [UIImage imageNamed:@"5p"];
            captionCredit = @"photo with custom maximum zoom scale";

        }
        
        // Если gif картинка
        if (i == 5)
        {
            photo.imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"6" ofType:@"gif"]];
            photo.placeholderImage = [UIImage imageNamed:@"6p"];
            captionCredit = @"animated GIF";
        }
        
        
        
        // Теперь наши NSString будем трансофрмировать в NSAttributedString
        photo.attributedCaptionTitle = [[NSAttributedString alloc] initWithString: @(i + 1).stringValue
                                                                       attributes: @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                                     NSFontAttributeName           : [UIFont preferredFontForTextStyle:UIFontTextStyleBody]}
                                        ];
        
        photo.attributedCaptionSummary = [[NSAttributedString alloc] initWithString:captionCredit
                                                                         attributes: @{NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                                                                       NSFontAttributeName           : [UIFont preferredFontForTextStyle:UIFontTextStyleBody]}
                                        ];

        photo.attributedCaptionCredit = [[NSAttributedString alloc] initWithString:@"NYT Building Photo Credit: Nic Lehoux"
                                                                        attributes:@{NSForegroundColorAttributeName: [UIColor grayColor],
                                                                                     NSFontAttributeName           : [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1]}
                                        ];
        [photos addObject:photo];
    }
 return photos;
}


@end
