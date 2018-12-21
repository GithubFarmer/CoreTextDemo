//
//  UIView+extend.h
//  CoreTextDemo
//
//  Created by 喻永权 on 2018/12/18.
//  Copyright © 2018年 喻永权. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (extend)

//起点坐标x
- (CGFloat)x;
- (void)setX:(CGFloat)x;

//起点坐标y
- (CGFloat)y;
- (void)setY:(CGFloat)y;

//高度
- (CGFloat)height;
- (void)setHeight:(CGFloat)height;

//宽度
- (CGFloat)width;
- (void)setWidth:(CGFloat)width;

@end
