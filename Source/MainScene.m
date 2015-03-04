//
//  MainScene.m
//  AppHack4
//
//  Created by Scotty Shaw on 1/24/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "MainScene.h"
#import "GameScene.h"

@implementation MainScene {
    CCLabelTTF *_dashLabel;
    CCLabelTTF *_dotLabel;
    CCNodeGradient *_background;
    GameScene *_gameScene;
}

- (void) loadGameScene {
    _background.color = [CCColor colorWithRed: 0.0 green: 1.0 blue: 0.0 alpha: 1.0f];
    _gameScene = (GameScene *) [CCBReader load: @"GameScene"];
    CCScene * newScene = [CCScene node];
    [newScene addChild: _gameScene];
    CCTransition * transition = [CCTransition transitionCrossFadeWithDuration: 1.0f];
    [[CCDirector sharedDirector] presentScene:newScene withTransition:transition];
//    CCScene *gameScene = [CCBReader loadAsScene: @"GameScene"];
//    [[CCDirector sharedDirector] replaceScene: gameScene];
} // fades slower than GameScene.m?

@end
