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
    
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
}

- (void)dealloc
{
    [self removeNotification];
    
    [self.playerLayer.player pause];
    self.playerLayer.player = nil;
}

#pragma mark - Subjoin
- (AVPlayerLayer *)playerLayer {
    return (AVPlayerLayer *)self.layer;
}

- (void)viewConfig:(NSString *)videoName
{
    NSString *videoPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:videoName];
    AVPlayer *player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:videoPath]];
    player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    
    self.playerLayer.player = player;
}

- (void)addNotification
{
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
}

- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerLayer.player.currentItem];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
}

#pragma mark - Public
- (void)playVideo:(NSString *)videoName
{
    [self removeNotification];
    
    [self viewConfig:videoName];
    
    [self addNotification];
    
    [self.playerLayer.player play];
}

#pragma mark - Notification
- (void)playbackFinished:(NSNotification *)notification {
    if (notification.object == self.playerLayer.player.currentItem) {
        [self.playerLayer.player seekToTime:CMTimeMake(0, 1)];
        [self.playerLayer.player play];
    }
}

- (void)appBecomeActive:(NSNotification *)notification {
    [self.playerLayer.player play];
}

- (void)appWillResignActive:(NSNotification *)notification {
    [self.playerLayer.player pause];
}

@end
