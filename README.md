HYCircleGesture
===============

The gesture that can recognize circle,works the same as 'UIGestureRecognize'.

![image](https://github.com/nathanwhy/HYCircleGesture/example_gesture.gif)

#use

```objective-c
    
    HYCircleGesture *gesture = [[HYCircleGesture alloc] initWithTarget:self action:@selector(circleGesture:)];
    gesture.isAnimation = YES;
    [self.view addGestureRecognizer:gesture];

```
