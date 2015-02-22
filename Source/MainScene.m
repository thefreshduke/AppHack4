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
    CCNodeGradient *_background;
}

- (void)loadGameScene {
    CCScene *gameScene = [CCBReader loadAsScene:@"GameScene"];
    [[CCDirector sharedDirector] replaceScene:gameScene];
}

@end
