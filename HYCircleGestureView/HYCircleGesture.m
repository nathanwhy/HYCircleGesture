//
//  HYCircleGesture.m
//  HYCircleGestureView
//
//  Created by nathan on 14/11/13.
//  Copyright (c) 2014年 nathan. All rights reserved.
//

#import "HYCircleGesture.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

#define DEGREES_TO_RADIANS(x) (M_PI * (x) / 180.0)
@interface HYCircleGesture ()
{
    NSInteger level;
    CGPoint   oldPoint;
    CGPoint   newPoint;
    CGPoint   beginPoint;
    
    CGPoint   mostLeftPoint;
    CGPoint   mostRightPoint;
    BOOL      clockwise;
}
@end

typedef enum direction {
    direction_Xup_Yup = 0,
    direction_Xup_Ydown,
    direction_Xdown_Yup,
    direction_Xdown_Ydown,
}direction;

@implementation HYCircleGesture

- (direction ) direction {
    if (newPoint.y > oldPoint.y) {
        return newPoint.x > oldPoint.x? 0: 2;
    }else{
        return newPoint.x > oldPoint.x? 1: 3;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    beginPoint     = [touch locationInView:self.view];
    
    level = 0;
    newPoint       = beginPoint;
    mostLeftPoint  = beginPoint;
    mostRightPoint = beginPoint;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    oldPoint = newPoint;
    newPoint = [touch locationInView:self.view];
    
    if (newPoint.y > oldPoint.y) {
        if (level == 0) {
            clockwise = newPoint.x > oldPoint.x;
            level = 1;
        }
    }
    
    if (mostRightPoint.x < newPoint.x) {
        mostRightPoint   = newPoint;
    }
    if (mostLeftPoint.x > newPoint.x) {
        mostLeftPoint   = newPoint;
    }
    
    if (clockwise) {
        if (level==1 && [self direction] == direction_Xdown_Yup) {
            level = 2;
        }
        if (level==2 && [self direction] == direction_Xdown_Ydown) {
            level = 3;
        }
        if (level==3 && [self direction] == direction_Xup_Ydown) {
            level = 4;
        }
    }else {
        if (level==1 && [self direction] == direction_Xup_Yup) {
            level = 2;
        }
        if (level==2 && [self direction] == direction_Xup_Ydown) {
            level = 3;
        }
        if (level==3 && [self direction] == direction_Xdown_Ydown) {
            level = 4;
        }
    }
    
    if (level==4 && ABS(newPoint.x-beginPoint.x)<30 && ABS(newPoint.y-beginPoint.y)<30) {
        level = 0;
        if ([self state] == UIGestureRecognizerStatePossible) {
            [self setState:UIGestureRecognizerStateBegan];
            [self setState:UIGestureRecognizerStateEnded];
        }
        if (self.isAnimation) {
            [self setupLayer];
            [self startCircleAnimation];
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setState:UIGestureRecognizerStateFailed];
}

- (void)setupLayer {
    self.strokeLayer = [CAShapeLayer layer];
    
    CGFloat endAngle = clockwise? (-0.2f-M_PI_2):(0.2f-M_PI_2);
    CGFloat radius = (mostRightPoint.x - mostLeftPoint.x) / 2;
    CGPoint center;
    center.x = (mostRightPoint.x + mostLeftPoint.x)/2;
    center.y = (mostRightPoint.y + mostLeftPoint.y)/2;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:-M_PI_2 endAngle:endAngle clockwise:clockwise];
    
    [self.strokeLayer setPath:[path CGPath]];
    [self.strokeLayer setFillColor:[[UIColor clearColor] CGColor]];
    [self.strokeLayer setStrokeColor:[self.strokeColor?:[UIColor orangeColor] CGColor]];
    [self.strokeLayer setLineWidth:self.strokeWidth?:5];
    [self.strokeLayer setLineCap:kCALineCapRound];
    [self.view.layer addSublayer:self.strokeLayer];
}

- (void)startCircleAnimation {
    CGFloat duration = self.duration?:0.6f;
    
    CABasicAnimation *strokeAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    [strokeAnimation setDuration:duration];
    [strokeAnimation setFromValue:@0];
    [strokeAnimation setToValue:@1];
    
    CABasicAnimation *hideAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [hideAnimation setFromValue:@1.0f];
    [hideAnimation setToValue:@0.0f];
    [hideAnimation setBeginTime:duration+0.4f];
    [hideAnimation setDuration:0.5f];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    [group setDuration:duration+0.9f];
    [group setRemovedOnCompletion:NO];
    [group setFillMode:kCAFillModeForwards];
    [group setDelegate:self];
    group.animations = @[strokeAnimation,hideAnimation];
    
    [self.strokeLayer addAnimation:group forKey:@"groupAnimation"];
}

#pragma mark - animation delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        [self.strokeLayer removeFromSuperlayer];
    }
}


@end
