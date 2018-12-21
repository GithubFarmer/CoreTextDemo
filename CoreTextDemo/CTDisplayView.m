//
//  CTDisplayView.m
//  CoreTextDemo
//
//  Created by 喻永权 on 2018/12/19.
//  Copyright © 2018年 喻永权. All rights reserved.
//

#import "CTDisplayView.h"

@implementation CTDisplayView

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(contextRef, CGAffineTransformIdentity);
    CGContextTranslateCTM(contextRef, 0, self.bounds.size.height);
    CGContextScaleCTM(contextRef, 1.0, -1.0);
    
    if(self.data){
        //绘制文字
        CTFrameDraw(self.data.ctframe, contextRef);
        //绘制图片
        for(CoreTextImageData *image in self.data.imageArray){
//            UIImage *imageInfo = [UIImage imageNamed:image.name];
            CGContextDrawImage(contextRef, image.imagePosition,image.image.CGImage);
        }
    }
    
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        [self setUpEvents];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setUpEvents];
    }
    return self;
}

- (void)setUpEvents{
    UIGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userTapGestureDetected:)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    self.userInteractionEnabled = YES;
}

//- (void)tapClick:(UITapGestureRecognizer *)tap{
//
//}

- (void)userTapGestureDetected:(UITapGestureRecognizer *)recognize{
    CGPoint point = [recognize locationInView:self];
    NSLog(@"%@",NSStringFromCGPoint(point));
    for(CoreTextImageData *imageData in self.data.imageArray){
        CGRect imageRect = imageData.imagePosition;
        CGPoint imagePosition = imageRect.origin;
        imagePosition.y = self.bounds.size.height - imageRect.origin.y - imageRect.size.height;
        CGRect rect = CGRectMake(imagePosition.x, imagePosition.y, imageRect.size.width, imageRect.size.height);
        if(CGRectContainsPoint(rect, point)){
            NSLog(@"========点击了图片");
        }
    }
    
}


@end
