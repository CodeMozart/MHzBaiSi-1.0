//
//  MHzSeeBigController.m
//  百思不得姐
//
//  Created by Minghe on 10/22/15.
//  Copyright © 2015 project. All rights reserved.
//

#import "MHzSeeBigController.h"
#import <UIImageView+WebCache.h>
#import <SVProgressHUD.h>
#import <Photos/Photos.h> // 从iOS8

@interface MHzSeeBigController ()<UIScrollViewDelegate>

@property (weak, nonatomic) UIImageView *imageView;/**< <#注释#> */

@end

static NSString * const MHzCollectionName = @"百思不得姐";

@implementation MHzSeeBigController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prefersStatusBarHidden];
    
    // 最底层应该是一个scrollView这样长图片才可以滚动
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = [UIScreen mainScreen].bounds;
    
    /* 因为self是通过xib加载的，所以self.view的尺寸会和xib里面一样，所以最好不用 self.view.width
    scrollView.frame = self.view.frame;
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    如果用self.view.frame的话，一定要记得调整autoresizingMask */
    [self.view insertSubview:scrollView atIndex:0];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    self.imageView = imageView;
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.topic.large_image]];
    
    imageView.width = scrollView.width;
    imageView.height = scrollView.width / self.topic.width * self.topic.height;
    imageView.x = 0;
    if (self.topic.isBigPicture) {
        imageView.y = 0;
    } else {
        imageView.centerY = self.view.centerY;
    }

    [scrollView addSubview:imageView];
    // scrollView的滚动范围
    scrollView.contentSize = CGSizeMake(0, self.imageView.height);
    
    // 设置缩放
    scrollView.delegate = self;
    CGFloat maxScele = self.topic.height / imageView.height;
    if (maxScele > 1.0) {
        scrollView.maximumZoomScale = maxScele;
        
    }
    
    
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}


/***********************************************************************************************************/
#pragma mark -  <页面上的按钮方法>

- (IBAction)close:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveImage:(id)sender {
    // 把图片写入相机胶卷
//    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSaveingWithError:contextInfo:), nil);
    // 这里对@selector的方法有要求，得是 a:a:a: 的格式
    // - (void)saveSuccess 错误，参数不对
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusDenied) { // 拒绝访问
        MHzLog(@"用户拒绝当前应用访问相册 please:Setting -> 百思不得姐 -> ALLOW TO ACCESS");
        
    } else if (status == PHAuthorizationStatusRestricted) { // 家长控制
        MHzLog(@"家长控制 － 不允许访问相册");
        
    } else if (status == PHAuthorizationStatusNotDetermined) { // 尚未决定
        MHzLog(@"用户尚未决定");
        [self saveImageToAlbum];
        
    } else if (status == PHAuthorizationStatusAuthorized) { // 允许访问
        MHzLog(@"用户允许当前应用访问相册");
        [self saveImageToAlbum];
    }
    
    
    
}

/**
 *  保存图片到相册
 */
- (void)saveImageToAlbum
{
    __block NSString *assetId = nil;
    // 1.存储图片到相机胶卷
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{ // 这个block里面放一些“修改”性质的代码
        
        // 新建一个PHAssetCreationRequest对象，保存到相机胶卷
        // 返回 PHAsset（图片）的字符串标识，用assetId保存
        assetId = [PHAssetCreationRequest creationRequestForAssetFromImage:self.imageView.image].placeholderForCreatedAsset.localIdentifier;
        
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (error) {
            MHzLog(@"保存图片到相机胶卷失败");
            return ;
        }
        
        // 2.获得app相册对象
        PHAssetCollection *collection = [self gainCollection];
        
        // 3.将“相机胶卷”中的图片 添加到 新的相册
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:collection];
            PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetId] options:nil].firstObject;
            [request addAssets:@[asset]];
            
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            if (error) {
                MHzLog(@"添加到“百思不得姐“相册中失败");
                return ;
            }
            
            MHzLog(@"添加到“百思不得姐“相册中成功");
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [SVProgressHUD showSuccessWithStatus:@"保存成功"];
            }];
        }];

    }];
}

/**
 *   获得相册
 *
 *  @return 一个PHAssetCollection对象
 */
- (PHAssetCollection *)gainCollection
{
    // 如果以前已经创建过app的相册，直接获取
    PHFetchResult<PHAssetCollection *> *collectionResult =[PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *collection in collectionResult) {
        if ([collection.localizedTitle isEqualToString:MHzCollectionName]) {
            return collection;
        }
    }
    
    // 如果app的相册不存在，就创建新的相册（文件夹）
    __block NSString *collectionId = nil;
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        // 新建一个PHAssetCollectionChangeRequest对象，用来创建一个新的相册,并且用collectionId保存这个相册对应的identifier
        collectionId = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:MHzCollectionName].placeholderForCreatedAssetCollection.localIdentifier;
    } error:nil];
    
    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[collectionId] options:nil].firstObject;
    
}

/**
 *  成功保存到相册中


- (void)image:(UIImage *)image didFinishSaveingWithError:(NSError *)error  contextInfo:(void *)contextInfo
{
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"保存失败"];
    } else {
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
    }
}
 */

/**
 *  返回一个scrollView的内部控件进行缩放
 *
 *  @param scrollView 这个控制器的scrollView
 *
 *  @return 需要进行缩放的控件
 */
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}



@end
