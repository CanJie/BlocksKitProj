//
//  ViewController.m
//  BlocksKitProj
//
//  Created by dongchanghao on 2017/12/6.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "ViewController.h"
#import "BlocksKit.h"
#import "BlocksKit+UIKit.h"
#import "BlocksKit+MessageUI.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface ViewController ()

@end

@implementation ViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    self.view.backgroundColor=[UIColor whiteColor];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
//    [self testActionSheet];
//    [self testAlertView];
//    [self testPopoverController];
//    [self testImagePickerController];
//    [self testGestureRecognizer];
    
//    [self testWebView];
    [self testView];
//    [self testTextField];
//    [self testControl];
//    [self testBarButtonItem];
}

#pragma mark -
-(void)testActionSheet{
    UIActionSheet *testSheet = [UIActionSheet bk_actionSheetWithTitle:@"Please select one."];
    [testSheet bk_addButtonWithTitle:@"Zip" handler:^{
        NSLog(@"Zip!");
    }];
    [testSheet bk_addButtonWithTitle:@"Rar" handler:^{
        NSLog(@"Rar!");
    }];
    [testSheet bk_addButtonWithTitle:@"7z" handler:^{
        NSLog(@"7z!");
    }];
    [testSheet bk_setDestructiveButtonWithTitle:@"销毁!" handler:^{
        NSLog(@"销毁!");
    }];
    [testSheet bk_setCancelButtonWithTitle:@"取消" handler:^{
        NSLog(@"取消!");
    }];
    
    testSheet.bk_willShowBlock=^(UIActionSheet *actionSheet){
        NSLog(@"bk_willShowBlock!");
    };
    testSheet.bk_didShowBlock=^(UIActionSheet *actionSheet){
        NSLog(@"bk_didShowBlock!");
    };
    testSheet.bk_willDismissBlock=^(UIActionSheet *actionSheet, NSInteger buttonIndex){
        NSLog(@"bk_willDismissBlock!");
    };
    testSheet.bk_didDismissBlock=^(UIActionSheet *actionSheet, NSInteger buttonIndex){
        NSLog(@"bk_didDismissBlock!");
    };
    [testSheet showInView:self.view];
}
-(void)testAlertView{
    //两个的话取消在左，大于两个取消在最下
    UIAlertView *alert = [UIAlertView bk_showAlertViewWithTitle:@"提示" message:@"这是一条提示" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确认",@"或许"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            NSLog(@"取消");
        }
        if (buttonIndex == 1) {
            NSLog(@"确认");
        }
        if (buttonIndex == 2) {
            NSLog(@"或许");
        }
        NSLog(@"buttonIndex = %ld", buttonIndex);
    }];
    [alert show];
    
