//
//  Created by 吴桐 on 15/1/27.
//
#import <UIKit/UIKit.h>


@protocol WTCropViewDelegate;
@interface WTCropViewController : UIViewController

@property (weak, nonatomic) id <WTCropViewDelegate> delegate;
@property (nonatomic, strong) UIImage *myImg;
@property (nonatomic, strong) UIImage *orzImg;
@end

@protocol WTCropViewDelegate <NSObject>
- (void)cropViewSendCropImage:(UIImage *)image orzImg:(UIImage *)orzImg;
@end
