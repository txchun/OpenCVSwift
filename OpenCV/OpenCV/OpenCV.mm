//
//  OpenCV.m
//  OpenCV
//
//  Created by 田小椿 on 2018/3/30.
//  Copyright © 2018年 com.openCV.mirror. All rights reserved.
//
#import <vector>
#import <opencv2/opencv.hpp>
#import <opencv2/imgproc.hpp>
#import "OpenCV.h"

static void UIImageToMat(UIImage *image, cv::Mat &mat) {
    // Create a pixel buffer.
    NSInteger width = CGImageGetWidth(image.CGImage);
    NSInteger height = CGImageGetHeight(image.CGImage);
    CGImageRef imageRef = image.CGImage;
    cv::Mat mat8uc4 = cv::Mat((int)height, (int)width, CV_8UC4);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef contextRef = CGBitmapContextCreate(mat8uc4.data, mat8uc4.cols, mat8uc4.rows, 8, mat8uc4.step, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrderDefault);
    CGContextDrawImage(contextRef, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpace);
    
    // Draw all pixels to the buffer.
    cv::Mat mat8uc3 = cv::Mat((int)width, (int)height, CV_8UC3);
    cv::cvtColor(mat8uc4, mat8uc3, CV_RGBA2BGR);
    
    mat = mat8uc3;
}


@implementation OpenCV
//在OpenCV中，所有的图像处理操作通常在Mat结构上进行。然而，在iOS中，为了在屏幕上呈现图像，它必须是UIImage类的一个实例。要将转换的OpenCV垫成的UIImage我们使用的核芯显卡在iOS中使用框架。以下是Mat和UIImage之间来回隐藏的代码。
//MARK
-(cv:: Mat)cvMatFromUIImage:(UIImage *)image{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    // cv::Mat mat8uc4 = cv::Mat((int)height, (int)width, CV_8UC4);
    cv::Mat cvMat(rows, cols, CV_8UC4);
    CGContextRef contextRef = CGBitmapContextCreate( cvMat.data, cols, rows, 8, cvMat.step[0], colorSpace ,kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault);
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    return cvMat;
}

//MARK:
-(cv::Mat)cvMatGrayFromUIImage:(UIImage *)image{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    cv::Mat cvMat(rows, cols, CV_8UC1);
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data, cols, rows, 8, cvMat.step[0],colorSpace, kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault);
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    return cvMat;
}

//处理后，我们需要将其转换回UIImage。下面的代码可以处理灰度和彩色图像转换（由if语句中的通道数决定）。

-(UIImage *)UIImageFromCVMat:(cv::Mat)cvMat{
    NSData *data = [NSData dataWithBytes: cvMat.data length: cvMat.elemSize()*cvMat.total()];
    CGColorSpaceRef colorSpace;
    if (cvMat.elemSize() == 1) {
         colorSpace = CGColorSpaceCreateDeviceGray();
    }else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    CGImageRef imageRef = CGImageCreate(cvMat.cols, cvMat.rows,8, 8 * cvMat.elemSize(), cvMat.step[0], colorSpace,  kCGImageAlphaNone|kCGBitmapByteOrderDefault, provider, NULL, false, kCGRenderingIntentDefault);
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    return finalImage;
}

@end
