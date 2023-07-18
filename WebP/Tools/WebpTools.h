//
//  WebpTools.h
//  WebP
//
//  Created by lanxuping on 2023/7/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WebpTools : NSObject
/** PNG转WebP */
+ (NSData *)encodePNGToWebpWithPNGData:(NSData *)data;
/**webp 转 png */
+ (NSData *)encodeWebpToPNGWithWebpData:(NSData *)data;
/** JPG\JPEG转WebP */
+ (NSData *)encodeJPGToWebpWithJPGData:(NSData *)data;
/** WebP转JPG\JPEG */
+ (NSData *)encodeWebpToJPGWithJPGData:(NSData *)data;
/** gif 转 webp */
+ (NSData *)encodeGifToWebpWithGifData:(NSData *)data;
/** webp 转 Gif */
+ (NSData *)encodeWebpToGifWithWebpData:(NSData *)data;
/** 编码gif */
+ (NSData *)encodeGifData:(NSArray *)imgArr timeInterval:(NSTimeInterval)interval;
/** 读取帧图动画时间*/
+ (NSTimeInterval)readFrameDuration:(NSData *)data;
/** 获取image data 类型*/
+ (NSString *)checkDataImageType:(NSData *)data;

/** 将不明确的类型的图片数据根据真实类型转换为webp素材*/
+ (NSData *)convertAnyImageDataToWebpData:(NSData *)data;
@end

NS_ASSUME_NONNULL_END
