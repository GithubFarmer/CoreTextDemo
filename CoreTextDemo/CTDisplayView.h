//
//  CTDisplayView.h
//  CoreTextDemo
//
//  Created by 喻永权 on 2018/12/19.
//  Copyright © 2018年 喻永权. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreTextData.h"

@interface CTDisplayView : UIView <UIGestureRecognizerDelegate>

@property (nonatomic, strong) CoreTextData *data;

@end
