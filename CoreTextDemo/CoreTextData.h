//
//  CoreTextData.h
//  CoreTextDemo
//
//  Created by 喻永权 on 2018/12/18.
//  Copyright © 2018年 喻永权. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import "CoreTextImageData.h"

@interface CoreTextData : NSObject

@property (nonatomic, assign) CTFrameRef ctframe;

@property (nonatomic, assign) CGFloat height;

//对图片处理，新增的属性
@property (nonatomic, strong) NSArray *imageArray;

@end
