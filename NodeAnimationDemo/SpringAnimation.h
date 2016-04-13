//
//  SpringAnimation.h
//  NodeAnimationDemo
//
//  Created by 顾振强 on 16/1/4.
//  Copyright © 2016年 leslie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SpringAnimation : NSObject
+ (void)animate:(CALayer *)layer keyPath:(NSString *)keyPath during:(CFTimeInterval)during dump:(double)dump velocity:(double)velocity fromValue:(double)fromValue toValue:(double)toValue;
@end
