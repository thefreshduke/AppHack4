//
//  RecapScene.m
//  AppHack4
//
//  Created by Scotty Shaw on 1/25/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "MainScene.h"
#import "GameScene.h"
#import "RecapScene.h"

@implementation RecapScene {
    BOOL isScoreNewHighScore;
    CCNodeGradient *_background;
    CCLabelTTF *_dashLabel;
    CCLabelTTF *_dotLabel;
    CCLabelTTF *_highScoreLabel;
    CCLabelTTF *_scoreLabel;
    CCLabelTTF *_scoreLabel2;
    NSInteger highScore;
    NSInteger newHighScore;
}

- (void) didLoadFromCCB {
    [self updateAndDisplayHighScore];
}

- (void) setScore: (NSInteger) score {
    _scoreLabel2.string = [NSString stringWithFormat: @"%ld", (long) score];
}

- (void) updateAndDisplayHighScore {
    highScore = [[NSUserDefaults standardUserDefaults] integerForKey: @"HighScore"];
    _highScoreLabel.string = [NSString stringWithFormat: @"%d", (int) highScore];
}

- (void) resetDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dictionary = [defaults dictionaryRepresentation];
    for (id key in dictionary) {
        [defaults removeObjectForKey: key];
    }
    [defaults synchronize];
    [self updateAndDisplayHighScore];
}

- (void) loadGameScene {
    CCScene *gameScene = [CCBReader loadAsScene: @"GameScene"];
    [[CCDirector sharedDirector] replaceScene: gameScene];
}

@end
