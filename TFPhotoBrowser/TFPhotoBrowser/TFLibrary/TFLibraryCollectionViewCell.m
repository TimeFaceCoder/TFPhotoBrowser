//
//  TFLibraryCollectionViewCell.m
//  TFPhotoBrowser
//
//  Created by Melvin on 12/17/15.
//  Copyright © 2015 TimeFace. All rights reserved.
//

#import "TFLibraryCollectionViewCell.h"
#import "TFLibraryCollectionOverlayView.h"
#import <pop/POP.h>
#import <Photos/Photos.h>
#import "TFCollectionOverlayProgressView.h"

@interface TFLibraryCollectionViewCell() {
    PHImageRequestID _assetRequestID;
}

@property (nonatomic ,strong) UIImageView                     *imageView;
@property (nonatomic ,strong) UIImageView                     *livePhotoBadgeImageView;
@property (nonatomic ,strong) UIButton                        *selectedButton;
@property (nonatomic ,strong) TFLibraryCollectionOverlayView  *overlayView;
@property (nonatomic ,strong) TFCollectionOverlayProgressView *progressView;

@end

@implementation TFLibraryCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.opaque                 = NO;
        self.alpha                  = 1;
        self.contentMode            = UIViewContentModeCenter;
        self.showsOverlayViewWhenSelected = YES;
        [self setupViews];
    }
    
    return self;
}


- (void)setupViews {
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    
    self.imageView = imageView;
    [self.contentView addSubview:self.imageView];
    
    UIImageView *livePhotoBadgeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 26, 26)];
    livePhotoBadgeImageView.contentMode = UIViewContentModeScaleAspectFill;
    livePhotoBadgeImageView.clipsToBounds = YES;
    
    self.livePhotoBadgeImageView = livePhotoBadgeImageView;
    [self.contentView addSubview:self.livePhotoBadgeImageView];
    
    TFLibraryCollectionOverlayView *overlayView = [[TFLibraryCollectionOverlayView alloc] initWithFrame:self.contentView.bounds];
    overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.overlayView = overlayView;
    [self.contentView addSubview:self.overlayView];
    
    TFCollectionOverlayProgressView *progressView = [[TFCollectionOverlayProgressView alloc] initWithFrame:self.contentView.bounds];
    progressView.alpha = 0;
    self.progressView = progressView;
    [self.contentView addSubview:self.progressView];
    [self.progressView setProgress:0];
}


- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    //检查iCloud状态
    if (selected && self.showsOverlayViewWhenSelected) {
        [self showOverlayView];
    } else {
        [self hideOverlayView];
    }
    [_overlayView checkMark:selected];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.imageView.image = nil;
    self.livePhotoBadgeImageView.image = nil;
}
- (void)setShowsOverlayViewWhenSelected:(BOOL)showsOverlayViewWhenSelected {
    _showsOverlayViewWhenSelected = showsOverlayViewWhenSelected;
    _overlayView.hidden = !_showsOverlayViewWhenSelected;
}

- (void)showOverlayView {
    POPBasicAnimation *backgroundColorAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewBackgroundColor];
    backgroundColorAnimation.toValue = [UIColor colorWithWhite:0 alpha:0.5];
    [self.overlayView pop_addAnimation:backgroundColorAnimation forKey:@"showBackgroundColorAnimation"];
}

- (void)hideOverlayView {
    POPBasicAnimation *backgroundColorAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewBackgroundColor];
    backgroundColorAnimation.toValue = [UIColor clearColor];
    [self.overlayView pop_addAnimation:backgroundColorAnimation forKey:@"hideBackgroundColorAnimation"];
}


- (void)setThumbnailImage:(UIImage *)thumbnailImage {
    //    _thumbnailImage = thumbnailImage;
    self.imageView.image = thumbnailImage;
}

- (void)setLivePhotoBadgeImage:(UIImage *)livePhotoBadgeImage {
    //    _livePhotoBadgeImage = livePhotoBadgeImage;
    self.livePhotoBadgeImageView.image = livePhotoBadgeImage;
}


// Load from photos library
- (void)loadUnderlyingImageAndNotifyWithAsset:(PHAsset *)asset targetSize:(CGSize)targetSize {
    
    PHImageManager *imageManager = [PHImageManager defaultManager];
    
    PHImageRequestOptions *options = [PHImageRequestOptions new];
    options.networkAccessAllowed = YES;
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    options.synchronous = false;
    options.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
        NSLog(@"progress:%f",progress);
    };
    
    _assetRequestID = [imageManager requestImageForAsset:asset
                                              targetSize:targetSize
                                             contentMode:PHImageContentModeAspectFit
                                                 options:options
                                           resultHandler:^(UIImage *result, NSDictionary *info) {
                                               //
                                           }];
    
}

@end
