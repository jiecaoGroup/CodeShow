//
//  UCNodeLayer.h
//  NodeAnimationDemo
//
//  Created by 顾振强 on 16/1/5.
//  Copyright © 2016年 leslie. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#define VOLUME_HEIGHT 9                                                                             //点的高度
#define VOLUME_WIDTH  VOLUME_HEIGHT                                                                 //点的宽度
#define NODE_NUM 9                                                                                  //总数
#define MIDDEL_NODE_INDEX (NODE_NUM/2)                                                              //根据总数拿到中间点
#define NODE_SPACEPADDING 6                                                                         //点之间的间距
#define NODEAPPEAR_DURING 0.4                                                                       //点出现\消失的 动画时间
#define NODEAPPEAR_TIMEOFFSET (NODEAPPEAR_DURING/10)
#define NODE_VALUECHANGE_TIMEOFFSET 0.08                                                            //点的纵向值改变时的时间差
#define NODE_THEMECOLOR [UIColor colorWithRed:0.2549 green:0.6078 blue:0.9843 alpha:1.0]            //点和阴影的颜色

#define IOS6_AND_HIGH ([[UIDevice currentDevice].systemVersion floatValue]>=6.0 ? YES : NO)


@protocol NodeLayerDelegate <NSObject>

@optional
- (void)nodesDidAppeared;
- (void)nodesDidDisappeared;

- (void)nodesLoadingMoveStop:(BOOL)forward;

@end

@interface UCNodeLayer : CALayer

@property (nonatomic,assign)NSInteger nodePosition;

@property (nonatomic,assign)id<NodeLayerDelegate> ndelegate;

- (id)initWithFrame:(CGRect)rect;

- (void)recordDisplayWithLevel:(id)level;

- (void)disAppearenceWithAnimation;

- (void)appearenceWithAnimation;

- (void)setBoundsToOrgin;

- (void)moveInLoading;

- (void)moveLoadingBack;

- (void)backPrepare;

@end
