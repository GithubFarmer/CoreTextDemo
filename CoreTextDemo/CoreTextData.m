//
//  CoreTextData.m
//  CoreTextDemo
//
//  Created by 喻永权 on 2018/12/18.
//  Copyright © 2018年 喻永权. All rights reserved.
//

#import "CoreTextData.h"

@implementation CoreTextData

- (void)setCtframe:(CTFrameRef)ctframe{
    if(_ctframe != ctframe){
        if(_ctframe != nil){
            CFRelease(_ctframe);
        }
        CFRetain(ctframe);
        _ctframe = ctframe;
    }
}

- (void)setImageArray:(NSArray *)imageArray{
    _imageArray = imageArray;
    [self fillImagePosition];
}

- (void)fillImagePosition{
    if(self.imageArray.count == 0){
        return;
    }
    //获取所有的CTLine
    NSArray *lines = (NSArray *)CTFrameGetLines(self.ctframe);
    NSInteger lineCount = [lines count];
    //建立起点坐标数组
    CGPoint lineOrigins[lineCount];
    //获取起点
    CTFrameGetLineOrigins(self.ctframe, CFRangeMake(0, 0), lineOrigins);
    NSInteger imgIndex = 0;
    CoreTextImageData *imageData = self.imageArray[0];
    for(int i = 0; i < lineCount; i++){
        if(imageData == nil){
            break;
        }
        CTLineRef line = (__bridge CTLineRef)lines[i];
        NSArray *runObjArray = (NSArray *)CTLineGetGlyphRuns(line);
        for(id runObj in runObjArray){
            CTRunRef run = (__bridge CTRunRef)runObj;
            NSDictionary *runAttributes = (NSDictionary *)CTRunGetAttributes(run);
            CTRunDelegateRef delegate = (__bridge CTRunDelegateRef)[runAttributes valueForKey:(id)kCTRunDelegateAttributeName];
            if(delegate == nil){
                continue;
            }
            NSDictionary *metaDict = CTRunDelegateGetRefCon(delegate);
            if(![metaDict isKindOfClass:[NSDictionary class]]){
                continue;
            }
            CGRect runBounds;
            CGFloat ascent;
            CGFloat descent;
            runBounds.size.width = CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, NULL);
            runBounds.size.height = ascent + descent;
            
            CGFloat xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
            runBounds.origin.x = lineOrigins[i].x + xOffset;
            runBounds.origin.y = lineOrigins[i].y;
            runBounds.origin.y -= descent;
            
            CGPathRef pathRef = CTFrameGetPath(self.ctframe);
            CGRect colRect = CGPathGetBoundingBox(pathRef);
            
            CGRect delegateBounds = CGRectOffset(runBounds, colRect.origin.x, colRect.origin.y);
            imageData.imagePosition = delegateBounds;
            imgIndex++;
            if(imgIndex == self.imageArray.count){
                imageData = nil;
                break;
            }else{
                imageData = self.imageArray[imgIndex];
            }
        }
    }
}

- (void)dealloc{
    if(_ctframe != nil){
        CFRelease(_ctframe);
        _ctframe = nil;
    }
}

@end
