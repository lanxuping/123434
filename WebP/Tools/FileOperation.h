//
//  FileOperation.h
//  WebP
//
//  Created by lanxuping on 2023/7/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
#define documentsPath  [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

@interface FileOperation : NSObject
/** 创建文件夹*/
+ (void)createFolder:(NSString *)folderName;
/** 修改document改文件名*/
+ (BOOL)renameFileNameoldName:(NSString *)oldName new:(NSString *)newName;
/** 通过指定路径修改子文件名*/
+ (BOOL)renameFileNameoldName:(NSString *)oldName new:(NSString *)newName originPath:(NSString *)originPath toPath:(NSString *)path;
/** 获取该路径下所有的文件*/
+ (NSArray*)allFilesAtPath:(NSString *)dirString;
+ (NSArray*)handleFoldersSortOutAndConvertWebpByPath:(NSString *)dirString;
/** 修改真实的文件类型*/
+ (void)changeDataRealType;
/** 将图片元数据保存到指定的emoji_static和emoji_animated目录*/
+ (void)saveImageDataToEmojiFolderWithAnyData:(NSData *)data originDataType:(NSString *)originDataType oldName:(NSString *)oldName newName:(NSString *)newName sourcePath:(NSString *)sourcePath;
@end

NS_ASSUME_NONNULL_END
