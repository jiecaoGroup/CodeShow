//
//  nodeLayer.m
//  NodeAnimationDemo
//
//  Created by 顾振强 on 15/12/31.
//  Copyright © 2015年 leslie. All rights reserved.
//

#import "UCVolumeMicView.h"
#import "UCNodeLayer.h"

@interface UCVolumeMicView ()<NodeLayerDelegate>

@property (nonatomic, strong) CADisplayLink     *displayLink;
@property (nonatomic, strong) NSMutableArray    *nodesArr;
@property (nonatomic, assign) NSInteger          numberOfNodes;
@property (nonatomic, assign) CGFloat            spacePadding;
@property (nonatomic, strong) UIButton          *micBtn;
@property (nonatomic, strong) CALayer           *micBtnShadowLayer;
@end

@implementation UCVolumeMicView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.nodesArr = [[NSMutableArray alloc] initWithCapacity:0];
        self.numberOfNodes = NODE_NUM;
        self.spacePadding = NODE_SPACEPADDING;
        [self createMicBtn];
        [self createNodes];

    }
    return self;
}

- (void)createMicBtn
{
    CGFloat centerX = self.bounds.size.width/2;
    CGFloat centerY = self.bounds.size.height/2;
    
    CGFloat micBtnWidth = (self.bounds.size.width - 2*[self getNodeSpaceLeftPadding]);
    
    UIButton * micBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    micBtn.frame = CGRectMake(0,0,micBtnWidth,micBtnWidth);
    micBtn.center = CGPointMake(centerX, centerY);
    [micBtn setBackgroundImage:[UIImage imageNamed:@"voice_btn_normal"] forState:UIControlStateNormal];
    [micBtn addTarget:self action:@selector(micAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.micBtn = micBtn];
    
    CALayer * micShadowLayer = [CALayer layer];
    micShadowLayer.frame = self.micBtn.bounds;
    micShadowLayer.shadowColor = NODE_THEMECOLOR.CGColor;
    micShadowLayer.cornerRadius = self.micBtn.frame.size.width/2;
    micShadowLayer.backgroundColor = [NODE_THEMECOLOR colorWithAlphaComponent:0.8].CGColor;
    micShadowLayer.shadowRadius = 10;
    micShadowLayer.shadowOpacity = 0;
    micShadowLayer.hidden = YES;
    micShadowLayer.shadowOffset = CGSizeMake(0, 0);
    
    [self.micBtn.layer addSublayer:self.micBtnShadowLayer = micShadowLayer];
}

- (void)createNodes
{
    for (int i = 0; i < self.numberOfNodes; i++)
    {
        UCNodeLayer * nodeLayer = [[UCNodeLayer alloc] initWithFrame:CGRectMake([self getNodeSpaceLeftPadding]+((VOLUME_WIDTH + self.spacePadding)*i),self.bounds.size.height/2, VOLUME_WIDTH, VOLUME_HEIGHT)];
        nodeLayer.nodePosition = i;
        nodeLayer.ndelegate = self;
        [self.nodesArr addObject:nodeLayer];
        [self.layer addSublayer:nodeLayer];
    }
}

- (CGFloat)getNodeSpaceLeftPadding
{
    CGFloat leftX = (self.bounds.size.width - (self.numberOfNodes * VOLUME_WIDTH + (self.numberOfNodes - 1)*self.spacePadding))/2;
    return leftX;
}

- (void)micAction
{
    [self micBtnDisappear];
}

- (void)setVolumeLevelDispalyLinkCallback:(void (^)(UCVolumeMicView *))volumeLevelDispalyLinkCallback
{
    _volumeLevelDispalyLinkCallback = volumeLevelDispalyLinkCallback;
    
    [self.displayLink invalidate];
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(recordDisplayAction)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [self.displayLink setPaused:YES];
}

- (void)setVolumeLevel:(CGFloat)volumeLevel
{
    _volumeLevel = volumeLevel;
}

- (void)micBtnDisappear
{
    [UIView animateWithDuration:NODEAPPEAR_DURING animations:^{
        self.micBtn.layer.affineTransform = CGAffineTransformMakeScale(0.01, 0.01);

        self.micBtnShadowLayer.shadowOpacity = 1;
        self.micBtnShadowLayer.hidden = NO;
        
    }completion:^(BOOL finished) {
        self.micBtn.hidden = YES;
        self.micBtnShadowLayer.shadowOpacity = 0;
        self.micBtnShadowLayer.hidden = YES;
        
        [self startScaleAnimation];
    }];
}

- (void)micBtnAppear
{
    [self.displayLink setPaused:YES];
    self.micBtn.hidden = NO;
    if (IOS6_AND_HIGH) {
        [UIView animateWithDuration:NODEAPPEAR_DURING delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:3 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.micBtn.layer.affineTransform = CGAffineTransformMakeScale(1,1);
        } completion:^(BOOL finish){
           
        }];
    }else{
        [UIView animateWithDuration:NODEAPPEAR_DURING animations:^{
            self.micBtn.layer.affineTransform = CGAffineTransformMakeScale(1,1);
        }completion:^(BOOL finish){
            
        }];
    }
}

- (void)startScaleAnimation
{    
    [self.nodesArr makeObjectsPerformSelector:@selector(appearenceWithAnimation)];
}

- (void)disspperanceScaleAnimation
{
    [self.displayLink setPaused:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MIDDEL_NODE_INDEX * NODE_VALUECHANGE_TIMEOFFSET * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.nodesArr makeObjectsPerformSelector:@selector(setBoundsToOrgin)];
        [self.nodesArr makeObjectsPerformSelector:@selector(disAppearenceWithAnimation)];
    });
}

- (void)recordDisplayAction
{
    _volumeLevelDispalyLinkCallback(self);
    [self.nodesArr makeObjectsPerformSelector:@selector(recordDisplayWithLevel:) withObject:@(_volumeLevel)];
}

- (void)moveNodesInLoading
{
    [self.displayLink setPaused:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MIDDEL_NODE_INDEX * NODE_VALUECHANGE_TIMEOFFSET+1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.nodesArr makeObjectsPerformSelector:@selector(setBoundsToOrgin)];
        [self.nodesArr makeObjectsPerformSelector:@selector(moveInLoading)];
    });
}

- (void)functionAction
{
    [self.nodesArr makeObjectsPerformSelector:@selector(backPrepare)];
}

#pragma mark  NodeLayerDelegate

- (void)nodesDidAppeared
{
    [self.displayLink setPaused:NO];
}

- (void)nodesDidDisappeared
{
    [self micBtnAppear];
    [self.nodesArr makeObjectsPerformSelector:@selector(setBoundsToOrgin)];
}

- (void)nodesLoadingMoveStop:(BOOL)forward
{
    if (forward)
    {
        [self.nodesArr makeObjectsPerformSelector:@selector(moveLoadingBack)];
    }else
    {
        [self.nodesArr makeObjectsPerformSelector:@selector(moveInLoading)];
    }
}

@end
