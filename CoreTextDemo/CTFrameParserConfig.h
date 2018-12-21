//
//  CTFrameParserConfig.h
//  CoreTextDemo
//
//  Created by 喻永权 on 2018/12/18.
//  Copyright © 2018年 喻永权. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CTHeader.h"

//基础配置类
@interface CTFrameParserConfig : NSObject

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) CGFloat fontSize;

@property (nonatomic, assign) CGFloat lineSpace;

@property (nonatomic, strong) UIColor *textColor;

@end
