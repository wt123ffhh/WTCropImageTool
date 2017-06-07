//
//  ViewController.m
//  WTCropImageTool
//
//  Created by 吴桐 on 17/6/7.
//  Copyright © 2017年 wtWork. All rights reserved.
//

#import "ViewController.h"
#import "WTCropViewController.h"

@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,WTCropViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *ImgView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WTCropViewDelegate
- (void)cropViewSendCropImage:(UIImage *)image orzImg:(UIImage *)orzImg {
    self.ImgView.image = image;
}

- (IBAction)galleryBtnClick {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [picker dismissViewControllerAnimated:NO completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    image = [self CropSmallImg:image];
    
    WTCropViewController *controller = [[WTCropViewController alloc] init];
    controller.myImg = image;
    controller.orzImg = image;
    controller.delegate = self;
    
    [self presentViewController:controller animated:YES completion:nil];
    
    
}
- (UIImage *)CropSmallImg:(UIImage *)image
{
    CGFloat sideLength = 1080.0;
    
    
    CGSize smallImgSize = image.size;
    if (image.size.width>=image.size.height&&image.size.width>sideLength) {
        smallImgSize = CGSizeMake(sideLength, sideLength*image.size.height/image.size.width);
    }else if(image.size.width<image.size.height&&image.size.height>sideLength){
        smallImgSize = CGSizeMake(sideLength*image.size.width/image.size.height, sideLength);
    }
    UIGraphicsBeginImageContext(smallImgSize);
    
    [image drawInRect:CGRectMake(0, 0, smallImgSize.width, smallImgSize.height)];
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

@end
