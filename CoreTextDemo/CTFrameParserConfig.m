//
//  CTFrameParserConfig.m
//  CoreTextDemo
//
//  Created by 喻永权 on 2018/12/18.
//  Copyright © 2018年 喻永权. All rights reserved.
//

#import "CTFrameParserConfig.h"

@implementation CTFrameParserConfig

- (instancetype)init{
    if(self = [super init]){
        _width = 200.f;
        _fontSize = 16.f;
        _lineSpace = 5.f;
        _textColor = RGB(108, 108, 108);
    }
    return self;
}

@end
