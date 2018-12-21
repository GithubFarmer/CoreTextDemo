//
//  CoreTextImageData.h
//  CoreTextDemo
//
//  Created by 喻永权 on 2018/12/19.
//  Copyright © 2018年 喻永权. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CoreTextImageData : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger position;

@property (nonatomic, assign) CGRect imagePosition;

@property (nonatomic, strong) UIImage *image;

@end