//    UIAlertView *testView = [UIAlertView bk_alertViewWithTitle:@"Very important!" message:@"Do you like chocolate?"];
//    [testView bk_addButtonWithTitle:@"Yes" handler:^{
//        NSLog(@"Yay!");
//    }];
//    [testView bk_addButtonWithTitle:@"Can" handler:^{
//        NSLog(@"May be!");
//    }];
//    [testView bk_setCancelButtonWithTitle:@"No" handler:^{
//        NSLog(@"We hate you.");
//    }];
//    testView.bk_willShowBlock=^(UIAlertView *alertView){
//        NSLog(@"bk_willShowBlock!");
//    };
//    testView.bk_didShowBlock=^(UIAlertView *alertView){
//        NSLog(@"bk_didShowBlock!");
//    };
//    testView.bk_willDismissBlock=^(UIAlertView *alertView, NSInteger buttonIndex){
//        NSLog(@"bk_willDismissBlock!");
//    };
//    testView.bk_didDismissBlock=^(UIAlertView *alertView, NSInteger buttonIndex){
//        NSLog(@"bk_didDismissBlock!");
//    };
//    [testView show];
}
-(void)testPopoverController{
//    http://www.jianshu.com/p/5d9872d13e5d
//    UIPopoverPresentationController
//    UIPresentationController
}
/** 从相册获取媒体 */
-(void)testImagePickerController{
//    http://www.jianshu.com/p/48ffc684c881
//    http://blog.csdn.net/boyqicheng/article/details/52909514
//    http://www.jianshu.com/p/587f3384dbdd
    // 1.判断当前的sourceType是否可用
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        // 2.实例化UIImagePickerController控制器
        UIImagePickerController *imagePickerVC = [[UIImagePickerController alloc] init];
        // 设置资源来源（相册、相机、图库之一）
        // 从图库获取与从相册获取一样，只不过 sourceType 换成 UIImagePickerControllerSourceTypeSavedPhotosAlbum
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // 设置可用的媒体类型、默认只包含kUTTypeImage，如果想选择视频，请添加kUTTypeMovie
        // 如果选择的是视屏，允许的视屏时长为20秒
        imagePickerVC.videoMaximumDuration = 20;
        // 允许的视屏质量（如果质量选取的质量过高，会自动降低质量）
        imagePickerVC.videoQuality = UIImagePickerControllerQualityTypeHigh;
        imagePickerVC.mediaTypes = @[(NSString *)kUTTypeMovie, (NSString *)kUTTypeImage];
        // 3.设置代理，遵守UINavigationControllerDelegate, UIImagePickerControllerDelegate 协议
//        imagePickerVC.delegate = self;
        __weak typeof(imagePickerVC) weakPicker = imagePickerVC;
        imagePickerVC.bk_didFinishPickingMediaBlock=^(UIImagePickerController *picker, NSDictionary<NSString *,id> *info){
            /* 选择的图片信息存储于info字典中
            UIImagePickerControllerCropRect // 编辑裁剪区域
            UIImagePickerControllerEditedImage // 编辑后的UIImage
            UIImagePickerControllerMediaType // 返回媒体的媒体类型
            UIImagePickerControllerOriginalImage // 原始的UIImage
            UIImagePickerControllerReferenceURL // 图片地址
            */
            [weakPicker dismissViewControllerAnimated:YES completion:^{
                
            }];
            NSLog(@"%@", info);
        };
        imagePickerVC.bk_didCancelBlock=^(UIImagePickerController *picker){
            NSLog(@"dismiss");
            [weakPicker dismissViewControllerAnimated:YES completion:^{
                
            }];
        };
        // 4.常用功能设置
        // 是否允许编辑（YES：图片选择完成进入编辑模式）
        imagePickerVC.allowsEditing = YES;
        // model出控制器
        [self presentViewController:imagePickerVC animated:YES completion:nil];
    }
}
/** 从相机中获取 */
-(void)testImagePickerController2{
    // 1.判断当前的sourceType是否可用
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        // 2.实例化UIImagePickerController控制器
        UIImagePickerController * imagePickerVC = [[UIImagePickerController alloc] init];
        // 设置资源来源
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        // 如果选择的是视屏，允许的视屏时长为20秒
        imagePickerVC.videoMaximumDuration = 20;
        // 允许的视屏质量（如果质量选取的质量过高，会自动降低质量）
        imagePickerVC.videoQuality = UIImagePickerControllerQualityTypeHigh;
        // 设置可用的媒体类型、默认只包含kUTTypeImage，如果想选择视频，请添加kUTTypeMovie
        imagePickerVC.mediaTypes = @[(NSString *)kUTTypeMovie, (NSString *)kUTTypeImage];
        // 3.设置代理，遵守UINavigationControllerDelegate, UIImagePickerControllerDelegate 协议
//        imagePickerVC.delegate = self;
        __weak typeof(imagePickerVC) weakPicker = imagePickerVC;
        imagePickerVC.bk_didFinishPickingMediaBlock=^(UIImagePickerController *picker, NSDictionary<NSString *,id> *info){
            /* 选择的图片信息存储于info字典中
             UIImagePickerControllerCropRect // 编辑裁剪区域
             UIImagePickerControllerEditedImage // 编辑后的UIImage
             UIImagePickerControllerMediaType // 返回媒体的媒体类型
             UIImagePickerControllerOriginalImage // 原始的UIImage
             UIImagePickerControllerReferenceURL // 图片地址
             */
            [weakPicker dismissViewControllerAnimated:YES completion:^{
                
            }];
            NSLog(@"%@", info);
        };
        imagePickerVC.bk_didCancelBlock=^(UIImagePickerController *picker){
            NSLog(@"dismiss");
            [weakPicker dismissViewControllerAnimated:YES completion:^{
                
            }];
        };
        // 4.常用功能设置
        // 是否允许编辑
        imagePickerVC.allowsEditing = YES;
        // 相机获取媒体的类型（照相、录制视屏）
        imagePickerVC.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        // 使用前置还是后置摄像头
        imagePickerVC.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        // 是否开起闪光灯
        imagePickerVC.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
        imagePickerVC.showsCameraControls = YES;
        // model出控制器
        [self presentViewController:imagePickerVC animated:YES completion:nil];
    }
}
/** 定制相机界面 */
-(void)testImagePickerController3{
//    定制相机界面，只需要给UIImagePickerController添加如下的一行代码，同时提供自己的界面即可（定制界面即定制拍照按钮等）:设置是否显示系统的相机页面（我们要定制则返回NO）imagePickerVC.showsCameraControls = NO;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController * imagePickerVC = [[UIImagePickerController alloc] init];
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerVC.videoMaximumDuration = 20;
        imagePickerVC.videoQuality = UIImagePickerControllerQualityTypeHigh;
        imagePickerVC.mediaTypes = @[(NSString *)kUTTypeMovie, (NSString *)kUTTypeImage];
        __weak typeof(imagePickerVC) weakPicker = imagePickerVC;
        imagePickerVC.bk_didFinishPickingMediaBlock=^(UIImagePickerController *picker, NSDictionary<NSString *,id> *info){
            /* 选择的图片信息存储于info字典中
             UIImagePickerControllerCropRect // 编辑裁剪区域
             UIImagePickerControllerEditedImage // 编辑后的UIImage
             UIImagePickerControllerMediaType // 返回媒体的媒体类型
             UIImagePickerControllerOriginalImage // 原始的UIImage
             UIImagePickerControllerReferenceURL // 图片地址
             */
            [weakPicker dismissViewControllerAnimated:YES completion:^{
                
            }];
            NSLog(@"%@", info);
        };
        imagePickerVC.bk_didCancelBlock=^(UIImagePickerController *picker){
            NSLog(@"dismiss");
            [weakPicker dismissViewControllerAnimated:YES completion:^{
                
            }];
        };
        
        imagePickerVC.allowsEditing = YES;
        imagePickerVC.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        imagePickerVC.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        imagePickerVC.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
        
        imagePickerVC.showsCameraControls = NO;
        // 拍照界面容器
        UIView *customCameraView = [[UIView alloc] initWithFrame:[UIScreen  mainScreen].bounds];
        // 开始摄像按钮（如果是拍照，则不需要此按钮）
        UIButton * start = [UIButton buttonWithType:UIButtonTypeCustom];
        start.frame = CGRectMake(0, 0, 44, 100);
        [start setTitle:@"开始" forState:UIControlStateNormal];
        [start bk_addEventHandler:^(id sender) {
            
            [weakPicker startVideoCapture];
        } forControlEvents:UIControlEventTouchDown];
        [customCameraView addSubview:start];
        // 停止摄像按钮（如果是拍照，则不需要此按钮）
        UIButton * stop = [UIButton buttonWithType:UIButtonTypeCustom];
        stop.frame = CGRectMake(200, 0, 44, 100);
        [stop setTitle:@"停止" forState:UIControlStateNormal];
        [stop bk_addEventHandler:^(id sender) {
            
            [weakPicker stopVideoCapture];
        } forControlEvents:UIControlEventTouchDown];
        [customCameraView addSubview:stop];
        // 拍照按钮（如果是摄像，则不需要此按钮）
        UIButton * takePicture = [UIButton buttonWithType:UIButtonTypeCustom];
        takePicture.frame = CGRectMake(200, 100, 44, 100);
        [takePicture setTitle:@"照相" forState:UIControlStateNormal];
        [stop bk_addEventHandler:^(id sender) {
            //调用了 [weakPicker takePicture]; 方法后会自动调用代理的 imagePickerController:didFinishPickingImage:editingInfo: 方法，在此方法中可不dismiss imagePic可Controller，则可以实现多联拍。
            //因为 UIImagePickerController 是继承至 UINavigationController,所以可以push和pop一些viewcontroller进行导航效果。例如，自定义照相机画面的时候可以在拍摄完后push一个viewcontroller用于对照片进行编辑。
            [weakPicker takePicture];
        } forControlEvents:UIControlEventTouchDown];
        [customCameraView addSubview:takePicture];
        // 将自定义的相机界面赋值给cameraOverlayView属性即可显示自定义界面
        imagePickerVC.cameraOverlayView = customCameraView;
        // 此属性可transform自定义界面
        imagePickerVC.cameraViewTransform = CGAffineTransformMakeScale(0.5, 0.5);
        [self presentViewController:imagePickerVC animated:YES completion:nil];
    }
}
/*
typedef NS_ENUM(NSInteger, UIImagePickerControllerSourceType) {};
typedef NS_ENUM(NSInteger, UIImagePickerControllerQualityType) {};
typedef NS_ENUM(NSInteger, UIImagePickerControllerCameraCaptureMode) {};
typedef NS_ENUM(NSInteger, UIImagePickerControllerCameraDevice) {};
typedef NS_ENUM(NSInteger, UIImagePickerControllerCameraFlashMode) {};
// info dictionary keys
NSString *const UIImagePickerControllerCropRect
NSString *const UIImagePickerControllerEditedImage
NSString *const UIImagePickerControllerMediaType
NSString *const UIImagePickerControllerOriginalImage
NSString *const UIImagePickerControllerReferenceURL
NSString *const UIImagePickerControllerLivePhoto
NSString *const UIImagePickerControllerMediaMetadata
NSString *const UIImagePickerControllerMediaURL

@interface UIImagePickerController : UINavigationController <NSCoding>
+ (BOOL)isSourceTypeAvailable:(UIImagePickerControllerSourceType)sourceType;
+ (nullable NSArray<NSString *> *)availableMediaTypesForSourceType:(UIImagePickerControllerSourceType)sourceType;
//拍摄和录制
+ (nullable NSArray<NSNumber *> *)availableCaptureModesForCameraDevice:(UIImagePickerControllerCameraDevice)cameraDevice;
//前后置摄像头
+ (BOOL)isCameraDeviceAvailable:(UIImagePickerControllerCameraDevice)cameraDevice;
//闪光灯
+ (BOOL)isFlashAvailableForCameraDevice:(UIImagePickerControllerCameraDevice)cameraDevice;

@property(nonatomic)UIImagePickerControllerSourceType sourceType;
@property(nonatomic)NSTimeInterval videoMaximumDuration;
@property(nonatomic)UIImagePickerControllerQualityType videoQuality;
@property(nonatomic,copy)NSArray<NSString *> *mediaTypes;

@property(nonatomic) UIImagePickerControllerCameraCaptureMode cameraCaptureMode;
@property(nonatomic)UIImagePickerControllerCameraDevice    cameraDevice;
@property(nonatomic)UIImagePickerControllerCameraFlashMode cameraFlashMode;
@property(nonatomic)BOOL allowsEditing;
@property(nonatomic)BOOL allowsImageEditing;

- (void)takePicture NS_AVAILABLE_IOS(3_1);
- (BOOL)startVideoCapture NS_AVAILABLE_IOS(4_0);
- (void)stopVideoCapture  NS_AVAILABLE_IOS(4_0);
@property(nonatomic)BOOL showsCameraControls;
@property(nullable, nonatomic,strong)__kindof UIView *cameraOverlayView;
@property(nonatomic)CGAffineTransform cameraViewTransform;
@end
*/
-(void)testGestureRecognizer{
    UIView *redView=[[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    redView.backgroundColor=[UIColor redColor];
    UITapGestureRecognizer *singleTap = [UITapGestureRecognizer bk_recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        NSLog(@"Single tap.");
    } delay:0.18];
    [redView addGestureRecognizer:singleTap];
    [self.view addSubview:redView];
}

#pragma mark -
-(void)testWebView{
    
//    @property (nonatomic, copy, setter = bk_setShouldStartLoadBlock:) BOOL (^bk_shouldStartLoadBlock)(UIWebView *webView, NSURLRequest *request, UIWebViewNavigationType navigationType);
//    @property (nonatomic, copy, setter = bk_setDidStartLoadBlock:) void (^bk_didStartLoadBlock)(UIWebView *webView);
//    @property (nonatomic, copy, setter = bk_setDidFinishLoadBlock:) void (^bk_didFinishLoadBlock)(UIWebView *webView);
//    @property (nonatomic, copy, setter = bk_setDidFinishWithErrorBlock:) void (^bk_didFinishWithErrorBlock)(UIWebView *webView, NSError *error);
}
-(void)testView{
//    UITextView
//    UIImageView
//    UIImage
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(20, 100, 130, 30)];
    view.backgroundColor=[UIColor cyanColor];
    [self.view addSubview:view];
//    @property (nonatomic) NSUInteger  numberOfTapsRequired;
//    @property (nonatomic) NSUInteger  numberOfTouchesRequired;
    [view bk_whenTouches:2 tapped:2 handler:^{
        NSLog(@">>>>>");
    }];
    [view bk_whenTapped:^{
        NSLog(@"1111");
    }];
    [view bk_eachSubview:^(UIView *subview) {
        
    }];
}
-(void)testTextField{
    UITextField *text = [[UITextField alloc]initWithFrame:CGRectMake(20, 100, 130, 30)];
    text.backgroundColor=[UIColor cyanColor];
    [self.view addSubview:text];
    text.bk_shouldBeginEditingBlock=^(UITextField *textField){
        NSLog(@"bk_shouldBeginEditingBlock");
        return YES;
    };
    text.bk_didBeginEditingBlock=^(UITextField *textField){
        NSLog(@"bk_didBeginEditingBlock");
    };
    text.bk_shouldEndEditingBlock=^(UITextField *textField){
        NSLog(@"bk_shouldEndEditingBlock");
        return YES;
    };
    text.bk_didEndEditingBlock=^(UITextField *textField){
        NSLog(@"bk_didEndEditingBlock");
    };
    text.bk_shouldChangeCharactersInRangeWithReplacementStringBlock=^(UITextField *textField, NSRange range, NSString *string){
        return YES;
    };
    text.bk_shouldClearBlock=^(UITextField *textField){
        return YES;
    };
    text.bk_shouldReturnBlock=^(UITextField *textField){
        return YES;
    };
    /*
    NSNotificationName const UITextFieldTextDidBeginEditingNotification
    NSNotificationName const UITextFieldTextDidEndEditingNotification
    NSNotificationName const UITextFieldTextDidChangeNotification
    typedef NS_ENUM(NSInteger, UITextBorderStyle) {}
    typedef NS_ENUM(NSInteger, UITextFieldViewMode) {}
    typedef NS_ENUM(NSInteger, UITextFieldDidEndEditingReason) {}
    
    @property(nullable, nonatomic,copy)   NSString *text;
    @property(nullable, nonatomic,strong) UIColor  *textColor;
    @property(nullable, nonatomic,strong) UIFont   *font;
    @property(nonatomic)BOOL                       adjustsFontSizeToFitWidth;
    @property(nonatomic)CGFloat                    minimumFontSize;
    @property(nonatomic)NSTextAlignment            textAlignment;
    @property(nonatomic)UITextBorderStyle          borderStyle;
    @property(nullable, nonatomic,strong) UIImage *background;
    @property(nullable, nonatomic,strong) UIImage *disabledBackground;
    
    @property(nonatomic)UITextFieldViewMode  clearButtonMode;
    @property(nullable, nonatomic,strong) UIView              *leftView;
    @property(nullable, nonatomic,strong) UIView              *rightView;
    @property(nonatomic)UITextFieldViewMode  leftViewMode;
    @property(nonatomic)UITextFieldViewMode  rightViewMode;
    @property (nullable, readwrite, strong) UIView *inputView;
    @property (nullable, readwrite, strong) UIView *inputAccessoryView;

    @property(nullable, nonatomic,copy)NSString               *placeholder;
    @property(nullable, nonatomic,copy)NSAttributedString     *attributedPlaceholder;
    @property(nullable, nonatomic,copy)NSAttributedString     *attributedText;
    @property(nonatomic,copy)NSDictionary<NSString *, id>           *defaultTextAttributes;
    @property(nullable, nonatomic,copy) NSDictionary<NSString *, id> *typingAttributes;
    @property(nonatomic) BOOL allowsEditingTextAttributes NS_AVAILABLE_IOS(6_0);
    @property(nonatomic,readonly,getter=isEditing) BOOL editing;
    @property(nonatomic) BOOL clearsOnBeginEditing;
    @property(nonatomic) BOOL clearsOnInsertion NS_AVAILABLE_IOS(6_0);
    
    // drawing and positioning overrides
    - (CGRect)borderRectForBounds:(CGRect)bounds;
    - (CGRect)editingRectForBounds:(CGRect)bounds;
    - (CGRect)clearButtonRectForBounds:(CGRect)bounds;
    - (CGRect)leftViewRectForBounds:(CGRect)bounds;
    - (CGRect)rightViewRectForBounds:(CGRect)bounds;

    - (CGRect)textRectForBounds:(CGRect)bounds;
    - (CGRect)placeholderRectForBounds:(CGRect)bounds;
    - (void)drawTextInRect:(CGRect)rect;
    - (void)drawPlaceholderInRect:(CGRect)rect;
     */
}
-(void)testControl{
//    UIButton、testTextField
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 100, 44, 44);
    button.backgroundColor=[UIColor redColor];
    [button setTitle:@"开始" forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button bk_addEventHandler:^(id sender) {
        
        NSLog(@"UIControl addEventHandler");
    } forControlEvents:UIControlEventTouchUpInside];
    BOOL flag=[button bk_hasEventHandlersForControlEvents:UIControlEventTouchUpInside];
    NSLog(@">>>%zd",flag);
}
-(void)testBarButtonItem{
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(self.view.frame.size.width-80, 22, 60, 40);
//    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc] initWithCustomView:button];
    
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc] bk_initWithTitle:@"完成" style:UIBarButtonItemStylePlain handler:^(id sender) {
        NSLog(@">>>testBarButtonItem");
    }];
    self.navigationItem.rightBarButtonItem = rightItem;
    
