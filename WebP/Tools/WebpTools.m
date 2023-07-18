//
//  WebpTools.m
//  WebP
//
//  Created by lanxuping on 2023/7/17.
//

#import "WebpTools.h"
#import <YYImage/YYImage.h>
#import <YYWebImage/YYWebImage.h>
#import "YYImageExampleHelper.h"
@implementation WebpTools
/** PNG转WebP */
+ (NSData *)encodePNGToWebpWithPNGData:(NSData *)data {
    YYImageEncoder *encoder = [[YYImageEncoder alloc] initWithType:YYImageTypeWebP];
    [encoder addImageWithData:data duration:0.0];
    return [encoder encode];
}
/**webp 转 png */
+ (NSData *)encodeWebpToPNGWithWebpData:(NSData *)data {
    YYImageEncoder *encoder = [[YYImageEncoder alloc] initWithType:YYImageTypePNG];
    [encoder addImageWithData:data duration:0.0];
    return [encoder encode];
}
/** JPG\JPEG转WebP */
+ (NSData *)encodeJPGToWebpWithJPGData:(NSData *)data {
    YYImageEncoder *encoder = [[YYImageEncoder alloc] initWithType:YYImageTypeWebP];
    [encoder addImageWithData:data duration:0.0];
    return [encoder encode];
}
/** WebP转JPG\JPEG */
+ (NSData *)encodeWebpToJPGWithJPGData:(NSData *)data {
    YYImageEncoder *encoder = [[YYImageEncoder alloc] initWithType:YYImageTypeJPEG];
    [encoder addImageWithData:data duration:0.0];
    return [encoder encode];
}
/** gif 转 webp */
+ (NSData *)encodeGifToWebpWithGifData:(NSData *)data {
    YYImageDecoder *decoder = [YYImageDecoder decoderWithData:data scale:[UIScreen mainScreen].scale];
    NSTimeInterval interval = [decoder frameDurationAtIndex:0];
    
    NSMutableArray *mutArr = [NSMutableArray array];
    for (int i = 0; i < decoder.frameCount; i++) {
        if (i > 15) {
            break;
        }
        UIImage *image = [decoder frameAtIndex:i decodeForDisplay:NO].image;
        [mutArr addObject:image];
    }
    YYImageEncoder *encoder = [[YYImageEncoder alloc] initWithType:YYImageTypeWebP];
    for (int i= 0; i< mutArr.count; i ++) {
        [encoder addImage:mutArr[i] duration:interval];
    }
    return [encoder encode];
}
/** webp 转 Gif */
+ (NSData *)encodeWebpToGifWithWebpData:(NSData *)data {
    YYImageDecoder *decoder = [YYImageDecoder decoderWithData:data scale:[UIScreen mainScreen].scale];
    NSTimeInterval interval = [decoder frameDurationAtIndex:0];//每一帧持续时间
    
    NSMutableArray *mutArr = [NSMutableArray array];
    for (int i = 0; i < decoder.frameCount; i++) {
        UIImage *image = [decoder frameAtIndex:i decodeForDisplay:NO].image;
        [mutArr addObject:image];
    }
    NSData *gifData = [self encodeGifData:mutArr timeInterval:interval];
    return gifData;
}
/** 编码gif */
+ (NSData *)encodeGifData:(NSArray *)imgArr timeInterval:(NSTimeInterval)interval {
    YYImageEncoder *encoder = [[YYImageEncoder alloc] initWithType:YYImageTypeGIF];
    for (int i= 0; i< imgArr.count; i ++) {
        [encoder addImage:imgArr[i] duration:interval];
    }
    return [encoder encode];
}
/** 读取帧图动画时间*/
+ (NSTimeInterval)readFrameDuration:(NSData *)data {
    YYImageDecoder *decoder = [YYImageDecoder decoderWithData:data scale:[UIScreen mainScreen].scale];
    NSTimeInterval interval = [decoder frameDurationAtIndex:0];
    return interval;
}
/** 获取image data 类型*/
+ (NSString *)checkDataImageType:(NSData *)data {
    YYImageType type = [self checkAnyImageDataType:data];
    return [self checkType:type];
}
+ (YYImageType)checkAnyImageDataType:(NSData *)data {
    return YYImageDetectType((__bridge CFDataRef)data);
}
+ (NSString *)checkType:(YYImageType)type {
    NSString *typeStr = @"";
    switch (type) {
        case YYImageTypeUnknown:
            typeStr = @"unknow";
            break;
        case YYImageTypeJPEG:
            typeStr = @"jpeg";
            break;
        case YYImageTypeJPEG2000:
            typeStr = @"jp2";
            break;
        case YYImageTypeTIFF:
            typeStr = @"tiff";
            break;
        case YYImageTypeBMP:
            typeStr = @"bmp";
            break;
        case YYImageTypeICO:
            typeStr = @"ico";
            break;
        case YYImageTypeICNS:
            typeStr = @"icns";
            break;
        case YYImageTypeGIF:
            typeStr = @"gif";
            break;
        case YYImageTypePNG:
            typeStr = @"png";
            break;
        case YYImageTypeWebP:
            typeStr = @"webp";
            break;
        case YYImageTypeOther:
            typeStr = @"otherimageformat";
            break;
        default:
            break;
    }
    return typeStr;
}

+ (NSData *)convertAnyImageDataToWebpData:(NSData *)data {
    //check real type
    YYImageType type = [self checkAnyImageDataType:data];
    //根据type类型将图片数据进行转换为webp
    NSData *anyData;
    switch (type) {
        case YYImageTypeJPEG:
            anyData = [self encodeJPGToWebpWithJPGData:data];
            break;
        case YYImageTypePNG:
            anyData = [self encodeWebpToPNGWithWebpData:data];
            break;
        case YYImageTypeGIF:
            anyData = [self encodeGifToWebpWithGifData:data];
            break;
        case YYImageTypeWebP:
            anyData = data;
            break;
        default:
            break;
    }
    return anyData;
}
@end
