//
//  ViewController.m
//  NodeAnimationDemo
//
//  Created by 顾振强 on 15/12/31.
//  Copyright © 2015年 leslie. All rights reserved.
//

#import "ViewController.h"
#import "SpringAnimation.h"
#import <AVFoundation/AVFoundation.h>
#import "UCVolumeMicView.h"

@interface ViewController ()
{
    
}

@property (nonatomic, strong) CALayer * nodeLayerOne;
@property (nonatomic, strong) CADisplayLink * displayLink;
@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) UCVolumeMicView * volumeView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupRecorder];
    
//    UCVolumeMicView * volumNodeView = [[UCVolumeMicView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 300)];
    UCVolumeMicView * volumNodeView = [[UCVolumeMicView alloc] initWithFrame:CGRectMake(63, 235, 225, 225)];
    volumNodeView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.volumeView = volumNodeView];

    __weak AVAudioRecorder *weakRecorder = self.recorder;
    
    volumNodeView.volumeLevelDispalyLinkCallback = ^(UCVolumeMicView * view){
        
        [weakRecorder updateMeters];
        CGFloat normalizedValue = pow (10, [weakRecorder averagePowerForChannel:0] / 40);

        NSLog(@"normalizedValue:%lf",normalizedValue);
        view.volumeLevel = normalizedValue;
    };
}

- (void)setupRecorder
{
    NSURL *url = [NSURL fileURLWithPath:@"/dev/null"];
    
    NSDictionary *settings = @{AVSampleRateKey:          [NSNumber numberWithFloat: 44100.0],
                               AVFormatIDKey:            [NSNumber numberWithInt: kAudioFormatAppleLossless],
                               AVNumberOfChannelsKey:    [NSNumber numberWithInt: 2],
                               AVEncoderAudioQualityKey: [NSNumber numberWithInt: AVAudioQualityMin]};
    
    NSError *error;
    self.recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
    
    if(error) {
        NSLog(@"Ups, could not create recorder %@", error);
        return;
    }
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    
    if (error) {
        NSLog(@"Error setting category: %@", [error description]);
    }
    
    [self.recorder prepareToRecord];
    [self.recorder setMeteringEnabled:YES];
    [self.recorder record];
}

- (IBAction)aniAction:(id)sender {
    [self.volumeView startScaleAnimation];
}

- (IBAction)stopAnimation:(id)sender {
    [self.volumeView moveNodesInLoading];
}

- (IBAction)removeAnimation:(id)sender {
    [self.volumeView disspperanceScaleAnimation];
}

- (IBAction)functionAction:(id)sender {
    [self.volumeView functionAction];
}

@end
