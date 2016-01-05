//
//  TFLibraryViewController.m
//  TFPhotoBrowser
//
//  Created by Melvin on 12/15/15.
//  Copyright © 2015 TimeFace. All rights reserved.
//

#import "TFLibraryViewController.h"
#import "TFPhotoBrowserConstants.h"
#import "TFLibraryViewLayout.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>
#import "NSIndexSet+TFLibrary.h"
#import "UICollectionView+TFLibrary.h"
#import "TFLibraryCollectionViewCell.h"


static NSString * const kTFLCollectionIdentifier        = @"kTFLCollectionIdentifier";
static NSString * const kTFLCollectionCameraIdentifier  = @"kTFLCollectionCameraIdentifier";
static NSString * const kTFLCollectionLibraryIdentifier = @"kTFLCollectionLibraryIdentifier";

@interface TFLibraryViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,PHPhotoLibraryChangeObserver>

@property (nonatomic, strong) NSMutableArray        *items;
@property (nonatomic, strong) PHFetchResult         *assetsFetchResults;
@property (nonatomic, strong) PHAssetCollection     *assetCollection;
@property (nonatomic, strong) PHCachingImageManager *imageManager;
@property (nonatomic, strong) UICollectionView      *collectionView;
@property (nonatomic, strong) NSMutableArray        *selectedAssets;
@property (nonatomic, strong) NSMutableArray        *removeAssets;

@property (nonatomic, strong) UIBarButtonItem       *doneButtonItem;
@property (nonatomic, strong) UIButton *selectedButton;

@property CGRect previousPreheatRect;

@end

@implementation TFLibraryViewController

static CGSize AssetGridThumbnailSize;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.imageManager = [[PHCachingImageManager alloc] init];
        [self resetCachedAssets];
        [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
        _items = [NSMutableArray array];
        _selectedAssets = [NSMutableArray array];
        _allowsMultipleSelection = YES;
        self.barButtonColor = [UIColor blueColor];
    }
    return self;
}
- (void)loadAssets {
    if (NSClassFromString(@"PHAsset")) {
        // Check library permissions
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusNotDetermined) {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {
                    [self performLoadAssets];
                }
            }];
        } else if (status == PHAuthorizationStatusAuthorized) {
            [self performLoadAssets];
        } else if (status == PHAuthorizationStatusDenied) {
            //没有权限
        }
        
    } else {
        // Assets library
        [self performLoadAssets];
        
    }
}


- (void)performLoadAssets {
    // Load
    self.navigationItem.title = NSLocalizedString(@"正在加载照片...", @"");
    __weak typeof(self) weakSelf = self;
    if (NSClassFromString(@"PHAsset")) {
        // Photos library iOS >= 8
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            PHFetchOptions *allPhotosOptions = [[PHFetchOptions alloc] init];
            allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
            weakSelf.assetsFetchResults = [PHAsset fetchAssetsWithOptions:allPhotosOptions];
            for (PHAsset *asset in weakSelf.assetsFetchResults) {
                TFAsset *tfAsset = [TFAsset assetFromPH:asset];
                [_items addObject:tfAsset];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.navigationItem.title = NSLocalizedString(@"All Photos", @"");
                [weakSelf.collectionView reloadData];
            });
        });
        
    } else {
        // Assets Library iOS < 8
        
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    [self setupToolBar];
}

