//
//  FileOperation.m
//  WebP
//
//  Created by lanxuping on 2023/7/17.
//

#import "FileOperation.h"
#import "WebpTools.h"
@implementation FileOperation
+ (void)createFolder:(NSString *)folderName {
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:folderName];

    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
        if (error) {
            NSLog(@"failed createFolder : %@",error);
        }
    } else {
//        NSLog(@"已经创建了 %@ ",folderName);
    }
}
+ (void)createFolderWithPath:(NSString *)path {
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:&error];
        if (error) {
            NSLog(@"failed createFolder : %@",error);
        }
    } else {
//        NSLog(@"已经创建了 %@ ",folderName);
    }
}
+ (BOOL)renameFileNameoldName:(NSString *)oldName new:(NSString *)newName {
    return [self renameFileNameoldName:oldName new:newName originPath:documentsPath toPath:documentsPath];
}
+ (BOOL)renameFileNameoldName:(NSString *)oldName new:(NSString *)newName originPath:(NSString *)originPath toPath:(NSString *)path{
    //通过移动该文件对文件重命名
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *filePath = [originPath stringByAppendingPathComponent:oldName];
    NSString *moveToPath = [path stringByAppendingPathComponent:newName];
    
    BOOL isSuccess = [fileManager moveItemAtPath:filePath toPath:moveToPath error:nil];
    return isSuccess;
}


+ (NSArray*)handleFoldersSortOutAndConvertWebpByPath:(NSString *)dirString {
    NSMutableArray *fileArray = [NSMutableArray array];
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    //读取文件夹中的所有文件
    NSArray* tempArray = [fileMgr contentsOfDirectoryAtPath:dirString error:nil];
    
    for (NSString *fileName in tempArray) {
        //文件夹遍历过程中不遍历DS_Store文件和Emoji（static animated）文件
        if([fileName hasSuffix:@"DS_Store"] || [fileName hasPrefix:@"emoji_"]) {
            continue;
        }
        NSLog(@"filename--> %@",fileName);
        
        //判断是否是子文件夹，如果是继续往深遍历
        if (![fileName containsString:@"."]) {
            NSString *p = [dirString stringByAppendingPathComponent:fileName];
            NSArray *a = [self handleFoldersSortOutAndConvertWebpByPath:p];
            NSLog(@"need change Array----> %@",a);
            continue;
        }
        
        //遍历到文件中存在图片数据，则创建emoji_static和emoji_animated文件夹
        [self createFolderWithPath:[dirString stringByAppendingPathComponent:@"emoji_static"]];
        [self createFolderWithPath:[dirString stringByAppendingPathComponent:@"emoji_animated"]];
        
        //将image图片进行图片格式转换
        NSFileHandle* filehandle = [NSFileHandle fileHandleForReadingAtPath:[dirString stringByAppendingPathComponent:fileName]];
        NSData *data = [filehandle readDataToEndOfFile];
        //原始数据的真实type
        NSString *oldDataType = [WebpTools checkDataImageType:data];
        
        NSData *webpData = [WebpTools convertAnyImageDataToWebpData:data];
        if (!webpData) {
            continue;
        }
        //获取文件名数组e:[name ，type]
        NSArray *fileComponentsArr = [fileName componentsSeparatedByString:@"."];

        NSString *newName = [fileComponentsArr.firstObject stringByAppendingString:@".webp"];
        
        //保存数据到对应文件夹
        [self saveImageDataToEmojiFolderWithAnyData:webpData originDataType:oldDataType oldName:fileName newName:newName sourcePath:dirString];
        [fileArray addObject:fileName];
    }
    return fileArray;
}

/** 将图片元数据保存到指定的emoji_static和emoji_animated目录*/
+ (void)saveImageDataToEmojiFolderWithAnyData:(NSData *)data originDataType:(NSString *)originDataType oldName:(NSString *)oldName newName:(NSString *)newName sourcePath:(NSString *)sourcePath {
    //判断是否是动静态图片
    BOOL animted = [WebpTools readFrameDuration:data] > 0 ? YES : NO;
    NSString *type = [oldName componentsSeparatedByString:@"."].lastObject;
    NSLog(@"\n   原名称:[%@]\n   转换类型:[   %@(real data type:%@)->%@   %@   ]\n   新名称:[%@]",oldName,type,originDataType,[WebpTools checkDataImageType:data],animted?@"animated":@"static",newName);
    //获取要存放的路径
    NSString *movePath = animted ? [sourcePath stringByAppendingPathComponent:@"emoji_animated"] : [sourcePath stringByAppendingPathComponent:@"emoji_static"];
    //转移文件
    [self renameFileNameoldName:oldName new:newName originPath:sourcePath toPath:movePath];

}

+ (NSArray*)allFilesAtPath:(NSString *)dirString {
    NSMutableArray *array = [NSMutableArray array];
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSArray* tempArray = [fileMgr contentsOfDirectoryAtPath:dirString error:nil];
    for (NSString* fileName in tempArray) {
        if([fileName hasSuffix:@"DS_Store"] || [fileName hasPrefix:@"emoji_"]) {
            continue;
        }
        NSLog(@"allFilesAtPath %@",fileName);
        
        if (![fileName containsString:@"."]) {
            NSString *p = [dirString stringByAppendingPathComponent:fileName];
            NSArray *a = [self allFilesAtPath:p];
            NSLog(@"allFilesAtPath ---- %@",a);
            continue;
        }
        [array addObject:fileName];
    }
    return array;
}
+ (void)changeDataRealType {
    NSArray *g = [self allFilesAtPath:documentsPath];
    for (int i = 0; i < g.count; i ++) {
        NSFileHandle* fh = [NSFileHandle fileHandleForReadingAtPath:[documentsPath stringByAppendingPathComponent:g[i]]];
        NSData *data = [fh readDataToEndOfFile];
        NSString *type = [WebpTools checkDataImageType:data];
        NSArray *fileComponentsArr = [g[i] componentsSeparatedByString:@"."];
        NSTimeInterval time = [WebpTools readFrameDuration:data];
        NSString *newName = [NSString stringWithFormat:@"%d_%@.%@",i,fileComponentsArr.firstObject,type];
        if ([self renameFileNameoldName:g[i] new:newName]) {
            NSLog(@"\n   原名称:[%@]\n   应类型:[%@]\n   timeInterval:[%f]\n   新名称:[%@]",g[i],type,time,newName);
        } else {
            NSLog(@"\n ------------------failed-------------------\n   原名称:[%@]\n   应类型:[%@]\n",g[i],type);
        }
    }
}
@end
