//
//  CTFrameParser.m
//  CoreTextDemo
//
//  Created by 喻永权 on 2018/12/18.
//  Copyright © 2018年 喻永权. All rights reserved.
//

#import "CTFrameParser.h"
#import <CoreText/CoreText.h>
static CGFloat ascentCallBack(void *ref){
    return [[(__bridge NSDictionary*)ref objectForKey:@"height"] floatValue];
}

static CGFloat descentCallBack(void *ref){
    return 0;
}

static CGFloat widthCallBack(void *ref){
    return [[(__bridge NSDictionary *)ref objectForKey:@"width"] floatValue];
}

@implementation CTFrameParser

+ (NSDictionary *)attributesWithConfig:(CTFrameParserConfig *)config{
    
    CGFloat fontSize = config.fontSize;
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", fontSize, NULL);
    CGFloat lineSpacing = config.lineSpace;
    const CFIndex kNumberOfSetting = 3;
    CTParagraphStyleSetting theSettings[kNumberOfSetting] = {
        {kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof(CGFloat), &lineSpacing},
        {kCTParagraphStyleSpecifierMinimumLineSpacing, sizeof(CGFloat), &lineSpacing},
        {kCTParagraphStyleSpecifierMaximumLineSpacing, sizeof(CGFloat), &lineSpacing}};
    CTParagraphStyleRef theParagraphRef = CTParagraphStyleCreate(theSettings, kNumberOfSetting);
    UIColor *textColor = config.textColor;
    
    NSMutableDictionary *dict = [NSMutableDictionary new];
    dict[(id)kCTForegroundColorAttributeName] = (id)textColor.CGColor;
    dict[(id)kCTFontAttributeName] = (__bridge id)fontRef;
    dict[(id)kCTParagraphStyleAttributeName] = (__bridge id)theParagraphRef;
    return dict;
}

+(CoreTextData *)parseContent:(NSString *)content config:(CTFrameParserConfig *)config{
    NSDictionary *attributes = [self attributesWithConfig:config];
    NSMutableAttributedString *contentString = [[NSMutableAttributedString alloc]initWithString:content attributes:attributes];
    
    //创建CTFramesetterRef实例
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)contentString);
    
    //获取要绘制的区域高度
    CGSize restrictSize = CGSizeMake(config.width, CGFLOAT_MAX);
    CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, restrictSize, nil);
    CGFloat textHeight = coreTextSize.height;
    
    //生成CTFrameRef实例
    CTFrameRef frame = [self createFrameWithFramesetter:framesetter config:config height:textHeight];
    
    //将生成好的CTFrameRef实例和计算好的绘制高度保存到coreTextData实例中，最后返回CoreTextData实例
    CoreTextData *data = [[CoreTextData alloc]init];
    data.ctframe = frame;
    data.height = textHeight;
    CFRelease(frame);
    CFRelease(framesetter);
    return data;
}

+ (CoreTextData *)parseAttrContent:(NSAttributedString *)content config:(CTFrameParserConfig *)config{
    
    //创建CTFramesetterRef实例
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)content);
    
    //获取要绘制的区域高度
    CGSize restrictSize = CGSizeMake(config.width, CGFLOAT_MAX);
    CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, restrictSize, nil);
    CGFloat textHeight = coreTextSize.height;
    
    //生成CTFrameRef实例
    CTFrameRef frame = [self createFrameWithFramesetter:framesetter config:config height:textHeight];
    
    //将生成好的CTFrameRef实例和计算好的绘制高度保存到coreTextData实例中，最后返回CoreTextData实例
    CoreTextData *data = [[CoreTextData alloc]init];
    data.ctframe = frame;
    data.height = textHeight;
    CFRelease(frame);
    CFRelease(framesetter);
    return data;
}

+ (CTFrameRef)createFrameWithFramesetter:(CTFramesetterRef)framesetter config:(CTFrameParserConfig *)config height:(CGFloat)height{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, config.width, height));
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    CFRelease(path);
    return frame;
}

