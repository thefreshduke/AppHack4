//
//  GameScene.m
//  AppHack4
//
//  Created by Scotty Shaw on 1/24/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "MainScene.h"
#import "GameScene.h"
#import "RecapScene.h"

static double MAX_HOLD_TIME = 0.2;

@implementation GameScene {
    CCButton *_loadMainSceneButton;
    CCButton *_loadRecapSceneButton;
    CCLabelTTF *_dashLabel;
    CCLabelTTF *_dotLabel;
    CCLabelTTF *_gameSceneLabel;
    CCNodeGradient *_background;
    NSTimer *_timer;
    int score;
}

- (void)didLoadFromCCB {
    self.userInteractionEnabled = true;
    [self setDashOrDot];
    _background.color = [CCColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0f];
}

- (void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    [self initHoldTimer];
    _background.color = [CCColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0f];
}

- (void) touchEnded: (UITouch *) touch withEvent: (UIEvent *) event {
    if (_timer.isValid) {
        if ((_seconds >= MAX_HOLD_TIME && [_dashLabel.string isEqualToString:@"_"]) ||
            (_seconds < MAX_HOLD_TIME && [_dotLabel.string isEqualToString:@"."])) {
            score++;
            _background.color = [CCColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0f];
        }
        else {
            NSLog(@"Your score is %d", score);
            [self loadRecapScene];
        }
        [_timer invalidate];
    }
    _seconds = 0.0;
    [self setDashOrDot];
}

- (void) initHoldTimer {
    _seconds = 0.0;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(hold:) userInfo:nil repeats:YES];
}

-(void) hold: (NSTimer *) sendingTimer {
    //    _seconds++;
    //    [self update:(CCTime)];
}

- (void) setDashOrDot {
    if (arc4random_uniform(2) == 0) {
        [_dashLabel setString:(@" ")];
        [_dotLabel setString:(@".")];
    }
    else {
        [_dashLabel setString:(@"_")];
        [_dotLabel setString:(@" ")];
    }
}

-(void) update: (CCTime) delta {
    _seconds += delta;
//    [self updateBackgroundColor];
}

- (void) updateBackgroundColor {
    CGFloat redness = (4.0 * pow(_seconds, 2.0)) - (4.0 * _seconds) + 1.0;
    CGFloat greenness = (-4.0 * pow(_seconds, 2.0)) + (4.0 * _seconds);
//    CGFloat redness = abs((2.0 * _seconds) - 1.0);
//    CGFloat greenness = -abs(2.0 * _seconds - 1.0) + 1.0;
    CGFloat blueness = (-2.0 * _seconds) + 1.0;
    _background.color = [CCColor colorWithRed:redness green:greenness blue:blueness alpha:1.0f];
}

- (void) loadMainScene {
    CCScene *mainScene = [CCBReader loadAsScene: @"MainScene"];
    [[CCDirector sharedDirector] replaceScene:mainScene];
}

- (void) loadRecapScene {
    CCScene *recapScene = [CCBReader loadAsScene: @"RecapScene"];
    [[CCDirector sharedDirector] replaceScene:recapScene];
}

@end
