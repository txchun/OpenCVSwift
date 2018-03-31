//
//  OpenCV.h
//  OpenCV
//
//  Created by 田小椿 on 2018/3/30.
//  Copyright © 2018年 com.openCV.mirror. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface OpenCV : NSObject
+ (nonnull UIImage *)cvtColorBGR2GRAY:(nonnull UIImage *)image;
+ (nonnull UIImage *)cvtColorBGR2Mult:(nonnull UIImage *)image;
@end
