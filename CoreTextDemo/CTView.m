//
//  CTView.m
//  CoreTextDemo
//
//  Created by 喻永权 on 2018/12/17.
//  Copyright © 2018年 喻永权. All rights reserved.
//

#import "CTView.h"
#import <CoreText/CoreText.h>

@implementation CTView

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //反转坐标系
    //在底层绘制的时候，左下角是（0，0）坐标；而对于上层的UIKit来说，左上角是（0，0）坐标。
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.bounds);
    
    NSMutableAttributedString *attstrings = [[NSMutableAttributedString alloc]initWithString:@"Hello World!噶空间放辣椒库房拉克己复礼；阿艰苦奋斗看了感觉那就卡六块腹肌放假啊了放假啊了；‘放假啊了给家里寄过来啊感觉啊了；感觉啊感觉就感觉啊了感觉啊了感觉啊了感觉老大古拉就够了；’啊感觉啦就跟阿胶糕阿胶糕家集啊放辣椒啊感觉啊；了放假啊啊放假快关机啦"];
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attstrings);
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, [attstrings length]), path, NULL);
    
    CTFrameDraw(frame, context);
    CFRelease(frame);
    CFRelease(path);
    CFRelease(frameSetter);
}


@end
