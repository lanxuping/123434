//
//  ViewController.m
//  WebP
//
//  Created by lanxuping on 2023/7/14.
//

#import "ViewController.h"
#import <YYImage/YYImage.h>
#import <YYWebImage/YYWebImage.h>
#import "YYImageExampleHelper.h"
#import "WebpTools.h"
#import "FileOperation.h"

@interface ViewController ()<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet YYAnimatedImageView *imageView;
@property (weak, nonatomic) IBOutlet YYAnimatedImageView *imageView2;
@property (weak, nonatomic) IBOutlet YYAnimatedImageView *imView1;
@property (weak, nonatomic) IBOutlet YYAnimatedImageView *imView2;
@property (weak, nonatomic) IBOutlet YYAnimatedImageView *imView3;
@property (weak, nonatomic) IBOutlet YYAnimatedImageView *imView4;
@property (weak, nonatomic) IBOutlet YYAnimatedImageView *imView5;
@property (weak, nonatomic) IBOutlet YYAnimatedImageView *imView6;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",documentsPath);
    
//    [FileOperation handleFoldersSortOutAndConvertWebpByPath:documentsPath];
    
//    [FileOperation changeDataRealType];
    
    [self readLocalPng]; //local png
    [self readConvertJPGToWebp];
    [self readLocalWebp]; //local webp
    [self readConvertPngToWebpImage];//png 转 webp
    [self readConvertWebpToGifImage];//webp 转 gif
    [self loadNetworkWebp];//network webp
    [self readLocalGif];//local gif
    [self readConvertWebpToPngImage];//webp 转 png
    [self readConvertGitToWebpImage];//git 转 webp
    
    [self addGesture:self.imageView];
    [self addGesture:self.imageView2];//添加手势
    [self addGesture:self.imView1];
    [self addGesture:self.imView2];
    [self addGesture:self.imView3];
    [self addGesture:self.imView4];
    [self addGesture:self.imView5];
    [self addGesture:self.imView6];
}

- (void)readConvertPngToWebpImage {
    NSData *pngData = UIImagePNGRepresentation([UIImage imageNamed:@"piapng"]);
    NSLog(@"png to webp : origin type is ==> %@",[WebpTools checkDataImageType:pngData]);

    NSData *webpData = [WebpTools encodePNGToWebpWithPNGData:pngData];
    NSLog(@"png to webp : convert type is ==> %@",[WebpTools checkDataImageType:webpData]);

//    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/pngtowebp.webp"];
//    [webpData writeToFile:filePath atomically:YES];
    self.imView1.image = [YYImage imageWithData:webpData];
}
- (void)readConvertWebpToGifImage {
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"image_9_1689317189" ofType:@"webp"];
    NSData *webpData = [NSData dataWithContentsOfFile:imagePath];
    NSLog(@"webp to gif : origin type is ==> %@",[WebpTools checkDataImageType:webpData]);
    
    NSData *gifData = [WebpTools encodeWebpToGifWithWebpData:webpData];
    NSLog(@"webp to gif : convert type is ==> %@",[WebpTools checkDataImageType:gifData]);
    
//    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/webptogif.gif"];
//    [gifData writeToFile:filePath atomically:YES];
    self.imView2.image = [YYImage imageWithData:gifData];
}
- (void)readConvertWebpToPngImage {
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"webpbear" ofType:@"webp"];
    NSData *webpData = [NSData dataWithContentsOfFile:imagePath];
    NSLog(@"webp to png : origin type is ==> %@",[WebpTools checkDataImageType:webpData]);

    NSData *pngData = [WebpTools encodeWebpToPNGWithWebpData:webpData];
    NSLog(@"webp to png : convert type is ==> %@",[WebpTools checkDataImageType:pngData]);
    
//    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/webptopng.png"];
//    [pngData writeToFile:filePath atomically:YES];
    self.imView5.image = [YYImage imageWithData:pngData];
}
- (void)readConvertGitToWebpImage {
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"gifimage" ofType:@"gif"];
    NSData *gifData = [NSData dataWithContentsOfFile:imagePath];
    NSLog(@"gif to webp : origin type is ==> %@",[WebpTools checkDataImageType:gifData]);

    NSData *webpData = [WebpTools encodeGifToWebpWithGifData:gifData];
    NSLog(@"gif to webp : convert type is ==> %@",[WebpTools checkDataImageType:webpData]);

    NSTimeInterval interval = [WebpTools readFrameDuration:webpData];
    
    
//    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/giftowebp.webp"];
//    [webpData writeToFile:filePath atomically:YES];
    self.imView6.image = [YYImage imageWithData:webpData];
}
- (void)readConvertJPGToWebp {
    YYImage *ig = [YYImage imageNamed:@"dog"] ;
    NSData *data = UIImageJPEGRepresentation(ig, 0.9);
    NSLog(@"jpg to webp : origin type is ==> %@",[WebpTools checkDataImageType:data]);
    
    NSData *webpData = [WebpTools encodeJPGToWebpWithJPGData:data];
    NSLog(@"jpg to webp : convert type is ==> %@",[WebpTools checkDataImageType:webpData]);
    
//    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/jpgtowebp.webp"];
//    [webpData writeToFile:filePath atomically:YES];
    self.imageView.image = [YYImage imageWithData:webpData];
}
- (IBAction)deleteCache:(UIButton *)sender {
    YYImageCache *cache = [YYWebImageManager sharedManager].cache;
    [cache.memoryCache removeAllObjects];
    [cache.diskCache removeAllObjects];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}
- (void)readLocalPng {
    self.imageView.image = [YYImage imageNamed:@"piapng"];
}
- (void)readLocalWebp {
    self.imageView2.image = [YYImage imageNamed:@"wallwebp"];
}
- (void)readLocalGif {
    self.imView4.image = [YYImage imageNamed:@"gifimage"];
}
- (void)loadNetworkWebp {
    //webp : http://littlesvr.ca/apng/gif_apng_webp.html
//    static NSString *webpUrl = @"http://littlesvr.ca/apng/images/SteamEngine.webp";
    static NSString *gifUrl = @"http://littlesvr.ca/apng/images/GenevaDrive.gif";
    [self.imView3 yy_setHighlightedImageWithURL:[NSURL URLWithString:gifUrl] placeholder:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        CGFloat progress = (float)receivedSize / expectedSize;
        NSLog(@"%lf",progress);
    } transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
//        image = [image yy_imageByResizeToSize:CGSizeMake(image.size.width, image.size.height) contentMode:UIViewContentModeCenter];
//        return [image yy_imageByRoundCornerRadius:10];
        return image;
    } completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        if (error) {
            NSLog(@"failed -> %@",error);
        } else {
            NSLog(@"success load image!image size:%f,%f",image.size.width, image.size.height);
            if (from == YYWebImageFromDiskCache) {NSLog(@"load from disk cache");}
            NSLog(@"%@",image);
            self.imView3.image = image;
        }
    }];
}
- (void)addGesture:(YYAnimatedImageView *)imageView {
    [YYImageExampleHelper addTapControlToAnimatedImageView:imageView];
    [YYImageExampleHelper addPanControlToAnimatedImageView:imageView];
    for (UIGestureRecognizer *g in self.imageView2.gestureRecognizers) {
        g.delegate = self;
    }
}
@end
