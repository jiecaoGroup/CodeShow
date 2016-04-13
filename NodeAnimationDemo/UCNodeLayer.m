//
//  UCNodeLayer.m
//  NodeAnimationDemo
//
//  Created by 顾振强 on 16/1/5.
//  Copyright © 2016年 leslie. All rights reserved.
//

#import "UCNodeLayer.h"
#import <UIKit/UIKit.h>



@interface UCNodeLayer()

@property (nonatomic,strong)CALayer * pLayer;

@property (nonatomic,assign)BOOL toApperance;

@property (nonatomic,strong)CABasicAnimation * loadAnimation;

@property (nonatomic,strong)CABasicAnimation * loadBackAnimation;

@property (nonatomic,assign)CGPoint orginPosition;

@end

@implementation UCNodeLayer

- (id)initWithFrame:(CGRect)rect
{
    self = [super init];
    if (self) {
        
        self.frame  = rect;
        self.orginPosition = self.position;
        self.shadowColor = NODE_THEMECOLOR.CGColor;
        self.shadowOpacity = 0.7;
        self.shadowOffset = CGSizeMake(0, 0);
        self.backgroundColor = NODE_THEMECOLOR.CGColor;
        self.cornerRadius = self.frame.size.width/2;
        self.shadowRadius = 2;
        self.affineTransform  = CGAffineTransformMakeScale(0, 0);
        
        self.pLayer = [CALayer layer];
        self.pLayer.backgroundColor = NODE_THEMECOLOR.CGColor;
        self.pLayer.masksToBounds = YES;
        self.pLayer.frame = self.bounds;
        [self.pLayer setCornerRadius:self.pLayer.frame.size.width/2];
        
        [self addSublayer:self.pLayer];
        
        self.toApperance = YES;
    }
    return self;
}

- (void)disAppearenceWithAnimation
{
    self.toApperance = NO;
    
    CGFloat delayTime = ((MIDDEL_NODE_INDEX - labs(self.nodePosition - MIDDEL_NODE_INDEX))*NODEAPPEAR_TIMEOFFSET);
    [self addAnimation:[self animationWithApperane:NO delay:delayTime] forKey:@"scale"];
}

- (void)appearenceWithAnimation
{
    self.toApperance = YES;
    
    CGFloat delayTime = (labs(self.nodePosition - MIDDEL_NODE_INDEX)*NODEAPPEAR_TIMEOFFSET);
    [self addAnimation:[self animationWithApperane:YES delay:delayTime] forKey:@"scale"];
}

- (CAKeyframeAnimation *)animationWithApperane:(BOOL)apperace delay:(CFTimeInterval)delay
{
    CAKeyframeAnimation *kAni = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    kAni.duration = NODEAPPEAR_DURING;
    kAni.delegate = self;
    if (apperace) {
        kAni.values = @[@(0.1),@(1.3),@(1.0),@(1.1),@(1.0)];
        kAni.keyTimes = @[@(0.0),@(0.5),@(0.7),@(0.9),@(1.0)];
    }else{
        kAni.values = @[@(1.0),@(1.1),@(1.0),@(1.3),@(0.0)];
        kAni.keyTimes = @[@(0.0),@(0.1),@(0.3),@(0.5),@(1.0)];
    }
    kAni.removedOnCompletion = NO;
    kAni.fillMode = kCAFillModeBoth;
    kAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    kAni.calculationMode = kCAAnimationLinear;
    kAni.beginTime = CACurrentMediaTime()+delay;

    return kAni;
}

- (void)setBoundsToOrgin
{
    CGRect bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, VOLUME_HEIGHT);
    self.bounds = bounds;
}

- (CGFloat)getVolumeHeightWithLevel:(CGFloat)level
{
    
    CGFloat maxHeight = 0.0;
    
    switch (self.nodePosition) {
        case 0:
            maxHeight = 12;
            break;
        case 1:
            maxHeight = 40;
            break;
        case 2:
            maxHeight = 28;
            break;
        case 3:
            maxHeight = 60;
            break;
        case 4:
            maxHeight = 100;
            break;
        case 5:
            maxHeight = 56;
            break;
        case 6:
            maxHeight = 24;
            break;
        case 7:
            maxHeight = 32;
            break;
        case 8:
            maxHeight = 12;
            break;
        default:
            maxHeight = 100;
            break;
    }
    
    CGFloat volumeHeightX = (maxHeight - VOLUME_HEIGHT) * (level-0.5>0?1.0:(2*level));
    volumeHeightX = VOLUME_HEIGHT + volumeHeightX;
    volumeHeightX = volumeHeightX;
    
    return volumeHeightX>maxHeight?maxHeight:volumeHeightX;
}

- (void)moveInLoading
{
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    animation.delegate = self;
    animation.duration = 1;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fromValue = @(self.frame.origin.x);
    animation.toValue = @(self.frame.origin.x + 200);
    animation.autoreverses = NO;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeBoth;
    animation.beginTime =  CACurrentMediaTime()+ (NODE_NUM - self.nodePosition)*0.1;
    
    [self addAnimation:animation forKey:@"move"];
    self.loadAnimation = animation;
}

- (void)moveLoadingBack
{
    self.hidden = NO;
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    animation.delegate = self;
    animation.duration = 1;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fromValue = @(self.position.x);
    animation.toValue = @(self.orginPosition.x);
    animation.autoreverses = NO;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeBoth;
    animation.beginTime =  CACurrentMediaTime()+ (NODE_NUM - self.nodePosition)*0.1;

    [self addAnimation:animation forKey:@"move"];
    self.loadBackAnimation = animation;
}

- (void)animationDidStart:(CAAnimation *)anim
{
    [self setBoundsToOrgin];
    if (!self.toApperance) {
        [UIView animateWithDuration:NODEAPPEAR_DURING animations:^{
            self.shadowRadius = 2;
        }];
    }
}

- (void)backPrepare
{
    [self removeAnimationForKey:@"move"];
    self.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.position = self.orginPosition;
    }];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    
    if (anim.beginTime == self.loadAnimation.beginTime&&flag)
    {

        self.hidden = YES;
        self.position = CGPointMake(-100, self.position.y);
        if (self.nodePosition == 0)
        {
            [self.ndelegate nodesLoadingMoveStop:YES];
        }
        
    }else if (anim.beginTime == self.loadBackAnimation.beginTime&&flag)
    {
        self.position = self.orginPosition;
        if (self.nodePosition == 0)
        {
            [self.ndelegate nodesLoadingMoveStop:NO];
        }
    }else
    {
        if (self.toApperance) {
            if (self.nodePosition == 0) {
                if ([self.ndelegate respondsToSelector:@selector(nodesDidAppeared)]) {
                    [self.ndelegate nodesDidAppeared];
                }
            }
            
            [UIView animateWithDuration:NODEAPPEAR_DURING animations:^{
                self.shadowRadius = 1;
            }];
        }else{
            if (self.nodePosition == MIDDEL_NODE_INDEX) {
                if ([self.ndelegate respondsToSelector:@selector(nodesDidDisappeared)]) {
                    [self.ndelegate nodesDidDisappeared];
                }
            }
        }
    
    }
    
}


- (void)recordDisplayWithLevel:(id)level
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((labs(self.nodePosition - MIDDEL_NODE_INDEX) * NODE_VALUECHANGE_TIMEOFFSET) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        CGFloat volumeHeightV = [self getVolumeHeightWithLevel:[(NSNumber *)level  floatValue]];
        CGRect bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, volumeHeightV);
        
        self.bounds = bounds;
    });
}

@end
