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

static double DOT_DASH_DELIMITER = 0.2; //0.2
static double MAX_DELAY = 0.7; //0.7
static NSString *dash = @"-";
static NSString *dot = @".";
static NSString *blank = @" ";
static NSString *highScoreMessage = @"HIGH SCORE";

@implementation GameScene {
    BOOL isGameSceneFading;
    CCButton *_loadRecapSceneButton;
    CCLabelTTF *_dashLabel;
    CCLabelTTF *_dotLabel;
    CCLabelTTF *_gameSceneLabel;
//    CCLabelTTF *_highLabel;
    CCLabelTTF *_scoreLabel;
    CCNodeGradient *_background;
    int fadeTimer;
    int _score;
    NSTimer *_timer;
    RecapScene *_recapScene;
}

- (void) didLoadFromCCB {
    self.userInteractionEnabled = YES;
    [self setDashOrDot];
    [self addObserver:self forKeyPath:@"score" options:0 context:NULL];
    [[NSUserDefaults standardUserDefaults] addObserver: self forKeyPath: @"highScore" options: 0
                                               context: NULL];
    _score = 0;
}

- (void) observeValueForKeyPath: (NSString *) keyPath ofObject: (id) object change: (NSDictionary *) change
                       context: (void *) context {
    if ([keyPath isEqualToString: @"score"]) {
        [_scoreLabel setString: [NSString stringWithFormat: @"%ld", (long) _score]];
    }
    else if ([keyPath isEqualToString: @"highScore"]) {
        [_recapScene updateAndDisplayHighScore];
    }
} // method seems unnecessary; no noticeable effect when commented out

- (void) dealloc {
    [self removeObserver: self forKeyPath: @"score"];
}

- (void) touchBegan: (UITouch *) touch withEvent: (UIEvent *) event {
    [self initHoldTimer];
    _seconds = 0.0;
    _background.color = [CCColor colorWithRed: 1.0 green: 1.0 blue: 1.0 alpha: 1.0f];
}

- (void) touchEnded: (UITouch *) touch withEvent: (UIEvent *) event {
    if (_timer.isValid) {
        if ((_seconds >= DOT_DASH_DELIMITER && [_dashLabel.string isEqualToString: dash]) ||
            (_seconds < DOT_DASH_DELIMITER && [_dotLabel.string isEqualToString: dot])) {
            _score++;
            _background.color = [CCColor colorWithRed: 0.0 green: 1.0 blue: 0.0 alpha: 1.0f];
//            if (_background.endOpacity > 0.0) {
//                _background.endOpacity -= 0.1; //test this again
//            }
//            if (_background.endOpacity < 0.0 && _background.startOpacity > 0.0) {
//                _background.startOpacity -= 0.1;
//            }
//            if (_background.startOpacity < 0.0) {
//                _dashLabel.opacity -= 0.1;
//            }
//            NSLog(@"end: %f --- start: %f", _background.endOpacity, _background.startOpacity);
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
    _timer = [NSTimer scheduledTimerWithTimeInterval: 1.0 target: self selector: @selector (hold:) userInfo: nil repeats: YES];
}

-(void) hold: (NSTimer *) sendingTimer {
    //    _seconds++;
    //    [self update:(CCTime)];
} // only here because of the selector in initHoldTimer method above

- (void) setDashOrDot {
    if (arc4random_uniform(2) == 0) {
        [_dashLabel setString: blank];
        [_dotLabel setString: dot];
    }
    else {
        [_dashLabel setString: dash];
        [_dotLabel setString: blank];
    }
}

-(void) update: (CCTime) delta {
    _seconds += delta;
    if (_timer.isValid && _seconds >= MAX_DELAY) {
        [self endGame];
    }
    if (isGameSceneFading) { // how to slide score downwards for recap scene?
        fadeTimer += delta;
//        _scoreLabel.position.y 80 - (27.5 * fadeTimer);
//        [_scoreLabel setPosition: (284.0f, 80 - (27.5 * fadeTimer))];
    }
    
    [_scoreLabel setString: [NSString stringWithFormat: @"%ld", (long) _score]];
//    if (_score > [[NSUserDefaults standardUserDefaults] integerForKey: @"HighScore"]) {
//        [_highLabel setString: [NSString stringWithFormat: @"%@", highScoreMessage]];
//    }
}

- (void) endGame {
    self.userInteractionEnabled = NO;
    _background.color = [CCColor colorWithRed: 1.0 green: 0.0 blue: 0.0 alpha: 1.0f];
    [self setHighScore];
    [_timer invalidate];
    
    [_dashLabel setString: dash];
    [_dotLabel setString: blank];
    isGameSceneFading = true;
    
    _recapScene = (RecapScene *) [CCBReader load: @"RecapScene"];
    [_recapScene setScore: self -> _score];
    CCScene * newScene = [CCScene node];
    [newScene addChild: _recapScene];
    CCTransition * transition = [CCTransition transitionCrossFadeWithDuration: 1.0f];
    [[CCDirector sharedDirector] presentScene:newScene withTransition:transition];
}

- (void) setHighScore {
    if (![[NSUserDefaults standardUserDefaults] integerForKey: @"HighScore"] || _score > [[NSUserDefaults standardUserDefaults] integerForKey: @"HighScore"]) {
        [[NSUserDefaults standardUserDefaults] setInteger: _score forKey: @"HighScore"];
    }
}

@end
