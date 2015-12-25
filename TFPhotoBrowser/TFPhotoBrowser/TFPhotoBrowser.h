//
//  TFPhotoBrowser.h
//  TFPhotoBrowser
//
//  Created by Melvin on 8/28/15.
//  Copyright © 2015 TimeFace. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFPhotoProtocol.h"
#import "TFPhoto.h"

// Delgate
@protocol TFPhotoBrowserDelegate;

@class TFPhotoBrowser;
@class TFPhotoCaptionView;

@protocol TFPhotoBrowserDelegate <NSObject>
@optional
- (void)photoBrowser:(TFPhotoBrowser *)photoBrowser didShowPhotoAtIndex:(NSUInteger)index;
- (void)photoBrowser:(TFPhotoBrowser *)photoBrowser didDismissAtPageIndex:(NSUInteger)index;
- (void)photoBrowser:(TFPhotoBrowser *)photoBrowser willDismissAtPageIndex:(NSUInteger)index;
- (void)photoBrowser:(TFPhotoBrowser *)photoBrowser didDismissActionSheetWithButtonIndex:(NSUInteger)buttonIndex photoIndex:(NSUInteger)photoIndex;
- (TFPhotoCaptionView *)photoBrowser:(TFPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index;


@end


@interface TFPhotoBrowser : UIViewController<UIScrollViewDelegate, UIActionSheetDelegate>

@property (nonatomic, weak) id<TFPhotoBrowserDelegate> delegate;
// Toolbar customization
@property (nonatomic) BOOL displayToolbar;
@property (nonatomic) BOOL zoomPhotosToFill;
@property (nonatomic) BOOL displayCounterLabel;
@property (nonatomic) BOOL displayArrowButton;
@property (nonatomic) BOOL displayActionButton;
@property (nonatomic, strong) NSArray *actionButtonTitles;
@property (nonatomic, weak) UIImage *leftArrowImage, *leftArrowSelectedImage;
@property (nonatomic, weak) UIImage *rightArrowImage, *rightArrowSelectedImage;

// View customization
@property (nonatomic) BOOL displayDoneButton;
@property (nonatomic) BOOL useWhiteBackgroundColor;
@property (nonatomic, weak) UIImage *doneButtonImage;
@property (nonatomic, weak) UIColor *trackTintColor, *progressTintColor;

@property (nonatomic, weak) UIImage *scaleImage;

@property (nonatomic) BOOL arrowButtonsChangePhotosAnimated;

@property (nonatomic) BOOL forceHideStatusBar;
@property (nonatomic) BOOL usePopAnimation;
@property (nonatomic) BOOL disableVerticalSwipe;

// defines zooming of the background (default 1.0)
@property (nonatomic) float backgroundScaleFactor;

// animation time (default .28)
@property (nonatomic) float animationDuration;

// Init
- (id)initWithPhotos:(NSArray *)photosArray;

// Init (animated)
- (id)initWithPhotos:(NSArray *)photosArray animatedFromView:(UIView*)view;

// Reloads the photo browser and refetches data
- (void)reloadData;

// Set page that photo browser starts on
- (void)setInitialPageIndex:(NSUInteger)index;

// Get IDMPhoto at index
- (id<TFPhoto>)photoAtIndex:(NSUInteger)index;

@end

