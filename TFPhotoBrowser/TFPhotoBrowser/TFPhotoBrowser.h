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

- (NSUInteger)numberOfPhotosInPhotoBrowser:(TFPhotoBrowser *)photoBrowser;
- (id <TFPhoto>)photoBrowser:(TFPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index;

@optional

- (id <TFPhoto>)photoBrowser:(TFPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index;
- (TFPhotoCaptionView *)photoBrowser:(TFPhotoBrowser *)photoBrowser photoCaptionViewForPhotoAtIndex:(NSUInteger)index;
- (NSString *)photoBrowser:(TFPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index;
- (void)photoBrowser:(TFPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index;
- (void)photoBrowser:(TFPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index;
- (BOOL)photoBrowser:(TFPhotoBrowser *)photoBrowser isPhotoSelectedAtIndex:(NSUInteger)index;
- (void)photoBrowser:(TFPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected;
- (void)photoBrowserDidFinishModalPresentation:(TFPhotoBrowser *)photoBrowser;

@end


@interface TFPhotoBrowser : UIViewController<UIScrollViewDelegate, UIActionSheetDelegate>

@property (nonatomic, weak) IBOutlet id<TFPhotoBrowserDelegate> delegate;
@property (nonatomic) BOOL zoomPhotosToFill;
@property (nonatomic) BOOL displayActionButton;
@property (nonatomic) BOOL displaySelectionButtons;
@property (nonatomic) BOOL alwaysShowControls;
@property (nonatomic) BOOL enableSwipeToDismiss;
@property (nonatomic) BOOL autoPlayOnAppear;
@property (nonatomic) NSUInteger delayToHideElements;
@property (nonatomic, readonly) NSUInteger currentIndex;

// Customise image selection icons as they are the only icons with a colour tint
// Icon should be located in the app's main bundle
@property (nonatomic, strong) NSString *customImageSelectedIconName;
@property (nonatomic, strong) NSString *customImageSelectedSmallIconName;

// Init
- (id)initWithPhotos:(NSArray *)photosArray;
- (id)initWithDelegate:(id <TFPhotoBrowserDelegate>)delegate;

// Reloads the photo browser and refetches data
- (void)reloadData;

// Set page that photo browser starts on
- (void)setCurrentPhotoIndex:(NSUInteger)index;

// Navigation
- (void)showNextPhotoAnimated:(BOOL)animated;
- (void)showPreviousPhotoAnimated:(BOOL)animated;

@end

