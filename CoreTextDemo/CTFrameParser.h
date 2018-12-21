//
//  CTFrameParser.h
//  CoreTextDemo
//
//  Created by 喻永权 on 2018/12/18.
//  Copyright © 2018年 喻永权. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreTextData.h"
#import "CTFrameParserConfig.h"
#import "CoreTextImageData.h"



//排版类
@interface CTFrameParser : NSObject

+ (CoreTextData *)parseContent:(NSString *)content config:(CTFrameParserConfig *)config;

+ (CoreTextData *)parseAttrContent:(NSAttributedString *)content config:(CTFrameParserConfig *)config;

+ (NSDictionary *)attributesWithConfig:(CTFrameParserConfig *)config;

+ (CoreTextData *)parseTemplateFile:(NSString *)path config:(CTFrameParserConfig *)config;

@end
