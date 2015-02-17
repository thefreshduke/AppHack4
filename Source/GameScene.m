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
}

- (void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    _background.color = [CCColor colorWithRed:255.0f/255.0f green:130.0/255.0f blue:0.0/255.0f alpha:1.0f];
    [self initHoldTimer];
}

- (void) touchEnded: (UITouch *) touch withEvent: (UIEvent *) event {
    _background.color = [CCColor colorWithRed:255.0f/255.0f green:0.0/255.0f blue:0.0/255.0f alpha:1.0f];
    if (_timer.isValid) {
        if ((_seconds >= MAX_HOLD_TIME && [_dashLabel.string isEqualToString:@"_"]) ||
            (_seconds < MAX_HOLD_TIME && [_dotLabel.string isEqualToString:@"."])) {
            score++;
        }
        else {
            NSLog(@"Your score is %d", score);
            [self loadRecapScene];
        }
        [_timer invalidate];
    }
    [self setDashOrDot];
}

- (void) initHoldTimer {
    _seconds = 0;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(hold:) userInfo:nil repeats:YES];
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

- (void) changeBackgroundColor {
    
}

-(void) update: (CCTime) delta {
    _seconds += delta;
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
