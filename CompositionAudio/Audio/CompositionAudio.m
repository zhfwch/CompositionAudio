//
//  CompositionAudio.m
//  CrashlyticsDemo
//
//  Created by fwzhou on 2017/7/17.
//  Copyright © 2017年 fwzhou. All rights reserved.
//

#import "CompositionAudio.h"
#import <AVFoundation/AVFoundation.h>

@interface CompositionAudio ()<AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer *player;

@end

@implementation CompositionAudio

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)convertAudio:(double)num
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterRoundHalfDown;
    NSString *str = [formatter stringFromNumber:[NSNumber numberWithDouble:num]];
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [arr addObject:@"base"];
    for (int i = 0; i < str.length; i++) {
        NSString *temp = [str substringWithRange:NSMakeRange(i, 1)];
        [arr addObject:[self convertAudioName:temp]];
    }
    [arr addObject:@"yuan"];
    [self exportAsynchronously:arr];
}

- (NSString *)convertAudioName:(NSString *)temp
{
    if ([temp isEqualToString:@"〇"]) {
        temp = @"zero";
    } else if ([temp isEqualToString:@"一"]) {
        temp = @"one";
    } else if ([temp isEqualToString:@"二"]) {
        temp = @"two";
    } else if ([temp isEqualToString:@"三"]) {
        temp = @"three";
    } else if ([temp isEqualToString:@"四"]) {
        temp = @"four";
    } else if ([temp isEqualToString:@"五"]) {
        temp = @"five";
    } else if ([temp isEqualToString:@"六"]) {
        temp = @"six";
    } else if ([temp isEqualToString:@"七"]) {
        temp = @"seven";
    } else if ([temp isEqualToString:@"八"]) {
        temp = @"eight";
    } else if ([temp isEqualToString:@"九"]) {
        temp = @"nine";
    } else if ([temp isEqualToString:@"十"]) {
        temp = @"ten";
    } else if ([temp isEqualToString:@"百"]) {
        temp = @"hundred";
    } else if ([temp isEqualToString:@"千"]) {
        temp = @"thousand";
    } else if ([temp isEqualToString:@"万"]) {
        temp = @"ten thousand";
    } else if ([temp isEqualToString:@"亿"]) {
        temp = @"hundred million";
    } else if ([temp isEqualToString:@"点"]) {
        temp = @"point";
    }
    return temp;
}

- (void)exportAsynchronously:(NSArray *)audioNames
{
    NSMutableArray *audioAssetArr = [[NSMutableArray alloc] init];
    for (NSString *audioName in audioNames) {
        NSString *auidoPath = [[NSBundle mainBundle] pathForResource:audioName ofType:@"mp3"];
        
        AVURLAsset *audioAsset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:auidoPath]];
        [audioAssetArr addObject:audioAsset];
    }
    
    NSMutableArray *timeRangeArr = [[NSMutableArray alloc] init];
    NSMutableArray *trackArr = [[NSMutableArray alloc] init];
    for (AVURLAsset *audioAsset in audioAssetArr) {
        [timeRangeArr addObject:[NSValue valueWithCMTimeRange:CMTimeRangeMake(kCMTimeZero, audioAsset.duration)]];
        [trackArr addObject:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] firstObject]];
    }
    
    AVMutableComposition *composition = [AVMutableComposition composition];
    NSError *error;
    AVMutableCompositionTrack *track = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:0];
    [track insertTimeRanges:timeRangeArr ofTracks:trackArr atTime:kCMTimeZero error:&error];
    
    AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetAppleM4A];
    NSString *fwzhouAudioPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/fwzhouAudio"];
    NSString *outPutFilePath = [fwzhouAudioPath stringByAppendingPathComponent:@"xindong.m4a"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:fwzhouAudioPath]) {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:fwzhouAudioPath withIntermediateDirectories:NO attributes:nil error:&error];
    } else {
        if ([[NSFileManager defaultManager] fileExistsAtPath:outPutFilePath]) {
            [[NSFileManager defaultManager] removeItemAtPath:outPutFilePath error:nil];
        }
    }
    
    NSURL *outPutURL = [NSURL fileURLWithPath:outPutFilePath];
    session.outputURL = outPutURL;
    session.outputFileType = AVFileTypeAppleM4A;
    [session exportAsynchronouslyWithCompletionHandler:^{
        NSError *error = nil;
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error];
        [[AVAudioSession sharedInstance] setActive:YES error:&error];
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:outPutURL error:&error];
        self.player.enableRate = true;
        self.player.rate = 1.7;
        [self.player play];
    }];
}

@end
