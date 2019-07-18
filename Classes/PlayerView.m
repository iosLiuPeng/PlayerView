//
//  PlayerView.m
//  
//
//  Created by 刘鹏 on 2019/1/24.
//  Copyright © 2019 Musjoy. All rights reserved.
//

#import "PlayerView.h"
#import <AVFoundation/AVFoundation.h>

@interface PlayerView ()
@end

@implementation PlayerView
#pragma mark - Life Cycle
+ (Class)layerClass {
    return AVPlayerLayer.class;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playbackFinished:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:self.playerLayer.player.currentItem];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
    self.playerLayer.videoGravity = AVLayerVideoGravityResize;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerLayer.player.currentItem];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    
    [self.playerLayer.player pause];
    self.playerLayer.player = nil;
}

#pragma mark - Subjoin
- (AVPlayerLayer *)playerLayer {
    return (AVPlayerLayer *)self.layer;
}

- (void)viewConfig:(NSString *)videoName
{
    NSString *videoPath = [[NSBundle mainBundle] pathForResource:videoName ofType:@"mp4"];
    AVPlayer *player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:videoPath]];
    player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    
    self.playerLayer.player = player;
}

#pragma mark - Public
- (void)playVideo:(NSString *)videoName
{
    [self viewConfig:videoName];
    [self.playerLayer.player play];
}

#pragma mark - Notification
- (void)playbackFinished:(NSNotification *)notification {
    [self.playerLayer.player seekToTime:CMTimeMake(0, 1)];
    [self.playerLayer.player play];
}

- (void)appBecomeActive:(NSNotification *)notification {
    [self.playerLayer.player play];
}

- (void)appWillResignActive:(NSNotification *)notification {
    [self.playerLayer.player pause];
}

@end
