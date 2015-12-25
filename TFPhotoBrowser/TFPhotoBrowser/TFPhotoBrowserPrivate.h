//
//  TFPhotoBrowserPrivate.h
//  TFPhotoBrowser
//
//  Created by Melvin on 11/13/15.
//  Copyright © 2015 TimeFace. All rights reserved.
//


#import <MediaPlayer/MediaPlayer.h>
#import "TFZoomingScrollView.h"

#ifndef TFPhotoBrowserLocalizedStrings
#define TFPhotoBrowserLocalizedStrings(key) \
NSLocalizedStringFromTableInBundle((key), nil, [NSBundle bundleWithPath:[[NSBundle bundleForClass: self.class] pathForResource:@"TFPhotoBrowserLocalizations" ofType:@"bundle"]], nil)
#endif

// Declare private methods of browser
@interface TFPhotoBrowser () {
    
    // Data
    NSMutableArray *_photos;
    
    // Views
    UIScrollView *_pagingScrollView;
    
    // Gesture
    UIPanGestureRecognizer *_panGesture;
    
    // Paging
    NSMutableSet *_visiblePages, *_recycledPages;
    NSUInteger _pageIndexBeforeRotation;
    NSUInteger _currentPageIndex;
    
    // Buttons
    UIButton *_doneButton;
    
    // Toolbar
    UIToolbar *_toolbar;
    UINavigationBar *_navigationBar;
    UIBarButtonItem *_actionButton;
    UIBarButtonItem *_counterButton;
    UILabel *_counterLabel;
    
    
    
    // Control
    NSTimer *_controlVisibilityTimer;
    
    // Appearance
    //UIStatusBarStyle _previousStatusBarStyle;
    BOOL _statusBarOriginallyHidden;
    
    // Present
    UIView *_senderViewForAnimation;
    
    // Misc
    BOOL _performingLayout;
    BOOL _rotating;
    BOOL _viewIsActive; // active as in it's in the view heirarchy
    BOOL _autoHide;
    NSInteger _initalPageIndex;
    
    BOOL _isdraggingPhoto;
    
    CGRect _senderViewOriginalFrame;
    //UIImage *_backgroundScreenshot;
    
    UIWindow *_applicationWindow;
    
    // iOS 7
    UIViewController *_applicationTopViewController;
    int _previousModalPresentationStyle;
    
}

// Private Properties
@property (nonatomic, strong) UIActionSheet *actionsSheet;
@property (nonatomic, strong) UIActivityViewController *activityViewController;

// Private Methods

// Layout
- (void)performLayout;

// Paging
- (void)tilePages;
- (BOOL)isDisplayingPageForIndex:(NSUInteger)index;
- (TFZoomingScrollView *)pageDisplayedAtIndex:(NSUInteger)index;
- (TFZoomingScrollView *)pageDisplayingPhoto:(id<TFPhoto>)photo;
- (TFZoomingScrollView *)dequeueRecycledPage;
- (void)configurePage:(TFZoomingScrollView *)page forIndex:(NSUInteger)index;
- (void)didStartViewingPageAtIndex:(NSUInteger)index;

// Frames
- (CGRect)frameForPagingScrollView;
- (CGRect)frameForPageAtIndex:(NSUInteger)index;
- (CGSize)contentSizeForPagingScrollView;
- (CGPoint)contentOffsetForPageAtIndex:(NSUInteger)index;
- (CGRect)frameForToolbarAtOrientation:(UIInterfaceOrientation)orientation;
- (CGRect)frameForDoneButtonAtOrientation:(UIInterfaceOrientation)orientation;
- (CGRect)frameForCaptionView:(TFPhotoCaptionView *)captionView atIndex:(NSUInteger)index;

// Toolbar
- (void)updateToolbar;

// Navigation
- (void)jumpToPageAtIndex:(NSUInteger)index;
- (void)gotoPreviousPage;
- (void)gotoNextPage;

// Controls
- (void)cancelControlHiding;
- (void)hideControlsAfterDelay;
- (void)setControlsHidden:(BOOL)hidden animated:(BOOL)animated permanent:(BOOL)permanent;
- (void)toggleControls;
- (BOOL)areControlsHidden;

// Data
- (NSUInteger)numberOfPhotos;
- (id<TFPhoto>)photoAtIndex:(NSUInteger)index;
- (UIImage *)imageForPhoto:(id<TFPhoto>)photo;
- (void)loadAdjacentPhotosIfNecessary:(id<TFPhoto>)photo;
- (void)releaseAllUnderlyingPhotos;

@end

