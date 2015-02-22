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
    CCNodeGradient *_background;
    CCLabelTTF *_highScoreLabel;
    CCLabelTTF *_scoreLabel;
}

- (void)setScore:(NSInteger)score {
    //    if (!highScore) {
    _scoreLabel.string = [NSString stringWithFormat:@"%ld", (long)score];
    //    } //how to shift between standard "your score/best score" and "YOU GOT A HIGH SCORE"?
}

- (void)updateHighScore {
    NSInteger newHighScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"HighScore"];
    _highScoreLabel.string = [NSString stringWithFormat:@"%d", (int) newHighScore];
}

- (void)loadMainScene {
    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:mainScene];
}

- (void)loadGameScene {
    CCScene *gameScene = [CCBReader loadAsScene:@"GameScene"];
    [[CCDirector sharedDirector] replaceScene:gameScene];
}

@end
