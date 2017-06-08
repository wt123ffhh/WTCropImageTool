
//  Created by 吴桐 on 15/1/27.
//

#import "WTCropViewController.h"
#import "UIView+Extension.h"
//#import "UIColor+Tools.h"

@interface WTCropViewController ()
@property (weak, nonatomic)  UIImageView *myImgView;
@property (weak, nonatomic)  UIView *coverView;
@property (weak, nonatomic) IBOutlet UILabel *cropLabel;

@property (nonatomic, weak) UIImageView *point1;
@property (nonatomic, weak) UIImageView *point2;
@property (nonatomic, weak) UIImageView *point3;
@property (nonatomic, weak) UIImageView *point4;

//@property (nonatomic, assign) CGPoint fixPoint1;
@property (nonatomic, assign) CGPoint fixPoint2;
@property (nonatomic, assign) CGPoint fixPoint3;
@property (nonatomic, assign) CGPoint fixPoint4;

@property (nonatomic, assign) NSInteger cropMode;
@property (nonatomic, assign) CGFloat cropScale;

@property (nonatomic, weak) UIScrollView *cropView;
@property (nonatomic, weak) UIImageView *squareImgView;

@property (nonatomic, weak) UIButton *slcBarBtn;


@end
#define kSWidth  ([UIScreen mainScreen].bounds.size.width)
#define kSHeight ([UIScreen mainScreen].bounds.size.height)
@implementation WTCropViewController
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor darkGrayColor];
    self.cropMode = 1;
