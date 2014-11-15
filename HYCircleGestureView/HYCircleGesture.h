//
//  HYCircleGesture.h
//  HYCircleGestureView
//
//  Created by nathan on 14/11/13.
//  Copyright (c) 2014年 nathan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HYCircleGesture : UIGestureRecognizer
@property (nonatomic,strong) CAShapeLayer *strokeLayer;
@property (nonatomic,strong) UIColor *strokeColor;
@property (nonatomic,assign) CGFloat duration;
@property (nonatomic,assign) CGFloat strokeWidth;
@property (nonatomic,assign) BOOL    isAnimation;

@end