//    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@""] style:UIBarButtonItemStylePlain handler:^(id sender) {
//        
//    }];
//    self.navigationItem.leftBarButtonItem = leftItem;
}




#pragma mark -
//（1）、容器相关的BlocksKit
//不管是可变容器还是不可变容器，容器相关的BlocksKit代码总体上说是对容器原生block相关函数的封装。容器相关的BlocksKit函数更加接近自然语义，有一种函数式编程和语义编程的感觉。
-(void)test1{
    NSArray *arr=@[@"1",@"3",@"222",@"433"];
    NSString *str=[arr bk_match:^BOOL(id  _Nonnull obj) {
        return ((NSString *)obj).length == 1;
    }];
    NSArray *arr_01=[arr bk_select:^BOOL(id  _Nonnull obj) {
        return ((NSString *)obj).length == 1;
    }];
    NSArray *arr_02=[arr bk_reject:^BOOL(id  _Nonnull obj) {
        return ((NSString *)obj).length == 1;
    }];
    NSLog(@"str = %@",str);
    NSLog(@"arr_01 = %@",arr_01);
    NSLog(@"arr_02 = %@",arr_02);
}
//（2）、关联对象相关的BlocksKit
/*
关联对象的作用如下：
在类的定义之外为类增加额外的存储空间。使用关联，我们可以不用修改类的定义而为其对象增加存储空间。这在我们无法访问到类的源码的时候或者是考虑到二进制兼容性的时候是非常有用。关联是基于关键字的，因此，我们可以为任何对象增加任意多的关联，每个都使用不同的关键字即可。关联是可以保证被关联的对象在关联对象的整个生命周期都是可用的（ARC下也不会导致资源不可回收）。
关联对象的例子，在我们的实际项目中的常见用法一般有category中用关联对象定义property，或者使用关联对象绑定一个block。
关联对象相关的BlocksKit是对objc_setAssociatedObject、objc_getAssociatedObject、objc_removeAssociatedObjects这几个原生关联对象函数的封装。主要是封装其其内存管理语义。
 */
