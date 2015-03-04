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
    _gameScene = (GameScene *) [CCBReader load: @"GameScene"];
    CCScene * newScene = [CCScene node];
    [newScene addChild: _gameScene];
    CCTransition * transition = [CCTransition transitionCrossFadeWithDuration: 1.0f];
    [[CCDirector sharedDirector] presentScene:newScene withTransition:transition];
} // fades slower than GameScene.m?

@end
