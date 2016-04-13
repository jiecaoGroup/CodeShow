//
//  SpringAnimation.m
//  NodeAnimationDemo
//
//  Created by 顾振强 on 16/1/4.
//  Copyright © 2016年 leslie. All rights reserved.
//

#import "SpringAnimation.h"
#import <UIKit/UIKit.h>

@implementation SpringAnimation

+ (void)animate:(CALayer *)layer keyPath:(NSString *)keyPath during:(CFTimeInterval)during dump:(double)dump velocity:(double)velocity fromValue:(double)fromValue toValue:(double)toValue
{
    [CATransaction begin];
    
    CAKeyframeAnimation * animation = [self createAnimationWithkeyPath:keyPath during:during dump:dump velocity:velocity fromValue:fromValue toValue:toValue];
    
    [layer addAnimation:animation forKey:@"springAnimation"];
    [CATransaction commit];
}

+ (CAKeyframeAnimation *)createAnimationWithkeyPath:(NSString *)keyPath during:(CFTimeInterval)during dump:(double)dump velocity:(double)velocity fromValue:(double)fromValue toValue:(double)toValue
{
    double dampingMultiplier  = 10.0;
    double velocityMultiplier = 10.0;
    
    NSArray *  values = [self animationValuesWithDuring:during dump:dump*dampingMultiplier velocity:velocity*velocityMultiplier fromValue:fromValue toValue:toValue];
    
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
    animation.values = values;
    animation.duration = during;

    return animation;
}

+ (NSArray *)animationValuesWithDuring:(CFTimeInterval)during dump:(double)dump velocity:(double)velocity fromValue:(double)fromValue toValue:(double)toValue
{
    NSMutableArray * values = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSInteger numOfPoint = 500;
    
    double distance = toValue - fromValue;
    
    for (int i = 0; i < 500; i++) {
        double x = i/numOfPoint;
        double valueNormalied = [self animationValuesNormalized:x damping:dump velocity:velocity];
        NSNumber * value = @(toValue - distance * valueNormalied);
        [values addObject:value];
    }
    return values;
}

+ (double)animationValuesNormalized:(double)x damping:(double)damp velocity:(double)velocity
{
    return pow(M_E, -damp*x)*cos(velocity*x);
}


@end