//    self.cropLabel.text = NSLocalizedString(@"Crop", nil);
    [self setupImgView];
    [self setupCropView];
    [self setupBottomBar];
    [self setupBarView];
}
- (void)setupBottomBar {
    UIView *bottomBarView = [[UIView alloc] init];
    bottomBarView.frame = CGRectMake(0, kSHeight-50, kSWidth, 50);
    bottomBarView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:bottomBarView];
    //Y/N

    
    UIButton *noBtn = [[UIButton alloc] init];
    noBtn.frame = CGRectMake(0, 0, kSWidth/2.0, 50);
    noBtn.backgroundColor = [UIColor clearColor];
    [noBtn setImage:[UIImage imageNamed:@"secCancel"] forState:UIControlStateNormal];
    [bottomBarView addSubview:noBtn];
    [noBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *yesBtn = [[UIButton alloc] init];
    yesBtn.frame = CGRectMake(kSWidth/2.0, 0, kSWidth/2.0, 50);
    yesBtn.backgroundColor = [UIColor clearColor];
    [yesBtn setImage:[UIImage imageNamed:@"secRight"] forState:UIControlStateNormal];
    [bottomBarView addSubview:yesBtn];
    [yesBtn addTarget:self action:@selector(okBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *midView = [[UIView alloc] init];
    midView.frame = CGRectMake(kSWidth/2.0-1, 7, 2, 36);
//    midView.backgroundColor = [UIColor colorWithHexString:@"262A30"];
    [bottomBarView addSubview:midView];
}

- (void)viewDidLayoutSubviews
{
//    if ([UIScreen mainScreen].bounds.size.height==480) {
//        self.contrView.y = 0;
//    }
}
- (void)setupImgView
{
    UIImageView *myImgView = [[UIImageView alloc] init];
    myImgView.frame = CGRectMake(10, 20, kSWidth-20, kSHeight-80-80);
    myImgView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:myImgView];
    self.myImgView = myImgView;
    
    UIView *coverView = [[UIView alloc] init];
    coverView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.45];
    coverView.frame = self.myImgView.frame;
    [self.view addSubview:coverView];
    self.coverView = coverView;
    
    CGFloat imgW = self.myImg.size.width;
    CGFloat imgH = self.myImg.size.height;
    CGFloat imgViewW = self.myImgView.width;
    CGFloat imgViewH = self.myImgView.height;
    
    if (imgViewW/imgViewH>imgW/imgH) {
        self.myImgView.bounds = CGRectMake(0, 0, imgViewH*imgW/imgH, imgViewH);
    }else {
        self.myImgView.bounds = CGRectMake(0, 0, imgViewW, imgViewW/imgW*imgH);
    }
    
    self.myImgView.image = self.myImg;
    coverView.frame = self.myImgView.frame;
    
}
- (void)setupCropView
{
    UIScrollView *cropView = [[UIScrollView alloc] init];
    cropView.frame = CGRectMake(0, 0, self.myImgView.width, self.myImgView.height);
    cropView.backgroundColor = [UIColor clearColor];
    //    cropView.layer.masksToBounds = YES;
    cropView.contentSize = CGSizeMake(self.myImgView.width, self.myImgView.height);
    cropView.showsHorizontalScrollIndicator = NO;
    cropView.showsVerticalScrollIndicator = NO;
    cropView.bounces = NO;
    cropView.scrollEnabled = NO;
    [self.coverView addSubview:cropView];
    self.cropView = cropView;
    cropView.layer.borderColor = [[UIColor whiteColor]CGColor];
    cropView.layer.borderWidth = 1.0;
    
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.frame = self.myImgView.bounds;
    imgView.image = self.myImg;
    [cropView addSubview:imgView];
    
    UIImageView *squareImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cropsquare"]];
    squareImgView.frame = CGRectMake(cropView.contentOffset.x, cropView.contentOffset.y, cropView.width, cropView.height);
    [cropView addSubview:squareImgView];
    self.squareImgView  = squareImgView;
    
    UIImage *img1 = [UIImage imageNamed:@"croppoint"];
    
    UIImageView *point1 = [[UIImageView alloc] init];
    point1.frame = CGRectMake(cropView.x-15+self.myImgView.x, cropView.y-15+self.myImgView.y, 30, 30);
    point1.image = [img1 imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//    point1.tintColor = [UIColor colorWithHexString:@"48dab8"];
    [self.view addSubview:point1];
    self.point1 = point1;

    
    UIImageView *point2 = [[UIImageView alloc] init];
    point2.frame = CGRectMake(cropView.x-15+self.myImgView.x, cropView.y + cropView.height-15+self.myImgView.y, 30, 30);
    point2.image = [img1 imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//    point2.tintColor = [UIColor colorWithHexString:@"48dab8"];
    [self.view addSubview:point2];
    self.point2 = point2;
    
    UIImageView *point3 = [[UIImageView alloc] init];
    point3.frame = CGRectMake(cropView.x + cropView.width-15+self.myImgView.x, cropView.y + cropView.height-15+self.myImgView.y, 30, 30);
    point3.image = [img1 imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//    point3.tintColor = [UIColor colorWithHexString:@"48dab8"];
    [self.view addSubview:point3];
    self.point3 = point3;
    
    UIImageView *point4 = [[UIImageView alloc] init];
    point4.frame = CGRectMake(cropView.x + cropView.width-15+self.myImgView.x, cropView.y-15+self.myImgView.y, 30, 30);
    point4.image = [img1 imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//    point4.tintColor = [UIColor colorWithHexString:@"48dab8"];
    [self.view addSubview:point4];
    self.point4 = point4;
    
    self.coverView.userInteractionEnabled = YES;
    cropView.userInteractionEnabled = YES;
    //    cropBackView.userInteractionEnabled = YES;
    UIPanGestureRecognizer *panGestureRecognizer1 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan1:)];
    UIPanGestureRecognizer *panGestureRecognizer2 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan2:)];
    UIPanGestureRecognizer *panGestureRecognizer3 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan3:)];
    UIPanGestureRecognizer *panGestureRecognizer4 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan4:)];
    [point1 addGestureRecognizer:panGestureRecognizer1];
    [point2 addGestureRecognizer:panGestureRecognizer2];
    [point3 addGestureRecognizer:panGestureRecognizer3];
    [point4 addGestureRecognizer:panGestureRecognizer4];
    point1.userInteractionEnabled = YES;
    point2.userInteractionEnabled = YES;
    point3.userInteractionEnabled = YES;
    point4.userInteractionEnabled = YES;
    
    UIPanGestureRecognizer *panGestureRecognizer5 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan5:)];
    [cropView addGestureRecognizer:panGestureRecognizer5];
    
    //    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    //    [cropView addGestureRecognizer:pinch];
    
}
- (void)setupBarView
{
    UIScrollView *barView = [[UIScrollView alloc] init];
    barView.frame = CGRectMake(0, kSHeight-80-50, kSWidth, 80);
    
    barView.contentSize = CGSizeMake(500, 80);
    barView.backgroundColor = [UIColor clearColor];
    barView.bounces = NO;
    barView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:barView];
    
    for (int i=0; i<8; i++) {
        UIButton *barBtn = [[UIButton alloc] init];
        barBtn.frame = CGRectMake(25+i*60, 15, 30, 30);
        NSString *cropScaleImgName = [NSString stringWithFormat:@"cropScale%d", i];
        NSString *cropScaleImgNameSlc = [NSString stringWithFormat:@"cropScale%02d", i];
        [barBtn setImage:[UIImage imageNamed:cropScaleImgName] forState:UIControlStateNormal];
        [barBtn setImage:[UIImage imageNamed:cropScaleImgNameSlc] forState:UIControlStateSelected];
        if (i==1) {
            self.slcBarBtn = barBtn;
            barBtn.selected = YES;
        }
        [barView addSubview:barBtn];
        barBtn.tag = 600+i;
        [barBtn addTarget:self action:@selector(barBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *barLabel = [[UILabel alloc] init];
        barLabel.frame = CGRectMake(20+i*60, 50, 40, 15);
        barLabel.backgroundColor = [UIColor clearColor];
        [barView addSubview:barLabel];
        barLabel.textAlignment = NSTextAlignmentCenter;
        barLabel.font = [UIFont systemFontOfSize:10];
        barLabel.textColor = [UIColor whiteColor];
        switch (i) {
            case 0:
                barLabel.text = NSLocalizedString(@"Original1", nil);
                break;
            case 1:
                barLabel.text = NSLocalizedString(@"Free", nil);
                break;
            case 2:
                barLabel.text = NSLocalizedString(@"Golden", nil);
                break;
            case 3:
                barLabel.text = @"1:1";
                break;
            case 4:
                barLabel.text = @"4:3";
                break;
            case 5:
                barLabel.text = @"3:4";
                break;
            case 6:
                barLabel.text = @"16:9";
                break;
            case 7:
                barLabel.text = @"9:16";
                break;
                
            default:
                break;
        }
    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //        self.fixPoint1 = CGPointMake(self.myImgView.x + self.point1.centerX, self.myImgView.y + self.point1.centerY);
    self.fixPoint2 = CGPointMake(self.point2.centerX,self.point2.centerY);
    self.fixPoint3 = CGPointMake(self.point3.centerX,self.point3.centerY);
    self.fixPoint4 = CGPointMake(self.point4.centerX,self.point4.centerY);
    //    NSLog(@"%@",NSStringFromCGPoint( self.fixPoint3));
}

-(void)barBtnClick:(UIButton *)btn
{
    self.slcBarBtn.selected = NO;
    btn.selected = YES;
    self.slcBarBtn = btn;
    self.cropMode = btn.tag - 600;
    // 0、原比例 1、自由 2、黄金比例 3、1:1   4、4:3  5、3:4  6、16:9  7、9:16
    switch (self.cropMode) {
        case 0:
            self.cropScale = self.myImgView.width/self.myImgView.height;
            self.cropView.frame = self.coverView.bounds;
            break;
        case 1:
            self.cropScale = 0;
            self.cropView.frame = self.coverView.bounds;
            break;
        case 2:
            self.cropScale = 0.618;
            break;
        case 3:
            self.cropScale = 1;
            break;
        case 4:
            self.cropScale = 1.333;
            break;
        case 5:
            self.cropScale = 0.75;
            break;
        case 6:
            self.cropScale = 1.778;
            break;
        case 7:
            self.cropScale = 0.5625;
            break;
            
        default:
            break;
    }
    if (self.cropMode>1) {
        if (self.myImgView.height*self.cropScale<=self.myImgView.width) {
            self.cropView.frame = CGRectMake((self.myImgView.width - self.myImgView.height*self.cropScale)/2, 0, self.myImgView.height*self.cropScale, self.myImgView.height);
        }else{
            self.cropView.frame = CGRectMake(0, (self.myImgView.height - self.myImgView.width/self.cropScale)/2, self.myImgView.width, self.myImgView.width/self.cropScale);
        }
    }
    self.cropView.contentOffset = CGPointMake(self.cropView.x, self.cropView.y);
    self.point1.frame = CGRectMake(self.cropView.x-15+self.myImgView.x, self.cropView.y-15+self.myImgView.y, 30, 30);
    self.point2.frame = CGRectMake(self.cropView.x-15+self.myImgView.x, self.cropView.y + self.cropView.height-15+self.myImgView.y, 30, 30);
    self.point3.frame = CGRectMake(self.cropView.x + self.cropView.width-15+self.myImgView.x, self.cropView.y + self.cropView.height-15+self.myImgView.y, 30, 30);
    self.point4.frame = CGRectMake(self.cropView.x + self.cropView.width-15+self.myImgView.x, self.cropView.y-15+self.myImgView.y, 30, 30);
    self.squareImgView.frame = CGRectMake(self.cropView.contentOffset.x, self.cropView.contentOffset.y, self.cropView.width, self.cropView.height);
}

- (void)handlePan1:(UIPanGestureRecognizer *)pan
{
    CGPoint locaPoint = [pan locationInView:self.view];
    
    self.point1.centerY = locaPoint.y;
    if (self.point1.centerY<self.myImgView.y) {
        self.point1.centerY = self.myImgView.y;
    }
    if (self.fixPoint3.y-self.point1.centerY<50) {
        self.point1.centerY = self.fixPoint3.y-50;
    }
    if (self.cropMode==1) {
        self.point1.centerX = locaPoint.x;
    }else{
        self.point1.centerX = self.fixPoint3.x - (self.fixPoint3.y-self.point1.centerY)*self.cropScale;
    }
    if (self.point1.centerX<self.myImgView.x) {
        self.point1.centerX = self.myImgView.x;
        if (self.cropMode!=1) {
            self.point1.centerY = self.fixPoint3.y-(self.fixPoint3.x - self.myImgView.x)/self.cropScale;
        }
    }
    if (self.fixPoint3.x-self.point1.centerX<50) {
        self.point1.centerX = self.fixPoint3.x-50;
        if (self.cropMode!=1) {
            self.point1.centerY = self.fixPoint3.y-50/self.cropScale;
        }
    }
    self.point2.centerX = self.point1.centerX;
    self.point4.centerY = self.point1.centerY;
    
    self.cropView.frame = CGRectMake(self.point1.centerX-self.myImgView.x, self.point1.centerY-self.myImgView.y, self.point3.centerX-self.point1.centerX, self.point3.centerY-self.point1.centerY);
    
    //调整图的位置
    self.cropView.contentOffset = CGPointMake(self.cropView.x, self.cropView.y);
    self.squareImgView.frame = CGRectMake(self.cropView.contentOffset.x, self.cropView.contentOffset.y, self.cropView.width, self.cropView.height);
    
    
}
- (void)handlePan2:(UIPanGestureRecognizer *)pan
{
    CGPoint locaPoint = [pan locationInView:self.view];
    
    self.point2.centerY = locaPoint.y;
    if (self.point2.centerY>self.myImgView.y+self.myImgView.height) {
        self.point2.centerY = self.myImgView.y+self.myImgView.height;
    }
    if (self.point2.centerY-self.fixPoint4.y<50) {
        self.point2.centerY = self.fixPoint4.y+50;
    }
    if (self.cropMode==1) {
        self.point2.centerX = locaPoint.x;
    }else{
        self.point2.centerX = self.fixPoint4.x - (self.point2.centerY-self.fixPoint4.y)*self.cropScale;
    }
    if (self.point2.centerX<self.myImgView.x) {
        self.point2.centerX = self.myImgView.x;
        if (self.cropMode!=1) {
            self.point2.centerY = self.fixPoint4.y+(self.fixPoint4.x - self.myImgView.x)/self.cropScale;
        }
    }
    if (self.fixPoint4.x-self.point2.centerX<50) {
        self.point2.centerX = self.fixPoint4.x-50;
        if (self.cropMode!=1) {
            self.point2.centerY = self.fixPoint4.y+50/self.cropScale;
        }
    }
    self.point1.centerX = self.point2.centerX;
    self.point3.centerY = self.point2.centerY;
    
    self.cropView.frame = CGRectMake(self.point1.centerX-self.myImgView.x, self.point1.centerY-self.myImgView.y, self.point3.centerX-self.point1.centerX, self.point3.centerY-self.point1.centerY);
    
    //调整图的位置
    self.cropView.contentOffset = CGPointMake(self.cropView.x, self.cropView.y);
    self.squareImgView.frame = CGRectMake(self.cropView.contentOffset.x, self.cropView.contentOffset.y, self.cropView.width, self.cropView.height);
    
}
- (void)handlePan3:(UIPanGestureRecognizer *)pan
{
    CGPoint locaPoint = [pan locationInView:self.view];
    
    self.point3.centerY = locaPoint.y;
    if (self.point3.centerY>self.myImgView.y+self.myImgView.height) {
        self.point3.centerY = self.myImgView.y+self.myImgView.height;
    }
    if (self.point3.centerY-self.fixPoint4.y<50) {
        self.point3.centerY = self.fixPoint4.y+50;
    }
    if (self.cropMode==1) {
        self.point3.centerX = locaPoint.x;
    }else{
        self.point3.centerX = self.fixPoint2.x + (self.point3.centerY-self.fixPoint4.y)*self.cropScale;
    }
    if (self.point3.centerX>self.myImgView.x+self.myImgView.width) {
        self.point3.centerX = self.myImgView.x+self.myImgView.width;
        if (self.cropMode!=1) {
            self.point3.centerY = self.fixPoint4.y+(self.myImgView.x+self.myImgView.width-self.fixPoint2.x)/self.cropScale;
        }
        
    }
    if (self.point3.centerX-self.fixPoint2.x<50) {
        self.point3.centerX = self.fixPoint2.x+50;
        if (self.cropMode!=1) {
            self.point3.centerY = self.fixPoint4.y+50/self.cropScale;
        }
    }
    self.point2.centerY = self.point3.centerY;
    self.point4.centerX = self.point3.centerX;
    
    self.cropView.frame = CGRectMake(self.point1.centerX-self.myImgView.x, self.point1.centerY-self.myImgView.y, self.point3.centerX-self.point1.centerX, self.point3.centerY-self.point1.centerY);
    
    
    //调整图的位置
    self.cropView.contentOffset = CGPointMake(self.cropView.x, self.cropView.y);
    self.squareImgView.frame = CGRectMake(self.cropView.contentOffset.x, self.cropView.contentOffset.y, self.cropView.width, self.cropView.height);
    
}
- (void)handlePan4:(UIPanGestureRecognizer *)pan
{
    CGPoint locaPoint = [pan locationInView:self.view];
    
    self.point4.centerY = locaPoint.y;
    if (self.point4.centerY<self.myImgView.y) {
        self.point4.centerY = self.myImgView.y;
    }
    if (self.fixPoint2.y-self.point4.centerY<50) {
        self.point4.centerY = self.fixPoint2.y-50;
    }
    if (self.cropMode==1) {
        self.point4.centerX = locaPoint.x;
    }else{
        self.point4.centerX = self.fixPoint2.x + (self.fixPoint2.y-self.point4.centerY)*self.cropScale;
    }
    if (self.point4.centerX>self.myImgView.x+self.myImgView.width) {
        self.point4.centerX = self.myImgView.x+self.myImgView.width;
        if (self.cropMode!=1) {
            self.point4.centerY = self.fixPoint2.y-(self.myImgView.x+self.myImgView.width-self.fixPoint2.x)/self.cropScale;
        }
    }
    if (self.point4.centerX-self.fixPoint2.x<50) {
        self.point4.centerX = self.fixPoint2.x+50;
        if (self.cropMode!=1) {
            self.point4.centerY = self.fixPoint2.y-50/self.cropScale;
        }
    }
    self.point1.centerY = self.point4.centerY;
    self.point3.centerX = self.point4.centerX;
    
    self.cropView.frame = CGRectMake(self.point1.centerX-self.myImgView.x, self.point1.centerY-self.myImgView.y, self.point3.centerX-self.point1.centerX, self.point3.centerY-self.point1.centerY);
    //调整图的位置
    self.cropView.contentOffset = CGPointMake(self.cropView.x, self.cropView.y);
    self.squareImgView.frame = CGRectMake(self.cropView.contentOffset.x, self.cropView.contentOffset.y, self.cropView.width, self.cropView.height);
    
}
- (void)handlePan5:(UIPanGestureRecognizer *)pan
{
    CGPoint translation = [pan translationInView:self.view];
    CGPoint cropCenter = CGPointMake(pan.view.center.x + translation.x,pan.view.center.y + translation.y);
    self.cropView.center = cropCenter;
    if (self.cropView.x<0) {
        self.cropView.x = 0;
    } if (self.cropView.y<0){
        self.cropView.y = 0;
    } if (self.cropView.x+self.cropView.width>self.myImgView.width){
        self.cropView.x = self.myImgView.width-self.cropView.width;
    } if (self.cropView.y+self.cropView.height>self.myImgView.height){
        self.cropView.y = self.myImgView.height - self.cropView.height;
    }
    self.point1.center = CGPointMake(self.cropView.x+self.myImgView.x, self.cropView.y+self.myImgView.y);
    self.point2.center = CGPointMake(self.cropView.x+self.myImgView.x, self.cropView.y+self.myImgView.y+self.cropView.height);
    self.point3.center = CGPointMake(self.cropView.x+self.myImgView.x+self.cropView.width, self.cropView.y+self.myImgView.y+self.cropView.height);
    self.point4.center = CGPointMake(self.cropView.x+self.myImgView.x+self.cropView.width, self.cropView.y+self.myImgView.y);
    
    [pan setTranslation:CGPointZero inView:self.view];
    self.cropView.contentOffset = CGPointMake(self.cropView.x, self.cropView.y);
    self.squareImgView.frame = CGRectMake(self.cropView.contentOffset.x, self.cropView.contentOffset.y, self.cropView.width, self.cropView.height);
}
- (void)handlePinch:(UIPinchGestureRecognizer *)pinch
{
    //    pinch.view.transform = CGAffineTransformScale(pinch.view.transform, pinch.scale, pinch.scale);
    //    pinch.scale = 1;
    //    CGAffineTransform myTransformation = CGAffineTransformMakeScale(pinch.scale, pinch.scale);
    //    pinch.view.transform = myTransformation;
    //    self.cropView.contentOffset = CGPointMake(self.cropView.x, self.cropView.y);
    //    self.squareImgView.frame = CGRectMake(self.cropView.contentOffset.x, self.cropView.contentOffset.y, self.cropView.width, self.cropView.height);
}
- (IBAction)backBtnClick {
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (IBAction)okBtnClick {
    UIImage *resultImg = [self cropImg:self.myImg];
    UIImage *orzImg = [self cropImg:self.orzImg];
    
    if ([self.delegate respondsToSelector:@selector(cropViewSendCropImage:orzImg:)]) {
        [self.delegate cropViewSendCropImage:resultImg orzImg:orzImg];
    }
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
//    [self.navigationController popViewControllerAnimated:YES];
}

- (UIImage *)cropImg:(UIImage *)image {
    CGFloat Scale;
    CGFloat imgW = self.myImgView.width;
    CGFloat imgH = self.myImgView.height;
    if ([UIScreen mainScreen].bounds.size.height==480) {
        if (self.myImg.size.height/imgW*imgW>=self.myImg.size.width) {
            Scale = self.myImg.size.height/self.myImgView.height;
        }else{
            Scale = self.myImg.size.width/self.myImgView.width;
        }
    }else{
        if (self.myImg.size.height/imgH*imgW>=self.myImg.size.width) {
            Scale = self.myImg.size.height/self.myImgView.height;
        }else{
            Scale = self.myImg.size.width/self.myImgView.width;
        }
    }
    CGSize imgSize = CGSizeMake(self.cropView.width*Scale-1, self.cropView.height*Scale-1);
    UIGraphicsBeginImageContext(imgSize);
    
    [image drawAtPoint:CGPointMake(-self.cropView.x*Scale, -self.cropView.y*Scale)];
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}


@end
