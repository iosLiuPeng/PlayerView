//
//  PlayerView.h
//
//
//  Created by 刘鹏 on 2019/1/24.
//  Copyright © 2019 Musjoy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AVPlayer;
@class AVPlayerLayer;

NS_ASSUME_NONNULL_BEGIN

@interface PlayerView : UIView

- (void)playVideo:(NSString *)videoName;
@end

NS_ASSUME_NONNULL_END
