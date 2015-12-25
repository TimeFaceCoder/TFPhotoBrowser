//
//  ViewController.m
//  TFPhotoBrowser
//
//  Created by Melvin on 8/28/15.
//  Copyright © 2015 TimeFace. All rights reserved.
//

#import "ViewController.h"
#import "TFPhotoBrowser.h"
#import "TFLibraryViewController.h"

@interface ViewController ()<TFPhotoBrowserDelegate>

@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;
@property (nonatomic, strong) NSMutableArray *selections;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"测试相册" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onViewClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(100, 100, 60, 40)];
    button.layer.borderWidth = 1;
    [self.view addSubview:button];
    
    _photos     = [NSMutableArray array];
    _thumbs     = [NSMutableArray array];
    _selections = [NSMutableArray array];
    @autoreleasepool {
        TFPhoto *photo,*thumb;
        for (NSInteger i=1;i<=9 ; i++) {
            photo = [TFPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"photo%@",@(i)] ofType:@"jpg"]]];
            photo.caption = @"这是一段对于这个图片的文字描述，我们需要进行展示，默认展示2行，提供手势操作展开的功能,默认展示2行，提供手势操作展开的功能默认展示2行，提供手势操作展开的功能默认展示2行，提供手势操作展开的功能默认展示2行，提供手势操作展开的功能默认展示2行，提供手势操作展开的功能默认展示2行，提供手势操作展开的功能默认展示2行，提供手势操作展开的功能默认展示2行，提供手势操作展开的功能默认展示2行，提供手势操作展开的功能默认展示2行，提供手势操作展开的功能";
            [_photos addObject:photo];
            
            thumb = [TFPhoto photoWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"photo%@t",@(i)] ofType:@"jpg"]]];
            [_thumbs addObject:thumb];
        }
    }
    
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"测试相册" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onViewClick2:) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(100, 200, 60, 40)];
    button.layer.borderWidth = 1;
    [self.view addSubview:button];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onViewClick:(id)sender {
    // Create browser
    
}


- (void)onViewClick2:(id)sender {
    TFLibraryViewController *viewController = [[TFLibraryViewController alloc] init];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:viewController];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    nc.toolbarHidden = NO;
    [self presentViewController:nc animated:YES completion:nil];
}


#pragma mark - TFPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(TFPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <TFPhoto>)photoBrowser:(TFPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

- (id <TFPhoto>)photoBrowser:(TFPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (index < _thumbs.count)
        return [_thumbs objectAtIndex:index];
    return nil;
}

//- (MWCaptionView *)photoBrowser:(MWPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index {
//    MWPhoto *photo = [self.photos objectAtIndex:index];
//    MWCaptionView *captionView = [[MWCaptionView alloc] initWithPhoto:photo];
//    return [captionView autorelease];
//}

//- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index {
//    NSLog(@"ACTION!");
//}

- (void)photoBrowser:(TFPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
    NSLog(@"Did start viewing photo at index %lu", (unsigned long)index);
}

- (BOOL)photoBrowser:(TFPhotoBrowser *)photoBrowser isPhotoSelectedAtIndex:(NSUInteger)index {
    return [[_selections objectAtIndex:index] boolValue];
}

//- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index {
//    return [NSString stringWithFormat:@"Photo %lu", (unsigned long)index+1];
//}

- (void)photoBrowser:(TFPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected {
    [_selections replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:selected]];
    NSLog(@"Photo at index %lu selected %@", (unsigned long)index, selected ? @"YES" : @"NO");
}

- (void)photoBrowserDidFinishModalPresentation:(TFPhotoBrowser *)photoBrowser {
    // If we subscribe to this method we must dismiss the view controller ourselves
    NSLog(@"Did finish modal presentation");
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
