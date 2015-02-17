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
