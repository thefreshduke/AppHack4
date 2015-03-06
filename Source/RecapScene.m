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

static NSString *newHighMessage = @"NEW HIGH SCORE";
static NSString *highScoreMessage = @"HIGH SCORE";

@implementation RecapScene {
    BOOL isScoreNewHighScore;
    CCNodeGradient *_background;
    CCLabelTTF *_achievementLabel;
    CCLabelTTF *_dashLabel;
    CCLabelTTF *_dotLabel;
    CCLabelTTF *_highLabel;
    CCLabelTTF *_highScoreLabel;
    CCLabelTTF *_scoreLabel;
    NSInteger highScore;
    NSInteger newHighScore;
}

- (void) didLoadFromCCB {
    highScore = [[NSUserDefaults standardUserDefaults] integerForKey: @"HighScore"];
    [self updateAndDisplayHighScore];
}

- (void) setScore: (NSInteger) score {
    NSLog(@"%ld, %ld", (long)score, (long) highScore);
    if (score == highScore) {
        [_highLabel setString: [NSString stringWithFormat: @"%@", newHighMessage]];
    }
    else {
        [_highLabel setString: [NSString stringWithFormat: @"%@", highScoreMessage]];
        [_scoreLabel setString: [NSString stringWithFormat: @"%ld", (long) score]];
    }
}

- (void) updateAndDisplayHighScore {
    [_highScoreLabel setString: [NSString stringWithFormat: @"%ld", (long) highScore]];
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
