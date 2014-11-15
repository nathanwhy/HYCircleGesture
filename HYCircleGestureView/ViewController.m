//
//  ViewController.m
//  HYCircleGestureView
//
//  Created by nathan on 14/11/13.
//  Copyright (c) 2014年 nathan. All rights reserved.
//

#import "ViewController.h"
#import "HYCircleGesture.h"

@interface ViewController ()

@end

@implementation ViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    
    HYCircleGesture *gesture = [[HYCircleGesture alloc] initWithTarget:self action:@selector(circleGesture:)];
    gesture.isAnimation = YES;
    [self.view addGestureRecognizer:gesture];
}

- (void)circleGesture:(HYCircleGesture *)gesture {
    NSLog(@"success");
}

@end
