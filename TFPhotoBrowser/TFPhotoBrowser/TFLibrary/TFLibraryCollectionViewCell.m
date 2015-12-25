//
//  TFLibraryCollectionViewCell.m
//  TFPhotoBrowser
//
//  Created by Melvin on 12/17/15.
//  Copyright © 2015 TimeFace. All rights reserved.
//

#import "TFLibraryCollectionViewCell.h"

@interface TFLibraryCollectionViewCell()


@property (nonatomic ,strong) UIImageView *imageView;
@property (nonatomic ,strong) UIImageView *livePhotoBadgeImageView;

@end

@implementation TFLibraryCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.opaque                 = NO;
        self.alpha                  = 1;
        self.contentMode            = UIViewContentModeCenter;
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
    
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.imageView.image = nil;
    self.livePhotoBadgeImageView.image = nil;
}

- (void)setThumbnailImage:(UIImage *)thumbnailImage {
//    _thumbnailImage = thumbnailImage;
    self.imageView.image = thumbnailImage;
}

- (void)setLivePhotoBadgeImage:(UIImage *)livePhotoBadgeImage {
//    _livePhotoBadgeImage = livePhotoBadgeImage;
    self.livePhotoBadgeImageView.image = livePhotoBadgeImage;
}


@end
