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
    RecapScene *_recapScene;
    CCButton *_loadMainSceneButton;
    CCButton *_loadRecapSceneButton;
    CCLabelTTF *_dashLabel;
    CCLabelTTF *_dotLabel;
    CCLabelTTF *_gameSceneLabel;
    CCLabelTTF *_scoreLabel;
    CCNodeGradient *_background;
    NSTimer *_timer;
    int _score;
}

- (void)didLoadFromCCB {
    self.userInteractionEnabled = YES;
    [self setDashOrDot];
    [self addObserver:self forKeyPath:@"score" options:0 context:NULL];
    [[NSUserDefaults standardUserDefaults] addObserver:self
                                            forKeyPath:@"highScore"
                                               options:0
                                               context:NULL];
    // load high score
    [_recapScene updateHighScore];
    
    _score = 0;
}

- (void) observeValueForKeyPath: (NSString *) keyPath ofObject: (id) object change: (NSDictionary *) change
                       context: (void *) context {
    if ([keyPath isEqualToString:@"score"]) {
        _scoreLabel.string = [NSString stringWithFormat:@"%ld", (long)_score];
    }
    else if ([keyPath isEqualToString: @"highScore"]) {
        [_recapScene updateHighScore];
    }
}

- (void) dealloc {
    [self removeObserver:self forKeyPath: @"score"];
}

- (void) touchBegan:(UITouch *) touch withEvent: (UIEvent *) event {
    [self initHoldTimer];
    _seconds = 0.0;
    _background.color = [CCColor colorWithRed: 1.0 green: 1.0 blue: 1.0 alpha: 1.0f];
}

- (void) touchEnded: (UITouch *) touch withEvent: (UIEvent *) event {
    if (_timer.isValid) {
        if ((_seconds >= DOT_DASH_DELIMITER && [_dashLabel.string isEqualToString:dash]) ||
            (_seconds < DOT_DASH_DELIMITER && [_dotLabel.string isEqualToString:dot])) {
            _score++;
            _background.color = [CCColor colorWithRed: 0.0 green: 1.0 blue: 0.0 alpha: 1.0f];
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
    _timer = [NSTimer scheduledTimerWithTimeInterval: 1.0 target: self selector: @selector (hold:) userInfo: nil repeats: YES];
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
    _scoreLabel.string = [NSString stringWithFormat: @"%ld", (long) _score];
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
    [self setHighScore];
//    [self resetDefaults];
//    [_recapScene setScore: _score];
//    [_recapScene setScore: self->_score];
//    [self scheduleOnce: @selector(loadRecapScene) delay: 1.0];
    [_timer invalidate];
    
    _recapScene = (RecapScene*) [CCBReader load:@"RecapScene"];
    [_recapScene setScore: self->_score];
    CCScene *newScene = [CCScene node];
    [newScene addChild:_recapScene];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:1.0f]; //no delay, transitions with fade???
    [[CCDirector sharedDirector] presentScene:newScene withTransition:transition];
}

- (void) setHighScore {
    if (![[NSUserDefaults standardUserDefaults] integerForKey:@"HighScore"]) {
        [[NSUserDefaults standardUserDefaults] setInteger:_score forKey:@"HighScore"];
    }
    else if (_score > [[NSUserDefaults standardUserDefaults] integerForKey:@"HighScore"]){
//        highScore = true;
        [[NSUserDefaults standardUserDefaults] setInteger:_score forKey:@"HighScore"];
    }
}

- (void) resetDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dictionary = [defaults dictionaryRepresentation];
    for (id key in dictionary) {
        [defaults removeObjectForKey: key];
    }
    [defaults synchronize];
}

- (void) loadMainScene {
    CCScene *mainScene = [CCBReader loadAsScene: @"MainScene"];
    [[CCDirector sharedDirector] replaceScene: mainScene];
}

- (void) loadRecapScene {
    CCScene *recapScene = [CCBReader loadAsScene: @"RecapScene"];
    [[CCDirector sharedDirector] replaceScene: recapScene];
}

@end
