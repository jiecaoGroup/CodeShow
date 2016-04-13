//
//  UCNodeLayer.h
//  NodeAnimationDemo
//
//  Created by 顾振强 on 15/12/31.
//  Copyright © 2015年 leslie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UCVolumeMicView : UIView
@property (nonatomic, copy) void (^volumeLevelDispalyLinkCallback)(UCVolumeMicView * volumeView);
@property (nonatomic, assign) CGFloat volumeLevel;

- (void)startScaleAnimation;

- (void)disspperanceScaleAnimation;

- (void)moveNodesInLoading;

- (void)functionAction;

@end