+ (CoreTextData *)parseTemplateFile:(NSString *)path config:(CTFrameParserConfig *)config{
    NSMutableArray *imageArray = [NSMutableArray new];
    NSMutableAttributedString *content = [self loadTemplateFile:path config:config imageArray:imageArray];
    CoreTextData *data = [self parseAttrContent:content config:config];
    data.imageArray = imageArray;
    return data;
}

+ (NSMutableAttributedString *)loadTemplateFile:(NSString *)path config:(CTFrameParserConfig *)config imageArray:(NSMutableArray *)imageArray{
//    NSData *data = [NSData dataWithContentsOfFile:path options:NSDataReadingUncached error:nil];
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc]init];
//    if(data){
        //可变的字符串
//        NSJSONReadingMutableContainers
        //可变的容器，字典或者是数组嵌套
//        NSJSONReadingMutableLeaves
        //有效的json对象
//        NSJSONReadingAllowFragments
//        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
        if([array isKindOfClass:[NSArray class]]){
            for(NSDictionary *dict in array){
                NSString *type = dict[@"type"];
                if([type isEqualToString:@"txt"]){
                    NSMutableAttributedString *as = [self parseAttributedContentFromNSDictionary:dict config:config];
                    [result appendAttributedString:as];
                }else if ([type isEqualToString:@"img"]){
                    
                    CoreTextImageData *imageData = [[CoreTextImageData alloc]init];
                    imageData.name = dict[@"name"];
                    imageData.image = [UIImage imageNamed:imageData.name];
                    imageData.position = [result length];
                    [imageArray addObject:imageData];
                    //创建一个占位符
                    NSAttributedString *as = [self parseImageDataFromDict:dict config:config];
                    [result appendAttributedString:as];
                }
            }
        }
//    }
    return result;
}

+ (NSMutableAttributedString *)parseAttributedContentFromNSDictionary:(NSDictionary *)dict config:(CTFrameParserConfig *)config{
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc]initWithDictionary:[self attributesWithConfig:config]];
    //设置颜色
    UIColor *color = [self colorFromTemplate:dict[@"color"]];
    if(color){
        attributes[(id)kCTForegroundColorAttributeName] = (id)color.CGColor;
    }
    //设置字体大小
    CGFloat fontSize = [dict[@"size"] floatValue];
    if(fontSize > 0){
        CTFontRef fontRef  = CTFontCreateWithName((CFStringRef)@"ArialMT", fontSize, NULL);
        attributes[(id)kCTFontAttributeName] = (__bridge id)fontRef;
        CFRelease(fontRef);
    }
    NSString *content = dict[@"content"];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:content attributes:attributes];
    return attr;
}


+ (UIColor *)colorFromTemplate:(NSString *)name{
    if([name isEqualToString:@"blue"]){
        return [UIColor blueColor];
    }else if ([name isEqualToString:@"red"]){
        return [UIColor redColor];
    }else{
        return [UIColor blackColor];
    }
}


+ (NSAttributedString *)parseImageDataFromDict:(NSDictionary *)dict config:(CTFrameParserConfig *)config{
    
    CTRunDelegateCallbacks callbacks;
    memset(&callbacks, 0, sizeof(CTRunDelegateCallbacks));
    callbacks.version = kCTRunDelegateVersion1;
    callbacks.getAscent = ascentCallBack;
    callbacks.getDescent = descentCallBack;
    callbacks.getWidth = widthCallBack;
    CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, (__bridge void*)(dict));
    
    //使用0xFFFC创建占位符
    unichar objectReplacementChar = 0xFFFC;
    NSString *content = [NSString stringWithCharacters:&objectReplacementChar length:1];
    NSDictionary *attrbutes = [self attributesWithConfig:config];
    NSMutableAttributedString *space = [[NSMutableAttributedString alloc]initWithString:content attributes:attrbutes];
    CFAttributedStringSetAttribute((CFMutableAttributedStringRef)space, CFRangeMake(0, 1), kCTRunDelegateAttributeName, delegate);
    CFRelease(delegate);
    return space;
}

@end
