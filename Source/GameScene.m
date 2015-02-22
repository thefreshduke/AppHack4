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

static double DOT_DASH_DELIMITER = 0.2;
static double MAX_DELAY = 0.7;
static NSString *dash = @"-";
static NSString *dot = @".";
static NSString *blank = @" ";

@implementation GameScene {
    CCButton *_loadMainSceneButton;
    CCButton *_loadRecapSceneButton;
    CCLabelTTF *_dashLabel;
    CCLabelTTF *_dotLabel;
    CCLabelTTF *_gameSceneLabel;
    CCNodeGradient *_background;
    NSTimer *_timer;
    int _score;
}

- (void)didLoadFromCCB {
    self.userInteractionEnabled = YES;
    [self setDashOrDot];
}

- (void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    [self initHoldTimer];
    _seconds = 0.0;
    _background.color = [CCColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0f];
}

- (void) touchEnded: (UITouch *) touch withEvent: (UIEvent *) event {
    if (_timer.isValid) {
        if ((_seconds >= DOT_DASH_DELIMITER && [_dashLabel.string isEqualToString:dash]) ||
            (_seconds < DOT_DASH_DELIMITER && [_dotLabel.string isEqualToString:dot])) {
            _score++;
            _background.color = [CCColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0f];
            _background.endOpacity -= 0.01;
            [self setDashOrDot];
        }
        else {
            [self endGame];
            return;
        }
        [_timer invalidate];
    }
    [self initHoldTimer];
    _seconds = 0.0;
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
        [_dashLabel setString:(blank)];
        [_dotLabel setString:(dot)];
    }
    else {
        [_dashLabel setString:(dash)];
        [_dotLabel setString:(blank)];
    }
}

-(void) update: (CCTime) delta {
    _seconds += delta;
//    [self updateBackgroundColor];
    if (_timer.isValid && _seconds >= MAX_DELAY) {
        [self endGame];
    }
}

- (void) updateBackgroundColor {
    CGFloat redness = (4.0 * pow(_seconds, 2.0)) - (4.0 * _seconds) + 1.0;
    CGFloat greenness = (-4.0 * pow(_seconds, 2.0)) + (4.0 * _seconds);
//    CGFloat redness = abs((2.0 * _seconds) - 1.0);
//    CGFloat greenness = -abs(2.0 * _seconds - 1.0) + 1.0;
    CGFloat blueness = (-2.0 * _seconds) + 1.0;
    _background.color = [CCColor colorWithRed: redness green: greenness blue: blueness alpha: 1.0f];
}

- (void) endGame {
    self.userInteractionEnabled = NO;
    _background.color = [CCColor colorWithRed: 1.0 green: 0.0 blue: 0.0 alpha: 1.0f];
    NSLog(@"Your score is %d", _score);
    [self scheduleOnce: @selector(loadRecapScene) delay: 1.0];
    [_timer invalidate];
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