- (void)dealloc {
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Add button to the navigation bar if the asset collection supports adding content.
    if (!self.assetCollection || [self.assetCollection canPerformEditOperation:PHCollectionEditOperationAddContent]) {
        
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadAssets];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(UICollectionView *) collectionView {
    if (!_collectionView) {
        TFLibraryViewLayout *flowLayout = [[TFLibraryViewLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds
                                             collectionViewLayout:flowLayout];
        [_collectionView setDelegate:self];
        [_collectionView setDataSource:self];
        [_collectionView setAllowsMultipleSelection:self.allowsMultipleSelection];
        [_collectionView setBackgroundColor:self.view.backgroundColor];
        
        
        [_collectionView registerClass:[TFLibraryCollectionViewCell class]
            forCellWithReuseIdentifier:kTFLCollectionLibraryIdentifier];
        
        
        CGFloat scale = [UIScreen mainScreen].scale;
        CGSize cellSize = ((UICollectionViewFlowLayout *)flowLayout).itemSize;
        AssetGridThumbnailSize = CGSizeMake(cellSize.width * scale, cellSize.height * scale);
        
        flowLayout.headerReferenceSize = CGSizeZero;
        flowLayout.footerReferenceSize = CGSizeZero;
    }
    return _collectionView;
}


- (void)setupToolBar {
    // Toolbar items
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    fixedSpace.width = 12; // To balance action button
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    NSMutableArray *items = [[NSMutableArray alloc] init];
    //    [items addObject:fixedSpace];
    _doneButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.selectedButton];
    [items addObject:flexSpace];
    [items addObject:_doneButtonItem];
    [items addObject:fixedSpace];
    
    [self setToolbarItems:items
                 animated:YES];
}

- (UIButton *)selectedButton {
    if (!_selectedButton) {
        _selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectedButton setBackgroundImage:[self createImageWithColor:self.barButtonColor] forState:UIControlStateSelected];
        [_selectedButton setBackgroundImage:[self createImageWithColor:[UIColor lightGrayColor]] forState:UIControlStateNormal];
        [[_selectedButton titleLabel] setFont:[UIFont systemFontOfSize:14]];
        _selectedButton.layer.masksToBounds = YES;
        _selectedButton.layer.cornerRadius = 4;
        [_selectedButton setTitle:@"完成" forState:UIControlStateNormal];
        [_selectedButton setFrame:CGRectMake(0, 0, 64, 32)];
        [_selectedButton addTarget:self action:@selector(onViewClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectedButton;
}


- (UIImage *)createImageWithColor:(UIColor *)color {
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (void)onViewClick:(id)sender {
    if ([_libraryControllerDelegate respondsToSelector:@selector(didSelectPHAssets:removeList:infos:)]) {
        [_libraryControllerDelegate didSelectPHAssets:_selectedAssets removeList:_removeAssets infos:nil];
    }
}

#pragma mark - PHPhotoLibraryChangeObserver

- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    // Check if there are changes to the assets we are showing.
    PHFetchResultChangeDetails *collectionChanges = [changeInstance changeDetailsForFetchResult:self.assetsFetchResults];
    if (collectionChanges == nil) {
        return;
    }
    
    /*
     Change notifications may be made on a background queue. Re-dispatch to the
     main queue before acting on the change as we'll be updating the UI.
     */
    dispatch_async(dispatch_get_main_queue(), ^{
        // Get the new fetch result.
        self.assetsFetchResults = [collectionChanges fetchResultAfterChanges];
        
        UICollectionView *collectionView = self.collectionView;
        
        if (![collectionChanges hasIncrementalChanges] || [collectionChanges hasMoves]) {
            // Reload the collection view if the incremental diffs are not available
            [collectionView reloadData];
            
        } else {
            /*
             Tell the collection view to animate insertions and deletions if we
             have incremental diffs.
             */
            [collectionView performBatchUpdates:^{
                NSIndexSet *removedIndexes = [collectionChanges removedIndexes];
                if ([removedIndexes count] > 0) {
                    [collectionView deleteItemsAtIndexPaths:[removedIndexes tfl_indexPathsFromIndexesWithSection:0]];
                }
                
                NSIndexSet *insertedIndexes = [collectionChanges insertedIndexes];
                if ([insertedIndexes count] > 0) {
                    [collectionView insertItemsAtIndexPaths:[insertedIndexes tfl_indexPathsFromIndexesWithSection:0]];
                }
                
                NSIndexSet *changedIndexes = [collectionChanges changedIndexes];
                if ([changedIndexes count] > 0) {
                    [collectionView reloadItemsAtIndexPaths:[changedIndexes tfl_indexPathsFromIndexesWithSection:0]];
                }
            } completion:NULL];
        }
        
        [self resetCachedAssets];
    });
}


#pragma mark -
#pragma mark UICollectionView data source.
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TFAsset *asset = self.items[indexPath.item];
    // Dequeue an AAPLGridViewCell.
    TFLibraryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kTFLCollectionLibraryIdentifier forIndexPath:indexPath];
    if (asset.isPHAsset) {
        cell.representedAssetIdentifier = asset.localIdentifier;
        
        // Add a badge to the cell if the PHAsset represents a Live Photo.
        if (asset.phAsset.mediaSubtypes & PHAssetMediaSubtypePhotoLive) {
            // Add Badge Image to the cell to denote that the asset is a Live Photo.
            UIImage *badge = [PHLivePhotoView livePhotoBadgeImageWithOptions:PHLivePhotoBadgeOptionsOverContent];
            cell.livePhotoBadgeImage = badge;
        }
        
        // Request an image for the asset from the PHCachingImageManager.
        [self.imageManager requestImageForAsset:asset.phAsset
                                     targetSize:AssetGridThumbnailSize
                                    contentMode:PHImageContentModeAspectFill
                                        options:nil
                                  resultHandler:^(UIImage *result, NSDictionary *info) {
                                      // Set the cell's thumbnail image if it's still showing the same asset.
                                      NSLog(@"info:%@",info);
                                      if ([cell.representedAssetIdentifier isEqualToString:asset.localIdentifier]) {
                                          cell.thumbnailImage = result;
                                      }
                                  }];
    }
    else {
        
    }
    
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath; {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return NO;
    }
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self validateMaximumNumberOfSelections:([self.selectedAssets count] + 1)];
}
- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        //打开相机
        if (!self.selectedAssets) {
            _selectedAssets = [NSMutableArray array];
        }
        [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    } else {
        TFAsset *asset = [self.items objectAtIndex:indexPath.item];
        if (asset.size.width > 0) {
            if (!_selectedAssets) {
                _selectedAssets = [NSMutableArray array];
            }
            if (!_removeAssets) {
                _removeAssets = [NSMutableArray array];
            }
            if (self.allowsMultipleSelection) {
                //多选
                [_selectedAssets addObject:asset];
                [_removeAssets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if ([obj isEqual:asset.localIdentifier]) {
                        [_removeAssets removeObject:obj];
                    }
                }];
            } else {
                if ( _allowsImageCrop) {
                    //打开裁剪界面
                } else {
                    //选择完成
                    if ([_libraryControllerDelegate respondsToSelector:@selector(didSelectPHAssets:removeList:infos:)]) {
                        [_libraryControllerDelegate didSelectPHAssets:@[asset] removeList:nil infos:nil];
                    }
                }
            }
            //            [_countButton setTitle:[NSString stringWithFormat:NSLocalizedString(@"照片选择完成", nil),[self.selectedAssets count],_maximumNumberOfSelection]
            //                          forState:UIControlStateNormal];
        }
    }
}



- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return;
    }
    TFAsset *asset = [self.items objectAtIndex:indexPath.item];
    if (asset.size.width > 0) {
        if ([_selectedAssets containsObject:asset]) {
            [_selectedAssets removeObject:asset];
        }
        if (!_removeAssets) {
            _removeAssets = [NSMutableArray array];
        }
        [_removeAssets addObject:asset];
        //        [_countButton setTitle:[NSString stringWithFormat:NSLocalizedString(@"照片选择完成", nil),[self.selectedAssets count],_maximumNumberOfSelection]
        //                      forState:UIControlStateNormal];
    }
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Update cached assets for the new visible area.
    [self updateCachedAssets];
}

#pragma mark - Asset Caching
- (void)resetCachedAssets {
    [self.imageManager stopCachingImagesForAllAssets];
    self.previousPreheatRect = CGRectZero;
}

- (void)updateCachedAssets {
    BOOL isViewVisible = [self isViewLoaded] && [[self view] window] != nil;
    if (!isViewVisible) { return; }
    
    // The preheat window is twice the height of the visible rect.
    CGRect preheatRect = self.collectionView.bounds;
    preheatRect = CGRectInset(preheatRect, 0.0f, -0.5f * CGRectGetHeight(preheatRect));
    
    /*
     Check if the collection view is showing an area that is significantly
     different to the last preheated area.
     */
    CGFloat delta = ABS(CGRectGetMidY(preheatRect) - CGRectGetMidY(self.previousPreheatRect));
    if (delta > CGRectGetHeight(self.collectionView.bounds) / 3.0f) {
        
        // Compute the assets to start caching and to stop caching.
        NSMutableArray *addedIndexPaths = [NSMutableArray array];
        NSMutableArray *removedIndexPaths = [NSMutableArray array];
        
        [self computeDifferenceBetweenRect:self.previousPreheatRect andRect:preheatRect removedHandler:^(CGRect removedRect) {
            NSArray *indexPaths = [self.collectionView tfl_indexPathsForElementsInRect:removedRect];
            [removedIndexPaths addObjectsFromArray:indexPaths];
        } addedHandler:^(CGRect addedRect) {
            NSArray *indexPaths = [self.collectionView tfl_indexPathsForElementsInRect:addedRect];
            [addedIndexPaths addObjectsFromArray:indexPaths];
        }];
        
        NSArray *assetsToStartCaching = [self assetsAtIndexPaths:addedIndexPaths];
        NSArray *assetsToStopCaching = [self assetsAtIndexPaths:removedIndexPaths];
        
        // Update the assets the PHCachingImageManager is caching.
        [self.imageManager startCachingImagesForAssets:assetsToStartCaching
                                            targetSize:AssetGridThumbnailSize
                                           contentMode:PHImageContentModeAspectFill
                                               options:nil];
        [self.imageManager stopCachingImagesForAssets:assetsToStopCaching
                                           targetSize:AssetGridThumbnailSize
                                          contentMode:PHImageContentModeAspectFill
                                              options:nil];
        
        // Store the preheat rect to compare against in the future.
        self.previousPreheatRect = preheatRect;
    }
}

