//
//  ViewController.m
//  CompositionAudio
//
//  Created by fwzhou on 2017/10/9.
//  Copyright © 2017年 fwzhou. All rights reserved.
//

#import "ViewController.h"
#import "CompositionAudio.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

@property (nonatomic, strong) CompositionAudio *playAudio;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    self.playAudio = [[CompositionAudio alloc] init];
    [_playAudio convertAudio:100];
}

@end