-(void)test2{
//    UITableViewCell *cell = [[UITableViewCell alloc] init];
//    [cell bk_associateValue:@"22岁" withKey:@"age"];
//    NSLog(@"age = %@", [cell bk_associatedValueForKey:@"age"]);
}
//（3）、逻辑执行相关的BlocksKit
//所谓逻辑执行，就是Block块执行。逻辑执行相关的BlocksKit是对dispatch_after函数的封装。使其更加符合语义。
-(void)test3{
    
}

//（4）、KVO相关BlocksKit
/*
 KVO主要涉及两类对象，即“被观察对象“和“观察者“。
 与“被观察对象”相关的函数主要有如下两个：

 通常的KVO做法是先对“被观察对象”添加“观察者”，同时在“观察者”中实现观察回调。这样每当“被观察对象”的指定property改变时，“观察者”就会调用观察回调。
 KVO相关BlocksKit弱化了“观察者”这种对象，使得每当“被观察对象”的指定property改变时，就会调起一个block。具体实现方式是定义一个_BKObserver类，让该类实现观察回调、对被观察对象添加观察者和删除观察者。
 */
-(void)test4{
    
}

// （5）、定时器相关BlocksKit
/*
 NSTimer有个比较恶心的特性，它会持有它的target。比如在一个controller中使用了timer，并且timer的target设置为该controller本身，那么想在controller的dealloc中fire掉timer是做不到的，必须要在其他的地方fire。这会让编码很难受。具体参考《Effective Objective C》的最后一条。 BlocksKit解除这种恶心，其方式是把timer的target设置为timer 的class对象。把要执行的block保存在timer的userInfo中执行。因为timer 的class对象一直存在，所以是否被持有其实无所谓。
 */
-(void)test5{
    
}

/*
 UIKit相关的Block
 拿UIControl打比方，要想处理一个事件:
 以前:
 - (void)addTarget:(nullable id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
 需要通过上述方法将某一个对象的某一个selector传入，一般的做法是在viewcontroller里定义一个方法专门处理某一个按钮的点击事件。
 
 现在:
 - (void)bk_addEventHandler:(void (^)(id sender))handler forControlEvents:(UIControlEvents)controlEvents;
 通过上述方法将一个block注册上去，不需要单独定义方法。
 */
@end