- (void)computeDifferenceBetweenRect:(CGRect)oldRect andRect:(CGRect)newRect removedHandler:(void (^)(CGRect removedRect))removedHandler addedHandler:(void (^)(CGRect addedRect))addedHandler {
    if (CGRectIntersectsRect(newRect, oldRect)) {
        CGFloat oldMaxY = CGRectGetMaxY(oldRect);
        CGFloat oldMinY = CGRectGetMinY(oldRect);
        CGFloat newMaxY = CGRectGetMaxY(newRect);
        CGFloat newMinY = CGRectGetMinY(newRect);
        
        if (newMaxY > oldMaxY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, oldMaxY, newRect.size.width, (newMaxY - oldMaxY));
            addedHandler(rectToAdd);
        }
        
        if (oldMinY > newMinY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, newMinY, newRect.size.width, (oldMinY - newMinY));
            addedHandler(rectToAdd);
        }
        
        if (newMaxY < oldMaxY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, newMaxY, newRect.size.width, (oldMaxY - newMaxY));
            removedHandler(rectToRemove);
        }
        
        if (oldMinY < newMinY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, oldMinY, newRect.size.width, (newMinY - oldMinY));
            removedHandler(rectToRemove);
        }
    } else {
        addedHandler(newRect);
        removedHandler(oldRect);
    }
}

- (NSArray *)assetsAtIndexPaths:(NSArray *)indexPaths {
    if (indexPaths.count == 0){
        return nil;
    }
    NSMutableArray *assets = [NSMutableArray arrayWithCapacity:indexPaths.count];
    for (NSIndexPath *indexPath in indexPaths) {
        PHAsset *asset = self.assetsFetchResults[indexPath.item];
        [assets addObject:asset];
    }
    return assets;
}

#pragma mark - Validating Selections

- (BOOL)validateNumberOfSelections:(NSUInteger)numberOfSelections
{
    NSUInteger minimumNumberOfSelection = MAX(1, self.minimumNumberOfSelection);
    BOOL qualifiesMinimumNumberOfSelection = (numberOfSelections >= minimumNumberOfSelection);
    
    BOOL qualifiesMaximumNumberOfSelection = YES;
    if (minimumNumberOfSelection <= self.maximumNumberOfSelection) {
        qualifiesMaximumNumberOfSelection = (numberOfSelections <= self.maximumNumberOfSelection);
    }
    
    return (qualifiesMinimumNumberOfSelection && qualifiesMaximumNumberOfSelection);
}

- (BOOL)validateMaximumNumberOfSelections:(NSUInteger)numberOfSelections
{
    NSUInteger minimumNumberOfSelection = MAX(1, self.minimumNumberOfSelection);
    
    if (minimumNumberOfSelection <= self.maximumNumberOfSelection) {
        return (numberOfSelections <= self.maximumNumberOfSelection);
    }
    
    return YES;
}


#pragma mark - 图片裁剪

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
